.DEFAULT_GOAL := help

#*******************************************************************************
# 가정
#-------------------------------------------------------------------------------
# 1. Docker가 설치된 Host에 접속 후
# 2. 작업 폴더를 하나 만들고
# 3. 그 아래 dockerhob 프로젝트를 clone 한 뒤
# 4. 현재 폴더로 이동했다고 가정합니다.

#*******************************************************************************
# 사용법
#-------------------------------------------------------------------------------
# (컨테이너 내부가 아니라) 호스트에서 실행되어야 합니다.
#
# 가장 먼저!
#
#   ARG_CONTAINER_NAME 을 수정하세요.
#   GPU                를 수정하세요.
#
# 사용 예
#
#   $ make run
#   $ make info
#   $ make rm
#
# 설명보기
#
#   $ make

#*******************************************************************************
# System (CPU)
#-------------------------------------------------------------------------------
#
#   ┌────────────┬────────────┐
#   │ TensorFlow │  PyTorch   │  <== Containers
#   ├────────────┴────────────┤
#   │          Docker         │  <== Host (User)
#   ├╶╶╶╶╶╶╶╶╶╶╶╶╶╶╶╶╶╶╶╶╶╶╶╶╶┤
#   │          Linux          │  <== Host (Kernel)
#   ├─────────────────────────┤
#   │           CPU           │  <== Hardware
#   └─────────────────────────┘

#*******************************************************************************
# System (GPU)
#-------------------------------------------------------------------------------
#
#   ┌────────────┬────────────┐
#   │ TensorFlow │  PyTorch   │
#   │   cuDNN    │   cuDNN    │  <== Containers
#   │   CUDA     │   CUDA     │
#   ├────────────┴────────────┤
#   │      nvidia-docker      │
#   │                         │  <== Host (User)
#   │          Docker         │
#   ├╶╶╶╶╶╶╶╶╶╶╶╶╶╶╶╶╶╶╶╶╶╶╶╶╶┤
#   │      NVIDIA Driver      │
#   │                         │  <== Host (Kernel)
#   │          Linux          │
#   ├─────────────────────────┤
#   │           GPU           │  <== Hardware
#   └─────────────────────────┘

#*******************************************************************************
# Build Args
#-------------------------------------------------------------------------------
# <CPU>
# DOCKER=docker
# PROCESSOR=CPU

# <GPU>
GPU?=0
DOCKER=NV_GPU=$(GPU) nvidia-docker
#-------------------------------------------------------------------------------
# JUPYTER=notebook
# JUPYTER=lab
#-------------------------------------------------------------------------------
ARG_IMAGE_NAME?=dockerhob/ml-ssh:v2
ARG_CONTAINER_NAME?=ml-ssh-v2-YOURNAME
ARG_CONTAINER_HOSTNAME?=ML-SSH-V2-YOURNAME
#-------------------------------------------------------------------------------
ARG_PUID?=$(shell id -u)
ARG_PGID?=$(shell id -g)
#-------------------------------------------------------------------------------
ARG_PORT_SSH?=9222
ARG_PORT_TENSORBOARD?=9206
#-------------------------------------------------------------------------------
ARG_WORKSPACE_HOST?=$(realpath ../..)
ARG_WORKSPACE_CONTAINER?=/workspace

#*******************************************************************************
# $ make xxx
#-------------------------------------------------------------------------------
_build: ## [관리자 전용] 도커 이미지를 만듭니다.
	docker build -t $(ARG_IMAGE_NAME) \
		--build-arg tensorflow_version=tf-nightly-gpu-2.0-preview \
		-f Dockerfile .

_push: ## [관리자 전용] 레지스트리에 push 합니다.
	docker push $(ARG_IMAGE_NAME)

pull: ## 이미 생성된 이미지를 받아옵니다.
	docker pull $(ARG_IMAGE_NAME)

run: ## 도커 컨테이너를 실행합니다. (랜덤 포트 연결)
	$(DOCKER) run -d --restart=unless-stopped \
		--name $(ARG_CONTAINER_NAME) \
		--ipc=host \
		-h $(ARG_CONTAINER_HOSTNAME) \
		-e PUID=$(ARG_PUID) -e PGID=$(ARG_PGID) \
		-P \
		-v $(ARG_WORKSPACE_HOST):$(ARG_WORKSPACE_CONTAINER) \
		-v /SGS:/SGS \
		-v /etc/timezone:/etc/timezone \
		-v /etc/localtime:/etc/localtime \
		$(ARG_IMAGE_NAME)

runi: ## 도커 컨테이너를 실행합니다. (랜덤 포트 연결. 인터랙티브 모드)
	$(DOCKER) run -it --restart=unless-stopped \
		--name $(ARG_CONTAINER_NAME) \
		--ipc=host \
		-h $(ARG_CONTAINER_HOSTNAME) \
		-e PUID=$(ARG_PUID) -e PGID=$(ARG_PGID) \
		-P \
		-v $(ARG_WORKSPACE_HOST):$(ARG_WORKSPACE_CONTAINER) \
		-v /SGS:/SGS \
		-v /etc/timezone:/etc/timezone \
		-v /etc/localtime:/etc/localtime \
		$(ARG_IMAGE_NAME) \
		bash

runf: ## 도커 컨테이너를 실행합니다. (고정 포트 연결)
	$(DOCKER) run -d --restart=unless-stopped \
		--name $(ARG_CONTAINER_NAME) \
		--ipc=host \
		-h $(ARG_CONTAINER_HOSTNAME) \
		-e PUID=$(ARG_PUID) -e PGID=$(ARG_PGID) \
		-p $(ARG_PORT_SSH):22 \
		-p $(ARG_PORT_TENSORBOARD):6006 \
		-v $(ARG_WORKSPACE_HOST):$(ARG_WORKSPACE_CONTAINER) \
		-v /SGS:/SGS \
		-v /etc/timezone:/etc/timezone \
		-v /etc/localtime:/etc/localtime \
		$(ARG_IMAGE_NAME)

start: ## 컨테이너를 시작합니다.
	docker start $(ARG_CONTAINER_NAME)

stop: ## 컨테이너를 중지합니다.
	docker stop $(ARG_CONTAINER_NAME)

rm: stop ## 컨테이너를 중지하고 삭제합니다.
	docker rm $(ARG_CONTAINER_NAME)

ssh: ## 컨테이너에 SSH 연결 (as coder)
	$(eval HOST_IP := $(shell hostname -I | grep -o '^\S*'))
	$(eval SSH_PORT := $(shell docker port $(ARG_CONTAINER_NAME) | grep 22/ | sed 's/.*0.0.0.0://g' | sed 's/->.*//g'))
	ssh coder@$(HOST_IP) -p $(SSH_PORT)

sshroot: ## 컨테이너에 SSH 연결 (as root)
	$(eval HOST_IP := $(shell hostname -I | grep -o '^\S*'))
	$(eval SSH_PORT := $(shell docker port $(ARG_CONTAINER_NAME) | grep 22/ | sed 's/.*0.0.0.0://g' | sed 's/->.*//g'))
	ssh root@$(HOST_IP) -p $(SSH_PORT)

info: ## SSH로 컨테이너에 연결할 때 사용할 컨맨드 등 출력
	$(info ----------------------------------------)
	$(info ARG_IMAGE_NAME          = $(ARG_IMAGE_NAME))
	$(info ARG_CONTAINER_NAME      = $(ARG_CONTAINER_NAME))
	$(info ARG_WORKSPACE_HOST      = $(ARG_WORKSPACE_HOST))
	$(info ARG_WORKSPACE_CONTAINER = $(ARG_WORKSPACE_CONTAINER))
	$(info ----------------------------------------)
	$(info ARG_PUID                = $(ARG_PUID))
	$(info ARG_PGID                = $(ARG_PGID))
	$(info ----------------------------------------)
	$(eval TB_PORT := $(shell docker port $(ARG_CONTAINER_NAME) | grep 6006/ | sed 's/.*0.0.0.0://g' | sed 's/->.*//g'))
	$(info Port(TensorBoard)=$(TB_PORT))
	$(info ----------------------------------------)
	$(eval HOST_IP := $(shell hostname -I | grep -o '^\S*'))
	$(eval SSH_PORT := $(shell docker port $(ARG_CONTAINER_NAME) | grep 22/ | sed 's/.*0.0.0.0://g' | sed 's/->.*//g'))
	$(info ==> ssh-keygen -t rsa -b 4096 -C "$$(id -un)[$$(id -u)-$$(id -g)]@$$(hostname)")
	$(info ==> ssh-copy-id -i ~/.ssh/id_rsa.pub coder@$(HOST_IP) -p $(SSH_PORT))
	$(info ----------------------------------------)
	$(info ==> ssh coder@$(HOST_IP) -p $(SSH_PORT))
	$(info ----------------------------------------)

logs: ## 컨테이너 내부의 로그를 봅니다.
	docker logs $(ARG_CONTAINER_NAME)

env: ## EXEC: 컨테이너 내부의 도커 환경을 봅니다. (as coder)
	docker exec -u $(ARG_PUID):$(ARG_PGID) $(ARG_CONTAINER_NAME) env

bash: ## EXEC: 컨테이너 bash 실행 (as coder)
	docker exec -it -u $(ARG_PUID):$(ARG_GUID) $(ARG_CONTAINER_NAME) bash

bashroot: ## EXEC: 컨테이너 bash 실행 (as root)
	docker exec -it $(ARG_CONTAINER_NAME) bash

piplist: ## EXEC: pip list (as coder)
	docker exec -u $(ARG_PUID):$(ARG_PGID) $(ARG_CONTAINER_NAME) pip list

cat: ## Makefile 출력
	@cat Makefile

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
