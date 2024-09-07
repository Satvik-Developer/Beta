; Boot Loader initialization
BITS 16
ORG 0x7C00

; Initialize the stack
MOV AX, 0x9000
MOV SS, AX
MOV SP, 0xFFFF

; Enter protected mode
CLI                 ; Disable interrupts
LGDT [gdt_descriptor] ; Load the GDT descriptor
MOV EAX, CR0
OR EAX, 1           ; Set the PE (Protection Enable) bit
MOV CR0, EAX
JMP 0x08:protected_mode_start  ; Far jump to protected mode

gdt_start:
    ; Define GDT (Global Descriptor Table)
    DQ 0x0000000000000000  ; Null descriptor
    DQ 0x00CF9A000000FFFF  ; Code segment (base=0, limit=0xFFFFF, DPL=0, executable, readable)
    DQ 0x00CF92000000FFFF  ; Data segment (base=0, limit=0xFFFFF, DPL=0, writable)

gdt_descriptor:
    DW gdt_end - gdt_start - 1
    DD gdt_start

gdt_end:

protected_mode_start:
    ; Set up segment registers in protected mode
    MOV AX, 0x10
    MOV DS, AX
    MOV ES, AX
    MOV SS, AX
    MOV ESP, 0x90000  ; Set up the stack in high memory

    ; Jump to the kernel (at 0x10000 in protected mode)
    JMP 0x10:0x10000

; Fill the rest of the bootloader with zeros and add the boot signature
TIMES 510 - ($ - $$) DB 0
DW 0xAA55
