package main

import (
	"bytes"
	"fmt"
	"log"
	"os"
	"os/exec"
	"os/signal"
	"regexp"
	"sort"
	"strconv"
	"syscall"
	"time"
)

type Config struct {
	Arguments string
}

type Backup struct {
	Date time.Time
	Part bool
}

type BackupList []Backup

func (d BackupList) Swap(i, j int)      { d[i], d[j] = d[j], d[i] }
func (d BackupList) Len() int           { return len(d) }
func (d BackupList) Less(i, j int) bool { return d[i].Date.Before(d[j].Date) }

var prefix string
var filename string
var nrOfBackups int
var configFileLocation string
var process *os.Process

const dateFormat = "2006-01-02"

func main() {
	gracefullExit := make(chan os.Signal, 1)
	signal.Notify(gracefullExit, os.Interrupt, os.Kill, syscall.SIGTERM, syscall.SIGQUIT)
	go func(c chan os.Signal) {
        signal := <-c
        log.Println("caught signal:", signal)
		if process != nil {
            log.Println("gracefull exit")
			process.Signal(syscall.SIGQUIT)
            process.Wait()
		}

	}(gracefullExit)

	ParseCommandLine()
	CallTarsnap()
	if len(ListArchivesWithPrefix()) > nrOfBackups {
		DeleteOldest()
	}
}

func ParseCommandLine() {
	// parse archive name / prefix
	for i, f := range os.Args {
		if f == "-f" {
			prefix = os.Args[i+1]
			filename = os.Args[i+1] + "-" + time.Now().Format(dateFormat)
			os.Args = append(os.Args[:i], os.Args[i+2:]...)
		}
		if f == "--nr-backups" {
			var err error
			nrOfBackups, err = strconv.Atoi(os.Args[i+1])
			if err != nil {
				log.Fatal("--nr-backups must be integer")
			}
			os.Args = append(os.Args[:i], os.Args[i+2:]...)
		}
		if f == "--configfile" {
			configFileLocation = os.Args[i+1]
		}
	}

	if nrOfBackups == 0 {
		nrOfBackups = 3
	}
}

func CallTarsnap() {
    // build argruments to exec.command
    arguments := append([]string{ "-f "+filename }, os.Args[1:]...)
	cmd := exec.Command("tarsnap", arguments...)
	log.Println(cmd.Args)

    // combine stderr and stdout in one buffer
	var b bytes.Buffer
	cmd.Stdout = &b
	cmd.Stderr = &b

	if err := cmd.Start(); err != nil {
		log.Fatal(err)
	}
	cmd.Start()
	// save process
	process = cmd.Process

    archiveExistsRegex := regexp.MustCompile("^tarsnap: An archive already exists with the name .*")
	if err := cmd.Wait(); err != nil {
		output := b.Bytes()
        if archiveExistsRegex.Match(output){
            filename += ".2"
            CallTarsnap()
        }
		log.Fatal(err, " ", string(output))
	}
    //Todo: check if error is "archive already exists", and act on that with prefix.1-date 
}

func ListArchivesWithPrefix() [][]byte {
	// run tarsnap --list-archives
	cmd := exec.Command("tarsnap", "--list-archives", "--configfile", configFileLocation)
	out, err := cmd.CombinedOutput()
	if err != nil {
		log.Fatal(err, " ", string(out))
	}
	var filtered [][]byte
	prefixRegex := regexp.MustCompile(prefix + ".*")
	for _, a := range bytes.Fields(out) {
		if prefixRegex.Match(a) {
			filtered = append(filtered, a)
		}
	}
	return filtered
}

func DeleteOldest() {
	archives := ListArchivesWithPrefix()
	if len(archives) < nrOfBackups {
		return
	}

	// extract dates
	dateRegex := regexp.MustCompile(prefix + `-(\d{4}-\d{2}-\d{2})(\.part)?$`)
	var backups BackupList
	found := false
	for _, line := range archives {
		match := dateRegex.FindSubmatch(line)
		if len(match) < 1 {
			continue
		}
		found = true
		date, err := time.Parse(dateFormat, string(match[1]))
		if err != nil {
			panic(err)
		}
		backups = append(backups, Backup{Date: date, Part: (string(match[2]) == ".part")})
	}
	if !found {
		log.Fatal("no backup wiht name: ", prefix)
	}
	sort.Sort(backups)

	// delete oldest one
	backupsToDelete := len(backups) - nrOfBackups

	for i := 0; i < backupsToDelete && backupsToDelete >= 1; i++ {
		oldest := fmt.Sprintf("%s-%s", prefix, backups[i].Date.Format(dateFormat))
		if backups[i].Part {
			oldest = oldest + ".part"
		}
		log.Println("Delete:", oldest)

		cmd := exec.Command("tarsnap", "--configfile", configFileLocation, "-d", "-f", oldest)
		out, err := cmd.CombinedOutput()
		if err != nil {
			log.Fatal(err, " ", string(out))
		}
	}

}
