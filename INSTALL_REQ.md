# UBUNTU

## [NVIDIA Driver](https://www.google.com/search?newwindow=1&ei=x0lBXfGhI5zMmAW_3ZXoDQ&q=How+to+Install+latest+nvidia+drivers+in+linux&oq=How+to+Install+latest+nvidia+drivers+in+linux&gs_l=psy-ab.3..35i39i19.1543.1917..2800...0.0..0.122.232.0j2......0....1..gws-wiz.......0i19.NIeyvBbm3Xs&ved=0ahUKEwixoabA197jAhUcJqYKHb9uBd0Q4dUDCAo&uact=5)

```bash
# 여러가지 방법으로 NVIDIA Driver를 설치할 수 있습니다.
# 다음은 PPA를 사용하여 최신 버전을 설치하는 방법입니다.

$ sudo apt install ubuntu-drivers-common
$ sudo add-apt-repository ppa:graphics-drivers/ppa
$ sudo apt update
$ sudo ubuntu-drivers autoinstall
```

## [Docker](https://docs.docker.com/install/)

```bash
$ mkdir -p ~/repos/install && cd ~/repos/install
$ curl -fsSL https://get.docker.com -o get-docker.sh && sudo sh get-docker.sh
$ sudo usermod -aG docker $USER
# (다시 로그인해야 usermod가 적용됩니다)
```

## [nvidia-docker](https://github.com/NVIDIA/nvidia-docker)

```bash
# If you have nvidia-docker 1.0 installed: we need to remove it and all existing GPU containers
$ docker volume ls -q -f driver=nvidia-docker | xargs -r -I{} -n1 docker ps -q -a -f volume={} | xargs -r docker rm -f
$ sudo apt-get purge -y nvidia-docker

# Add the package repositories
$ curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | \
    sudo apt-key add -
$ distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
$ curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | \
    sudo tee /etc/apt/sources.list.d/nvidia-docker.list
$ sudo apt-get update

# Install nvidia-docker2 and reload the Docker daemon configuration
$ sudo apt-get install -y nvidia-docker2
$ sudo pkill -SIGHUP dockerd

# Test nvidia-smi with the latest official CUDA image
$ docker run --runtime=nvidia --rm nvidia/cuda:9.0-base nvidia-smi
```
