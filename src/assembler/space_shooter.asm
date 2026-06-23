

.data
.equ LEFT_ARROW_KEYCODE, 0x00
.equ RIGHT_ARROW_KEYCODE, 0x01
.equ UP_ARROW_KEYCODE, 0x02
.equ DOWN_ARROW_KEYCODE, 0x03
.equ SPACE_KEYCODE, 0x04

.equ AZUL, 0xFF0000FF
.equ PRETO, 0xFF000000
.equ BRANCO, 0xFFFFFFFF
.equ VERMELHO, 0xFFFF0000
.equ AMARELO, 0xFFFFDE33
.equ TRANSPARENTE, 0x00000000           


.equ MAX_BULLETS, 10
; Cada tiro usa 1 palavra (32 bits) em cada array
bullet_active: .space 10  ; 1 = ativo, 0 = livre para atirar
bullet_x:      .space 10  ; Posição X
bullet_y:      .space 10  ; Posição Y
bullet_counter: .var 0

enemy_counter: .var 0
enemy_x:      .space 10  ; Posição X
enemy_y:      .space 10  ; Posição Y
enemies_speed: .var 1
enemy_active: .space 5

player_x: .var 70
player_y: .var 200
movement_frame_counter: .var 0
enemy_frame_counter: .var 0
enemy_spawn_timeout: .var 3

msg: .string "WELCOME TO DOOMSHIP!"


black_ship_sprite:
.array 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0xFF000001, 0xFF010101, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0xFF000100, 0xFF000001, 0xFF010001, 0xFF010001, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0xFF000000, 0xFF000001, 0xFF010001, 0xFF000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0xFF010100, 0xFF010001, 0xFF010001, 0xFF010101, 0xFF010001, 0xFF000100, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0xFF000000, 0x00000000, 0xFF010101, 0xFF010000, 0xFF000000, 0xFF000001, 0xFF000100, 0xFF010001, 0xFF000100, 0xFF010000, 0x00000000, 0xFF000001, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0xFF000000, 0xFF010000, 0xFF010100, 0xFF010000, 0xFF010101, 0xFF010100, 0xFF000001, 0xFF010001, 0xFF000100, 0xFF000000, 0xFF010100, 0xFF010001, 0x00000000, 0x00000000, 0x00000000, 0xFF010000, 0xFF000000, 0xFF000000, 0xFF000001, 0xFF000100, 0xFF000001, 0xFF010100, 0xFF010100, 0xFF010100, 0xFF000000, 0xFF000000, 0xFF000000, 0xFF010000, 0xFF000001, 0x00000000, 0x00000000, 0xFF010001, 0xFF000000, 0xFF010100, 0xFF010000, 0xFF000001, 0xFF010101, 0xFF010100, 0xFF010001, 0xFF000000, 0xFF000101, 0xFF000100, 0xFF000001, 0xFF010001, 0xFF000101, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0xFF000001, 0xFF010001, 0xFF000101, 0xFF010100, 0xFF000000, 0xFF000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0xFF000100, 0xFF000000, 0xFF000000, 0xFF000000, 0xFF010101, 0xFF000101, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0xFF000001, 0xFF010000, 0xFF010100, 0xFF000001, 0xFF000000, 0xFF010101, 0xFF000101, 0xFF000001, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0xFF010101, 0xFF000000, 0xFF010001, 0xFF010101, 0xFF000101, 0xFF000100, 0xFF010000, 0xFF010001, 0xFF000001, 0xFF000100, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0xFF010001, 0xFF000101, 0xFF000001, 0xFF000000, 0xFF000001, 0xFF000100, 0xFF010100, 0xFF010000, 0xFF010000, 0xFF000101, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000

ship_sprite:
.array 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0xFF464747, 0xFF464646, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0xFF474747, 0xFFB4B4B5, 0xFFB5B4B4, 0xFF464646, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0xFF464746, 0xFF4C6CF2, 0xFF00B6EF, 0xFF474746, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0xFF474647, 0xFFB5B5B4, 0xFF4D6CF3, 0xFF4D6CF2, 0xFFB4B5B4, 0xFF474647, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0xFF474746, 0x00000000, 0xFFFF7F01, 0xFF474746, 0xFFB5B5B4, 0xFFB4B5B4, 0xFFB4B5B5, 0xFFB5B4B5, 0xFF464746, 0xFFFF7E01, 0x00000000, 0xFF464646, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0xFF464647, 0xFFFF7E01, 0xFFFEC20F, 0xFF474746, 0xFFB5B4B5, 0xFFB5B5B4, 0xFFB4B4B4, 0xFFB4B5B5, 0xFF464647, 0xFFFFC30E, 0xFFFF7F00, 0xFF474747, 0x00000000, 0x00000000, 0x00000000, 0xFF474747, 0xFFFE7E00, 0xFFFFC30E, 0xFFFEC20E, 0xFF464647, 0xFFB4B5B4, 0xFFB5B5B5, 0xFFB4B5B4, 0xFFB4B5B5, 0xFF474647, 0xFFFFC20E, 0xFFFFC30F, 0xFFFF7E01, 0xFF474746, 0x00000000, 0x00000000, 0xFFFE7E00, 0xFFFFC20F, 0xFFFEC30F, 0xFFFEC30E, 0xFF464747, 0xFFB5B4B4, 0xFFB5B5B5, 0xFFB5B4B4, 0xFFB4B4B5, 0xFF474746, 0xFFFFC30F, 0xFFFEC30F, 0xFFFFC30F, 0xFFFF7F00, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0xFF464746, 0xFFB4B5B5, 0xFFB4B5B5, 0xFFB5B5B4, 0xFFB5B4B4, 0xFF474746, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0xFF464746, 0xFF464646, 0xFFB5B4B4, 0xFFB4B5B4, 0xFF464747, 0xFF464647, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0xFF474746, 0xFFFEC30F, 0xFF464747, 0xFF464747, 0xFF464747, 0xFF464647, 0xFFFFC30F, 0xFF474746, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0xFF474646, 0xFFFEC20E, 0xFFFFC20F, 0xFFFFC30E, 0xFFFFC20E, 0xFFFEC30F, 0xFFFFC30E, 0xFFFFC30E, 0xFFFFC20F, 0xFF464646, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0xFF474646, 0xFF464647, 0xFF464646, 0xFF474747, 0xFF474646, 0xFF464647, 0xFF474746, 0xFF474647, 0xFF474746, 0xFF474647, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000

enemy_ship_sprite:
.array 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0xFF464746, 0xFF464646, 0xFF464646, 0xFF464747, 0xFF464647, 0xFF464746, 0xFF474646, 0xFF464647, 0xFF474746, 0xFF474747, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0xFF464746, 0xFF709AD0, 0xFF709AD1, 0xFF709AD1, 0xFF709BD1, 0xFF709AD1, 0xFF709AD1, 0xFF719BD0, 0xFF719BD1, 0xFF464746, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0xFF474647, 0xFF709AD0, 0xFF474647, 0xFF474646, 0xFF474647, 0xFF464747, 0xFF709BD0, 0xFF474647, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0xFF464647, 0xFF474746, 0xFF6F3099, 0xFF6E3198, 0xFF474647, 0xFF464746, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0xFF464647, 0xFF6E3198, 0xFF6E3098, 0xFF6E3198, 0xFF6F3099, 0xFF464746, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0xFF2E3799, 0xFF719BD1, 0xFF709AD0, 0xFF719BD0, 0xFF464746, 0xFF6E3198, 0xFF6F3098, 0xFF6F3099, 0xFF6F3098, 0xFF474647, 0xFF719AD1, 0xFF719AD1, 0xFF719AD1, 0xFF2E3798, 0x00000000, 0x00000000, 0xFF464647, 0xFF2F3799, 0xFF719BD1, 0xFF719BD0, 0xFF464646, 0xFFB4A5D4, 0xFFB5A4D4, 0xFF6E3198, 0xFF6F3099, 0xFF464746, 0xFF719AD0, 0xFF719AD1, 0xFF2E3798, 0xFF474646, 0x00000000, 0x00000000, 0x00000000, 0xFF464746, 0xFF2F3699, 0xFF719AD1, 0xFF464646, 0xFFB4A5D4, 0xFFB4A5D4, 0xFFB4A5D5, 0xFF6E3198, 0xFF474747, 0xFF719AD1, 0xFF2E3798, 0xFF464646, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0xFF474646, 0x00000000, 0xFF2E3698, 0xFF474746, 0xFFB5A4D4, 0xFFB5A5D5, 0xFFB5A5D5, 0xFF6E3098, 0xFF474646, 0xFF2F3698, 0x00000000, 0xFF464747, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0xFF474646, 0xFFB5A5D4, 0xFF4D6CF2, 0xFF4D6CF2, 0xFFB5A4D5, 0xFF464647, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0xFF474747, 0xFF01B7EF, 0xFF4C6CF2, 0xFF474747, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0xFF464746, 0xFFB5B5B4, 0xFFB4B4B4, 0xFF474647, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0xFF474647, 0xFF464647, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000

black_enemy_ship_sprite:
.array 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0xFF000001, 0xFF000100, 0xFF010001, 0xFF010001, 0xFF000101, 0xFF000101, 0xFF000100, 0xFF010100, 0xFF000001, 0xFF000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0xFF000100, 0xFF010001, 0xFF010100, 0xFF000100, 0xFF000000, 0xFF000101, 0xFF000000, 0xFF010101, 0xFF000100, 0xFF000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0xFF000101, 0xFF000000, 0xFF010001, 0xFF010101, 0xFF000101, 0xFF000100, 0xFF010100, 0xFF010000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0xFF010100, 0xFF000001, 0xFF000000, 0xFF010001, 0xFF010101, 0xFF000101, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0xFF000001, 0xFF010000, 0xFF000100, 0xFF000001, 0xFF000100, 0xFF000101, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0xFF000000, 0xFF010101, 0xFF000000, 0xFF000001, 0xFF010000, 0xFF010000, 0xFF000000, 0xFF000000, 0xFF000100, 0xFF000100, 0xFF000101, 0xFF000100, 0xFF000000, 0xFF000100, 0x00000000, 0x00000000, 0xFF010100, 0xFF000100, 0xFF010000, 0xFF010100, 0xFF010001, 0xFF010101, 0xFF000101, 0xFF010000, 0xFF000000, 0xFF000001, 0xFF010000, 0xFF000000, 0xFF000000, 0xFF010101, 0x00000000, 0x00000000, 0x00000000, 0xFF010001, 0xFF010001, 0xFF000100, 0xFF010001, 0xFF000101, 0xFF010000, 0xFF000001, 0xFF000001, 0xFF010001, 0xFF010000, 0xFF010000, 0xFF000100, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0xFF010100, 0x00000000, 0xFF010101, 0xFF000001, 0xFF000100, 0xFF010001, 0xFF010101, 0xFF000001, 0xFF010000, 0xFF010101, 0x00000000, 0xFF000001, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0xFF000100, 0xFF000100, 0xFF010100, 0xFF010000, 0xFF010001, 0xFF010101, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0xFF000100, 0xFF000101, 0xFF000101, 0xFF000001, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0xFF000001, 0xFF000100, 0xFF000101, 0xFF000100, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0xFF000000, 0xFF010000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000


.text
START:
    FRAMENUM R1
    SRAND R1

    
    MOVL R5, PRETO.l
    MOVH R5, PRETO.h
    ; BLACK BACKGROUND
    MOVL R1, 0   ; X
    MOVL R2, 0   ; Y
    MOVL R3, 320 ; W
    MOVL R4, 240 ; H
    RECT R1, R2, R3, R4, R5
    BEQ R0, R0, PLAY_INITIAL_MUSIC
    


    
    ; STARS GENERATOR 

    

    ;MOVL R9, 30         ; MAX STARS
    ;AND R1, R0, R0      ; STAR COUNTER = 0 

    ;LOOP_STAR:
        ;FRAMENUM R11
        ;SRAND R11
        ;MOVL R4, 1      ; MIN Y VALUE
        ;MOVL R5, 316    ; MAX X VALUE
        ;RAND R2, R4, R5 ; RANDOM X  FOR STAR 
        ;MOVL R5, 236    ; MAX Y VALUE 
        ;RAND R3, R4, R5 ; RANDOM Y  FOR STAR
        ;RECT R2, R3, R7, R7, R8
        ;ADDI R1, R1, 1
        ;BLT R1, R9, LOOP_STAR

PLAY_INITIAL_MUSIC:
    ; PLAY MUSIC
    MOVL R3, 1   ; waveform = square
    MOVL R4, 130    ; duração padrão

      
    ; MOVL R1, 82
    ; PLAY R1, R4, R3
    ; SLEEP R4
    

    ; MOVL R1, 82
    ; PLAY R1, R4, R3
    ; SLEEP R4

    ; MOVL R1, 165
    ; PLAY R1, R4, R3
    ; SLEEP R4

    ; MOVL R1, 82
    ; PLAY R1, R4, R3
    ; SLEEP R4

    ; MOVL R1, 82
    ; PLAY R1, R4, R3
    ; SLEEP R4

    ; MOVL R1, 147
    ; PLAY R1, R4, R3
    ; SLEEP R4

    ; MOVL R1, 82
    ; PLAY R1, R4, R3
    ; SLEEP R4

    ; MOVL R1, 82
    ; PLAY R1, R4, R3
    ; SLEEP R4

    ; MOVL R1, 131
    ; PLAY R1, R4, R3
    ; SLEEP R4

    ; MOVL R1, 82
    ; PLAY R1, R4, R3
    ; SLEEP R4

    ; MOVL R1, 82
    ; PLAY R1, R4, R3
    ; SLEEP R4

    ; MOVL R1, 117
    ; PLAY R1, R4, R3
    ; SLEEP R4

    ; MOVL R1, 82
    ; PLAY R1, R4, R3
    ; SLEEP R4

    ; MOVL R1, 82
    ; PLAY R1, R4, R3
    ; SLEEP R4

    ; MOVL R1, 123
    ; PLAY R1, R4, R3
    ; SLEEP R4

    ; MOVL R1, 131
    ; PLAY R1, R4, R3
    ; SLEEP R4

    ; MOVL R1, 82
    ; PLAY R1, R4, R3
    ; SLEEP R4

    ; MOVL R1, 82
    ; PLAY R1, R4, R3
    ; SLEEP R4

    ; MOVL R1, 165
    ; PLAY R1, R4, R3
    ; SLEEP R4

    ; MOVL R1, 82
    ; PLAY R1, R4, R3
    ; SLEEP R4

    ; MOVL R1, 82
    ; PLAY R1, R4, R3
    ; SLEEP R4

    ; MOVL R1, 147
    ; PLAY R1, R4, R3
    ; SLEEP R4

    ; MOVL R1, 82
    ; PLAY R1, R4, R3
    ; SLEEP R4

    ; MOVL R1, 82
    ; PLAY R1, R4, R3
    ; SLEEP R4

    ; MOVL R1, 131
    ; PLAY R1, R4, R3
    ; SLEEP R4

    ; MOVL R1, 82
    ; PLAY R1, R4, R3
    ; SLEEP R4

    ; MOVL R1, 82
    ; PLAY R1, R4, R3
    ; SLEEP R4

    ; MOVL R1, 117
    ; MOVL R4, 300
    ; PLAY R1, R4, R3


  
    BEQ R0, R0, DRAW_STARS_BACKGROUND

DRAW_STARS_BACKGROUND:
    MOVL R7, 2 ; STAR SIZE

    MOVL R8, BRANCO.l
    MOVH R8, BRANCO.h

    ; Linha superior
    MOVL R1, 10
    MOVL R2, 10
    RECT R1, R2, R7, R7, R8

    MOVL R1, 45
    MOVL R2, 25
    RECT R1, R2, R7, R7, R8

    MOVL R1, 80
    MOVL R2, 15
    RECT R1, R2, R7, R7, R8

    MOVL R1, 130
    MOVL R2, 35
    RECT R1, R2, R7, R7, R8

    MOVL R1, 180
    MOVL R2, 18
    RECT R1, R2, R7, R7, R8

    MOVL R1, 240
    MOVL R2, 40
    RECT R1, R2, R7, R7, R8

    MOVL R1, 300
    MOVL R2, 12
    RECT R1, R2, R7, R7, R8

    ; Linha do meio
    MOVL R1, 25
    MOVL R2, 70
    RECT R1, R2, R7, R7, R8

    MOVL R1, 90
    MOVL R2, 90
    RECT R1, R2, R7, R7, R8

    MOVL R1, 150
    MOVL R2, 75
    RECT R1, R2, R7, R7, R8

    MOVL R1, 210
    MOVL R2, 100
    RECT R1, R2, R7, R7, R8

    MOVL R1, 280
    MOVL R2, 65
    RECT R1, R2, R7, R7, R8

    ; Próximo ao horizonte
    MOVL R1, 40
    MOVL R2, 130
    RECT R1, R2, R7, R7, R8

    MOVL R1, 100
    MOVL R2, 145
    RECT R1, R2, R7, R7, R8

    MOVL R1, 170
    MOVL R2, 120
    RECT R1, R2, R7, R7, R8

    MOVL R1, 230
    MOVL R2, 150
    RECT R1, R2, R7, R7, R8

    MOVL R1, 295
    MOVL R2, 135
    RECT R1, R2, R7, R7, R8

    MOVL R5, 80            ; x = 160
    MOVL R6, 60            ; y = 120
    MOVL R7, msg.l          ; endereço da string (parte baixa)
    MOVH R7, msg.h          ; endereço da string (parte alta)
    MOVL R8, AZUL.l         ; color = branco (ARGB)
    MOVH R8, AZUL.h         ; color = branco (ARGB)
    PSTR R5, R6, R7, R8 

    MOVL R3, 4
    ; SYSCALL R3, R0,R0,R0,R0

    
    AND R1, R0, R0      ; Enemy index = 0
    MOVL R3, enemy_active.l
    MOVH R3, enemy_active.h


    DRAW_ENEMIES:
        LOAD R4, R3, 0                  ; Verifica se o inimigo atual está ativo
        BEQ R4, R0, NEXT_ENEMY_DRAW     ; Se 0 (inativo), pula para o próximo

        ; --- CÁLCULO DE OFFSET EM BYTES --- 
        MOVL R10, 2
        SHL R9, R1, R10                 ; R9 = R1 << 2 (offset)

        ; --- CARREGAR POSIÇÕES X e Y ---
        MOVL R11, enemy_x.l
        MOVH R11, enemy_x.h
        ADD R11, R11, R9                
        LOAD R5, R11, 0                 ; R5 = Posição X 

        MOVL R11, enemy_y.l
        MOVH R11, enemy_y.h
        ADD R11, R11, R9                
        LOAD R6, R11, 0                 ; R6 = Posição Y 


        ; APAGAR RASTRO DO INIMIGO 

        MOVL R7, 16                     ; Largura (W)
        MOVL R12, black_enemy_ship_sprite.l
        MOVH R12, black_enemy_ship_sprite.h
        DSPRITE R5, R6, R7, R7, R12       ; Desenha na nova coordenada

        ; ATUALIZAR POSIÇÃO Y (Descer) 
        MOVL R12, 1                    ; Velocidade do inimigo: desce 1 pixel por frame
        ADD R6, R6, R12                 
        STORE R6, R11, 0                ; Salva a nova posição Y na memória

        ; VERIFICAR LIMITE DA TELA 
        MOVL R12, 240                   ; Altura máxima da tela
        BGE R6, R12, DEACTIVATE_ENEMY   ; Se passou do fundo, desativa


        ;; DETECT COLLISION WITH BULLETS

        DETECT_COLISION:
            ; Registradores qu não posso usar:
            ; R1 = Index inimigo
            ; R3 = Endereço active
            ; R5 = enemy_x, 
            ; R6 = enemy_y

            AND R2, R0, R0                  ; R2 = Bullet index = 0
            MOVL R4, bullet_active.l        ; R4 = Ponteiro base das balas ativas
            MOVH R4, bullet_active.h

        BULLET_CALC:
            LOAD R8, R4, 0                  ; Verifica se o tiro atual está ativo
            BEQ R8, R0, NEXT_BULLET_VER     ; Se inativo, pula

            ; CÁLCULO DE OFFSET EM BYTES (R2 * 4)
            MOVL R10, 2
            SHL R9, R2, R10                 ; R9 = R2 << 2 (offset)

            ; CARREGAR POSIÇÃO X DO TIRO
            MOVL R11, bullet_x.l
            MOVH R11, bullet_x.h
            ADD R11, R11, R9                
            LOAD R8, R11, 0                 ; R8 = Posição X da bala
            ADDI R8, R8, 7                  ; Centraliza o tiro 

            ; CARREGAR POSIÇÃO Y DO TIRO 
            MOVL R11, bullet_y.l
            MOVH R11, bullet_y.h
            ADD R11, R11, R9                
            LOAD R12, R11, 0                ; R12 = Posição Y da bala (Protegendo R6!)

            ;; LÓGICA DE COLISÃO  
            ; CONDIÇÕES DE NÃO COLISÃO

            ; bullet_x >= enemy_x + enemy_width (16)
            MOVL R10, 16
            ADD R11, R5, R10                ; R11 = enemy_x + 16
            BGE R8, R11, NEXT_BULLET_VER

            ; enemy_x >= bullet_x + bullet_width (2)
            MOVL R10, 2
            ADD R11, R8, R10                ; R11 = bullet_x + 2
            BGE R5, R11, NEXT_BULLET_VER

            ; bullet_y >= enemy_y + enemy_height (16)
            MOVL R10, 16
            ADD R11, R6, R10                ; R11 = enemy_y + 16
            BGE R12, R11, NEXT_BULLET_VER

            ; enemy_y >= bullet_y + bullet_height (6)
            MOVL R10, 6
            ADD R11, R12, R10               ; R11 = bullet_y + 6
            BGE R6, R11, NEXT_BULLET_VER

            ;; TIRO COLIDIU
            
            ; APAGA O TIRO
            MOVL R10, 2                     ; W do tiro
            MOVL R11, 6                     ; H do tiro
            MOVL R13, PRETO.l
            MOVH R13, PRETO.h
            RECT R8, R12, R10, R11, R13

            ; APAGA O INIMIGO
            MOVL R10, 16                    ; W/H do inimigo
            RECT R5, R6, R10, R10, R13

            ; Desativa as entidades na memória
            STORE R0, R4, 0                 ; bullet_active[i] = 0
            STORE R0, R3, 0                 ; enemy_active[i] = 0

            ; Inimigo abatido, sem necessidade de verificar mais
            BEQ R0, R0, NEXT_ENEMY_DRAW

        NEXT_BULLET_VER:
            ADDI R4, R4, 4                  ; Avança o ponteiro bullet_active
            INC R2                          ; Incrementa índice do tiro
            
            MOVL R7, 10                     ; MAX_BULLETS
            BGE R2, R7, DRAW_ENEMY_SHIP     ; Não houve colisão, desenha
            BEQ R0, R0, BULLET_CALC

        DRAW_ENEMY_SHIP:
            MOVL R7, 16                     ; Largura (W) e Altura (H)
            MOVL R12, enemy_ship_sprite.l
            MOVH R12, enemy_ship_sprite.h
            DSPRITE R5, R6, R7, R7, R12 

            BEQ R0, R0, NEXT_ENEMY_DRAW

        DEACTIVATE_ENEMY:
            STORE R0, R3, 0                 ; Libera o slot do inimigo

        NEXT_ENEMY_DRAW:
            ADDI R3, R3, 4                  
            INC R1                          

            MOVL R7, 5                      ; Limite de 5 inimigos
            BGE R1, R7, FINISHED_ENEMY_DRAW 

            BEQ R0, R0, DRAW_ENEMIES
    FINISHED_ENEMY_DRAW:
        AND R1, R0, R0      ; Bullet index = 0
        MOVL R3, bullet_active.l
        MOVH R3, bullet_active.h

    
    DRAW_BULLETS:
        LOAD R4, R3, 0                  ; Verifica se o tiro atual está ativo
        BEQ R4, R0, NEXT_BULLET_DRAW    ; Se 0 (inativo), pula para o próximo

        ; CÁLCULO DE OFFSET EM BYTES (R1 * 4) 
        MOVL R10, 2
        SHL R9, R1, R10                 ; R9 = R1 << 2 (offset)

        ; CARREGAR POSIÇÃO X DO TIRO
        MOVL R11, bullet_x.l
        MOVH R11, bullet_x.h
        ADD R11, R11, R9                ; Base X + offset
        LOAD R5, R11, 0                 ; R5 = Posição X da bala
        ADDI R5, R5, 7                  ; Centraliza o tiro em relação à nave

        ; CARREGAR E ATUALIZAR POSIÇÃO Y DO TIRO
        MOVL R11, bullet_y.l
        MOVH R11, bullet_y.h
        ADD R11, R11, R9                ; Base Y + offset
        LOAD R6, R11, 0                 ; R6 = Posição Y atual

        ; APAGAR TIRO ANTERIOR
        MOVL R7, 2                      ; Largura (W)
        MOVL R8, 6                      ; Altura (H)
        MOVL R12, PRETO.l               
        MOVH R12, PRETO.h
        RECT R5, R6, R7, R8, R12        

        ; ATUALIZAR POSIÇÃO Y 
        MOVL R12, 2                     ; Velocidade do projétil: sobe 2 pixels por frame
        SUB R6, R6, R12                 
        STORE R6, R11, 0                ; Salva a nova posição Y na memória

        ; LIMITE DA TELA
        ; Se Y <= 0, desvia para a rotina de desativação
        BLE R6, R0, DEACTIVATE_BULLET 

        ; DESENHAR O NOVO PROJÉTIL
        MOVL R12, VERMELHO.l            ; Cor do laser
        MOVH R12, VERMELHO.h
        RECT R5, R6, R7, R8, R12        
        BEQ R0, R0, NEXT_BULLET_DRAW    ; Pula a desativação e vai para a próxima

    DEACTIVATE_BULLET:
        ; O tiro saiu da tela. Liberamos o slot definindo bullet_active[i] = 0
        ; R3 ainda aponta para o endereço no array
        STORE R0, R3, 0

    NEXT_BULLET_DRAW:
        ADDI R3, R3, 4                  ; Avança para o próximo endereço de bullet_active
        INC R1                          ; Incrementa o contador de índice

        ; Verifica se já iterou por todas as balas
        MOVL R7, 10                     ; Carrega o valor de MAX_BULLETS diretamente
        BGE R1, R7, GAME                ; Se i >= 10, encerra o loop de desenho e vai para GAME

        BEQ R0, R0, DRAW_BULLETS        ; Retorna para desenhar a próxima bala
    


GAME:


    ; CLEAN FRAME COUNTER FOR NEXT FRAME
    MOVL R1, 10        
    MOVL R2, 10          
    MOVL R3, 48
    MOVL R4, 16  
    MOVL R5, PRETO.l         
    MOVH R5, PRETO.h         
    RECT R1, R2, R3, R4, R5

    ; FRAME COUNTER
    FRAMENUM R4
    MOVL R1, 10
    MOVL R2, 10
    MOVL R3, AMARELO.l       
    MOVH R3, AMARELO.h         
    PINT R1, R2, R4, R3



    ; ENEMIES LOGIC

    MOVL R4, enemy_frame_counter.l
    MOVH R4, enemy_frame_counter.h
    LOAD R3, R4, 0       ; R3 = Guarda o último frame em que um inimigo apareceu
    FRAMENUM R5          ; R5 = Pega o frame atual do relógio
    
    SUB R6, R5, R3       ; CORRIGIDO: Calcula tempo decorrido (R5 - R3)
    
    MOVL R7, 120         ; 120 frames (2 segundos)
    BLT R6, R7, DEPOIS   ; Se não deu o tempo, foge para o fim da lógica

    
    ; Atualiza o relógio do spawn com o frame atual:
    STORE R5, R4, 0

    AND R1, R0, R0                  ; R1 = Index counter (0 a 4)
    MOVL R3, enemy_active.l
    MOVH R3, enemy_active.h
    MOVL R12, 5                     ; R12 = MAX_ENEMIES
    MOVL R8, 4

    FIND_ENEMY_INDEX:
        LOAD R4, R3, 0          
        BEQ R4, R0, INACTIVE_ENEMY_FOUND ; Found an inactive enemy

        ADDI R3, R3, 4                  ; Advance to the next active enemy address
        INC R1                          ; Next index
        
        BLT R1, R12, FIND_ENEMY_INDEX  ; If i < 10, keep searching
        BEQ R0, R0, DEPOIS         ; If no inactive enemy found, proceed

        INACTIVE_ENEMY_FOUND:
            MOVL R12, 1500                    ; 15 frames de cooldown (Trava o tiro por 1/4 de segundo)
            MOVL R11, enemy_counter.l
            MOVH R11, enemy_counter.h
            STORE R12, R11, 0               ; Ativa cooldown para o próximo tiro

            ; Ativa o inimigo na memória (R3 já aponta para enemy_active[i])
            MOVL R4, 1
            STORE R4, R3, 0
            ; O índice original está em R1. calcular o offset em bytes (R1 * 4)
            MOVL R10, 2
            SHL R9, R1, R10                 ; R9 = R1 << 2  (Equivalente a R1 * 4)


            ; RANDOM X POSITION FOR ENEMY
            MOVL R6, 1                      ; Valor mínimo de X
            MOVL R8, 300                    ; Valor máximo de X (320 da tela - 20 de largura)
            RAND R7, R6, R8                 ; R7 = Random X position for enemy    

            ; RANDOM y POSITION FOR ENEMY
            ; MOVL R6, 0
            ; MOVL R7, 310
            ; RAND R10, R6, R7                 ; R10 = Random y position for enemy        
            AND R10, R0, R0                  ; R10 = 0 Enemy will spawn at the top of the screen


            ; SALVAR EM bullet_x[i] 
            MOVL R11, enemy_x.l
            MOVH R11, enemy_x.h
            ADD R11, R11, R9                ; Endereço = base de enemy_x + offset
            MOVL R12, 4
            STORE R7, R11, 0                ; Mem[enemy_x + (i*4)] = player_x

            ; SALVAR EM enemy_y[i]
            MOVL R11, enemy_y.l
            MOVH R11, enemy_y.h
            ADD R11, R11, R9                ; Endereço = base de enemy_y + offset
            STORE R10, R11, 0               ; Mem[enemy_y + (i*4)] = player_y
            BEQ R0, R0, DEPOIS         ; Retorna ao fluxo de movimento

    
    ; ;;
    ; MOVL R5, 50
    ; MOVL R7, 20                      ; Largura (W)
    ; MOVL R8, 10                      ; Altura (H)
    ; MOVL R12, BRANCO.l               ; 
    ; MOVH R12, BRANCO.h
    ; RECT R5, R6, R7, R8, R12


    DEPOIS:



    ; FPS SYNC
    MOVL R4, movement_frame_counter.l
    MOVH R4, movement_frame_counter.h
    LOAD R3, R4, 0       ; R3 = Guarda o último frame em que a nave se moveu
    FRAMENUM R5          ; R5 = Pega o frame atual do relógio
    BEQ R3, R5, GAME     ; Se o frame for igual, volta pro começo (espera!)

    ; Se passou do BEQ, significa que o frame mudou (1/60 de segundo se passou!)
    STORE R5, R4, 0      ; Atualiza o movement_frame_counter com o novo frame

    MANAGE_COOLDOWN:
        MOVL R11, bullet_counter.l
        MOVH R11, bullet_counter.h
        LOAD R12, R11, 0
        BEQ R12, R0, SPACE_KEY_INPUT    ; Se o cooldown for 0, pronto pra atirar
        DEC R12                         ; Se for maior que 0, espera 1 frame
        STORE R12, R11, 0
        BEQ R0, R0, MOVE_PLAYER         ; Ignora até cooldown terminar

    SPACE_KEY_INPUT:
        MOVL R3, SPACE_KEYCODE 
        GKEY R4, R3
        BEQ R4, R0, MOVE_PLAYER ; Se a barra de espaço não estiver pressionada, move o player normalmente

        
        AND R1, R0, R0                  ; R1 = Contador de índice (0 a 9)
        MOVL R3, bullet_active.l
        MOVH R3, bullet_active.h
        MOVL R12, 10                    ; R12 = MAX_BULLETS
        
    FIND_BULLET_INDEX:
        LOAD R4, R3, 0          
        BEQ R4, R0, INACTIVE_BULLET_FOUND ; Achou uma livre

        ADDI R3, R3, 4                  ; Avança endereço do active
        INC R1                          ; Próximo índice
        
        BLT R1, R12, FIND_BULLET_INDEX  ; Se i < 10, continua procurando
        BEQ R0, R0, MOVE_PLAYER         ; Se não achou nenhuma, sai

        INACTIVE_BULLET_FOUND:
            MOVL R12, 5                    ; 15 frames de cooldown (Trava o tiro por 1/4 de segundo)
            MOVL R11, bullet_counter.l
            MOVH R11, bullet_counter.h
            STORE R12, R11, 0               ; Ativa cooldown para o próximo tiro

            ; Ativa a bala na memória (R3 já aponta para bullet_active[i])
            MOVL R4, 1
            STORE R4, R3, 0

            ; O índice original está em R1. calcular o offset em bytes (R1 * 4)
            MOVL R10, 2
            SHL R9, R1, R10                 ; R9 = R1 << 2  (Equivalente a R1 * 4)

            ; POSIÇÃO ATUAL DO JOGADOR
            MOVL R6, player_x.l
            MOVH R6, player_x.h
            LOAD R7, R6, 0                  ; R7 = valor de player_x

            MOVL R8, player_y.l
            MOVH R8, player_y.h
            LOAD R10, R8, 0                 ; R10 = valor de player_y

            ; SALVAR EM bullet_x[i] 
            MOVL R11, bullet_x.l
            MOVH R11, bullet_x.h
            ADD R11, R11, R9                ; Endereço = base de bullet_x + offset
            STORE R7, R11, 0                ; Mem[bullet_x + (i*4)] = player_x

            ; SALVAR EM bullet_y[i]
            MOVL R11, bullet_y.l
            MOVH R11, bullet_y.h
            ADD R11, R11, R9                ; Endereço = base de bullet_y + offset
            STORE R10, R11, 0               ; Mem[bullet_y + (i*4)] = player_y

            BEQ R0, R0, MOVE_PLAYER         ; Retorna ao fluxo de movimento


    MOVE_PLAYER:
        ;; PLAYER POSITION 
        MOVL R6, player_x.l
        MOVH R6, player_x.h
        LOAD R1, R6, 0

        MOVL R7, player_y.l
        MOVH R7, player_y.h
        LOAD R2, R7, 0

        ;; Clean old ship
        MOVL R3, 16
        MOVL R5, black_ship_sprite.l
        MOVH R5, black_ship_sprite.h
        DSPRITE R1, R2, R3, R3, R5     

        

        LEFT_ARROW: 
            MOVL R3, LEFT_ARROW_KEYCODE
            GKEY R4, R3
            BEQ R4, R0, RIGHT_ARROW
            ; LEFET LIMIT 
            BEQ R1, R0, RIGHT_ARROW
            DEC R1

        RIGHT_ARROW: 
            MOVL R3, RIGHT_ARROW_KEYCODE
            GKEY R4, R3
            BEQ R4, R0, UP_ARROW
            ; RIGHT LIMIT 
            MOVL R8, 304
            BGE R1, R8, UP_ARROW
            INC R1

        UP_ARROW: 
            MOVL R3, UP_ARROW_KEYCODE
            GKEY R4, R3
            BEQ R4, R0, DOWN_ARROW
            ; UP LIMIT 
            BEQ R2, R0, DOWN_ARROW
            DEC R2

        DOWN_ARROW: 
            MOVL R3, DOWN_ARROW_KEYCODE
            GKEY R4, R3
            BEQ R4, R0, DRAW_SPACE_SHIP
            ; DOWN LIMIT
            MOVL R8, 224
            BGE R2, R8, DRAW_SPACE_SHIP
            INC R2

        DRAW_SPACE_SHIP: 
            STORE R1, R6, 0
            STORE R2, R7, 0 
            
            ; DRAW SPACE SHIP
            MOVL R3, 16
            MOVL R4, 16
            MOVL R5, ship_sprite.l
            MOVH R5, ship_sprite.h
            DSPRITE R1, R2, R3, R4, R5       ; Desenha na nova coordenada
        
    BEQ R0, R0, DRAW_STARS_BACKGROUND ; infinite loop


