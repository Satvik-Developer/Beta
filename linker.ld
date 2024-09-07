/* linker.ld */
OUTPUT_FORMAT("elf32")
OUTPUT_ARCH(i386)
ENTRY(start)  ; Entry point in the assembly code

SECTIONS
{
    . = 0x100000; /* Set the starting address for the kernel */
    .text : {
        *(.text)
    }
    .data : {
        *(.data)
    }
    .bss : {
        *(.bss)
    }
}
