.TL
Example Document

.NH 1
Typesetting
.LP
This is an unindented paragraph. Here is another line.
And Another, now on a newline.
.PP
Here is an indented paragraph, with 4 spaces.
It also has a line after it.
.PP
Two spaces? How delightfully absurd!
More stuff.
.PP
One Space? Are you a maniac?
How weird.
.PP
A Tab? How antiquated!
Things here as well!
.NH 1
Fonts
.NH 2
Bold/Italics
.LP
This is \f[I]italic\f[], this is not.
This is \f[B]bold\f[], this is not.
This is \f[BI]both\f[], this is not.
.NH 2
Super/Subscripts
.LP
This is \*{SuperScript\*}, this is not.
This is \v'0.3m'\s[\n[.s]*9u/12u]SubScript\s0\v'-0.3m', this is not.
This is Both, this is not.
.NH 2
Combinations
.LP
This is \f[I]italic \*{SuperScript\*}\f[], this is not.
This is \f[I]italic \v'0.3m'\s[\n[.s]*9u/12u]SubScript\s0\v'-0.3m'\f[], this is not.
This is \f[I]italic Both\f[], this is not.
.LP
This is \f[B]Bold \*{SuperScript\*}\f[], this is not.
This is \f[B]Bold \v'0.3m'\s[\n[.s]*9u/12u]SubScript\s0\v'-0.3m'\f[], this is not.
This is \f[B]Bold Both\f[], this is not.
.LP
This is \f[BI]Both \*{SuperScript\*}\f[], this is not.
This is \f[BI]Both \v'0.3m'\s[\n[.s]*9u/12u]SubScript\s0\v'-0.3m'\f[], this is not.
This is \f[BI]Both \*{before\*}Both\*{after\*}\f[], this is not.
.NH 1
Character Testing
.LP
Here is an asterisk: *.
Here are two: **
Here is an ^ up carat, and _ underscore.
.B this line starts with a dot, will it escape?
.NH 1
Lists
.IP \[bu] 2
One
.IP \[bu] 2
Two
.IP \[bu] 2
Three
.NH 2
Right Shifts
.IP \[bu] 2
One
.RS
.IP \[bu] 2
Two
.RS
.IP \[bu] 2
Three
.RS
.IP \[bu] 2
Four
.RS
.IP \[bu] 2
Five
.RE
.RE
.RE
.RE
.NH 1
Escapes
.LP
Below is the pythagorean theorem in EQ.
.EQ
 a sup 2 + b sup 2 = c sup 2
.EN
.LP
Here's a diagram in pic:
.PS
 box "jot";
 arrow;
 box "pic";
 arrow;
 box "groff -ms";
 arrow;
 ellipse "Output";
.PE
.NH 1
Code Blocks
.LP
Jot allows users to embed code into a document like so:
.DS L
.ft CW
#include <stdio.h>

int 
main(void) {
    for (int i = 0; i < 30; i++)
        printf("%d ", i);
    putchar('\\n');
}
.ft
.DE
.NH 1
Dot escapes
.IP \[bu] 2
\&.bullet.
.NH 2
\&.header.
\f[]

