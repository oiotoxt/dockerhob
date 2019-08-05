# 0. 소개

* 컨테이너 기반 머신러닝 개발 환경을 제공합니다.
  * make 명령어를 통한 약식 CLI 지원
  * Directories
    * base
      * /docker.mldev.base.ssh.gpu 및 /docker.mldev.base.ssh.cpu 에 포함된 주요 패키지
        * python        3.6    (apt)
        * onnx          latest (pip)
        * pytorch       latest (pip)
        * tensorflow    latest (pip)
        * **openssh-server** latest (apt)
          * [VS Code Remote Development](https://code.visualstudio.com/docs/remote/remote-overview)를 통해 원격 개발이 가능합니다.
      * /docker.mldev.base.jpt.gpu 에 포함된 주요 패키지
        * python        3.6    (apt)
        * onnx          latest (pip)
        * pytorch       latest (pip)
        * tensorflow    latest (pip)
        * **jupyter**     latest (pip)
    * spch
      * /docker.mldev.spch.ssh.gpu 및 /docker.mldev.spch.ssh.cpu 에 포함된 주요 패키지
        * python        3.6    (apt)
        * onnx          latest (pip)
        * pytorch       latest (pip)
        * tensorflow    latest (pip)
        * **openssh-server** latest (apt)
          * [VS Code Remote Development](https://code.visualstudio.com/docs/remote/remote-overview)를 통해 원격 개발이 가능합니다.
        * **Packages for speech-synthesis**
      * /docker.mldev.spch.jpt.gpu 에 포함된 주요 패키지
        * python        3.6    (apt)
        * onnx          latest (pip)
        * pytorch       latest (pip)
        * tensorflow    latest (pip)
        * **jupyter**     latest (pip)
        * **Packages for speech-synthesis**
* 지속적으로 다양한 Dockerfile을 추가할 예정입니다.
* 참고한 프로젝트
  * Deepo : https://github.com/ufoym/deepo
  * Docker Color Logo : https://github.com/jmhardison/dockercolorlogo

### docker(CPU) vs nvidia-docker(GPU)
```
# CPU Version
┌────────────┬────────────┐
│ TensorFlow │  PyTorch   │  <== Containers
├────────────┴────────────┤
│          Docker         │  <== Host (User)
├╶╶╶╶╶╶╶╶╶╶╶╶╶╶╶╶╶╶╶╶╶╶╶╶╶┤
│          Linux          │  <== Host (Kernel)
├─────────────────────────┤
│           CPU           │  <== Hardware
└─────────────────────────┘

# GPU Version
┌────────────┬────────────┐
│ TensorFlow │  PyTorch   │
│   cuDNN    │   cuDNN    │  <== Containers
│   CUDA     │   CUDA     │
├────────────┴────────────┤
│      nvidia-docker      │
│                         │  <== Host (User)
│          Docker         │
├╶╶╶╶╶╶╶╶╶╶╶╶╶╶╶╶╶╶╶╶╶╶╶╶╶┤
│      NVIDIA Driver      │
│                         │  <== Host (Kernel)
│          Linux          │
├─────────────────────────┤
│           GPU           │  <== Hardware
└─────────────────────────┘
```

# 1. [/docker.mldev.base.ssh.gpu](https://github.com/oiotoxt/dockerhob/tree/master/docker.mldev.base.ssh.gpu)

### 시스템 요구 사항

* [Linux](https://ubuntu.com/)
* [NVIDIA Driver](https://www.google.com/search?newwindow=1&ei=x0lBXfGhI5zMmAW_3ZXoDQ&q=How+to+Install+latest+nvidia+drivers+in+linux&oq=How+to+Install+latest+nvidia+drivers+in+linux&gs_l=psy-ab.3..35i39i19.1543.1917..2800...0.0..0.122.232.0j2......0....1..gws-wiz.......0i19.NIeyvBbm3Xs&ved=0ahUKEwixoabA197jAhUcJqYKHb9uBd0Q4dUDCAo&uact=5)
* [Docker](https://docs.docker.com/install/)
* [nvidia-docker](https://github.com/NVIDIA/nvidia-docker)

### 따라하기

```bash
# (컨테이너에서 바라볼) 작업 디렉토리 만들기
$ mkdir .../MY_WORKSPACE
$ cd .../MY_WORKSPACE

# 프로젝트 클론
$ git clone https://github.com/oiotoxt/dockerhob.git
$ cd dockerhob/docker.mldev.base.ssh.gpu
```

```bash
#(Option) Makefile에서 다음 두 라인 편집
GPU?=0
ARG_CONTAINER_NAME?=mldev-base-ssh-gpu-default

# 예)
GPU?=0,1,2,3
ARG_CONTAINER_NAME?=mldev-base-ssh-gpu-dev1
```

```bash
# 명령어 설명 보기
$ make

# 결과 예)
_build       로컬에 도커 이미지를 만듭니다.
_push        [관리자 전용] 이미지를 레지스트리에 push 합니다.
pull         레지스트리에서 이미지를 받아옵니다.
run          도커 컨테이너를 실행합니다. (랜덤 포트 연결)
runi         도커 컨테이너를 실행합니다. (랜덤 포트 연결. 인터랙티브 모드)
runf         도커 컨테이너를 실행합니다. (고정 포트 연결)
start        컨테이너를 시작합니다.
stop         컨테이너를 중지합니다.
rm           컨테이너를 중지하고 삭제합니다.
copyauth     호스트의 authrized_keys를 컨테이너에 복사 (as coder)
ssh          컨테이너에 SSH 연결 (as coder)
sshroot      컨테이너에 SSH 연결 (as root)
info         SSH로 컨테이너에 연결할 때 사용할 컨맨드 등 출력
logs         컨테이너 내부의 로그를 봅니다.
env          EXEC: 컨테이너 내부의 도커 환경을 봅니다. (as coder)
bash         EXEC: 컨테이너 내부의 bash 실행 (as coder)
bashroot     EXEC: 컨테이너 내부의 bash 실행 (as root)
piplist      EXEC: 컨테이너 내부의 pip list 실행 (as coder)
cat          Makefile 출력
```

```bash
# 컨테이너 실행
$ make run

# 결과 예)
NV_GPU=0,1,2,3 nvidia-docker run -d --restart=unless-stopped \
    --name mldev-base-ssh-gpu-default \
    --ipc=host \
    -h mldev-base-ssh-gpu-default \
    -e PUID=1080 -e PGID=1080 \
    -P \
    -v /home/MY_ID/MY_WORKSPACE:/workspace \
    -v /etc/timezone:/etc/timezone \
    -v /etc/localtime:/etc/localtime \
    dockerhob/ml-ssh:v1
e01c613790a39a2d0f740b390241eac2370c084dc4b5e0026a67618e04c63a87
```

```bash
# 컨테이너 정보 조회
$ make info

# 결과 예)
----------------------------------------
ARG_IMAGE_NAME          = dockerhob/mldev:ssh-gpu-v1
ARG_CONTAINER_NAME      = mldev-base-ssh-gpu-default
ARG_WORKSPACE_HOST      = /home/MY_ID/MY_WORKSPACE
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

```bash
# (Option) 편의를 위해 호스트의 authrized_keys를 컨테이너에 복사 (password: coder)
$ make copyauth

# 위 make info의 출력 내용을 참고하여 접속 (password: coder)
$ ssh coder@172.20.41.21 -p 32993
```

```bash
# 더 이상 컨테이너가 필요 없으면 중지 및 삭제
$ make rm
```

# 2. [/docker.mldev.base.jpt.gpu](https://github.com/oiotoxt/dockerhob/tree/master/docker.mldev.base.jpt.gpu)

### 시스템 요구 사항

* [Linux](https://ubuntu.com/)
* [NVIDIA Driver](https://www.google.com/search?newwindow=1&ei=x0lBXfGhI5zMmAW_3ZXoDQ&q=How+to+Install+latest+nvidia+drivers+in+linux&oq=How+to+Install+latest+nvidia+drivers+in+linux&gs_l=psy-ab.3..35i39i19.1543.1917..2800...0.0..0.122.232.0j2......0....1..gws-wiz.......0i19.NIeyvBbm3Xs&ved=0ahUKEwixoabA197jAhUcJqYKHb9uBd0Q4dUDCAo&uact=5)
* [Docker](https://docs.docker.com/install/)
* [nvidia-docker](https://github.com/NVIDIA/nvidia-docker)

# 3. [/docker.mldev.base.ssh.cpu](https://github.com/oiotoxt/dockerhob/tree/master/docker.mldev.base.ssh.cpu)

### 시스템 요구 사항

* [Docker](https://docs.docker.com/install/)