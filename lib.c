#include "lib.h"

void kmemcpy(void *dst, const void *src, size_t sz)
{
	char *d = dst;
	const char *s = src;

	for (size_t i = 0; i < sz; i++)
		d[i] = s[i];
}

void kmemset(void *dst, char num, size_t sz)
{
	char *d = dst;

	for (size_t i = 0; i < sz; i++)
		d[i] = num;
}
