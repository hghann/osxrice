#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include "tokenline.h"
#include "util.h"

#define LINE_ESCAPE(c) ((c) == '_' || (c) == '^' || \
                        (c) == '*' || (c) == '-' || (c) == '\\') \

#define START_ESCAPE(c) ((c) == '#' || LINE_ESCAPE((c)))

static void 
push(TokenLine *line, Token t) {
    if (!line)
        return;
        
    struct TokenNode* tn = emalloc(sizeof(struct TokenNode),
                                   "allocating tokennode");

    tn->val = t;
    tn->next = NULL;

    if (!line->start)
        line->start = line->end = tn;
    else
        line->end = line->end->next = tn;
}

#define PUSH_CHAR(l, c) push((l), (Token) { chr, (c) })
#define PUSH_CTRL(l, c) push((l), (Token) { (c), '\0' })

TokenLine 
parseLine(char* str) {
    TokenLine line = EMPTY_LINE;
    line.line = str;
    char* curr = str;

    if (!curr || *curr == '\0')
        return line;

    while (isspace(*curr))
        line.level += *curr++ == '\t' ? 4 : 1;

    switch (*curr) {
        case '\\':
            line.type = normal;

            curr++;

            if (!START_ESCAPE(*curr))
                PUSH_CHAR(&line, '\\');
            PUSH_CHAR(&line, *curr);

            curr++;

            break;
        case '#':
            line.type = header;

            for (line.level = 0; *curr == '#'; curr++)
                line.level++;

            while (isspace(*curr))
                curr++;

            break;
        case '!':
            curr++; // This should fall through
        case '\'':
        case '.':
            line.type = escape;
            break;
        case '>':
            line.type = quote;

            do
                curr++;
            while (isspace(*curr));

            break;
        case '`':
            if (curr[1] == '`' && curr[2] == '`') {
                line.type = mono;
                curr += 3;
            } else
                line.type = normal;
            break;
        case '~':
            if (curr[1] == '~' && curr[2] == '~') {
                line.type = mono;
                curr += 3;
            } else
                line.type = normal;
            break;
        case '*':
        case '-':
            if (isspace(curr[1])) {
                while (isspace(*++curr)) {};
                line.level /= DENT;
                line.type = bullet;
                break;
            } // falls through
        default:
            line.type = normal;
    }

    for (; *curr != '\0'; curr++) {
        switch (*curr) {
            case '\\':
                curr++;

                if (!LINE_ESCAPE(*curr))
                    PUSH_CHAR(&line, '\\');

                if (*curr == '\0')
                    curr--;
                else
                    PUSH_CHAR(&line, *curr);

                break;
            case '*':
                if (curr[1] == '*') {
                    curr++;
                    PUSH_CTRL(&line, bold);
                } else
                    PUSH_CTRL(&line, italic);
                break;
            case '_':
                PUSH_CTRL(&line, subscript);
                break;
            case '^':
                PUSH_CTRL(&line, superscript);
                break;
            case '`':
                PUSH_CTRL(&line, constwidth);
                break;
            default:
                PUSH_CHAR(&line, *curr);
        }
    }

    push(&line, (Token) {chr, '\n'});

    return line;
}

int 
pop(TokenLine *line, Token *t) {
    struct TokenNode *top;
    if (!line)
        return 0;

    if (!(top = line->start))
        return 1;

    if (t)
        *t = top->val;
    line->start = top->next;
    free(top);

    return 0;
}

void
freeLine(TokenLine *tl) {
    while (!pop(tl, NULL))
        {}
}

int
peek(TokenLine *line, Token *t) {
    if (!line || !t)
        return 0;

    if (!line->start)
        return 1;

    *t = line->start->val;

    return 0;
}
