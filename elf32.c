#include <elf.h>

#include "lib.h"

void elf_load_sections(const char *buf, Elf32_Phdr *phdr, Elf32_Half num,
		       Elf32_Half entsz)
{
	for (Elf32_Half i = 0; i < num; i++ ) {
		if (phdr->p_type != PT_LOAD)
			continue;
		/* Only LOAD segments. */
		kmemcpy((void *)(uintptr_t)phdr->p_vaddr, buf + phdr->p_offset, phdr->p_filesz);

		phdr = (Elf32_Phdr *)((const char *)phdr + entsz);
	}
}

/* buf points to the memory location. */
void *elf32_load_file(void *buf)
{
	Elf32_Ehdr *ehdr = (Elf32_Ehdr *)buf;
	Elf32_Phdr *phdr = (Elf32_Phdr *)(buf + ehdr->e_phoff);

	if (ehdr->e_ident[EI_MAG0] != 0x7f ||
	    ehdr->e_ident[EI_MAG1] != 'E' ||
	    ehdr->e_ident[EI_MAG2] != 'L' ||
	    ehdr->e_ident[EI_MAG3] != 'F')
		return NULL;

	if (ehdr->e_ident[EI_CLASS] != ELFCLASS32)
		return NULL;

	if (ehdr->e_ident[EI_DATA] != ELFDATA2LSB)
		return NULL;

	elf_load_sections(buf, phdr, ehdr->e_phnum, ehdr->e_phentsize);

	return (void *)ehdr->e_entry;
}
