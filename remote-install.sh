#!/usr/bin/env sh

######################################################################
# @author      : hg (https://github.com/hghann)
# @file        : remote-install.sh
# @created     : Tue 28 Dec 23:08:25 2021
#
# @description : remote install script for my dotfiles
######################################################################

SOURCE="https://github.com/hghann/osxrice"
TARBALL="$SOURCE/tarball/master"
TARGET="$HOME/.dotfiles"
TAR_CMD="tar -xzv -C "$TARGET" --strip-components=1 --exclude='{.gitignore}'"

is_executable() {
  type "$1" > /dev/null 2>&1
}

if is_executable "git"; then
  CMD="git clone $SOURCE $TARGET"
elif is_executable "curl"; then
  CMD="curl -#L $TARBALL | $TAR_CMD"
elif is_executable "wget"; then
  CMD="wget --no-check-certificate -O - $TARBALL | $TAR_CMD"
fi

if [ -z "$CMD" ]; then
  echo "No git, curl or wget available. Aborting."
else
  echo "Installing dotfiles..."
  mkdir -p "$TARGET"
  eval "$CMD"
fi

# vim: set tw=78 ts=2 et sw=2 sr:

