package main

import (
	"bytes"
	"github.com/stathat/go"
	"os/exec"
	"regexp"
	"strconv"
    "time"
)

func main() {
	cmd := exec.Command("uptime")
	output, err := cmd.CombinedOutput()
	if err != nil {
		panic(err)
	}
	uptimeRegex := regexp.MustCompile(`.*up\s+(\d+:\d+).*`)
	matches := uptimeRegex.FindSubmatch(output)
    justMinutesRegex := regexp.MustCompile(`.*up\s+(\d+)\s+\min.*`)

	// find index of :
	// everythin before : is hours
	i := bytes.IndexByte(matches[1], byte(':'))
    var stat float64
    if i >= 0 {
        hours, err := strconv.ParseInt(string(matches[1][:i]), 10, 64)
        if err != nil {
            panic(err)
        }
        minutes, err := strconv.ParseInt(string(matches[1][i+1:]), 10, 64)
        if err != nil {
            panic(err)
        }
	    stat = float64(minutes + 60 * hours)
    }else if matches = justMinutesRegex.FindSubmatch(output); len(matches)>0{
        var err error
        stat, err = strconv.ParseFloat(string(matches[1]), 64)
        if err != nil {
            panic(err)
        }
    }

	err = stathat.PostEZValue("london uptime", "freek@kalteronline.org", stat)
	if err != nil {
		panic(err)
	}

    // wait for a maximum of 20 seconds for request to complete
	stathat.WaitUntilFinished(20 * time.Second)
}
