FREE_SPACE              equ     $7f80
PIECE_HEIGHT            equ     $af81
COLLISION_DETECTION     equ     $5932
BIT_BUTTON_UP           equ     6
BIT_BUTTON_DOWN         equ     7


SECTION "down_press", ROMX[$5780], BANK[1]
        jp      check_for_up_press
        nop

SECTION "code", ROMX[FREE_SPACE], BANK[1]
check_for_up_press::
        bit     BIT_BUTTON_UP, a
        jr      z, .check_for_down_press
.harddrop_loop
        ld      hl, PIECE_HEIGHT
        inc     [hl]
        call    COLLISION_DETECTION
        and     a
        jr      nz, .harddrop_loop
        jp      $578e
.check_for_down_press
        bit     BIT_BUTTON_DOWN, a
        jp      z, $57c1
        jp      $5784
