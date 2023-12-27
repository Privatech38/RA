.text
.org 0x20

COUNTER: .word 0xBB80

.global _start
.align
_start:

    adr r0, COUNTER
    mov r2, #500
    mov r1, #0
ZUNANJA_ZANKA:
    ldr r3, [r0]
    b NOTRANJA_ZANKA

NOTRANJA_ZANKA:
    add r1, r1, #1
    subs r3, r3, #1
    bne NOTRANJA_ZANKA
    subs r2, r2, #1
    bne ZUNANJA_ZANKA

_end: b _end