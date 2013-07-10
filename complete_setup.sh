#!/bin/bash
## Setup script for an Ubuntu 12.04 LTS Amazon Web Services EC2 instance,
## based on setup script from Startup Engineering course script by
## Balaji S. Srinivasan. 


################################################################################
# Core Development Environment: git, emacs, dotfiles
################################################################################

# Update package information before installing anything.
sudo apt-get update

# Install and configure git.
sudo apt-get install -y git-core
git config --global user.name "Chaitanya Ganoo"
git config --global user.email chaitanyaganoo9@gmail.com

# Install emacs24. See https://launchpad.net/~cassou/+archive/emacs.
sudo apt-add-repository -y ppa:cassou/emacs
sudo apt-get update
sudo apt-get install -y emacs24 emacs24-el emacs24-common-non-dfsg

# Pull dotfiles from public git repo and setup symbolic links to them.
cd $HOME
if [ -d ./nix-env/ ]; then
  rsync -a nix-env/ nix-env.old/
  rm -rf nix-env/
fi
if [ -d .emacs.d/ ]; then
  rsync -a .emacs.d/ .emacs.d~/
  rm -rf .emacs.d/
fi

git clone https://github.com/cganoo/dot-files.git
ln -sb nix-env/dotfiles/.bash_aliases .
ln -sb nix-env/dotfiles/.bash_config_history .
ln -sb nix-env/dotfiles/.bash_config_prompt .
ln -sb nix-env/dotfiles/.bash_profile .
ln -sb nix-env/dotfiles/.bashrc .
ln -sb nix-env/dotfiles/.screenrc .
ln -sf nix-env/dotfiles/.emacs.d .


################################################################################
# JavaScript Tools: node.js, jshint, rlwrap
################################################################################

# Install nvm: node version manager (https://github.com/creationix/nvm), for
# managing multiple active node.js versions.
curl https://raw.github.com/creationix/nvm/master/install.sh | sh

# Install latest node.js production version v0.10.12.
source $HOME/.nvm/nvm.sh
sudo nvm install v0.10.12
nvm use v0.10.12

# Install Node Package Manager (npm) and some commonly used node packages.
sudo apt-get install -y npm
sudo npm install -g accounting  # Financial accounting libs.
sudo npm install -g commander   # Command-line flags.
sudo npm install -g csv         # Work with CSV files.
sudo npm install -g jshint      # Allow checking JS code within emacs.
sudo npm install -g restler     # Make REST API calls.

# Install rlwrap to provide libreadline features with node.
# See http://nodejs.org/api/repl.html#repl_repl.
sudo apt-get install -y rlwrap


################################################################################
# Production Tools: heroku
################################################################################

# Install heroku tools.
wget -qO- https://toolbelt.heroku.com/install-ubuntu.sh | sudo sh


# Load bash dotfiles just setup.
source $HOME/.bash_profile
