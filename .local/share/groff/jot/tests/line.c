#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define DEFAULT_LINE_SIZE 1000
#define LINE_REALLOC_CONSTANT 1.5F

static int 
readLine(FILE* source, char** linep) {
    int i, linesize, c;

    linesize = DEFAULT_LINE_SIZE;
    (*linep) = malloc(linesize * sizeof(char));

    for (i = 0, c = getc(source); c != '\n' && c != EOF; c = getc(source), i++) {
        if (i+1 == linesize)
            (*linep) = realloc((*linep), linesize *= (LINE_REALLOC_CONSTANT * sizeof(char)));
        (*linep)[i] = c;
    }

    (*linep)[i] = '\0';

    return c == EOF;
}

int
main(void) {
    char* line;
    int running = 1;
    while (running) {
        running = !readLine(stdin, &line);
        printf("%x\n", line);
        free(line);
    }
}
