def FREE_SPACE                equ $7f80
def TETROMINO_HEIGHT          equ $af81
def TETROMINO_SPRITE_Y        equ $ff9d
def GHOST_PALETTE             equ 7
def GHOST_TILE                equ $0d
def BIT_BUTTON_UP             equ 6
def BIT_BUTTON_DOWN           equ 7
def FUN_DRAW_TETROMINO        equ $05b5
def FUN_COLLISION_DETECTION   equ $5932

IF ENABLE_GHOST == 1
SECTION "tetromino", ROMX[$421e], BANK[1]
        call    draw_ghost_tetromino
ENDC

SECTION "down_press", ROMX[$5780], BANK[1]
        jp      check_for_up_press
        nop

SECTION "code", ROMX[FREE_SPACE], BANK[1]
check_for_up_press::
        bit     BIT_BUTTON_UP, a
        jr      z, .check_for_down_press
        call    initiate_harddrop
        jp      $578e
.check_for_down_press
        bit     BIT_BUTTON_DOWN, a
        jp      z, $57c1
        jp      $5784

initiate_harddrop::
.loop
        ld      hl, TETROMINO_HEIGHT
        inc     [hl]
        call    FUN_COLLISION_DETECTION
        and     a
        jr      nz, .loop
        ret

IF ENABLE_GHOST == 1
draw_ghost_tetromino::
        push    de
        ; replace original instruction
        call    FUN_DRAW_TETROMINO
.determine_ghost_tetromino_height
        ld      a, [TETROMINO_HEIGHT]
        push    af
        call    initiate_harddrop
        ld      a, [TETROMINO_HEIGHT]
        ld      h, a
        pop     af
        ld      [TETROMINO_HEIGHT], a
        ld      b, a
        ld      a, h
.add_distance_to_active_tetromino_sprite
        sub     b
        dec     a
        sla     a
        sla     a
        sla     a
        dec     a
        ld      b, a
        pop     de
        ldh     a, [TETROMINO_SPRITE_Y]
        add     b
        ldh     [TETROMINO_SPRITE_Y], a
        call    FUN_DRAW_TETROMINO
.set_palette
        ld      a, GHOST_PALETTE
        ld      [$c013+$00], a
        ld      [$c013+$04], a
        ld      [$c013+$08], a
        ld      [$c013+$0c], a
.set_ghost_tile
IF GHOST_COLOR_DARK == 0
        ld      a, GHOST_TILE
        ld      [$c012+$00], a
        ld      [$c012+$04], a
        ld      [$c012+$08], a
        ld      [$c012+$0c], a
ENDC
        ret
ENDC
