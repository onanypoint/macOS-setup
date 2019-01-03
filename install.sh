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

# Check for Homebrew and install if we don't have it
if test ! $(which brew); then
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

echo "Installing stuff via Homebrew"
# Update Homebrew recipes
brew update

# Install brew package
# brew tap homebrew/bundle
brew bundle

echo "Updating preferences using Mackup"
# Restore dotfiles
ln -s $(pwd)/dotfiles/.mackup ~/.mackup
ln -s $(pwd)/dotfiles/.mackup.cfg ~/.mackup.cfg
mackup restore

echo "Setting preferences"

# Set macOS preferences
source macos.setup
source macos.prefs
source macos.nvram

# macOS security 101
# Definitely check out in more details the README
# https://github.com/drduh/macOS-Security-and-Privacy-Guide
# https://blog.bejarano.io/hardening-macos.html
