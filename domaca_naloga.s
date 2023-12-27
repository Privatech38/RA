.text
.org 0x20

izvorna_koda: .asciz " \n\n stev1: .var 0xf123 @ komentar 1\n @prazna vrstica \n stev2: .var 15\nstev3: .var 128\n_start:\n mov r1, #5 @v r1 premakni 5\nmov r2, #1\nukaz3: add r1, #1\nb _start"

.align
izvorna_koda_pocisceno: .space 120

.align

tabela_oznak: .space 100

@ r0 - izvorna_koda adress
@ r1 - izvorna_koda_pocisceno adress
@ r2 - current char
@ r3 - line state (0 - normal, 1 - comment)

.align
.global _start
_start:

@ ----------- PRVI DEL -----------
@ Ta del odstrani odvečne presledke in komentarje

    adr r0, izvorna_koda
    adr r1, izvorna_koda_pocisceno
    sub r0, r0, #1
    sub r1, r1, #1

PRVI_DEL:
    ldrb r2, [r0, #1]!
    @ Preveri ce je LF
    cmp r2, #10
    moveq r3, #0
    @ Preveri ce je komentar
    cmp r2, #64
    moveq r3, #1
    @ Skoci ce je state 1 (komentar)
    cmp r3, #1
    beq PRVI_DEL
    @ Preveri za presledek
    cmp r2, #32
    bleq CHECK_SPACE
    @ Shrani ce je non-whitespace char
    strb r2, [r1, #1]!
    cmp r2, #0
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
@ r3 - line state (0 - normal, 1 - start of line)

DRUGI_DEL_INIT:
    @ Get adresses
    adr r0, izvorna_koda
    adr r1, izvorna_koda_pocisceno
    sub r0, r0, #1
    sub r1, r1, #1
    @ Reset previous
    mov r2, #0
    mov r3, #1

DRUGI_DEL:
    ldrb r2, [r1, #1]!
    @ Poglej ce je oznaka
    cmp r2, #58
    moveq r3, #3
    beq ZAPISI_2
    @ Preveri ce je LF
    cmp r2, #10
    beq LF_CHECK
    movne r3, #0
    b ZAPISI_2

ZAPISI_2:
    strb r2, [r0, #1]!
    cmp r2, #0
    bne DRUGI_DEL
    b POCISTI_OSTALO

REPLACE_LF_SPACE:
    mov r2, #32
    strb r2, [r0, #1]!
    b DRUGI_DEL

LF_CHECK:
    @ Preveri ce je LF in line state
    cmp r3, #1
    bhi REPLACE_LF_SPACE
    beq DRUGI_DEL
    mov r3, #1
    b ZAPISI_2

POCISTI_OSTALO:
    mov r2, #0
    adr r1, izvorna_koda_pocisceno
    sub r1, r1, #1
    b POCISTI_LOOP

POCISTI_LOOP:
    strb r2, [r0, #1]!
    cmp r0, r1
    bne POCISTI_LOOP
    b TRETJI_DEL_INIT

@ ----------- TRETJI DEL -----------
@ Ta del izračuna tabelo oznak

@ r0 - izvorna_koda adress
@ r1 - tabela_oznak adress
@ r2 - current char
@ r3 - word start index
@ r4 - oznaka adress

TRETJI_DEL_INIT:
    @ Prepare adresses
    adr r0, izvorna_koda
    adr r1, tabela_oznak
    sub r0, r0, #1
    sub r1, r1, #1
    @ Get limiter
    mov r3, r0
    mov r4, #0
    b SEARCH_FOR_LABEL

SEARCH_FOR_LABEL:
    ldrb r2, [r0, #1]!
    @ Poglej ce je newline
    cmp r2, #10
    addeq r4, r4, #1
    @ Poglej ce je :
    cmp r2, #58
    beq DOLOCI_NASLOV_OZNAKE
    @ Poglej ce je whitespace
    cmp r2, #32
    movls r3, r0
    @ Poglej ce je vse prebral
    cmp r2, #0
    bne SEARCH_FOR_LABEL
    b _end

DOLOCI_NASLOV_OZNAKE:
    mov r2, #39 @ Zapisi single quotation mark (')
    strb r2, [r1, #1]!
    sub r0, r0, #1
    b ZAPISI_OZNAKO

ZAPISI_OZNAKO:
    ldrb r2, [r3, #1]!
    strb r2, [r1, #1]!
    @ Loop
    cmp r3, r0
    bne ZAPISI_OZNAKO
    @ Zapisi '
    mov r2, #39
    strb r2, [r1, #1]!
    mov r2, #0
    strb r2, [r1, #1]!
    add r0, r0, #1
    @ Zapisi address
    tst r1, #1
    addeq r1, r1, #1
    strh r4, [r1, #1]!
    add r1, r1, #1
    b SEARCH_FOR_LABEL

_end: b _end