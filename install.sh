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

# macOS security 101
# Definitely check out in more details the README
# and https://github.com/drduh/macOS-Security-and-Privacy-Guide


