CWD=$(shell pwd)
GOPATH := $(CWD)

prep:
	if test -d pkg; then rm -rf pkg; fi

self:   prep rmdeps
	if -d src; then rm -rf src; fi
	mkdir -p src/github.com/whosonfirst/go-whosonfirst-mmdb/
	cp *.go src/github.com/whosonfirst/go-whosonfirst-mmdb/
	mkdir -p src/github.com/whosonfirst/go-whosonfirst-mmdb/provider
	cp provider/*.go src/github.com/whosonfirst/go-whosonfirst-mmdb/provider/
	cp -r vendor/* src/
	cp -r vendor/github.com/whosonfirst/go-whosonfirst-geojson-v2/vendor/src/github.com/tidwall src/github.com/
	cp -r vendor/github.com/whosonfirst/go-whosonfirst-geojson-v2/vendor/src/github.com/whosonfirst/go-whosonfirst-hash src/github.com/whosonfirst/
	cp -r vendor/github.com/whosonfirst/go-whosonfirst-geojson-v2/vendor/src/github.com/whosonfirst/go-whosonfirst-placetypes src/github.com/whosonfirst/

rmdeps:
	if test -d src; then rm -rf src; fi 

build:	fmt bin

deps:
	@GOPATH=$(GOPATH) go get -u "github.com/oschwald/maxminddb-golang"
	@GOPATH=$(GOPATH) go get -u "github.com/whosonfirst/go-whosonfirst-csv"
	@GOPATH=$(GOPATH) go get -u "github.com/whosonfirst/go-whosonfirst-geojson-v2"
	# @GOPATH=$(GOPATH) go get -u "github.com/whosonfirst/go-whosonfirst-iplookup"
	@GOPATH=$(GOPATH) go get -u "github.com/whosonfirst/go-whosonfirst-log"
	@GOPATH=$(GOPATH) go get -u "github.com/whosonfirst/go-whosonfirst-spr"
	@GOPATH=$(GOPATH) go get -u "github.com/whosonfirst/go-whosonfirst-uri"

vendor-deps: rmdeps deps
	if test -d vendor; then rm -rf vendor; fi
	mkdir vendor
	cp -r src/* vendor/
	find vendor -name '.git' -print -type d -exec rm -rf {} +
	rm -rf src
	rm -rf vendor/github.com/whosonfirst/go-whosonfirst-iplookup/vendor/github.com/whosonfirst/*

fmt:
	go fmt *.go
	go fmt cmd/*.go

bin: 	self
	@GOPATH=$(GOPATH) go build -o bin/wof-mmdb cmd/wof-mmdb.go
	@GOPATH=$(GOPATH) go build -o bin/wof-mmdb-server cmd/wof-mmdb-server.go
	@GOPATH=$(GOPATH) go build -o bin/wof-mmdb-lookup cmd/wof-mmdb-lookup.go
