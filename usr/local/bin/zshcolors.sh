#!/bin/zsh

######################################################################
# @author      : {{+~g:name+}} ({{+~g:web+}})
# @file        : {{+~expand('%:t')+}}
# @created     : {{+~strftime("%c")+}}
#
# @description : {{++}}
######################################################################

## Get all scripts into a Zsh array
#scripts=($HOME/.local/bin/shell-color-scripts/*)
#
## Pick a random index and execute
## $#scripts is the count, RANDOM is a Zsh variable
#selected="${scripts[RANDOM % $#scripts + 1]}"
#
## Use 'exec' to replace the current shell process with the color script
## (Only if you don't need to run anything in randomcolors.sh after it)
#exec "$selected"

## The (N) ensures that if the glob fails, the array is truly empty (size 0)
#scripts=($HOME/.local/bin/shell-color-scripts/*(N))
#
## We MUST check if the count is greater than 0 before doing math (%)
#if (( $#scripts > 0 )); then
#    selected="${scripts[RANDOM % $#scripts + 1]}"
#    exec "$selected"
#else
#    # This prevents the "value too great for base" / "divide by zero" error
#    echo "Error: No scripts found in ~/.local/bin/shell-color-scripts"
#    exit 1
#fi

scripts=($HOME/.local/bin/shell-color-scripts/*(N))

if (( $#scripts > 0 )); then
    exec "${scripts[RANDOM % $#scripts + 1]}"
fi

# vim: set tw=78 ts=2 et sw=2 sr:

