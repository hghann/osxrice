.SUFFIXES: .ms .ps .pdf

ROFF = groff
MACROS = -Tpdf -U -tepR -mspdf
PRE = preconv | soelim | refer | pic | grap | tbl | eqn
POST = gropdf
ROFFEXT = ms
LAST=$(shell ls -t *.$(ROFFEXT) | head -1 | sed -e "s/\.$(ROFFEXT)//")

all: $(LAST).pdf

.ms.pdf:
	cat $< | $(ROFF) $(MACROS) > $@

clean:
	rm -f *.ps equations.ms figures.ms tables.ms equations.pdf figures.pdf tables.pdf

.DEFAULT_GOAL := default

default: all .ms.pdf clean
