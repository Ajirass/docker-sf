#!/usr/bin/env bash

# /!\ Ceci est un script d'installation prévu pour des personnes n'ayant rien de configuré sur leur machine
# /!\ Adaptez ce script en fonction de vos besoins avant de le lancer.

# Lancer ce script depuis la racine de Docker :
# ./install/linux-install.sh

set -e

# Colors
COL_RESET=$'\e[39;49;00m'
RED=$'\e[31;01m'
GREEN=$'\e[32;01m'
YELLOW=$'\e[33;01m'
BLUE=$'\e[34;01m'
MAGENTA=$'\e[35;01m'
CYAN=$'\e[36;01m'

#DOCKER_PATH=$HOME/docker/docker-sf
#PROJECT_PATH=$HOME/www
#PROJECT_NAME=project_name
#GITHUB_LINK=github_link

# @info:    Prints error messages
# @args:    error-message
echoError ()
{
  echo "\033[0;31mFAIL\n\n$1 \033[0m"
}

# @info:    Prints warning messages
# @args:    warning-message
echoWarn ()
{
  echo "\033[0;33m$1 \033[0m"
}

# @info:    Prints success messages
# @args:    success-message
echoSuccess ()
{
  echo "\033[0;32m$1 \033[0m"
}

# @info:    Prints check messages
# @args:    success-message
echoInfo ()
{
  echo "\033[1;34m[INFO] \033[0m$1"
}

# @info:    Prints property messages
# @args:    property-message
echoProperties ()
{
  echo "\t\033[0;35m- $1 \033[0m"
}

install_github_ssh_key() {
    while true; do
        read -p "${GREEN} - Enter your github email address: ${COL_RESET}" email
        case $email in
            ?*@?*.?* ) ssh-keygen -t rsa -b 4096 -C "$email"; break;;
            * ) echo "      ${RED}Please enter a valid email${COL_RESET}";;
        esac
    done

    echo
    echo

    ssh-add ~/.ssh/id_rsa
    cat ~/.ssh/id_rsa.pub

    echo

    while true; do
        read -p "${GREEN} - Now copy past your ssh-rsa into github (see https://help.github.com/articles/generating-ssh-keys/#step-4-add-your-ssh-key-to-your-account) and press enter when its done !${COL_RESET} " yn
        case $yn in
            * ) break;;
        esac
    done

    ssh -T git@github.com

    break
}

echo "============================================================="
echo
echo "=============== Install Symfony3 Docker stack ==============="
echo
echo "============================================================="

echo

default=$HOME/docker/docker-sf
read -p "- Enter the docker path (${YELLOW}$default${COL_RESET}): " DOCKER_PATH
DOCKER_PATH=${DOCKER_PATH:-$default}

default=$HOME/www
read -p "- Enter your website (${YELLOW}$default${COL_RESET}): " PROJECT_PATH
PROJECT_PATH=${PROJECT_PATH:-$default}

#
# Check if Homebrew is installed
#
which -s brew
if [[ $? != 0 ]] ; then
    # Install package manager on mac osx call homebrew
    # https://github.com/mxcl/homebrew/wiki/installation
    echoInfo "==> Install Homebrew"
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
else
    echoInfo "brew update && brew upgrade"
    # Make sure brew is up to date
    brew update && brew upgrade
    echoSuccess "======= Done ! ======="
fi

echoInfo "==> Install brew-cask"
# Homebrew Cask extends Homebrew and brings its elegance, simplicity, and speed to OS X applications and large binaries alike.
brew tap caskroom/cask
echoSuccess "======= Done ! ======="

if  [[ "$(vboxmanage --version)" == 0 ]] ; then
    read -p "Install Virtualbox (y/n)? " -n 1 -r
    echo    # (optional) move to a new line
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        echoInfo "==> Install Virtualbox"
        brew cask install virtualbox
        echoSuccess "======= Done ! ======="
    fi
fi

echoInfo "==> Install some libraries with brew"
for pkg in wget git docker docker-compose docker-machine gettext docker-machine-nfs; do
    echoInfo "Trying to install '$pkg'..."
    sleep 0.3
    if brew list -1 | grep -q "^${pkg}\$"; then
        echo " - '$pkg' already installed"
    else
        brew install $pkg
    fi
done
brew link --force gettext
echoSuccess "======= Done ! ======="

cd $DOCKER_PATH

read -p "Create docker-machine dev (y/n)? " -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]
then
    echoInfo "==> Create docker machine dev"
    sh create-machine.sh
    default=$HOME/.bash_profile
    read -p "- Enter your bashprofile path (${YELLOW}$default${COL_RESET}): " BASH_PATH
    BASH_PATH=${BASH_PATH:-$default}
    docker-machine env dev >> $BASH_PATH
    echoSuccess "======= Done ! ======="
fi

#sh config_env.sh $PROJECT_PATH $DOCKER_PATH $(id -u)

echoInfo "==> Mount local path to doker-machine please wait ... "
sleep 5
docker-machine-nfs dev --shared-folder=/Users/$USER --nfs-config="-alldirs -maproot=0" --mount-opts="noatime,soft,nolock,vers=3,udp,proto=udp,rsize=8192,wsize=8192,namlen=255,timeo=10,retrans=3,nfsvers=3"
echo "${GREEN}======= Done ! =======${COL_RESET}"

