#ifndef _ELF32_H
#define _ELF32_H

#include <stdlib.h>

/* Buf is a pointer to raw file in memory. */
void *elf32_load_file(void *buf);

#endif
