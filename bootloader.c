#include "elf32.h"
#include "lib.h"

#define GDT_FLAGS_SZ 2
#define GDT_FLAGS_GR 3
#define GDT_AB_AC 0
#define GDT_AB_RW 1
#define GDT_AB_DC 2
#define GDT_AB_EX 3
#define GDT_AB_PRIV 5
#define GDT_AB_PR 7
#define GDT_AB_MASK (1 << 4)

struct gdt_entry {
	unsigned int limit_low16 : 16;
	unsigned int base_low16 : 16;
	unsigned int base_mid8 : 8;
	unsigned int access_byte: 8;
	unsigned int limit_high4 : 4;
	unsigned int flags : 4;
	unsigned int base_high8 : 8;

};

/* Remember that .bss is not initialized yet.  */
struct gdt_entry gdt_entries[4];

static void set_gdt_entry(struct gdt_entry *ent, unsigned int base,
			  unsigned int limit, unsigned char access_byte,
			  unsigned char flags);

void _start(void)
{
	void *kern = NULL;

	/* kern = ..., laod with IDE PMIO driver. */

	elf32_load_file(kern);

	while (1)
		;
}

__attribute__((unused))
static void set_gdt_entry(struct gdt_entry *ent, unsigned int base,
			  unsigned int limit, unsigned char access_byte,
			  unsigned char flags)
{
	ent->limit_low16 = limit & 0xFFFF;
	ent->limit_high4 = (limit >> 16) & 0xF;
	ent->base_low16 = base & 0xFFFF;
	ent->base_mid8 = (base >> 16) & 0xFF;
	ent->base_high8 = (base >> 24) & 0xFF;
	ent->flags = flags & 0xF;
	ent->access_byte = access_byte;
}
