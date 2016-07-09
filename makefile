ACCOUNT = ocramz
PROJECT = compute-node
TAG = $(ACCOUNT)/$(PROJECT)

.DEFAULT_GOAL := help

help:
	@echo "Use \`make <target>\` where <target> is one of"
	@echo "  help     to display this help message"
	@echo "  build    to build the docker image"
	@echo "  rebuild  '', ignoring previous builds"
	@echo "  login    to login to your docker account"
	@echo "  push     to push the image to the docker registry"
	@echo "  run0     run bash in the image"

build:
	docker build -t $(TAG) .

rebuild:
	docker build --no-cache -t $(TAG) .

login:
	docker login -u $(ACCOUNT)

push: build login
	docker push $(TAG)

run0:
	docker run --rm -it $(TAG) /bin/bash
