#!/usr/bin/env sh

######################################################################
# @author      : hg (https://github.com/hghann)
# @file        : uni.sh
# @created     : Mon  3 Jan 19:01:48 2022
#
# @description : A script that utilizes fzf, groff, and recutils to get
#                information on my university classes
# @requires    : recutils, fzf and groff
######################################################################

fmt="A:box \"\fB{{CourseCode}}\fP\" \"{{Description}}\" \"{{Term}} {{Year}}\" \"Prof: {{ProfName}} - {{ProfEmail}}\" \"TA: {{TAName}} - {{TAEmail}}\" \"Class Size: {{ClassSize}}\" \"Class Avg: {{ClassAverage}}\" \"My Grade: {{MyGrade}} [{{MyLetterGrade}}]\" wid 4 ht 3
B:box invis  \"{{Credits}}\" at (A.w.x + 1, A.e.y + 0.5)
C:box \"{{CourseNumber}}\" invis at ((A.e.x - 0.5), (A.n.y - 0.3))"

# Replace with where ever you placed the included chem.rec file
UNIREC=$HOME/.local/share/rec/uni.rec

SYMBOL=$(recsel -C "$UNIREC"  -P "CourseCode,Description" | fzf --preview \
  "recsel -e ' ( CourseCode = \"{}\" ) || ( Description = \"{}\" ) ' $UNIREC")

format(){
echo .PS
recsel -e " ( CourseCode = '$SYMBOL' ) || ( Description = '$SYMBOL' ) " "$UNIREC" | recfmt "$fmt"
printf '\n.PE'
}

format | pic -Tascii | nroff | sed -e '/^$/d'

# vim: set tw=78 ts=2 et sw=2 sr:

