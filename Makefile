.PHONY: help

GCP_PROJECT=up9-docker-hub
REPO_BASE=gcr.io
PROJECT_NAME=consul-envoy
DOCKER_REPOSITORY=$(REPO_BASE)/$(GCP_PROJECT)/$(PROJECT_NAME)

CONSUL_VERSION=1.9.1
ENVOY_VERSION=1.16.2

help: ## This is help
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

build:	## Build docker image locally and tag it
	docker build --build-arg CONSUL_VERSION=${CONSUL_VERSION} --build-arg ENVOY_VERSION=${ENVOY_VERSION} -t "${DOCKER_REPOSITORY}:v${CONSUL_VERSION}-v${ENVOY_VERSION}" .

push: build		## Push locally built image to the docker repo
	docker push "${DOCKER_REPOSITORY}:v${CONSUL_VERSION}-v${ENVOY_VERSION}"

show-image:  ## Show latest images in GCR
	@gcloud container images list-tags $(DOCKER_REPOSITORY) --limit=10


