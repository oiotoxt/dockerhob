## 사용법

---

### GPU를 사용할 경우

#### 시스템 요구 사항

- linux
- NVIDIA Driver
- docker
- nvidia-docker

#### 사용법

(컨테이너에서 바라볼) 작업 디렉토리 만들기

    $ mkdir .../my_workspace

    $ cd .../my_workspace

프로젝트 클론

    $ git clone https://github.com/oiotoxt/dockerhob.git

다음 중 한 폴더로 이동

    $ cd docker.ml.ssh

    $ cd docker.ml.jpt

(옵션) Makefile에서 다음 두 라인 편집

    GPU?=0
    ARG_CONTAINER_NAME?=ml-jpt-v1-YOURNAME

명령어 설명 보기

    $ make

```
# 출력된 결과

_build                         [관리자 전용] 도커 이미지를 만듭니다.
_push                          [관리자 전용] 레지스트리에 push 합니다.
pull                           이미 생성된 이미지를 받아옵니다.
run                            도커 컨테이너를 실행합니다. (랜덤 포트 연결)
runi                           도커 컨테이너를 실행합니다. (랜덤 포트 연결. 인터랙티브 모드)
runf                           도커 컨테이너를 실행합니다. (고정 포트 연결)
start                          컨테이너를 시작합니다.
stop                           컨테이너를 중지합니다.
rm                             컨테이너를 중지하고 삭제합니다.
ssh                            컨테이너에 SSH 연결 (as coder)
sshroot                        컨테이너에 SSH 연결 (as root)
info                           SSH로 컨테이너에 연결할 때 사용할 컨맨드 등 출력
logs                           컨테이너 내부의 로그를 봅니다.
env                            EXEC: 컨테이너 내부의 도커 환경을 봅니다. (as coder)
bash                           EXEC: 컨테이너 bash 실행 (as coder)
bashroot                       EXEC: 컨테이너 bash 실행 (as root)
piplist                        EXEC: pip list (as coder)
cat                            Makefile 출력
```

컨테이너 실행

    $ make run

```
# 출력된 결과

NV_GPU=0 nvidia-docker run -d --restart=unless-stopped \
	--name ml-ssh-v1-YOURNAME \
	--ipc=host \
	-h ML-SSH-V1 \
	-e PUID=1080 -e PGID=1080 \
	-P \
	-v /home/peras/repos:/workspace \
	-v /etc/timezone:/etc/timezone \
	-v /etc/localtime:/etc/localtime \
	dockerhob/ml-ssh:v1
e01c613790a39a2d0f740b390241eac2370c084dc4b5e0026a67618e04c63a87
```

컨테이너 정보 조회

    $ make info

```
# 출력된 결과

----------------------------------------
ARG_IMAGE_NAME          = dockerhob/ml-ssh:v1
ARG_CONTAINER_NAME      = ml-ssh-v1-YOURNAME
ARG_WORKSPACE_HOST      = /home/peras/repos
ARG_WORKSPACE_CONTAINER = /workspace
----------------------------------------
ARG_PUID                = 1080
ARG_PGID                = 1080
----------------------------------------
Port(TensorBoard)=32992
----------------------------------------
==> ssh-keygen -t rsa -b 4096 -C "$(id -un)[$(id -u)-$(id -g)]@$(hostname)"
==> ssh-copy-id -i ~/.ssh/id_rsa.pub coder@172.20.41.21 -p 32993
----------------------------------------
==> ssh coder@172.20.41.21 -p 32993
----------------------------------------
```

위 결과 내용을 참고하여 ssh 접속

    $ ssh coder@172.20.41.21 -p 32993

    password: coder

더 이상 컨테이너가 필요 없으면 중지 및 삭제

    $ make rm

---

### CPU만 사용할 경우

#### 시스템 요구 사항

- linux
- docker

#### 사용법

- 준비 중입니다.