.text
.org 0x20

izvorna_koda: .asciz " \n\n stev1: .var 0xf123 @ komentar 1\n @prazna vrstica \n stev2: .var 15\nstev3: .var 128\n_start:\n mov r1, #5 @v r1 premakni 5\nmov r2, #1\nukaz3: add r1, #1\nb _start"

izvorna_koda_pocisceno: .space 120

tabela_oznak: .space 100

@ r0 - izvorna_koda adress
@ r1 - izvorna_koda_pocisceno adress
@ r2 - current char
@ r3 - limiter for izvorna_koda read
@ r4 - line state (0 - normal, 1 - comment)

.align
.global _start
_start:

@ ----------- PRVI DEL -----------^
@ Ta del odstrani odvečne presledke in komentarje

    adr r0, izvorna_koda
    adr r1, izvorna_koda_pocisceno
    sub r0, r0, #1
    sub r1, r1, #1
    @ Pripravi counter
    mov r3, r1

PRVI_DEL:
    ldrb r2, [r0, #1]!
    @ Preveri ce je LF
    cmp r2, #10
    moveq r4, #0
    @ Preveri ce je komentar
    cmp r2, #64
    moveq r4, #1
    @ Skoci ce je state 1 (komentar)
    cmp r4, #1
    beq PRVI_DEL
    @ Preveri za presledek
    cmp r2, #32
    bleq CHECK_SPACE
    @ Shrani ce je non-whitespace char
    strb r2, [r1, #1]!
    cmp r0, r3
    beq DRUGI_DEL_INIT
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
    @ Check if right is comment
    cmp r2, #64
    beq PRVI_DEL
    ldrb r2, [r0]
    mov pc, lr

@ ----------- DRUGI DEL -----------
@ Ta del odstrani odvečne LF oz. \n

@ r0 - izvorna_koda adress
@ r1 - izvorna_koda_pocisceno adress
@ r2 - current char
@ r3 - limiter for izvorna_koda read
@ r4 - line state (0 - normal, 1 - start of line)

DRUGI_DEL_INIT:
    adr r0, izvorna_koda
    adr r1, izvorna_koda_pocisceno
    sub r0, r0, #1
    sub r1, r1, #1
    @ Pripravi counter
    mov r3, r1
    @ Reset previous
    mov r2, #0
    mov r4, #0

DRUGI_DEL:
    ldrb r2, [r1, #1]!
    @ Preveri ce je LF
    cmp r2, #10
    bleq LF_CHECK
    @ Zapisi

LF_CHECK:
    @ Preveri ce je 
    cmp r4, #1
    bne DRUGI_DEL
    cmp r2, #10
    moveq r4, #0
    mov pc, lr

_end: b _end