TSTS = $(wildcard *.c)
HDRS = $(wildcard ../*.h)
MAIN = ../jot.c
ALLS = $(wildcard ../*.c)
SRCS = $(filter-out $(MAIN),$(ALLS))
TSTO = $(TSTS:.c=.test)
OPTS = -std=c99 -Wall -Wextra -pedantic -g -I..
CCWO = $(CC) $(OPTS)

all: tests

tests: $(TSTO)

%.test: %.c 
	$(CCWO) -o $@ $+ $(SRCS) $(HDRS)

clean:
	rm -f *.test

.PHONY: all clean tests
