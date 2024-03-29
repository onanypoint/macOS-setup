#!/usr/bin/env bash

# Thanks to
# - Mathias Bynens, https://mths.be/macos
# - Dries Vints, https://github.com/driesvints
# - philiprein, https://github.com/philiprein/
# - https://privacy.sexy/

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until `.macos` has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Close any open System Preferences panes, to prevent them from overriding
# settings we’re about to change
osascript -e 'tell application "System Preferences" to quit'

###############################################################################
# General                                                                     #
###############################################################################

# Disable AirDrop
defaults write com.apple.NetworkBrowser DisableAirDrop -bool YES

# Disable Remote Apple Events
sudo systemsetup -setremoteappleevents off

# Disable iCloud drive
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

# Disable Creation of Metadata Files
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# Disable Guest user
sudo defaults write /Library/Preferences/com.apple.AppleFileServer guestAccess -bool NO
sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server AllowGuestAccess -bool NO

# Disable disk image verification"
defaults write com.apple.frameworks.diskimages skip-verify -bool true
defaults write com.apple.frameworks.diskimages skip-verify-locked -bool true
defaults write com.apple.frameworks.diskimages skip-verify-remote -bool true

# Disable font smoothing
defaults write -g CGFontRenderingFontSmoothingDisabled -bool FALSE

# Disable Resume system-wide
defaults write NSGlobalDomain NSQuitAlwaysKeepsWindows -bool false

# Disable reopen windows during restart
defaults write com.apple.loginwindow TALLogoutSavesState -bool false
defaults write com.apple.loginwindow LoginwindowLaunchesRelaunchApps -bool false

# Turn Off “Application Downloaded from Internet” Warning in OS X with defaults write
defaults write com.apple.LaunchServices LSQuarantine -bool false

###############################################################################
# Security                                                                    #
###############################################################################

# Disables signing in as Guest from the login screen
sudo defaults write /Library/Preferences/com.apple.loginwindow GuestEnabled -bool NO

# Disables Guest access to file shares over AF
sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server AllowGuestAccess -bool NO

# Disables Guest access to file shares over SMB
sudo defaults write /Library/Preferences/com.apple.AppleFileServer guestAccess -bool NO

# Disable remote login (incoming SSH and SFTP connections)
echo 'yes' | sudo systemsetup -setremotelogin off

# Disable insecure TFTP service
sudo launchctl disable 'system/com.apple.tftpd'

# Disable Bonjour multicast advertising
sudo defaults write /Library/Preferences/com.apple.mDNSResponder.plist NoMulticastAdvertisements -bool true

# Disable insecure telnet protocol
sudo launchctl disable system/com.apple.telnetd

# Disable sharing of local printers with other computers
cupsctl --no-share-printers

# Disable printing from any address including the Internet
cupsctl --no-remote-any

# Disable remote printer administration
cupsctl --no-remote-admin

# ###############################################################################
# # General UI/UX                                                               #
# ###############################################################################

# Expand Save Panel by Default
defaults write -g NSNavPanelExpandedStateForSaveMode -bool true
defaults write -g NSNavPanelExpandedStateForSaveMode2 -bool true

# Expand print panel by default"
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

# Automatically quit printer app once the print jobs complete
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

# Disable Captive Portal
sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.captive.control Active -boolean false

# Require an administrator password to access system-wide preferences"
security authorizationdb read system.preferences > /tmp/system.preferences.plist &&/usr/libexec/PlistBuddy -c "Set :shared false" /tmp/system.preferences.plist && security authorizationdb write system.preferences < /tmp/system.preferences.plist

# Remove duplicates in the “Open With” menu (also see 'lscleanup' alias)
/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user

# Disable the crash reporter"
defaults write com.apple.CrashReporter DialogType -string "none"

# Disable automatic capitalization as it’s annoying when typing code
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false

# Disable smart quotes as they’re annoying when typing code
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false

# Disable smart dashes as they’re annoying when typing code"
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

# Disable automatic termination of inactive apps
defaults write NSGlobalDomain NSDisableAutomaticTermination -bool true

# Disable Notification Center and remove the menu bar icon
launchctl unload -w /System/Library/LaunchAgents/com.apple.notificationcenterui.plist 2> /dev/null

# Disable auto-correct
defaults write -g NSAutomaticSpellingCorrectionEnabled -bool false

# Disable Internet based spell correction
defaults write NSGlobalDomain WebAutomaticSpellingCorrectionEnabled -bool false

# Enable dragging any part of the window by holding ctrl+cmd 
defaults write -g NSWindowShouldDragOnGesture YES

# ###############################################################################
# # Screen                                                                      #
# ###############################################################################

# Start screen saver when inactive (default: 20 minutes)
# time in seconds
# never = 0
defaults -currentHost write com.apple.screensaver idleTime -int 300

# Turn display off on battery when inactive (default: 2 minutes)
# time in minutes
# never = 0
sudo pmset -b displaysleep 5

# Show user name and photo (default: on)
# on = false
# off = true
sudo defaults write /Library/Preferences/com.apple.loginwindow HideUserAvatarAndName -bool false

# Require password immediately after sleep or screen saver begins
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

# Show password hints (default: off)
# on = 3
# off = 0
sudo defaults write /Library/Preferences/com.apple.loginwindow RetriesUntilHint -int 0

# Enable subpixel font rendering on non-Apple LCDs
defaults write NSGlobalDomain AppleFontSmoothing -int 2

# Show the sleep, restart, and shut down buttons (default: on)
# on = false
# off = true
sudo defaults write /Library/Preferences/com.apple.loginwindow PowerOffDisabled -bool false

# Screen: Set hot corners
# Possible values:
#  0: no-op
#  2: Mission Control
#  3: Show application windows
#  4: Desktop
#  5: Start screen saver
#  6: Disable screen saver
#  7: Dashboard
# 10: Put display to sleep
# 11: Launchpad
# 12: Notification Center
# 13: Lock Screen

# Top right screen corner → Desktop
defaults write com.apple.dock wvous-bl-corner -int 0
defaults write com.apple.dock wvous-bl-modifier -int 0
defaults write com.apple.dock wvous-br-corner -int 13
defaults write com.apple.dock wvous-br-modifier -int 0
defaults write com.apple.dock wvous-tl-corner -int 0
defaults write com.apple.dock wvous-tl-modifier -int 0
defaults write com.apple.dock wvous-tr-corner -int 4
defaults write com.apple.dock wvous-tr-modifier -int 0


# ###############################################################################
# # MenuBar                                                                     #
# ###############################################################################

# Dont hide and show the menu bar
defaults write NSGlobalDomain _HIHideMenuBar -bool false

# Disable the menubar transparency
sudo defaults write com.apple.universalaccess reduceTransparency -bool true

# Show percentage in battery Status
defaults write com.apple.menuextra.battery ShowPercent -string "YES"
defaults write com.apple.menuextra.battery ShowTime -string "NO"

# ###############################################################################
# # Finder                                                                      #
# ###############################################################################

# Set wallpaper
osascript -e 'tell application "Finder" to set desktop picture to POSIX file "/System/Library/Desktop Pictures/Solid Colors/Stone.png"'

# Finder: Set Desktop as the default location for new windows'
# computer = PfCm
# volume = PfVo, "file:///"
# home folder = PfHm, "file://${HOME}/"
# desktop = PfDe, "file://${HOME}/Desktop/"
# documents = PfDo, "file://${HOME}/Documents/"
# icloud drive = PfID, "file://${HOME}/Library/Mobile%20Documents/com~apple~CloudDocs/"
# recents = PfAF, "file:///System/Library/CoreServices/Finder.app/Contents/Resources/MyLibraries/myDocuments.cannedSearch/"
# Other… = PfLo, "file:///full/path/here/"
defaults write com.apple.finder NewWindowTarget -string "PfDe"

# Allow quitting via ⌘ + Q though this will hide desktop icons
defaults write com.apple.finder QuitMenuItem -bool true

# Show all filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Disable the warning when changing a file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Performing a search in the current folder by default
# search this mac = SCev
# search the current folder = SCcf
# use the previous search scope = SCsp
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# Do not show icons for hard drives servers and removable media on the desktop
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool false
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool false
defaults write com.apple.finder ShowMountedServersOnDesktop -bool false
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool false

# FShow the ~/Library folder'
chflags nohidden ~/Library && xattr -d com.apple.FinderInfo ~/Library

# Expand the following File Info panes:
# “General”, “Open with”, and “Sharing & Permissions”
defaults write com.apple.finder FXInfoPanesExpanded -dict \
    General -bool true \
    OpenWith -bool true \
	Privileges -bool true

# Keep folders on top when sorting by name on Desktop  (default: off)
defaults write com.apple.finder _FXSortFoldersFirst -bool true

# Keep folders on top on desktop (default: off)
defaults write com.apple.finder _FXSortFoldersFirstOnDesktop -bool true

# Hide recent tags
defaults write com.apple.finder ShowRecentTags -bool false

# Disable handoff between this mac and your icloud devices (default: on)
# on = true, true
# off = false, false
defaults -currentHost write com.apple.coreservices.useractivityd ActivityAdvertisingAllowed -bool false
defaults -currentHost write com.apple.coreservices.useractivityd ActivityReceivingAllowed -bool false

# Disable airdrop (default: "Off")
# no one = "Off"
# contacts only = "Contacts Only"
# everyone = "Everyone"
defaults write com.apple.sharingd DiscoverableMode -string "Contacts Only"

# airplay receiver (default: on)
defaults write -currentHost com.apple.controlcenter AirplayRecieverEnabled -bool false

# Click wallpaper to reveal desktop setting to Only in Stage Manager
defaults write com.apple.WindowManager EnableStandardClickToShowDesktop -bool false

#
# Scrolling
#

# Disable Smooth Scrolling
defaults write -g NSScrollAnimationEnabled -bool false

# Disable Rubberband Scrolling
defaults write -g NSScrollViewRubberbanding -bool false

# Always show Scrollbar
defaults write -g AppleShowScrollBars -string "Always"

#
# Finder window
#

# Use column view in all Finder windows by default
# as icons = icnv
# as list = Nlsv
# as columns = clmv
# as gallery = Flwv
defaults write com.apple.finder FXPreferredViewStyle Clmv

# Show Full Path in Finder Title
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

# Show the bottom status bar
defaults write com.apple.finder ShowStatusBar -bool true

# Show bottom path bar
defaults write com.apple.finder ShowPathbar -bool true

# Show side bar
defaults write com.apple.finder ShowSideBar -bool true

# Set side bar icons to small
defaults write NSGlobalDomain NSTableViewDefaultSizeMode -int 1

# Grouping (default: none)
defaults write com.apple.finder FXPreferredGroupBy -string "Kind"

#
# Icon view
#

# arrangeBy
# backgroundType (default: default) default = 0 / color = 1 / picture = 2
# gridSpacing (default: 54)
# iconSize (default: 64)
# labelOnBottom (default: bottom) bottom = true / right = false
# showIconPreview (default: true)
# showItemInfo (default: false)
# textSize (default: 12)

# desktop
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy kind" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:gridSpacing 54" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:iconSize 24" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:labelOnBottom true" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:showIconPreview true" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:showItemInfo false" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:textSize 13" ~/Library/Preferences/com.apple.finder.plist

# finder icon view
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:arrangeBy kind" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:gridSpacing 54" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:iconSize 24" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:labelOnBottom true" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:showIconPreview true" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:showItemInfo false" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:textSize 13" ~/Library/Preferences/com.apple.finder.plist

# finder list view
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:ListViewSettings:sortColumn name" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:ListViewSettings:useRelativeDates false" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:ListViewSettings:showIconPreview false" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:ListViewSettings:iconSize 16" ~/Library/Preferences/com.apple.finder.plist

###############################################################################
# Trackpad, mouse, keyboard, Bluetooth accessories, and input                 #
###############################################################################

# Enable tap to click for this user and for the login screen
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true

# Mouse: Disable natural scrolling
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false

# Enable full keyboad access for all controls (Tab in modals)
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

# Disable press-and-hold for keys in favor of key repeat
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# Set the keyboard repeat rate to be reasonably fast
defaults write NSGlobalDomain KeyRepeat -int 2

# Set a shorter Delay until key repeat
defaults write NSGlobalDomain InitialKeyRepeat -int 15

# Automatically illuminate built-in MacBook keyboard in low light
defaults write com.apple.BezelServices kDim -bool true

# Turn off keyboard illumination when computer is not used for 2 minutes
defaults write com.apple.BezelServices kDimTime -int 120

###############################################################################
# Dashboard                                                                   #
###############################################################################

# Disable Dashboard
defaults write com.apple.dashboard mcx-disabled -bool true

# Don’t show Dashboard as a Space
defaults write com.apple.dock dashboard-in-overlay -bool true

###############################################################################
# Space                                                                       #
###############################################################################

# Don’t automatically rearrange Spaces based on most recent use
defaults write com.apple.dock mru-spaces -bool false

###############################################################################
# Launchpad                                                                   #
###############################################################################

# Disable the Launchpad gesture (pinch with thumb and three fingers)
defaults write com.apple.dock showLaunchpadGestureEnabled -int 0

###############################################################################
# Mission Control                                                             #
###############################################################################

# Group windows by application in Mission Control
defaults write com.apple.dock expose-group-by-app -bool true

###############################################################################
# Dock                                                                        #
###############################################################################

# Automatically hide and show the Dock
defaults write com.apple.dock autohide -bool true

# Don’t animate opening applications from the Dock
defaults write com.apple.dock launchanim -bool false

# Set dock icone size to smallest possible
defaults write com.apple.dock largesize -float 20
defaults write com.apple.dock tilesize -float 20

# Make Dock icons of hidden Applications translucent
defaults write com.apple.dock showhidden -bool true

# Don't show recent applications
defaults write com.apple.dock show-recents -bool false

# Don't minimize windows into their application’s icon
defaults write com.apple.dock minimize-to-application -bool false

# Wipe all (default) app icons from the Dock
defaults write com.apple.dock persistent-apps -array
defaults write com.apple.dock persistent-others -array

# Minimize windows into their application’s icon
defaults write com.apple.dock minimize-to-application -bool true

# Setup dock apps
apps=(
	"/System/Applications/System Settings.app"
	"empty"
	"/Applications/iTerm.app"
    "/Applications/Visual Studio Code.app"
	"/Applications/Sublime Text.app"
	"/Applications/Firefox.app"
	"empty"
	"/Applications/Telegram.app"
	"empty"
)

for app in "${apps[@]}"
do
	if [[ "$app" == "empty" ]]; then
		# Add empty space in the Dock
		defaults write com.apple.dock persistent-apps -array-add '{"tile-type"="spacer-tile";}'
	else
		defaults write com.apple.dock persistent-apps -array-add "<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>$app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>"
	fi
done

###############################################################################
# Animations                                                                  #
###############################################################################

# Oening and closing windows and popovers
defaults write -g NSAutomaticWindowAnimationsEnabled -bool false

# Showing and hiding sheets, resizing preference windows, zooming windows
# float 0 doesn't work
defaults write -g NSWindowResizeTime -float 0.001

# Opening and closing Quick Look windows
defaults write -g QLPanelAnimationDuration -float 0

# Resizing windows before and after showing the version browser
# also disabled by NSWindowResizeTime -float 0.001
defaults write -g NSDocumentRevisionsWindowTransformAnimation -bool false

# Showing a toolbar or menu bar in full screen
defaults write -g NSToolbarFullScreenAnimationDuration -float 0

# Scrolling column views
defaults write -g NSBrowserColumnAnimationSpeedMultiplier -float 0

# Showing and hiding Mission Control, command+numbers
defaults write com.apple.dock expose-animation-duration -float 0

# Showing and hiding Launchpad
defaults write com.apple.dock springboard-show-duration -float 0
defaults write com.apple.dock springboard-hide-duration -float 0

# Changing pages in Launchpad
defaults write com.apple.dock springboard-page-duration -float 0

# At least AnimateInfoPanes
defaults write com.apple.finder DisableAllAnimations -bool true

# Sending messages and opening windows for replies
defaults write com.apple.Mail DisableSendAnimations -bool true
defaults write com.apple.Mail DisableReplyAnimations -bool true

# Dock: Remove the auto-hiding Dock delay
defaults write com.apple.dock autohide-time-modifier -float 0
defaults write com.apple.dock autohide-delay -float 0

# Dock: Change minimize/maximize window effect
defaults write com.apple.dock mineffect -string "scale"

# Dock: Don’t animate opening applications
defaults write com.apple.dock no-bouncing -bool true

# Disable window animations and Get Info animations
defaults write com.apple.finder DisableAllAnimations -bool true

# Enable spring loading for directories
defaults write NSGlobalDomain com.apple.springing.enabled -bool true

# Remove the spring loading delay for directories
defaults write NSGlobalDomain com.apple.springing.delay -float 0

###############################################################################
# Siri                                                                        #
###############################################################################

# Hide Siri from menu bar
defaults write com.apple.systemuiserver 'NSStatusItem Visible Siri' 0

# Hide Siri from status menu
defaults write com.apple.Siri 'StatusMenuVisible' -bool false
defaults write com.apple.Siri 'UserHasDeclinedEnable' -bool true

# Opt-out from Siri data collection
defaults write com.apple.assistant.support 'Siri Data Sharing Opt-In Status' -int 2

# Listen for ("hey siri" on headphones) (default: off)
defaults write com.apple.Siri VoiceTriggerUserEnabled -bool false

###############################################################################
# Remote Management Service                                                   #
###############################################################################

# Deactivate the Remote Management Service
sudo /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -deactivate -stop

# Remove Apple Remote Desktop Settings
sudo rm -rf /var/db/RemoteManagement
sudo defaults delete /Library/Preferences/com.apple.RemoteDesktop.plist
defaults delete ~/Library/Preferences/com.apple.RemoteDesktop.plist
sudo rm -r /Library/Application\ Support/Apple/Remote\ Desktop/
rm -r ~/Library/Application\ Support/Remote\ Desktop/
rm -r ~/Library/Containers/com.apple.RemoteDesktop

###############################################################################
# Analytics & improvements
###############################################################################

# Share mac analytics (default: set in setup assistant)
defaults write "/Library/Application Support/CrashReporter/DiagnosticMessagesHistory.plist" AutoSubmit -bool false
defaults write "/Library/Application Support/CrashReporter/DiagnosticMessagesHistory.plist" SeedAutoSubmit -bool false
defaults write "/Library/Application Support/CrashReporter/DiagnosticMessagesHistory.plist" AutoSubmitVersion -integer 4

# Improve siri & dictation (default: set in setup assistant)
defaults write com.apple.assistant.support "Siri Data Sharing Opt-In Status" -integer 2

# Share with app developers (default: set in setup assistant)
defaults write "/Library/Application Support/CrashReporter/DiagnosticMessagesHistory.plist" ThirdPartyDataSubmit -bool false
defaults write "/Library/Application Support/CrashReporter/DiagnosticMessagesHistory.plist" ThirdPartyDataSubmitVersion -integer 4

# Personalized ads
defaults write com.apple.AdLib allowApplePersonalizedAdvertising -bool false

###############################################################################
# Security
###############################################################################

# Allow applications downloaded from (default: app store and identified developers)
# app store
# sudo spctl --master-enable
# sudo spctl --disable
# app store and identified developers
sudo spctl --master-enable
sudo spctl --enable
# disable gatekeeper completely
# sudo spctl --master-disable

###############################################################################
###############################################################################

for app in "Activity Monitor" "Address Book" "Calendar" "Contacts" "cfprefsd" \
    "Dock" "Finder" "Mail" "Messages" "Photos" "Safari" "SystemUIServer" \
    "iCal" "NotificationCenter"; do
    killall "${app}" &> /dev/null
done

echo "Done. Note that some of these changes require a logout/restart to take effect."
