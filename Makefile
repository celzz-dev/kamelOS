.PHONY: all clean

all: kamelos.iso
	
kamelos.iso: kernel.elf grub.cfg
	mkdir -p isodir/boot/grub
	cp kernel.elf isodir/boot/kernel.elf
	cp grub.cfg isodir/boot/grub/grub.cfg
	grub-mkrescue -o kamelos.iso isodir
	
kernel.elf: boot.o kernel.o linker.ld
	ld -m elf_i386 -T linker.ld -o kernel.elf boot.o kernel.o
	grub-file --is-x86-multiboot kernel.elf && echo "kernel.elf: Valid multiboot"

boot.o: boot.asm
	nasm -f elf32 boot.asm -o boot.o

kernel.o: kernel.c
	gcc -m32 -ffreestanding -fno-pie -fno-stack-protector -c kernel.c -o kernel.o
		
clean:
	rm -f kamelos.iso kernel.elf boot.o kernel.o
	rm -rf isodir
