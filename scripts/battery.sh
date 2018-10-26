#!/usr/bin/env bash

# Tracking your Mac's battery useage, with data saved every minute!

# Reference:
# https://www.ifweassume.com/2013/08/the-de-evolution-of-my-laptop-battery.html
# https://github.com/jradavenport/batlog
# https://github.com/pietvandongen/batlog2csv

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

dir="$HOME/.config.sync/data/"
name=$(scutil --get  ComputerName)
file=$name.battery.dat
file=$dir$file

if [ ! -e "$file" ] ; then
	echo "Creating $file"
	mkdir -p $dir
	touch $file    
fi

date >> "$file"
/usr/sbin/ioreg -l | egrep "CycleCount|Capacity" >> "$file"