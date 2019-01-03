#!/usr/bin/env bash

# Tracking your Mac's battery useage, with data saved every minute!

# To use it, create a plist file

#	<?xml version="1.0" encoding="UTF-8"?>
# 	<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
# 	<plist version="1.0">
# 	<dict>
#     	<key>Label</key>
#     	<string>com.user.battery</string>
#     	<key>ProgramArguments</key>
#     	<array>
#       	  <string>/bin/bash</string>
#       	  <string>/Users/<USER>/.config.git/scripts/battery.sh</string>
#     	</array>
#     	<key>StartInterval</key>
#     	<integer>30</integer>
#     	<key>RunAtLoad</key>
#     	<true/>
# 	</dict>
# 	</plist>

# Launch using 
# 	launchctl load ~/Library/LaunchAgents/com.user.battery.plist 

dir="$HOME/.config.sync/data/"
name=$(scutil --get  ComputerName)
file=$name.battery.dat
file=$dir$file

if [ ! -e "$file" ] ; then
	echo "Creating $file"
	mkdir -p $dir
	touch $file    
fi

d=$(date)
values=$(ioreg -n AppleSmartBattery -r | grep -o '"[^"]"*.*' | sort | sed -e 's/.*= //g' | tr '\n' '\t' | sed -e $'s/\t$//')

printf "${d}\t${values}\n" >> "$file"