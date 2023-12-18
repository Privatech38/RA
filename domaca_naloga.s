.text
.org 0x20

izvorna_koda: .asciz " \n\n stev1: .var 0xf123 @ komentar 1\n @prazna vrstica \n stev2: .var 15\nstev3: .var 128\n_start:\n mov r1, #5 @v r1 premakni 5\nmov r2, #1\nukaz3: add r1, #1\nb _start"

izvorna_koda_pocisceno: .space 120

tabela_oznak: .space 100

@ r0 - izvorna_koda addres
@ r1 - izvorna_koda_pocisceno
@ r2 - current char
@ r3 - last char above value 32

.align
.global _start
_start:

    adr r0, izvorna_koda
    adr r1, izvorna_koda_pocisceno
    sub r0, r0, #1
    sub r1, r1, #1
    mov r3, #0

CHECK_WHITESPACE:
    cmp r3, #0 @ Check if last char is NULL
    beq PRVI_DEL
    mov r3, r2
    cmp r3, #10 @ Check if new line
    moveq r3, 0
    b PRVI_DEL


PRVI_DEL:
    ldrb r2, [r0, #1]!
    cmp r2, #32
    bls CHECK_WHITESPACE
    strb r2, [r1, #1]!
    adr r2, izvorna_koda_pocisceno
    sub r2, r2, #1
    cmp r2, r0
    beq _end
    b PRVI_DEL


_end: b _end