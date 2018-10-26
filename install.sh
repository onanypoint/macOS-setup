#!/bin/sh

echo "Setting up your Mac..."

# Check for Homebrew and install if we don't have it
if test ! $(which brew); then
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Update Homebrew recipes
brew update

# Install brew package
# brew tap homebrew/bundle
brew bundle

# Restore dotfiles
ln -s $(pwd)/dotfiles/.mackup ~/.mackup
ln -s $(pwd)/dotfiles/.mackup.cfg ~/.mackup.cfg
mackup restore

# Set macOS preferences
source macos.setup
source macos.prefs

# Paremeters
while getopts "n:" opt; do
case "${opt}" in
	n) COMPUTER_NAME=${OPTARG};;
esac
done

# Set computer name
# https://ilostmynotes.blogspot.com/2012/03/computername-vs-localhostname-vs.html
if [[ -z "${COMPUTER_NAME}" ]] ; then
	scutil --set ComputerName "${COMPUTER_NAME}"
	scutil --set HostName "${COMPUTER_NAME}"
	scutil --set LocalHostName "${COMPUTER_NAME}"
	echo "Computer name set to ${COMPUTER_NAME}"
else
	echo "Computer name not set"
fi

# macOS security 101
# Definitely check out in more details the README
# https://github.com/drduh/macOS-Security-and-Privacy-Guide
# https://blog.bejarano.io/hardening-macos.html
