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

DOCKER_PATH=$HOME/docker
PROJECT_PATH=$HOME/www
PROJECT_NAME=project_name
GITHUB_LINK=github_link

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
  printf "\033[1;34m[INFO] \033[0m$1"
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

    echo ""

    while true; do
        read -p "${GREEN} - Now copy past your ssh-rsa into github (see https://help.github.com/articles/generating-ssh-keys/#step-4-add-your-ssh-key-to-your-account) and press enter when its done !${COL_RESET} " yn
        case $yn in
            * ) break;;
        esac
    done

    ssh -T git@github.com

    break
}

echoInfo "======================================================"
echoInfo "=============== Install Symfony2 stack ==============="
echoInfo "======================================================"

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
    # Make sure brew is up to date
    brew update && brew upgrade
    echoSuccess "======= Done ! ======="
fi

echoinfo "==> Install brew-cask"
# Homebrew Cask extends Homebrew and brings its elegance, simplicity, and speed to OS X applications and large binaries alike.
brew tap caskroom/cask
brew install brew-cask
echoSuccess "======= Done ! ======="

echoInfo "==> Install Virtualbox"
brew cask install virtualbox
echoSuccess "======= Done ! ======="

echoInfo "==> Install some libraries with brew"
# Install amazon web services command cli
brew install awscli
brew install wget
brew install git
brew install docker
brew install docker-compose
brew install docker-machine
brew install gettext
brew link --force gettext
curl -sS https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer
echoSuccess "======= Done ! ======="

echoInfo "==> Install docker-machine nfs script"
brew install docker-machine-nfs
echoSuccess "======= Done ! ======="

cp ./.gitignore_global ~/.gitignore_global
git config --global core.excludesfile ~/.gitignore_global

cd $DOCKER_PATH
sh config_env.sh $PROJECT_PATH $DOCKER_PATH $(id -u)
echoInfo "==> Create docker machine dev"
sh create-machine.sh
echoInfo "==> Mount local path to doker-machine please wait ... "
sleep 5
sudo docker-machine-nfs --shared-folder=/Users/$USER --nfs-config="-alldirs -maproot=0" --mount-opts="noatime,soft,nolock,vers=3,udp,proto=udp,rsize=8192,wsize=8192,namlen=255,timeo=10,retrans=3,nfsvers=3"
echo "${GREEN}======= Done ! =======${COL_RESET}"

echo "${YELLOW}==> Install oh my zsh${COL_RESET}"
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
cp zsh_aliases ~/.zsh_aliases
echo ". ~/.zsh_aliases" >> ~/.zshrc
echo "${GREEN}======= Done ! =======${COL_RESET}"

echoInfo "==> Cloning project into $PROJECT_PATH/$PROJECT_NAME "
mkdir ~/www
git clone $GITHUB_LINK $PROJECT_PATH/$PROJECT_NAME
cp ./ips.php $PROJECT_PATH/$PROJECT_NAME/web
echoSuccess "======= Done ! ======="