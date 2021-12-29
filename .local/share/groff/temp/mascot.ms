\# Use "$ equation $" within text to include math in paragraphs
.EQ 0
delim $$
.EN 0
.nr no-head-numbering 1 \" Uncomment to disable equation/figure/table numbering based on heading
.so /Users/hadiibrahim/Documents/university/macros/opening_macros.ms
.so /Users/hadiibrahim/Documents/university/macros/colors.ms
.nr HM 0.3      \" Set Header and footer margins
.nr FM 1.25i
.nr LT 6.25i
.nr LL 6.25i
\#
\# The following lines define the headers and footers the document.
\# LH stands for Left Header, LF stands for Left Footer, etc.
\# \D sets the line width in points
\# \l draws a line of specified length
\# \v moves vertically
\# \h moves horizontally
\#
.ds LH \D't 0.2p'\v'1.5'\l'6.25i'\v'-0.5'\h'-6.25i'{{+Course code+}}\D't 0.5p'
.ds RH Lecture {{+number+}}
.ds LF \D't 0.2p'\v'-3.5'\l'6.25i'\v'1'\h'-6.25i'Hadi Ghannoum\D't 0.5p'
.ds RF Page No. %
.ds RH {{+Course code+}}  \" Right aligned header
.ds CH           \" Empty header (centred)
\#.ds CF - % -   \" Footer with page number (centred)
.sp -4
.po 0.8i         \" Page offset
.ll 6.7i         \" Line length
\l'6.6i'         \" Draw horizontal line (Make sure it is a little smaller than line length)
.br              \" Break line
.po 1i           \" Change page offset (to default)
.ll 6.25i        \" Change line length (to default)
.sp -0.8         \" More up because there is too much spacing
.ad c            \" Center align
.PS              \" Invoke GNU Pic
box rad 0.1 ht 1 wid 4.1 at (0,0) fill 0.1 outline "white"
.PE
.po 1i
.sp -5.5
.ps 16           \" Set font point size
.pdfhref W -D https://uottawa.brightspace.com/d2l/le/content/243395/Home {{+Course name+}} \" A hyperlink
.br
.ps 10
.sp 0.2
Lecture {{+number+}}
.br
.sp 0.5
{{+Title+}}
.br
.ad n           \" Normal/Justify alignment
.po 0.8i
.ll 6.7i
.sp -1i
.PDFPIC -L /Users/hadiibrahim/Documents/university/bachelor-2/semester-1/cal-III/img/uottawa-logo.pdf 1.1
.sp -1.12i
.PDFPIC -R /Users/hadiibrahim/Documents/university/bachelor-2/semester-1/cal-III/img/cal3.pdf 1.0
.sp 0.5
\D't 1.5p'      \" Change line thickness
\l'6.6i'        \" Draw a horizontal line
\D't 0.5p'      \" Change line thickness (to default)
.br
.po 1i          \" Change page offset (to default)
.nr LL 6.25i    \" Change line length (to default)
.nr HM 1.2i
.ds LH \D't 0.2p'\v'1.5'\l'6.25i'\v'-0.5'\h'-6.25i'{{+Course code+}}\D't 0.5p'
.ds RH Lecture {{+number+}}
.PP
\#
\#
\#
.head "{{+Section one+}}"
.nr PS 11
.nr VS 15
.LP
{{+Start here+}}
\#
\#
\#
.so /Users/hadiibrahim/Documents/university/macros/closing_macros.ms
