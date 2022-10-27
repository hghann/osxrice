#!/bin/sh

######################################################################
# @author      : hg (https://github.com/hghann)
# @file        : pdfcat.sh
# @created     : Thu 27 Oct 2022 12:04:35 PM
#
# @description : Concatinate all pdf files in working directory
# @requires    : ghostscript
######################################################################

gs -q -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -sOutputFile=merged.pdf *.pdf
