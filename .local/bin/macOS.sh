#!/usr/bin/env sh

######################################################################
# @author      : hg (https://github.com/hghann)
# @file        : macOS.sh
# @created     : Sat 25 Dec 16:17:59 2021
#
# @description : automate defaults on macOS
######################################################################

echo "Applying defaults."

COMPUTER_NAME="osx"

osascript -e 'tell application "System Preferences" to quit'

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until `.osx` has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# chown local directory
sudo chown -R $(whoami):admin /usr/local

######################################################################
# Rectangle                                                          #
######################################################################

defaults write com.knollsoft.Rectangle gapSize -float 4
#defaults write com.knollsoft.Rectangle almostMaximizeHeight -float .98
#defaults write com.knollsoft.Rectangle almostMaximizeWidth -float .98

######################################################################
# General UI/UX                                                      #
######################################################################

# Set computer name (as done via System Preferences → Sharing)
sudo scutil --set ComputerName "$COMPUTER_NAME"
sudo scutil --set HostName "$COMPUTER_NAME"
sudo scutil --set LocalHostName "$COMPUTER_NAME"
sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string "$COMPUTER_NAME"

# Set language and text formats
defaults write NSGlobalDomain AppleLanguages -array "en" "ar"
defaults write NSGlobalDomain AppleLocale -string "en_US@currency=CAD"
defaults write NSGlobalDomain AppleMeasurementUnits -string "Centimeters"
defaults write NSGlobalDomain AppleMetricUnits -bool true

# Set the timezone (see `sudo systemsetup -listtimezones` for other values)
sudo systemsetup -settimezone "America/Toronto" > /dev/null

# Set standby delay to 24 hours (default is 1 hour)
#sudo pmset -a standbydelay 86400

# Disable Sudden Motion Sensor
#sudo pmset -a sms 0

# Disable audio feedback when volume is changed
defaults write com.apple.sound.beep.feedback -bool false

# Disable opening and closing window animations
#defaults write NSGlobalDomain NSAutomaticWindowAnimationsEnabled -bool false

# Increase window resize speed for Cocoa applications
#defaults write NSGlobalDomain NSWindowResizeTime -float 0.001

# Automatically expanding printer dialog box & NSNav panel
# Expand save panel by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true
# Expand print panel by default
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

# Save to disk (not to iCloud) by default
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

# Automatically quit printer app once the print jobs complete
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

# Delete preview window history on close
defaults write com.apple.Preview NSQuitAlwaysKeepsWindows -bool FALSE

# Disable the “Are you sure you want to open this application?” dialog
defaults write com.apple.LaunchServices LSQuarantine -bool false

# Disable the sound effects on boot
sudo nvram SystemAudioVolume=" "

# Show battery percentage in menu bar
defaults write com.apple.menuextra.battery ShowPercent YES

# Disable Resume system-wide
#defaults write com.apple.systempreferences NSQuitAlwaysKeepsWindows -bool false

# Disable the crash reporter
defaults write com.apple.CrashReporter DialogType -string "none"

# Restart automatically if the computer freezes
#sudo systemsetup -setrestartfreeze on

# Disable notification center and remove the menu bar icon
#launchctl unload -w /System/Library/LaunchAgents/com.apple.notificationcenterui.plist 2> /dev/null

# Remove save to icloud functionality
defaults write com.apple.NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool FALSE

# Disables double space bar to period
#defaults write com.apple.NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool NO

# Disables Miniaturize on Double Click
#defaults write com.apple.NSGlobalDomain AppleMiniaturizeOnDoubleClick -bool NO

# Setting double click action to minimize
#defaults write com.apple.NSGlobalDomain AppleActionOnDoubleClick -string "Minimize"

# Setting highlight color to red
#defaults write com.apple.NSGlobalDomain AppleHighlightColor -string "1.000000 0.733333 0.721569 Red"

# Setting apple accent color to red
#defaults write com.apple.NSGlobalDomain AppleAccentColor -int 0

# Disabling animated focus ring (the blue halo around input fields)
#defaults write com.apple.NSGlobalDomain NSUseAnimatedFocusRing -bool NO

# Showing scroll bars only when scrolling
#defaults write com.apple.NSGlobalDomain AppleShowScrollBars -string "WhenScrolling"

# Sets default finder view size to 1
#defaults write com.apple.NSGlobalDomain NSTableViewDefaultSizeMode -int 1

# Disabling automatic capitalization
#defaults write com.apple.NSGlobalDomain NSAutomaticCapitalizationEnabled -bool NO

#Disabling automatic dash & quote substitution, spell correct
#defaults write com.apple.NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
#defaults write com.apple.NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
#defaults write com.apple.NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false

# Sets Windows Resize Time to the Minimize Possible
#defaults write com.apple.NSGlobalDomain NSWindowResizeTime -float 0.001

# Disabling App Springing Animation
#defaults write com.apple.NSGlobalDomain com.apple.springing.enabled -bool false
#defaults write com.apple.NSGlobalDomain com.apple.springing.delay -float 0

######################################################################
# Keyboard & Input                                                   #
######################################################################

# Disable smart quotes and dashes as they’re annoying when typing code
#defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
#defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

# Enable full keyboard access for all controls
# (e.g. enable Tab in modal dialogs)
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

# Disable press-and-hold for keys in favor of key repeat
#defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# Set a blazingly fast keyboard repeat rate
defaults write NSGlobalDomain KeyRepeat -int 1
defaults write NSGlobalDomain InitialKeyRepeat -int 15

# Automatically illuminate built-in MacBook keyboard in low light
defaults write com.apple.BezelServices kDim -bool true

# Turn off keyboard illumination when computer is not used for 5 minutes
defaults write com.apple.BezelServices kDimTime -int 300

# Disable auto-correct
#defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

######################################################################
# Trackpad, mouse, and Bluetooth accessories                         #
######################################################################

# Trackpad: enable tap to click for this user and for the login screen
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# Trackpad: swipe between pages with three fingers
defaults write NSGlobalDomain AppleEnableSwipeNavigateWithScrolls -bool true
defaults -currentHost write NSGlobalDomain com.apple.trackpad.threeFingerHorizSwipeGesture -int 1
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerHorizSwipeGesture -int 1

# Increase sound quality for Bluetooth headphones/headsets
defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Min (editable)" -int 40

# Trackpad: map bottom right corner to right-click
#defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadCornerSecondaryClick -int 2
#defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRightClick -bool true
#defaults -currentHost write NSGlobalDomain com.apple.trackpad.trackpadCornerClickBehavior -int 1
#defaults -currentHost write NSGlobalDomain com.apple.trackpad.enableSecondaryClick -bool true

######################################################################
# Screen                                                             #
######################################################################

# Require password immediately after sleep or screen saver begins
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

# Change screenshots directory
defaults write com.apple.screencapture location -string "${HOME}/Pictures/screenshots"

# Save screenshots in PNG format (other options: BMP, GIF, JPG, PDF, TIFF)
defaults write com.apple.screencapture type -string "png"

# Disable shadow in screenshots
# Disable Screen Capture Shadow
defaults write com.apple.screencapture disable-shadow -bool true

# Enable subpixel font rendering on non-Apple LCDs
#defaults write NSGlobalDomain AppleFontSmoothing -int 2

######################################################################
# Finder                                                             #
######################################################################

# Allow quitting via ⌘ + Q; doing so will also hide desktop icons
#defaults write com.apple.finder QuitMenuItem -bool true

# Show hidden files by default
defaults write com.apple.finder AppleShowAllFiles -bool true

# Show all filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Display full POSIX path as Finder window title
# Show a path bar in the finder that shows the exact location
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

# Adds the path bar to the bottom of the finder
defaults write com.apple.finder ShowPathbar -bool true

# Shows Status Bar in Finder
defaults write com.apple.finder ShowStatusBar -bool true

# Stop the automatic save to iCloud thing
defaults write com.apple.finder FXEnableRemoveFromICloudDriveWarning -bool false

# Disable the warning when changing a file extension in OSX
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Always open everything in Finder's list view.
# Use list view in all Finder windows by default
# Four-letter codes for the other view modes: `icnv`, `clmv`, `Flwv`
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

# Disable the warning before emptying the Trash
defaults write com.apple.finder WarnOnEmptyTrash -bool false

# Avoid creating .DS_Store files on network and USB volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# Disable Finder Animations
defaults write com.apple.finder DisableAllAnimations -bool true

# Changes default finder location to ~
defaults write com.apple.finder NewWindowTargetPath -string "file:///Users/$uname/"

# Removes External Drives on Desktop
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool false

# Removes Internal Drives on Desktop
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool false

# Removes Mounted Servers on Desktop
defaults write com.apple.finder ShowMountedServersOnDesktop -bool false

# Removes Removable Media on Desktop
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool false

# Arranges Finder by Name By Default
defaults write com.apple.finder FXArrangeGroupViewBy -string "Name"

# Keep folders to top when sorting alphabetically (by name) in finder
defaults write com.apple.finder _FXSortFoldersFirst -bool true

# When performing a search, search the current folder by default
# (i.e. changes default finder search to current folder only)
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# Doesn't Sync Desktop to iCloud
defaults write com.apple.finder FXICloudDriveDesktop -bool NO

# Removes iCloud Desktop from Finder Sidebar
defaults write com.apple.finder SidebarShowingiCloudDesktop -bool NO

# Makes Sure iCloud Drive is Showing in Finder Sidebar
defaults write com.apple.finder SidebariCloudDriveSectionDisclosedState -bool NO

# Disable window animations and Get Info animations
#defaults write com.apple.finder DisableAllAnimations -bool true

# Disable disk image verification
#defaults write com.apple.frameworks.diskimages skip-verify -bool true
#defaults write com.apple.frameworks.diskimages skip-verify-locked -bool true
#defaults write com.apple.frameworks.diskimages skip-verify-remote -bool true

# Use AirDrop over every interface.
#defaults write com.apple.NetworkBrowser BrowseAllInterfaces -bool true

# Allow text selection in Quick Look
defaults write com.apple.finder QLEnableTextSelection -bool true

# Expand the following File Info panes:
# “General”, “Open with”, and “Sharing & Permissions”
defaults write com.apple.finder FXInfoPanesExpanded -dict \
    General -bool true \
    OpenWith -bool true \
    Privileges -bool true

######################################################################
# Terminal                                                           #
######################################################################

# Only use UTF-8 in Terminal.app
defaults write com.apple.terminal StringEncodings -array 4

# Appearance
defaults write com.apple.terminal "Default Window Settings" -string "Pro"
defaults write com.apple.terminal "Startup Window Settings" -string "Pro"
defaults write com.apple.Terminal ShowLineMarks -int 0

# Use zsh as default shell
defaults write com.apple.terminal shell -string zsh

######################################################################
# Spotlight                                                          #
######################################################################

#defaults write com.apple.Spotlight orderedItems Item 1 enabled -bool 0

######################################################################
# Mail                                                               #
######################################################################

# Copy email addresses as `foo@example.com` instead of `Foo Bar <foo@example.com>` in Mail.app
defaults write com.apple.mail AddressesIncludeNameOnPasteboard -bool false

# Display emails in threaded mode
#defaults write com.apple.mail DraftsViewerAttributes -dict-add "DisplayInThreadedMode" -string "yes"

# Disable send and reply animations in Mail.app
#defaults write com.apple.mail DisableReplyAnimations -bool true
#defaults write com.apple.mail DisableSendAnimations -bool true

# Disable inline attachments (just show the icons)
defaults write com.apple.mail DisableInlineAttachmentViewing -bool true

# Disable automatic spell checking
#defaults write com.apple.mail SpellCheckingBehavior -string "NoSpellCheckingEnabled"

# Disable sound for incoming mail
#defaults write com.apple.mail MailSound -string ""

# Disable sound for other mail actions
#defaults write com.apple.mail PlayMailSounds -bool false

# Mark all messages as read when opening a conversation
defaults write com.apple.mail ConversationViewMarkAllAsRead -bool true

# Disable includings results from trash in search
defaults write com.apple.mail IndexTrash -bool false

# Automatically check for new message (not every 5 minutes)
defaults write com.apple.mail AutoFetch -bool true
defaults write com.apple.mail PollTime -string "-1"

# Show most recent message at the top in conversations
defaults write com.apple.mail ConversationViewSortDescending -bool true

######################################################################
# Calendar                                                           #
######################################################################

# Show week numbers (10.8 only)
defaults write com.apple.iCal "Show Week Numbers" -bool true

# Week starts on monday
defaults write com.apple.iCal "first day of week" -int 1

######################################################################
# Dock                                                               #
######################################################################

# Show indicator lights for open applications in the Dock
defaults write com.apple.dock show-process-indicators -bool true

# Automatically hide and show the Dock
defaults write com.apple.dock autohide -bool true

#Sets Dock Autohide Time to O Seconds
defaults write com.apple.dock autohide-time-modifier -int 0

# Turns off Dock Magnification
defaults write com.apple.dock magnification -bool 0

# Moves the Dock to the left Side of the Screen
#defaults write com.apple.dock orientation -string left

# Minimizing applications to their respective application icon
defaults write com.apple.dock minimize-to-application -bool 1

# Make Dock icons of hidden applications translucent
defaults write com.apple.dock showhidden -bool true

# Setting Expose Animation to 0 Seconds
#defaults write com.apple.dock expose-animation-duration -string 0

# Setting Icon Size to 36 Pixels
defaults write com.apple.dock tilesize -int 36

# Change minimize to dock animation to "Genie" effect
# which seems to be the fastest
defaults write com.apple.dock mineffect -string "genie"

# Don’t animate opening applications from the Dock
defaults write com.apple.dock launchanim -bool false

# Don't show recently used applications in the Dock
defaults write com.Apple.Dock show-recents -bool false

# Disable hot corners
defaults write com.apple.dock wvous-tl-corner -int 0
defaults write com.apple.dock wvous-tr-corner -int 0
defaults write com.apple.dock wvous-bl-corner -int 0
defaults write com.apple.dock wvous-br-corner -int 0

# No bouncing icons
#defaults write com.apple.dock  -bool true

######################################################################
# Activity Monitor                                                   #
######################################################################

# Show the main window when launching Activity Monitor
defaults write com.apple.ActivityMonitor OpenMainWindow -bool true

# Visualize CPU usage in the Activity Monitor Dock icon
defaults write com.apple.ActivityMonitor IconType -int 5

# Show all processes in Activity Monitor
defaults write com.apple.ActivityMonitor ShowCategory -int 0

# Sort Activity Monitor results by CPU usage
defaults write com.apple.ActivityMonitor SortColumn -string "CPUUsage"
defaults write com.apple.ActivityMonitor SortDirection -int 0

######################################################################
# Software Updates                                                   #
######################################################################

# Enable the automatic update check
defaults write com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true

# Check for software updates daily, not just once per week
defaults write com.apple.SoftwareUpdate ScheduleFrequency -bool true

# Download newly available updates in background
defaults write com.apple.SoftwareUpdate AutomaticDownload -bool true

# Install System data files & security updates
defaults write com.apple.SoftwareUpdate CriticalUpdateInstall -bool true

# Turn on app auto-update
defaults write com.apple.commerce AutoUpdate -bool true

# Allow the App Store to reboot machine on macOS updates
defaults write com.apple.commerce AutoUpdateRestartRequired -bool true

# Fixing Automatic Software Updates
#defaults write com.apple.SoftwareUpdate ConfigDataInstall -int 1

######################################################################
# Kill affected applications                                         #
######################################################################

for app in "Address Book" "Calendar" "Contacts" "Dock" "Finder" "Mail"
  "Safari" "SystemUIServer" "iCal"; do
  killall "${app}" &> /dev/null
done

echo "Defaults set."
echo" Some changes may require a logout/restart to take effect."

# vim: set tw=78 ts=2 et sw=2 sr:

