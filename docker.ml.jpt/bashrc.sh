#!/bin/bash

echo "sourced: /etc/bash.bashrc"
#-------------------------------------------------------------------------------
export PS1="\[\e[31m\]coder\[\e[m\] \[\e[33m\]\w\[\e[m\] > "
export TERM=xterm-256color
alias grep="grep --color=auto"
alias ls="ls --color=auto"
#-------------------------------------------------------------------------------
colorred="\033[31m"
colorpowder_blue="\033[1;36m" #with bold
colorblue="\033[34m"
colornormal="\033[0m"
colorwhite="\033[97m"
colorlightgrey="\033[90m"

echo -e "\e[1;31m"
echo "--------------------------------------------------------------------------------"
echo
printf "                   ${colorred} ##       ${colorlightgrey} .         \n"
printf "             ${colorred} ## ## ##      ${colorlightgrey} ==         \n"
printf "           ${colorred}## ## ## ##      ${colorlightgrey}===         \n"
printf "       /\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\\\___/ ===       \n"
printf "  ${colorblue}~~~ ${colorlightgrey}{${colorblue}~~ ~~~~ ~~~ ~~~~ ~~ ~ ${colorlightgrey}/  ===- ${colorblue}~~~${colorlightgrey}\n"
printf "       \\\______${colorwhite} o ${colorlightgrey}         __/           \n"
printf "         \\\    \\\        __/            \n"
printf "          \\\____\\\______/               \n"
printf "${colorpowder_blue}                                          \n"
printf "          |          |                    \n"
printf "       __ |  __   __ | _  __   _          \n"
printf "      /  \\\| /  \\\ /   |/  / _\\\ |     \n"
printf "      \\\__/| \\\__/ \\\__ |\\\_ \\\__  | \n"
printf " ${colornormal}                                         \n"
#-------------------------------------------------------------------------------
echo -e "\e[1;31m"
echo "--------------------------------------------------------------------------------"
echo "User UID:  $(id -u)"
echo "User GID:  $(id -g)"
echo "--------------------------------------------------------------------------------"
#-------------------------------------------------------------------------------
echo -e "\e[0;33m"

if [[ $EUID -eq 0 ]]; then
  cat <<WARN
WARNING: You are running this container as root, which can cause new files in
mounted volumes to be created as the root user on your host machine.
To avoid this, run the container by specifying your user's userid:
$ docker run -e PUID=\$(id -u) -e PGID=\$(id -g) args...
WARN
else
  cat <<EXPL
You are running this container as user with UID=$(id -u) and GID=$(id -g),
which should map to the ID and group for your user on the Docker host. Great!
EXPL
fi

# Turn off colors
echo -e "\e[m"
