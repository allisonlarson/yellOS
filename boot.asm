global start

section .text
bits 32
start:
    ; Point the first entry of the level 4 page table to the first entry in the
    ; p3 table
    mov eax, p3_table
    or eax, 0b11
    mov dword [p4_table + 0], eax

    ; Point the first entry of the level 4 page table to the first entry in the
    ; p2 table
    mov eax, p2_table
    or eax, 0b11
    mov dword [p3_table + 0], eax

    ; point each page table level two entry to a page
    mov ecx, 0 ; counter variable
.map_p2_table:
    mov eax, 0x200000 ; 2MiB
    mul ecx ; ecx * eax
    or eax, 0b10000011
    mov [p2_table + ecx * 8], eax
    inc ecx ; increment
    cmp ecx, 512 ; compare
    jne .map_p2_table ; jump if not equal

    ; move page table address to cr3
    mov eax, p4_table
    mov cr3, eax ; cr3 has to be mov from another register

    ; enable PAE (physical address extension)
    mov eax, cr4
    or eax, 1 << 5 ; modify cr4
    mov cr4, eax

    ; set the long mode bit
    mov ecx, 0xC0000080
    rdmsr ; read to model specific register
    or eax, 1 << 8
    wrmsr ; write to model specific register

    ; enable paging
    mov eax, cr0
    or eax, 1 << 31
    or eax, 1 << 16
    mov cr0, eax

    lgdt [gdt64.pointer]

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

section .rodata ; readonly data
gdt64:
  dq 0
.code: equ $ - gdt64
  dq (1<<44) | (1<<47) | (1<<41) | (1<<43) | (1<<53) ; 44: 'descriptor type', 47: 'present', 41: 'read/write', 43: 'executable'. 53: '64-bit'
.data: equ $ -  gdt64
  dq (1<<44) | (1<<47) | (1<<41)
.pointer:
  dw .pointer - gdt64 - 1
  dq gdt64
