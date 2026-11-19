# kamelOS

A 32-bit x86 kernel written from scratch in C and NASM assembly, booted by GRUB using the Multiboot specification.

kamelOS is a learning project. The goal is to understand every layer between the power button and a running program, so each piece (toolchain, linker script, boot code) is written and understood by hand rather than copied.

## Status

**v0.1: boots and halts.** GRUB loads the kernel at 1 MiB, jumps to `_start`, and the kernel disables interrupts and halts the CPU. There is no output yet.

## Roadmap

- [x] Multiboot header and entry point (`boot.asm`)
- [x] Linker script that loads the kernel at 1 MiB (`linker.ld`)
- [x] Bootable ISO that runs in QEMU
- [ ] Set up a stack and call `kernel_main` in C
- [ ] Print to the VGA text buffer (`0xB8000`)
- [ ] GDT (Global Descriptor Table)
- [ ] IDT and interrupt handling (exceptions, keyboard)
- [ ] Memory management (physical memory manager, allocator)
- [ ] Scheduler and processes
- [ ] Filesystem
- [ ] 64-bit mode
- [ ] Port existing software

## How it boots

1. The BIOS loads GRUB from the disc image.
2. GRUB reads `/boot/grub/grub.cfg` and loads `/boot/kernel.elf`.
3. GRUB scans the first 8 KiB of the kernel for the Multiboot header (magic number `0x1BADB002`, flags, and a checksum so that all three add up to 0).
4. GRUB switches the CPU to 32-bit protected mode and jumps to `_start`.
5. `_start` runs `cli` (no interrupts) and loops on `hlt`.

## Project layout

```
boot.asm      Multiboot header and entry point (NASM)
linker.ld     Linker script: places the kernel at 0x100000
grub.cfg      GRUB menu entry that loads the kernel
```

## Building

Requirements: `nasm`, `ld` (binutils), `grub` (`grub-mkrescue`, `grub-file`), `xorriso`, `mtools`, `qemu-system-i386`.

On Arch Linux:

```
sudo pacman -S nasm qemu-system-x86 grub xorriso mtools
```

Build and run:

```
# 1. Assemble to a 32-bit ELF object file
nasm -f elf32 boot.asm -o boot.o

# 2. Link using our script (32-bit ELF output)
ld -m elf_i386 -T linker.ld -o kernel.elf boot.o

# 3. Check that the Multiboot header is valid
grub-file --is-x86-multiboot kernel.elf && echo "valid multiboot"

# 4. Lay out the disc contents
mkdir -p isodir/boot/grub
cp kernel.elf isodir/boot/kernel.elf
cp grub.cfg isodir/boot/grub/grub.cfg

# 5. Build a bootable ISO
grub-mkrescue -o kamelos.iso isodir

# 6. Boot it in QEMU
qemu-system-i386 -cdrom kamelos.iso
```

Select the **kamelOS** entry in the GRUB menu to boot.

## Why "kamelOS"?

It follows `kamelib`, the mini standard library this project grew out of.

## License

To be decided.
