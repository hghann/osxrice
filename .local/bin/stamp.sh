#!/usr/bin/env sh

######################################################################
# @author      : hg (https://github.com/hghann)
# @file        : stamp.sh
# @created     : Wed 23 Feb 09:58:54 2022
#
# @description : add stamps to pdf documents using imgmagic
######################################################################

# Increase the `-density` number for higher quality.
# Add `+antialias` to stop ImageMagick from antialiasing your images.
convert -density 300 base_filename null: stamp_filename -compose multiply -layers composite output_filename

# vim: set tw=78 ts=2 et sw=2 sr:

