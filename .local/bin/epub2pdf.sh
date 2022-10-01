#!/usr/bin/env sh

######################################################################
# @author      : hg (https://github.com/hghann)
# @file        : conv.sh
# @created     : Tue 11 Jan 15:09:22 2022
#
# @description : epub2pdf
######################################################################

ebook-convert principles-and-applications-of-electrical-engineering.epub principles-and-applications-of-electrical-engineering.pdf \
--smarten-punctuation \
--pretty-print \
--preserve-cover-aspect-ratio \
--insert-blank-line \
--embed-all-fonts \
--pdf-default-font-size 14 \
#--pdf-serif-family "Times New Roman" \
#--extra-css 'img {max-width:25%; max-height:25%; display: block; margin-left: auto; margin-right: auto;}'
#--custom-size 6.5x9.5 \
#--margin-top 60 \
#--margin-left 60 \
#--margin-right 60 \

# vim: set tw=78 ts=2 et sw=2 sr:

