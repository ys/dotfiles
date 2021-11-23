GITCOMMIT := $(shell git rev-parse --short=7 HEAD 2>/dev/null)
NAME=dev

all: build

build:
	docker build -t yannicks/${NAME}:${GITCOMMIT} .

.PHONY: all build
