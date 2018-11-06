#ifndef _LIB_H
#define _LIB_H

#include <stdlib.h>

/* All function works with kernel space. */

void kmemcpy(void *dst, const void *src, size_t sz);
void kmemset(void *dst, char num, size_t sz);

#endif
