.text
.org 0x20

izvorna_koda: .asciz " \n\n stev1: .var 0xf123 @ komentar 1\n @prazna vrstica \n stev2: .var 15\nstev3: .var 128\n_start:\n mov r1, #5 @v r1 premakni 5\nmov r2, #1\nukaz3: add r1, #1\nb _start"

izvorna_koda_pocisceno: .space 120

tabela_oznak: .space 100

@ r0 - izvorna_koda adress
@ r1 - izvorna_koda_pocisceno adress
@ r2 - current char
@ r3 - counter

.align
.global _start
_start:

    adr r0, izvorna_koda
    adr r1, izvorna_koda_pocisceno
    sub r0, r0, #1
    sub r1, r1, #1
    @ Pripravi counter
    mov r3, r1
    sub r3, r3, #19

PRVI_DEL:
    subs r3, r3, #1
    beq _end
    ldrb r2, [r0, #1]!
    cmp r2, #32
    bleq CHECK_SPACE
    strneb r2, [r1, #1]!
    b PRVI_DEL

CHECK_SPACE:
    @ Check left
    ldrb r2, [r0, #-1]
    cmp r2, #32
    bls PRVI_DEL
    @ Check right
    ldrb r2, [r0, #1]
    cmp r2, #32
    bls PRVI_DEL

_end: b _end