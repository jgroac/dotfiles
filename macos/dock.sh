#!/bin/sh

dockutil --no-restart --remove all
dockutil --no-restart --add "/Applications/Safari.app"
dockutil --no-restart --add "/Applications/FirefoxDeveloperEdition.app"
dockutil --no-restart --add "/Applications/Brave Browser.app"
dockutil --no-restart --add "/Applications/iTerm.app"
dockutil --no-restart --add "/Applications/Sublime Text.app"
dockutil --no-restart --add "/System/Applications/Calendar.app"
dockutil --no-restart --add "/Applications/Slack.app"
dockutil --no-restart --add "/System/Applications/System Settings.app"
dockutil --no-restart --add "/Applications/Spotify.app"
dockutil --no-restart --add "/Applications/Obsidian.app"

killall Dock
