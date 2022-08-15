# Setup macOS

> Set of shell scripts for automated macOS machine setup.

The macOS-setup project is an opinionated configuration which meets the needs of my development environment. The goal was to enable frictionless installs while being easy and fast to keep up-to-date.

It is also meant to serve as an example and guide for building your own personalized setup.

#IMAGE

## Features

- Downloads and installs [Xcode Command Line Tools](https://developer.apple.com/xcode)
- Downloads, installs, and configures [Homebrew Formulas](http://brew.sh) and [Homebrew Casks](https://caskroom.github.io).
- Downloads, installs, and configures [App Store](http://www.apple.com/macosx/whats-new/app-store.html).
- Downloads, installs, and configures non-App Store software applications.
- Applies basic and default software settings.
- Sets up and configures installed software for use.

### Setup Overview

- Strive for clean and simple interface interactions ([Amenyst](https://github.com/ianyh/Amethyst), [Dozer](https://github.com/Mortennn/Dozer))
- Productivity oriented `ZSH` and `Tmux` configs ([zprezto](https://github.com/sorin-ionescu/prezto), [tmux-plugin](https://github.com/tmux-plugins/tmux-resurrect), [mcfly](https://github.com/cantino/mcfly))
- Try to improve macOS services ([automator tasks](), [clipy](https://github.com/Clipy/Clipy))
- Consistent `Tmux`, `iTerm` and `Visual Studio Code` themes
- Opiniated dev environment (Python via [miniconda](https://docs.conda.io/en/latest/miniconda.html), Node via [nvm](https://github.com/nvm-sh/nvm))

## Usage

1. Go through the [Brewfile](https://github.com/Homebrew/homebrew-bundle) and update it with your library and apps requirements.

2. Run the setup script using

   ```shell
   sh install.sh -n <computer-name>
   ```

### Finalization

#### **Git**

Create a `.gitconfig-user` (using `touch ~/.gitconfig-user`) file in you home with the following content

```
[user]
    name = Awesome Name
    email = awesome@name.com
```

#### **iTerm**

- Go to `Preferences > Profiles > Terminal` and uncheck 'Save lines to scrollback in alternate screen mode to avoid having McFly pollute the scrollback history.

#### Python & Conda

See Development [README](DEVELOPMENT.md)

#### Spotlight

`Xcode.app` needs to be installed in order for Spotlight to let you deactivate the "Developer" results. You can fake this by creating an empty file with the same name in `Applications`.

```
touch /Applications/Xcode.app
```

## Usefull Links

- https://github.com/drduh/macOS-Security-and-Privacy-Guide
