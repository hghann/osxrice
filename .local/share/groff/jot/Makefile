SRC  = writer.c jot.c tokenline.c util.c
OBJ  = $(SRC:.c=.o)
DOBJ = $(SRC:.c=.dev.o)
OPTS = -std=c99 -Wall -Wextra -pedantic -Wimplicit-fallthrough=2
CCWO = $(CC) $(OPTS)
DCWO = $(CCWO) -g

all: jot

jot: $(OBJ)
	$(CCWO) -o $@ $(OBJ)

%.o: %.c
	$(CCWO) -c -o $@ $<

# Used for debugging
dev: jot.dev

jot.dev: $(DOBJ)
	$(DCWO) -o $@ $(DOBJ)

%.dev.o: %.c
	$(DCWO) -c -o $@ $<

PREF = /usr/local
BIN  = $(PREF)/bin
MAN  = $(PREF)/share/man/man1
VER  = 0.3.0

install: jot
	mkdir -p $(BIN)
	cp -f jot $(BIN)
	chmod 775 $(BIN)/jot
	mkdir -p $(MAN)
	sed "s/VERSION/$(VER)/g" < jot.1 > $(MAN)/jot.1
	chmod 664 $(MAN)/jot.1

clean:
	rm jot jot.dev $(DOBJ) $(OBJ) -f

.PHONY: all clean install
