#!/bin/sh

echo "Setting up your Mac..."

# Paremeters
while getopts ":n:" opt; do
  case $opt in
    n)
        COMPUTER_NAME=${OPTARG};;
  esac
done

# Set computer name
# https://ilostmynotes.blogspot.com/2012/03/computername-vs-localhostname-vs.html
if [[ -z ${COMPUTER_NAME} ]] ; then
    echo "Computer name not set"
else
    echo "Computer name set to ${COMPUTER_NAME}"
    sudo scutil --set ComputerName "${COMPUTER_NAME}"
    sudo scutil --set HostName "${COMPUTER_NAME}"
    sudo scutil --set LocalHostName "${COMPUTER_NAME}"
fi

# Disable natural scrolling
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool FALSE

# Show hidden file
defaults write com.apple.Finder AppleShowAllFiles true

# Restart Finder
killall Finder

# Check for zrezto and install if we don't have it
if [ ! -d "${ZDOTDIR:-$HOME}/.zprezto" ]; then
  echo "Installing Prezto"
  git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"

  # setopt EXTENDED_GLOB
  # for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
  #   ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
  # done

  chsh -s /bin/zsh
fi

# Check for Homebrew and install if we don't have it
if test ! $(which brew); then
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Update Homebrew recipes
echo "Installing stuff via Homebrew"
brew update
brew bundle

# Restore dotfiles
echo "Updating preferences using Mackup"
if [[ -f "~/.mackup" ]]; then
  echo "Mackup file already exists, aborting"
else
  ln -s $(pwd)/dotfiles/.mackup ~/.mackup
  ln -s $(pwd)/dotfiles/.mackup.cfg ~/.mackup.cfg
  mackup restore
fi

# Set macOS preferences
echo "Setting preferences"
source setup/settings.sh
source setup/preferences.sh
source setup/nvram.sh

# macOS security 101
# Definitely check out in more details the README
# https://github.com/drduh/macOS-Security-and-Privacy-Guide
# https://blog.bejarano.io/hardening-macos.html