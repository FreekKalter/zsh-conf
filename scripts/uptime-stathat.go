package main

import (
	"bytes"
	"github.com/stathat/go"
	"log"
	"os"
	"os/exec"
	"regexp"
	"strconv"
	"time"
)

func main() {
	cmd := exec.Command("uptime")
	output, err := cmd.CombinedOutput()
	if err != nil {
		log.Fatal(err)
	}
	uptimeRegex := regexp.MustCompile(`.*up\s+(\d+:\d+).*`)
	matches := uptimeRegex.FindSubmatch(output)
	justMinutesRegex := regexp.MustCompile(`.*up\s+(\d+)\s+min.*`)

	// find index of :
	// everythin before : is hours
	var hourStat float64
	if len(matches) > 0 {
		i := bytes.IndexByte(matches[1], byte(':'))
		hours, err := strconv.ParseInt(string(matches[1][:i]), 10, 64)
		if err != nil {
			log.Fatal(err)
		}
		minutes, err := strconv.ParseInt(string(matches[1][i+1:]), 10, 64)
		if err != nil {
			log.Fatal(err)
		}
		hourStat = float64(hours) + float64(minutes)/60
	} else if matches = justMinutesRegex.FindSubmatch(output); len(matches) > 0 {
		var err error
		minutes, err := strconv.ParseFloat(string(matches[1]), 64)
		if err != nil {
			log.Fatal(err)
		}
		hourStat = float64(minutes) / 60
	}

	var hostname string
	hostname, err = os.Hostname()
	if err != nil {
		hostname = ""
	}
	log.Println(hourStat, hostname)
	err = stathat.PostEZValue("uptime@"+hostname, "freek@kalteronline.org", hourStat)
	if err != nil {
		log.Fatal(err)
	}

	// wait for a maximum of 20 seconds for request to complete
	stathat.WaitUntilFinished(20 * time.Second)
}
