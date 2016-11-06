global start

section .text
bits 32
start:
    mov word [0xb8000], 0x0e48 ; H
    mov word [0xb8002], 0x0e65 ; e
    mov word [0xb8004], 0x0e6c ; l
    mov word [0xb8006], 0x0e6c ; l
    mov word [0xb8008], 0x0e6f ; o
    mov word [0xb800a], 0x0e2c ; ,
    mov word [0xb800c], 0x0e20 ;
    mov word [0xb800e], 0x0e77 ; w
    mov word [0xb8010], 0x0e6f ; o
    mov word [0xb8012], 0x0e72 ; r
    mov word [0xb8014], 0x0e6c ; l
    mov word [0xb8016], 0x0e64 ; d
    mov word [0xb8018], 0x0e21 ; !
    hlt

section .bss

align 4096

p4_table:
    resb 4096
p3_table:
    resb 4096
p2_table:
    resb 4096
