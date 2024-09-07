BITS 64
EXTERN kernel_entry
GLOBAL START
start:
 ; Set up segment registers
    mov eax, 0x10
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax
    mov esp, 0x90000  ; Set up the stack
    
    call kernel_entry
halt:
    jmp halt
times 510 - ($ - $$) db 0
dw 0xAA55