#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>
#include "tokenline.h"
#include "writer.h"
#include "util.h"

#define DEFAULT_LINE_SIZE 1000
#define LINE_REALLOC_CONSTANT 1.5F

static int
readLine(FILE* source, char** linep) {
    int i, linesize, c;

    linesize = DEFAULT_LINE_SIZE;
    (*linep) = emalloc(linesize * sizeof(char), "allocating initial line");

    for (i = 0, c = getc(source); c != '\n' && c != EOF; c = getc(source), i++) {
        if (i+1 == linesize)
            *linep = erealloc(*linep,
                              (linesize *= LINE_REALLOC_CONSTANT) * sizeof(char),
                              "reading line");
        (*linep)[i] = c;
    }

    (*linep)[i] = '\0';

    return c == EOF;
}

static void
parseFile(FILE* file) {
    Writer writer;
    INIT(&writer);
    char* line;
    int running = 1, writing = 0;

    while (running) {
        running = !readLine(file, &line);

        if (!strcmp(line, ".js") || !strcmp(line, ".JS"))
            writing = 1;
        else if (writing && (!strcmp(line, ".je") || !strcmp(line, ".JE"))) {
            writing = 0;
            close(&writer);
        } else if (writing) {
            TokenLine queue = parseLine(line);
            write(&writer, queue);
        } else if (running)
            puts(line);
        else
            fputs(line, stdout);
        free(line);
    }
}

int
main(int argc, char** argv) {
    FILE* f;

    if (argc == 1)
        parseFile(stdin);
    else {
        for (int i = 1; i < argc; i++) {
            if (!(f = fopen(argv[i], "r")))
                die("file error", "opening file");
            parseFile(f);
            if (fclose(f))
                die("file error", "closing file");
        }
    }
}
