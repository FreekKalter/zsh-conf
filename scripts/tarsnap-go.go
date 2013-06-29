package main

import (
	"bytes"
	"fmt"
	"log"
	"os"
	"os/exec"
	"regexp"
	"sort"
	"strconv"
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
var nrOfBackups int
var configFileLocation string

const dateFormat = "2006-01-02"

func main() {
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
			os.Args[i+1] += "-" + time.Now().Add(-100 * time.Hour).Format(dateFormat)
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
	cmd := exec.Command("tarsnap", os.Args[1:]...)
	fmt.Println(cmd.Args)
	out, err := cmd.CombinedOutput()
	if err != nil {
		log.Fatal(err, " ", string(out))
	}
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
		fmt.Println("Delete:", oldest)

		cmd := exec.Command("tarsnap", "--configfile", configFileLocation, "-d", "-f", oldest)
		out, err := cmd.CombinedOutput()
		if err != nil {
			log.Fatal(err, " ", string(out))
		}
	}

}
