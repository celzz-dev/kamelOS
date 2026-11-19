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
extern kernel_main
global _start
_start:
    cli
    mov esp, stack_top
    call kernel_main
.hang:
    hlt
    jmp .hang 

section .bss
align 16
stack_bottom:
    resb 16384
stack_top:
