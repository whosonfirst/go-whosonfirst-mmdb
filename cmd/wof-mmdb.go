package main

import (
	"encoding/json"
	"flag"
	"fmt"
	"github.com/whosonfirst/go-whosonfirst-log"
	"github.com/whosonfirst/go-whosonfirst-spr"
	"github.com/whosonfirst/go-whosonfirst-mmdb/provider"
	"os"
)

func main() {

	var db = flag.String("db", "", "The path to your IP lookup database file")

	flag.Parse()

	logger := log.SimpleWOFLogger()

	pr, err := provider.NewWOFProvider(*db)

	if err != nil {
		logger.Fatal("failed to create IPLookup because %v", err)
	}

	results := make(map[string]spr.StandardPlacesResult)

	for _, ip := range flag.Args() {

		r, err := pr.QueryString(ip)

		if err != nil {
			logger.Fatal("unable to query %s because %s", ip, err)
		}

		results[ip] = r
	}

	enc, err := json.Marshal(results)

	if err != nil {
		logger.Fatal("unable to encode results because %s", err)
	}

	fmt.Printf("%s\n", enc)
	os.Exit(0)
}
