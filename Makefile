# Cross-compiler settings
AS = nasm
CC = x86_64-elf-gcc
LD = x86_64-elf-ld

# Directories
BOOTLOADER_DIR = bootloader
KERNEL_DIR = kernel
BIN_DIR = bin

# Files
BOOTLOADER_SRC = $(BOOTLOADER_DIR)/core.asm
KERNEL_ASM_SRC = $(KERNEL_DIR)/kernel_first_entry_point.asm
KERNEL_C_SRC = $(KERNEL_DIR)/kernel_entry_point.c
LINKER_SCRIPT = linker.ld

BOOTLOADER_BIN = $(BIN_DIR)/bootloader.bin
KERNEL_BIN = $(BIN_DIR)/kernel.bin
OS_IMAGE = os-image.bin

# Build rules
CROSS_COMPILE = x86_64-elf-
AS = $(CROSS_COMPILE)as
CC = $(CROSS_COMPILE)gcc
LD = $(CROSS_COMPILE)ld
CFLAGS = -ffreestanding -m64 -O2
LDFLAGS = -nostdlib -T $(LINKER_SCRIPT)

all: $(OS_IMAGE)

# Assemble bootloader
$(BOOTLOADER_BIN): $(BOOTLOADER_SRC)
	$(AS) -f bin -o $(BOOTLOADER_BIN) $(BOOTLOADER_SRC)

# Assemble kernel entry point (assembly)
$(BIN_DIR)/kernel_first_entry_point.o: $(KERNEL_ASM_SRC)
	$(AS) -f elf64 -o $(BIN_DIR)/kernel_first_entry_point.o $(KERNEL_ASM_SRC)

# Compile kernel (C)
$(BIN_DIR)/kernel_entry_point.o: $(KERNEL_C_SRC)
	$(CC) $(CFLAGS) -c $(KERNEL_C_SRC) -o $(BIN_DIR)/kernel_entry_point.o

# Link kernel
$(KERNEL_BIN): $(BIN_DIR)/kernel_first_entry_point.o $(BIN_DIR)/kernel_entry_point.o
	$(LD) $(LDFLAGS) -o $(KERNEL_BIN) $(BIN_DIR)/kernel_first_entry_point.o $(BIN_DIR)/kernel_entry_point.o

# Combine bootloader and kernel into OS image
$(OS_IMAGE): $(BOOTLOADER_BIN) $(KERNEL_BIN)
	cat $(BOOTLOADER_BIN) $(KERNEL_BIN) > $(OS_IMAGE)

# Clean build files
clean:
	rm -rf $(BIN_DIR)/*.o $(KERNEL_BIN) $(BOOTLOADER_BIN) $(OS_IMAGE)

