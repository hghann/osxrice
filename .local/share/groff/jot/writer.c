#include <stdlib.h>
#include <stdio.h>
#include "writer.h"

/* 
All credit for the subscript syntax goes to Ted Harding on the Groff mailing list:
    https://lists.gnu.org/archive/html/groff/2012-07/msg00046.html
*/

#define DENT 4

static void
printFont(Writer w) {
    putchar('\\');
    putchar('f');
    putchar('[');
    if (w.flags.constw)
        fputs("CW", stdout);
    else {
        if (w.flags.bold)
            putchar('B');
        if (w.flags.italic)
            putchar('I');
    }
    putchar(']');
}

static void 
printScript(Writer old, Writer new) {
    if (new.flags.super && new.flags.sub)
        new.flags.super = new.flags.sub = 0;
    if (old.flags.super && old.flags.sub)
        old.flags.super = old.flags.sub = 0;

    if (old.flags.super && !new.flags.super)
        fputs("\\*}", stdout);
    if (old.flags.sub && !new.flags.sub)
        fputs("\\s0\\v'-0.3m'", stdout);

    if (!old.flags.super && new.flags.super)
        fputs("\\*{", stdout);
    if (!old.flags.sub && new.flags.sub)
        fputs("\\v'0.3m'\\s[\\n[.s]*9u/12u]", stdout);
}

#define ESCAPE(c)                      \
    do {                               \
        if ((c) == '\'' || (c) == '.') \
            fputs("\\&", stdout);      \
    } while (0)

/* Three printing functions:
    - printOut prints the line to groff such that it should show exacly what's there
    - printRaw prints the line itself, but escaped
    - printClean is like printRaw, but doesn't include the front of the line
    - printFormatted prints the line formatted with escapes */

static void
printOut(TokenLine tl) {
    char *c;

    ESCAPE(*tl.line);

    for (c = tl.line; *c != '\0'; c++) {
        if (*c == '\\')
            fputs("\\\\", stdout);
        else
            putchar(*c);
    }

    putchar('\n');

    freeLine(&tl);
}

static void
printRaw(TokenLine tl) {
    ESCAPE(*tl.line);
    puts(tl.line);
    freeLine(&tl);
}

static void 
printClean(TokenLine tl) {
    Token t;

    if (pop(&tl, &t))
        return;
    else if (t.type == chr && tl.type != escape)
        ESCAPE(t.val);

    do {
        switch (t.type) {
            case bold:
                fputs("**", stdout);
                break;
            case italic:
                putchar('*');
                break;
            case superscript:
                putchar('^');
                break;
            case subscript:
                putchar('_');
                break;
            case constwidth:
                putchar('`');
                break;
            default:
                putchar(t.val);
        }
    } while (!pop(&tl, &t));
}

static void 
printFormatted(Writer* state, TokenLine tl) {
    Token t, temp;
    Writer old;

    if (pop(&tl, &t))
        return;
    else if (t.type == chr && tl.type != escape)
        ESCAPE(t.val);

    do {
        old = *state;
        switch (t.type) {
            case constwidth:
            case italic:
            case bold: {
                switch (t.type) {
                case bold:
                    state->flags.bold = !state->flags.bold;
                    break;
                case italic:
                    state->flags.italic = !state->flags.italic;
                    break;
                case constwidth:
                    state->flags.constw = !state->flags.constw;
                    break;
                default:
                    break;
                }

                while (!peek(&tl, &temp) && (temp.type == bold || temp.type == italic || temp.type == constwidth)) {
                    pop(&tl, &temp);
                    switch (temp.type) {
                    case bold:
                        state->flags.bold = !state->flags.bold;
                        break;
                    case italic:
                        state->flags.italic = !state->flags.italic;
                        break;
                    case constwidth:
                        state->flags.constw = !state->flags.constw;
                        break;
                    default:
                        break;
                    }
                }

                // If constw changes, or we're not constwidth and bold or italics changes
                if (old.flags.constw != state->flags.constw 
                    || (!state->flags.constw 
                        && (old.flags.italic != state->flags.italic
                            || old.flags.bold != state->flags.bold)))
                    printFont(*state);

                break;
            } 
            case subscript:
            case superscript: {

                if (t.type == superscript)
                    state->flags.super = !state->flags.super;
                else
                    state->flags.sub = !state->flags.sub;

                while (!peek(&tl, &temp) && (temp.type == subscript || temp.type == superscript)) {
                    pop(&tl, &t);
                    if (t.type == superscript)
                        state->flags.super = !state->flags.super;
                    else
                        state->flags.sub = !state->flags.sub;
                }
                printScript(old, *state);
                break;
            } 
            default:
                putchar(t.val);
                break;
        }        
    } while (!pop(&tl, &t));
}

/* SETTING
    These macros are inserted before each header and bullet respectively.
    You can change these to change how the output sees headers and bullets respectively.
    The '%d' in the first one is the current level of the header (# means 1, ## means 2, etc)
*/
#define HEADER ".NH %d"
#define BULLET ".IP \\[bu] 2"

void 
write(Writer* state, TokenLine line) {
    if (!state)
        return;

    if (state->flags.mono) {
        if (line.type == mono) {
            state->flags.mono = 0;
            puts(".ft\n.DE");
            printFont(*state);
            putchar('\n');
            freeLine(&line);
        } else
            printOut(line);
        return;
    }

    switch (line.type) {
        case mono:
            state->flags.mono = 1;
            puts(".LD\n.ft CW");
            freeLine(&line);
            return;
        case empty:
            state->flags.para = state->flags.quote = 0;
            for (; state->indent > 0; state->indent--)
                puts(".RE");
            return;
        case escape:
            state->flags.quote = state->flags.para = 0;
            printClean(line);
            return;
        case header:
            state->flags.quote = state->flags.para = 0;
            printf(HEADER, line.level);
            putchar('\n');
            printClean(line);
            return;
        case bullet:
            state->flags.para = 0;
            for (; state->indent < line.level; state->indent++)
                puts(".RS");
            for (; state->indent > line.level; state->indent--)
                puts(".RE");
            puts(BULLET);
            printFormatted(state, line);
            return;
        case quote:
            state->flags.para = 0;
            if (!state->flags.quote) {
                puts(".QP");
                state->flags.quote = 1;
            }
            printFormatted(state, line);
            return;
        case normal:
            if (line.level > 0) {
                puts(".PP");
                state->flags.para = 1;
                state->flags.quote = 0;
            } else if (!state->flags.para) {
                puts(".LP");
                state->flags.para = 1;
                state->flags.quote = 0;
            }
            printFormatted(state, line);
    }
}

void 
close(Writer* w) {
    if (!w) return;

    Writer empty;
    INIT(&empty);
    printScript(*w, empty);
    puts("\\f[]");
}
