#ifndef WRITER_H_
#define WRITER_H_

#include <stdint.h>
#include "tokenline.h"

typedef struct {
    unsigned int indent;
    struct {
        unsigned int mono:   1;
        unsigned int quote:  1;
        unsigned int para:   1;
        unsigned int sub:    1;
        unsigned int super:  1;
        unsigned int italic: 1;
        unsigned int bold:   1;
        unsigned int constw: 1;
    } flags;
} Writer;

/*
    These three things can be re-defined for different writers, so as long as these are defined, a given writer works
*/

#define INIT(W) { *W = (Writer) {0, {0,0,0,0,0,0,0,0}}; }

void 
write(Writer* w, TokenLine tl);

void 
close(Writer* w);

#endif
