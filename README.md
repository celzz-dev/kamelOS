# kamelOS

kamelOS is an operating system built from scratch in C and assembly. The goal is a usable OS that can run ported software.

It currently exists as an early x86 kernel, booted by GRUB using the Multiboot specification. It starts in 32-bit mode, and 64-bit support is planned.

## Status

**v0.2: boots and shows text.** GRUB loads the kernel at 1 MiB, jumps to `_start`, and the kernel disables interrupts and calls kernel_main which writes to vga and then halts the CPU. There is simple text output.

## Roadmap

- [x] Multiboot header and entry point (`boot.asm`)
- [x] Linker script that loads the kernel at 1 MiB (`linker.ld`)
- [x] Bootable ISO that runs in QEMU
- [x] Set up a stack and call `kernel_main` in C
- [x] Print to the VGA text buffer (`0xB8000`)
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
5. `_start` runs `cli` (no interrupts) and calls kernel_main.
6. kernel_main prints to the vga text buffer and then hlts in a loop.

## Project layout

```
boot.asm      Multiboot header and entry point (NASM)
kernel.c      The kernel's code (currently prints text to the screen)
linker.ld     Linker script: places the kernel at 0x100000 and links boot.asm and kernel.c
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
# 1. Run make and it makes the build for you
# 2. Boot it in QEMU
qemu-system-i386 -cdrom kamelos.iso
```

Select the **kamelOS** entry in the GRUB menu to boot.

## Why "kamelOS"?

It follows `kamelib`, the mini standard library this project grew out of.

## License

[MIT](LICENSE)
