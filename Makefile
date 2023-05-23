username := index.docker.io/bossjones
container_name := docker-chezmoi

GIT_BRANCH  = $(shell git rev-parse --abbrev-ref HEAD)
GIT_SHA     = $(shell git rev-parse HEAD)
BUILD_DATE  = $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")
VERSION    ?= $(shell grep "ubuntu" Dockerfile | head -1 | cut -d":" -f2)

TAG ?= $(VERSION)
ifeq ($(TAG),@branch)
	override TAG = $(shell git symbolic-ref --short HEAD)
	@echo $(value TAG)
endif

build-push-base:
		docker buildx build \
		--push \
		--platform linux/arm/v7,linux/arm64/v8,linux/amd64 \
		--build-arg VCS_REF=$(GIT_SHA) --build-arg BUILD_DATE=$(VERSION) --build-arg BUILD_DATE=$(shell date -u +'%Y-%m-%dT%H:%M:%SZ') \
		--tag $(username)/$(container_name):latest .

build: build-push-base

build-push: build

pull:
	docker pull $(username)/$(container_name):latest

# --platform linux/amd64

bash:
	docker run \
	-it \
	--rm \
	--name docker-chezmoi \
	-v /etc/localtime:/etc/localtime:ro \
	--entrypoint "/bin/bash" \
	$(username)/$(container_name):latest \
	-l
