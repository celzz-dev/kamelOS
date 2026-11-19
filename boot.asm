bits 32

MB_MAGIC equ 0x1BADB002
MB_FLAGS equ 0
MB_CHECKSUM equ -(MB_MAGIC + MB_FLAGS)

section .multiboot
align 4
    dd MB_MAGIC
    dd MB_FLAGS
    dd MB_CHECKSUM

section .text
global _start
_start:
    cli
.hang:
    hlt
    jmp .hang 
