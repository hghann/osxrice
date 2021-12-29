#ifndef TOKENLINE_H_
#define TOKENLINE_H_

#include <stddef.h>

/*
    SETTING: set prefered indent level

    DENT is the number of spaces needed to indent a given bullet once.
    E.g., if a bullet has an 8 space indent and DENT is 4, it's indented twice

    Integer division is in effect, so the result is always rounded down.
    E.g., if a bullet has 5 spaces and DENT is 4, it's indented once

    Tabs are considered 4 spaces, so tab-based indentation can just use the default value.
*/

#define DENT 4

typedef struct {
    enum TokenType {
        bold,
        italic,
        subscript,
        superscript,
        constwidth,
        chr,
    } type;
    char val; // Only defined if type == chr
} Token;

typedef struct {
    char* line; // The original str it points to
    enum LineType {
        bullet, // An entry in a list
        header, // A header
        normal, // A normal line
        escape, // Line of groff included in Jot
        quote,  // A blockquote
        mono,   // A monospaced section
        empty,  // An empty line
    } type;     // The type of the line
    unsigned int level;  /* Depending on the type, this means:
                                bullet: the level of indent of a bullet, using DENT
                                header: the level of a header, h1, h2, etc
                                normal: the raw number of spaces a line has
                                escape, mono, quote, empty: undefined */
    struct TokenNode {
        struct TokenNode* next;
        Token val;
    } *start, *end;
} TokenLine;

#define EMPTY_LINE ((TokenLine) {NULL, empty, 0, NULL, NULL})

TokenLine parseLine(char* string);

int pop(TokenLine *line, Token *t);

int peek(TokenLine *line, Token *t);

void freeLine(TokenLine *tl);

#endif
