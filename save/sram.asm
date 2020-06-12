
format binary as 'gba'

include '../lib/constants.inc'
include '../lib/macros.inc'

macro m_exit test {
        mov     r12, test
        b       eval
}

header:
        include '../lib/header.asm'

main:
        m_test_init

        ; Reset test register
        mov     r12, 0

        mov     r11, MEM_SRAM
        b       t001

sram:
        ; Fake SRAM save type
        dw      'SRAM'
        dw      '_V  '

t001:
        ; Uninitialized SRAM
        ldrb    r0, [r11]
        cmp     r0, 0xFF
        bne     f001

        add     r11, 32
        b       t002

f001:
        m_exit  1

t002:
        ; SRAM mirror 1
        mov     r0, 1
        strb    r0, [r11]
        add     r1, 0x10000
        ldrb    r0, [r11]
        cmp     r0, 1
        bne     f002

        add     r11, 32
        b       t003

f002:
        m_exit  2

t003:
        ; SRAM mirror 2
        mov     r0, 1
        mov     r1, r11
        strb    r0, [r1]
        add     r1, 0x01000000
        ldrb    r0, [r1]
        cmp     r0, 1
        bne     f003

        add     r11, 32
        b       t004

f003:
        m_exit  3

t004:
        ; SRAM load half
        mov     r0, 1
        mov     r1, r11
        strb    r0, [r1]
        ldrh    r0, [r1]
        m_half  r1, 0x0101
        cmp     r1, r0
        bne     f004

        add     r11, 32
        b       t005

f004:
        m_exit  4

t005:
        ; SRAM load word
        mov     r0, 1
        mov     r1, r11
        strb    r0, [r1]
        ldr     r0, [r1]
        m_word  r1, 0x01010101
        cmp     r1, r0
        bne     f005

        add     r11, 32
        b       t006

f005:
        m_exit  5

t006:
        ; SRAM store half position
        m_half  r0, 0xAABB
        mov     r1, r11

        strh    r0, [r1]
        ldrb    r2, [r1]
        cmp     r2, 0xBB
        bne     f006

        strh    r0, [r1, 1]
        ldrb    r2, [r1, 1]
        cmp     r2, 0xAA
        bne     f006

        add     r11, 32
        b       t007

f006:
        m_exit  6

t007:
        ; SRAM store half just byte
        m_half  r0, 0xAABB
        mov     r1, r11
        strh    r0, [r1]

        ldrb    r2, [r1]
        cmp     r2, 0xBB
        bne     f007

        ldrb    r2, [r1, 1]
        cmp     r2, 0xFF
        bne     f007

        add     r11, 32
        b       t008

f007:
        m_exit  7

t008:
        ; SRAM store word position
        m_word  r0, 0xAABBCCDD
        mov     r1, r11

        str     r0, [r1]
        ldrb    r2, [r1]
        cmp     r2, 0xDD
        bne     f008

        str     r0, [r1, 1]
        ldrb    r2, [r1, 1]
        cmp     r2, 0xCC
        bne     f008

        str     r0, [r1, 2]
        ldrb    r2, [r1, 2]
        cmp     r2, 0xBB
        bne     f008

        str     r0, [r1, 3]
        ldrb    r2, [r1, 3]
        cmp     r2, 0xAA
        bne     f008

        add     r11, 32
        b       t009

f008:
        m_exit  8

t009:
        ; SRAM store word just byte
        m_word  r0, 0xAABBCCDD
        mov     r1, r11
        str     r0, [r1]

        ldrb    r2, [r1]
        cmp     r2, 0xDD
        bne     f009

        ldrb    r2, [r1, 1]
        cmp     r2, 0xFF
        bne     f009

        ldrb    r2, [r1, 2]
        cmp     r2, 0xFF
        bne     f009

        ldrb    r2, [r1, 3]
        cmp     r2, 0xFF
        bne     f009

        b       eval

f009:
        m_exit  9

eval:
        m_vsync
        m_test_eval r12

idle:
        b       idle

include '../lib/text.asm'
