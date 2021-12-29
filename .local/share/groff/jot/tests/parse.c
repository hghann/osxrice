#include <stdio.h>
#include <stdlib.h>
#include "../tokenline.h"

#define DEFAULT_LINE_SIZE 1000
#define LINE_REALLOC_CONSTANT ((double) 3 / 2)

static int readLine(FILE* source, char** linep) {
    int i, linesize, c;

    linesize = DEFAULT_LINE_SIZE;
    (*linep) = malloc(linesize * sizeof(char));

    for (i = 0, c = getc(source); c != '\n' && c != EOF; c = getc(source), i++) {
        if (i+1 == linesize)
            (*linep) = realloc((*linep), linesize *= (LINE_REALLOC_CONSTANT * sizeof(char)));
        (*linep)[i] = c;
    }

    (*linep)[++i] = '\0';

    return c == EOF;
}

void printToken(Token t) {
    switch (t.type) {
        case bold:
            puts("a bold token");
            break;
        case italic:
            puts("a italic token");
            break;
        case subscript:
            puts("a subscript token");
            break;
        case superscript:
            puts("a superscript token");
            break;
        case chr:
            fputs("a chr token of value '", stdout);
            if (t.val == '\n')
                fputs("\\n", stdout);
            else
                putchar(t.val);
            putchar('\'');
            putchar('\n');
            break;
    }
}

void printLine(TokenLine l) {
    printf("A line of type %s and level %d\n", 
        l.type == bullet ? "bullet" : 
            l.type == header ? "header" :
            l.type == normal ? "normal" : "empty",
        l.level);

    Token t;
    while (!pop(&l, &t))
        printToken(t);
}

int main(int argc, char** argv) {
    TokenLine tl;
    if (argc == 1) {
        char* str;
        readLine(stdin, &str);
        tl = parseLine(str);
        free(str);
    } else
        tl = parseLine(argv[1]);
    printLine(tl);
}
