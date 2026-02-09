#!/bin/sh

######################################################################
# @author      : {{+~g:name+}} ({{+~g:web+}})
# @file        : {{+~expand('%:t')+}}
# @created     : {{+~strftime("%c")+}}
#
# @description : {{++}}
######################################################################


# --------------------------------------------------------------------------
# WHY #!/bin/sh OVER #!/usr/bin/env sh:
# 1. PERFORMANCE: Directly invokes the binary, skipping the $PATH search
#    overhead caused by 'env'. Crucial for shell startup latency.
# 2. SECURITY: Prevents "PATH hijacking" where a malicious binary named 'sh'
#    in a local directory could be executed instead of the system shell.
# 3. STANDARDS: POSIX guarantees 'sh' exists at /bin/sh on all Unix-like
#    systems, making the flexible lookup of 'env' redundant for this shell.
# --------------------------------------------------------------------------

# 1. Define the directory
dir="$HOME/.local/bin/shell-color-scripts"

# 2. Use the shell's positional parameters as a "fake array"
# This is POSIX-safe and lightning fast.
set -- "$dir"/*

# 3. Handle empty directory
[ ! -e "$1" ] && exit 0

# 4. Generate a pseudo-random number using the PID ($$) and Date
# Since we don't have $RANDOM, we use the nanoseconds or seconds
# and the modulo operator.
num_files=$#
seed=$(date +%S%M)
# shellcheck disable=SC2004
index=$(($seed % $num_files + 1))

# 5. Shift to the selected file
# This is the POSIX way to pick an item from our "fake array"
shift "$(($index - 1))"
selected_file="$1"

# 6. Execute
exec "$selected_file"

# vim: set tw=78 ts=2 et sw=2 sr:

