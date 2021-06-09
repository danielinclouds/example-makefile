
# Include variables from the .envrc file
include .envrc

# ==================================================================================== # 
# HELPERS
# ==================================================================================== #
## help: print this help message
.PHONY: help
help:
	@echo 'Usage:'
	@sed -n 's/^##//p' ${MAKEFILE_LIST} | column -t -s ':' | sed -e 's/^/ /'


# ==================================================================================== # 
# PLAY
# ==================================================================================== #
## run/hello: prints Hello
.PHONY: run/hello
run/hello:
	@echo "Hello"

## run/bye: prints Bye
.PHONY: run/bye
run/bye:
	echo "Bye"

## run/foo: prints bar
.PHONY: run/foo
run/foo:
	@echo "bar"

## user: prints username
.PHONY: user
user:
	@echo ${USER}


# ==================================================================================== # 
# BUILD
# ==================================================================================== #
current_time = $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")
git_commit   = $(shell git describe --always --dirty)
git_tag      = $(shell git describe --always --dirty --tags)
linker_flags = '-X main.buildTime=${current_time} -X main.version=${git_tag} -X main.gitCommit=${git_commit}'

## build/api: build the cmd/api application
.PHONY: build
build:
	@echo 'Building...'
	GOOS=darwin GOARCH=amd64 go build -ldflags=${linker_flags} -o=./bin/darwin/
	GOOS=linux  GOARCH=amd64 go build -ldflags=${linker_flags} -o=./bin/linux_amd64/


# ==================================================================================== # 
# QUALITY CONTROL
# ==================================================================================== #
## audit: tidy dependencies and format, vet and test all code
.PHONY: audit 
audit:
	@echo 'Tidying and verifying module dependencies...'
	go mod tidy
	go mod verify
	@echo 'Formatting code...'
	go fmt ./...
	@echo 'Vetting code...'
	go vet ./...
	staticcheck ./...
	@echo 'Running tests...'
	go test -race -vet=off ./...

