.text
.org 0x20

TABELA: .space 8

.global _start
.align
_start:

    adr r0, TABELA
    mov r1, #8
    mov r2, #0xFF

ZANKA:
    strb r2, [r0]
    add r0, r0, #1
    subs r1, r1, #1
    bne ZANKA

_end: b _end