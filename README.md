# Setup macOS

Set of shell scripts for automated macOS machine setup.

This project is my framework for automating the setup of a macOS machine. The goal was to enable frictionless installs while being easy and fast to keep up-to-date.

The macOS-setup project is an opinionated configuration which meets the needs of my development environment but is also meant to serve as an example and guide for building your own personalized setup. 

## Features
- Downloads and installs development tools (required by Homebrew):
    - [Xcode Command Line Tools](https://developer.apple.com/xcode)
- Downloads, installs, and configures [Homebrew Formulas](http://brew.sh).
- Downloads, installs, and configures [Homebrew Casks](https://caskroom.github.io).
- Downloads, installs, and configures
  [App Store](http://www.apple.com/macosx/whats-new/app-store.html) software.
- Downloads, installs, and configures non-App Store software applications. 
- Applies basic and default software settings.
- Sets up and configures installed software for use.


## Command

Run the setup script using

    sh install.sh -n <computer-name>