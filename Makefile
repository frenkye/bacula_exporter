################################################################################

# This Makefile generated by GoMakeGen 1.3.0 using next command:
# gomakegen .
#
# More info: https://kaos.sh/gomakegen

################################################################################

.DEFAULT_GOAL := help
.PHONY = fmt vet all clean git-config deps help

################################################################################

DOCKER_IMAGE = funbox/bacula_exporter
VERSION := 1.0.2
BUMPVERSION_PART ?= patch

################################################################################

all: bacula_exporter ## Build all binaries

bacula_exporter: ## Build bacula_exporter binary
	CGO_ENABLED=0 go build bacula_exporter.go

compress: ## Compress bacula_exporter binary
	upx bacula_exporter

docker-build: ## Build Docker image
	docker build -t $(DOCKER_IMAGE):$(VERSION) .

docker-push: ## Push Docker image
	docker push $(DOCKER_IMAGE):$(VERSION)

chart: ## Build Helm chart
	helm package charts/bacula_exporter

install: ## Install all binaries
	cp bacula_exporter /usr/bin/bacula_exporter

uninstall: ## Uninstall all binaries
	rm -f /usr/bin/bacula_exporter

git-config: ## Configure git redirects for stable import path services
	git config --global http.https://pkg.re.followRedirects true

deps: git-config ## Download dependencies
	go get -d -v github.com/funbox/bacula_exporter
	go get -d -v github.com/jmoiron/sqlx
	go get -d -v github.com/lib/pq
	go get -d -v github.com/avast/retry-go
	go get -d -v pkg.re/essentialkaos/ek.v12/fmtc
	go get -d -v pkg.re/essentialkaos/ek.v12/knf
	go get -d -v pkg.re/essentialkaos/ek.v12/knf/validators
	go get -d -v pkg.re/essentialkaos/ek.v12/knf/validators/fs
	go get -d -v pkg.re/essentialkaos/ek.v12/log
	go get -d -v pkg.re/essentialkaos/ek.v12/options
	go get -d -v pkg.re/essentialkaos/ek.v12/signal
	go get -d -v pkg.re/essentialkaos/ek.v12/usage

bump:
	bump2version $(BUMPVERSION_PART)

fmt: ## Format source code with gofmt
	find . -name "*.go" -exec gofmt -s -w {} \;

vet: ## Runs go vet over sources
	go vet -composites=false -printfuncs=LPrintf,TLPrintf,TPrintf,log.Debug,log.Info,log.Warn,log.Error,log.Critical,log.Print ./...

clean: ## Remove generated files
	rm -f bacula_exporter
	rm -f *.tgz

################################################################################

dev:
	docker-compose up -d

################################################################################

help: ## Show this info
	@echo -e '\n\033[1mSupported targets:\033[0m\n'
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[33m%-17s\033[0m %s\n", $$1, $$2}'
	@echo -e ''
	@echo -e '\033[90mGenerated by GoMakeGen 1.3.0\033[0m\n'

################################################################################
