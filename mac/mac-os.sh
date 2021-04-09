#!/bin/bash

# Title        mac-os.sh
# Description  Customize macOS default settings and change key bindings
# Author       Zachi Nachshon <zachi.nachshon@gmail.com>
#==============================================================================
print_banner() {
  echo -e "
███╗   ███╗ █████╗  ██████╗               ██████╗ ███████╗
████╗ ████║██╔══██╗██╔════╝              ██╔═══██╗██╔════╝
██╔████╔██║███████║██║         █████╗    ██║   ██║███████╗
██║╚██╔╝██║██╔══██║██║         ╚════╝    ██║   ██║╚════██║
██║ ╚═╝ ██║██║  ██║╚██████╗              ╚██████╔╝███████║
╚═╝     ╚═╝╚═╝  ╚═╝ ╚═════╝               ╚═════╝ ╚══════╝
"
}

key_bindings() {
  if [[ ! -d "${HOME}/Library/KeyBindings" ]]; then
    mkdir -p ${HOME}/Library/KeyBindings
    cp mac/assets/DefaultKeyBinding.dict ${HOME}/Library/KeyBindings
    echo -e "\nKey bindings override ...."
    echo -e "Key bindings override .... Done."
  else
    echo -e "\nKey bindings override ...."
    echo -e "Key bindings override .... Already installed."
  fi
}

finder() {
  echo -e "\nFinder settings override ...."

  ### Finder: show hidden files by default
  defaults write com.apple.finder AppleShowAllFiles -bool true

  ### Finder: show all filename extensions
  defaults write NSGlobalDomain AppleShowAllExtensions -bool true

  ### Finder: show status bar
  defaults write com.apple.finder ShowStatusBar -bool true

  ### Finder: show path bar
  defaults write com.apple.finder ShowPathbar -bool true
  echo -e "Finder settings override .... Done."
}

keyboard() {
  echo -e "\nKeyboard settings override ...."

  ### Disable press-and-hold for keys in favor of key repeat
  defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

  ### Set a blazingly fast keyboard repeat rate
  defaults write NSGlobalDomain KeyRepeat -int 1
  defaults write NSGlobalDomain InitialKeyRepeat -int 10
  echo -e "Keyboard settings override .... Done."
}

hidden_files_and_folders() {
  echo -e "\nHidden files & folders settings override ...."

  # Show the ~/Library folder
  chflags nohidden ~/Library && xattr -d com.apple.FinderInfo ~/Library

  # Show the /Volumes folder
  sudo chflags nohidden /Volumes
  echo -e "Hidden files & folders settings override .... Done."
}

activity_monitor() {
  echo -e "\nActivity monitor settings override ...."

  # Show all processes in Activity Monitor
  defaults write com.apple.ActivityMonitor ShowCategory -int 0

  # Sort Activity Monitor results by CPU usage
  defaults write com.apple.ActivityMonitor SortColumn -string "CPUUsage"
  defaults write com.apple.ActivityMonitor SortDirection -int 0
  echo -e "Activity monitor settings override .... Done."
}

verify_pre_install() {
  read -p "Do you want to override macOS defaults and change key bindings? (y/n): " input
  if [[ ${input} != "y" ]]; then
    echo -e "\nNothing has changed.\n"
    exit 0
  fi
}

airplay() {
  echo -e "\nAirplay settings override ...."
  # Use AirDrop over every interface. srsly this should be a default.
  defaults write com.apple.NetworkBrowser BrowseAllInterfaces 1
  echo -e "Airplay settings override .... Done."
}

desktop() {
  echo -e "\Display settings override ...."
  # Set the Finder prefs for showing a few different volumes on the Desktop.
  defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
  defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true
  echo -e "Display settings override .... Done."
}

screensaver() {
  echo -e "\Screensaver settings override ...."
  # Run the screensaver if we're in the bottom-left hot corner.
  defaults write com.apple.dock wvous-tl-corner -int 5
  defaults write com.apple.dock wvous-tl-modifier -int 0
  echo -e "Screensaver settings override .... Done."
}

safari() {
  echo -e "\Safari settings override ...."
  # Hide Safari's bookmark bar.
  defaults write com.apple.Safari ShowFavoritesBar -bool false

  # Enable “Do Not Track”
  defaults write com.apple.Safari SendDoNotTrackHTTPHeader -bool true
  
  # Set up Safari for development.
  defaults write com.apple.Safari IncludeInternalDebugMenu -bool true
  defaults write com.apple.Safari IncludeDevelopMenu -bool true
  defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
  defaults write com.apple.Safari "com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled" -bool true
  defaults write NSGlobalDomain WebKitDeveloperExtras -bool true
  echo -e "Safari settings override .... Done."
}

quit_system_preferences() {
  echo -e "\Quit system Preferences ...."
  # Close any open System Preferences panes, to prevent them from overriding
  # settings we’re about to change
  osascript -e 'tell application "System Preferences" to quit'
  echo -e "Quit system Preferences .... Done."
}

get_sudo() {
  echo -e "\Get sudo ...."
  # Ask for the administrator password upfront
  sudo -v

  # Keep-alive: update existing `sudo` time stamp until `.macos` has finished
  while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &
  echo -e "Get sudo .... Done."
}

menubar() {
  echo -e "\Tweaking menubar ...."
  # Disable Notification Center and remove the menu bar icon
  launchctl unload -w /System/Library/LaunchAgents/com.apple.notificationcenterui.plist 2> /dev/null
  echo -e "Tweaking menubar .... Done."
}

tidyup() {
  echo -e "\Tidying up ...."
  # Remove duplicates in the “Open With” menu (also see `lscleanup` alias)
  /System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user
  echo -e "Tidying up .... Done."
}

mouse() {
  echo -e "\Mouse settings override ...."
  # Disable “natural” (Lion-style) scrolling
  defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false
  echo -e "Mouse settings override .... Done."
}

privacy() {
  echo -e "\Privacy settings override ...."
  # Privacy: don’t send search queries to Apple
  defaults write com.apple.Safari UniversalSearchEnabled -bool false
  defaults write com.apple.Safari SuppressSearchSuggestions -bool true
  echo -e "Privacy settings override .... Done."
}

main() {  
  print_banner
  quit_system_preferences
  get_sudo
  verify_pre_install

  key_bindings
  finder
  keyboard
  mouse
  airplay
  desktop
  menubar
  screensaver
  safari
  hidden_files_and_folders
  activity_monitor
  privacy

  tidyup

  # Kill all Finder to apply some settings
  Killall Finder

  echo -e "\nRestart is required !\n"
}

main "$@"