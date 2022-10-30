#! /bin/sh

set -e

if grep -qe '^PreserveJobHistory Off$' /etc/cups/cupsd.conf; then
  exit 0
fi

echo "PreserveJobHistory Off" | sudo tee -a /etc/cups/cupsd.conf

sudo launchctl unload /System/Library/LaunchDaemons/org.cups.cupsd.plist

sudo launchctl load /System/Library/LaunchDaemons/org.cups.cupsd.plist
