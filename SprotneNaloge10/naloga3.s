.text
.org 0x20

TABELA: .byte 192,155,224,48,0,128,99,147,177,101

.align

REZ: .space 2

.global _start
.align
_start:

adr r0, TABELA
mov r1, #10
mov r2, #0
mov r3, #0
mov r4, #0

ZANKA:
    ldrsb r2, [r0]
    add r3, r3, r2
    cmp r2, #100
    addgt r4, r4, #1
    add r0, r0, #1
    subs r1, r1, #1
    bne ZANKA

adr r0, REZ
strh r3, [r0]

_end: b _end