#include <stdio.h>
#include <stdlib.h>
#include <errno.h>

void 
die(const char* reason, const char* context) {
    fprintf(stderr, "Jot: failed because of %s while %s\n", reason, context);
    exit(1);
}

void* 
erealloc(void* vp, size_t size, const char* context) {
    void* ret;

    if (!(ret = realloc(vp, size)))
        die("out of memory error (calloc)", context);

    return ret;
}

void* 
emalloc(size_t size, const char* context) {
    void* ret;

    if (!(ret = malloc(size)))
        die("out of memory error (malloc)", context);

    return ret;
}
