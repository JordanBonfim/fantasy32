.data
.equ SPACE_KEYCODE, 0x04
.equ A_KEYCODE, 0x08
.equ S_KEYCODE, 0x09
.equ D_KEYCODE, 0x0A
.equ W_KEYCODE, 0x0B
.equ BRANCO, 0xFFFFFFFF
.equ PRETO, 0xFF000000
.equ VERDE, 0xFF6abe30
.equ AZUL, 0xFF1835E5
.equ VERMELHO, 0xFFac3232
.equ BLOCK_W, 16
.equ BLOCK_H, 16
.equ START_X, 19
.equ START_Y, 8
.equ ROW_N, 14
.equ COLL_N, 10
.equ MATRIZ_S, 140
IS_PRESSED: .var 0
ROTATION: .var 0
MATRIZ: .space[140]

; Controla a quantidade de frames até a peça sofrer gravidade
; ou seja, é invercamente proporcional a velocidade de queda
.equ FRAMES_FALL, 20

msg: .string "Pressione ESPACO para COMECAR..."

.text

; Aqui é desenhar o layout básico usando apenas retângulos.
START:
    ; Limpa a tela
    MOVL R6, PRETO.l         ; color = preto (parte baixa)
    MOVH R6, PRETO.h         ; color = preto (parte alta)
    CLEAR R1

    ; Desenha 4 retângulos azuis para formar aonde as peças vão ficar
    MOVL R5, AZUL.l         ; color = azul (parte baixa)
    MOVH R5, AZUL.h         ; color = azul (parte alta)
    
    MOVL R1, 13
    MOVL R2, 2
    MOVL R3, 171
    MOVL R4, 4
    RECT R1, R2, R3, R4, R5 ; linha superior
    
    MOVL R3, 4
    MOVL R4, 235
    RECT R1, R2, R3, R4, R5 ; linha esquerda
    
    MOVL R1, 181
    MOVL R2, 2
    RECT R1, R2, R3, R4, R5 ; linha direita

    MOVL R1, 13
    MOVL R2, 234
    MOVL R3, 172
    MOVL R4, 4
    RECT R1, R2, R3, R4, R5 ; linha INFERIOR


    ; inicar a matriz com PRETOS
    MOVL R1, ROW_N
    MOVL R2, COLL_N
    MUL R3, R1, R2
    MOVL R1, 0 ; contador
    MOVL R2, MATRIZ.l
    MOVH R2, MATRIZ.h
    MOVL R7, 2

    FILL:
    BGT R1, R3, END_FILL
        SHL R4, R1, R7
        ADD R4, R2, R4
        STORE R6, R4, 0
        INC R1
        JMP FILL
    END_FILL:


    ; Peça inicial é um l
    CALL DRAW_L
    CALL DRAW_MATRIZ

    MOVL R4, 0 ; grande contador de frames
    PUSH R4 ; proteje o contador de frames para ele não ser perdido

RUN:
    CALL CLEAR_OLD          ; apaga posição atual da MATRIZ

    ; input
    MOVL R2, A_KEYCODE
    GKEY R1, R2
    BNE R1, R0, PRESSED_A

    MOVL R2, W_KEYCODE
    GKEY R1, R2
    BNE R1, R0, PRESSED_W

    MOVL R2, D_KEYCODE
    GKEY R1, R2
    BNE R1, R0, PRESSED_D

    JMP NOTHING_PRESSED

    PRESSED_A:
        MOVL R1, IS_PRESSED.l ; se no  ultimo frame ele já tinha apertado a tecla, não iremos computar o input, sem segurar a tecla bobão
        MOVH R1, IS_PRESSED.h
        LOAD R3, R1, 0
        BNE R3, R0, AFTER_INPUT
        MOVL R2, 1
        STORE R2, R1, 0
        CALL MOVE_LEFT
        JMP AFTER_INPUT

    PRESSED_D:
        MOVL R1, IS_PRESSED.l
        MOVH R1, IS_PRESSED.h
        LOAD R3, R1, 0
        BNE R3, R0, AFTER_INPUT
        MOVL R2, 1
        STORE R2, R1, 0
        CALL MOVE_RIGHT
        JMP AFTER_INPUT
    
    PRESSED_W: ; Rotação
        MOVL R1, IS_PRESSED.l
        MOVH R1, IS_PRESSED.h
        LOAD R3, R1, 0
        BNE R3, R0, AFTER_INPUT
        MOVL R2, 1
        STORE R2, R1, 0
        CALL ROTATE_PIECE
        JMP AFTER_INPUT
    
    NOTHING_PRESSED: ; Nenhum botão foi pressionado, pode resetar o nosso mano
        MOVL R1, IS_PRESSED.l
        MOVH R1, IS_PRESSED.h
        STORE R0, R1, 0
    
    AFTER_INPUT:

    ; gravidade ------------------------------------------------
    POP R4
    INC R4
    MOVL R5, FRAMES_FALL
    BLT R4, R5, SKIP_FALL

        MOVL R4, 0
        PUSH R4
        MOVL R1, COLL_N
        ADD R9,  R9,  R1
        ADD R10, R10, R1
        ADD R11, R11, R1
        ADD R12, R12, R1

        MOVL R1, 139
        BGT R9,  R1, COLISION_INF
        BGT R10, R1, COLISION_INF
        BGT R11, R1, COLISION_INF
        BGT R12, R1, COLISION_INF

        MOVL R3, PRETO.l
        MOVH R3, PRETO.h
        MOVL R4, MATRIZ.l
        MOVH R4, MATRIZ.h
        MOVL R2, 2

        ; Verifica célula 1
        SHL R1, R9, R2
        ADD R1, R1, R4
        LOAD R5, R1, 0
        BNE R5, R3, COLISION_INF   ; colisão 

        ; Verifica célula 2
        SHL R1, R10, R2
        ADD R1, R1, R4
        LOAD R5, R1, 0
        BNE R5, R3, COLISION_INF

        ; Verifica célula 3
        SHL R1, R11, R2
        ADD R1, R1, R4
        LOAD R5, R1, 0
        BNE R5, R3, COLISION_INF

        ; Verifica célula 4
        SHL R1, R12, R2
        ADD R1, R1, R4
        LOAD R5, R1, 0
        BNE R5, R3, COLISION_INF

        ; Nenhuma colisão
        SHL R1, R9, R2
        ADD R1, R1, R4
        STORE R13, R1, 0

        SHL R1, R10, R2
        ADD R1, R1, R4
        STORE R13, R1, 0

        SHL R1, R11, R2
        ADD R1, R1, R4
        STORE R13, R1, 0

        SHL R1, R12, R2
        ADD R1, R1, R4
        STORE R13, R1, 0

    SKIP_FALL:
    PUSH R4
    ; salva posição atual (movimento horizontal pode ter mudado)
    CALL SAVE_POS

    ; desenha, dorme, próximo frame
    CALL DRAW_MATRIZ
    MOVL R3, 16
    SLEEP R3
    JMP RUN

; recebe posições de r9 até r12 e faz tudo ir para direita. Segura em relação ao limite da MATRIZ
MOVE_RIGHT:
    MOVL R8, 1          ; <-- guarda o "1" em R8, que não será sobrescrito
    MOVL R2, COLL_N

    DIV R3, R9,  R2
    DIV R4, R10, R2
    DIV R5, R11, R2
    DIV R6, R12, R2

    ADD R9,  R9,  R8
    ADD R10, R10, R8
    ADD R11, R11, R8
    ADD R12, R12, R8

    DIV R7, R9,  R2
    BNE R3, R7, COLISION_RIGHT
    DIV R7, R10, R2
    BNE R4, R7, COLISION_RIGHT
    DIV R7, R11, R2
    BNE R5, R7, COLISION_RIGHT
    DIV R7, R12, R2
    BNE R6, R7, COLISION_RIGHT

    ; verifica se as posições novas estão vazias
    MOVL R2, 2
    MOVL R3, PRETO.l
    MOVH R3, PRETO.h
    MOVL R4, MATRIZ.l
    MOVH R4, MATRIZ.h

    SHL R1, R9,  R2
    ADD R1, R1, R4
    LOAD R5, R1, 0
    BNE R5, R3, COLISION_RIGHT

    SHL R1, R10, R2
    ADD R1, R1, R4
    LOAD R5, R1, 0
    BNE R5, R3, COLISION_RIGHT

    SHL R1, R11, R2
    ADD R1, R1, R4
    LOAD R5, R1, 0
    BNE R5, R3, COLISION_RIGHT

    SHL R1, R12, R2
    ADD R1, R1, R4
    LOAD R5, R1, 0
    BNE R5, R3, COLISION_RIGHT

    RET

    COLISION_RIGHT:
        SUB R9,  R9,  R8   
        SUB R10, R10, R8
        SUB R11, R11, R8
        SUB R12, R12, R8
        RET

MOVE_LEFT:
    MOVL R8, 1          ; guarda o "1" em R8
    MOVL R2, COLL_N

    ; salva as linhas ANTES de mover
    DIV R3, R9,  R2
    DIV R4, R10, R2
    DIV R5, R11, R2
    DIV R6, R12, R2

    ; move todos
    SUB R9,  R9,  R8
    SUB R10, R10, R8
    SUB R11, R11, R8
    SUB R12, R12, R8

    ; verifica se cruzou a borda
    DIV R7, R9,  R2
    BNE R3, R7, COLISION_LEFT
    DIV R7, R10, R2
    BNE R4, R7, COLISION_LEFT
    DIV R7, R11, R2
    BNE R5, R7, COLISION_LEFT
    DIV R7, R12, R2
    BNE R6, R7, COLISION_LEFT

    ; verifica se as posições novas estão vazias
    MOVL R2, 2
    MOVL R3, PRETO.l
    MOVH R3, PRETO.h
    MOVL R4, MATRIZ.l
    MOVH R4, MATRIZ.h

    SHL R1, R9,  R2
    ADD R1, R1, R4
    LOAD R5, R1, 0
    BNE R5, R3, COLISION_LEFT

    SHL R1, R10, R2
    ADD R1, R1, R4
    LOAD R5, R1, 0
    BNE R5, R3, COLISION_LEFT

    SHL R1, R11, R2
    ADD R1, R1, R4
    LOAD R5, R1, 0
    BNE R5, R3, COLISION_LEFT

    SHL R1, R12, R2
    ADD R1, R1, R4
    LOAD R5, R1, 0
    BNE R5, R3, COLISION_LEFT

    RET

    COLISION_LEFT:
        ADD R9,  R9,  R8    ; R8 continua valendo 1
        ADD R10, R10, R8
        ADD R11, R11, R8
        ADD R12, R12, R8
        RET

; recebe posições de r9 até r12 e r13 deve ser a cor
COLISION_INF:
    MOVL R3, COLL_N
    SUB R9,  R9,  R3
    SUB R10, R10, R3
    SUB R11, R11, R3
    SUB R12, R12, R3

    CALL SAVE_POS
    CALL DRAW_L     ; spawna nova peça (já salva posição nos registradores)

    MOVL R4, 0      ; reseta contador de frames para a nova peça ter tempo de cair

    JMP SKIP_FALL   ; pula direto pro desenho, sem tentar cair nesse mesmo fr

; recebe posições de r9 até r12 e r13 deve ser a cor
SAVE_POS:

    MOVL R2, MATRIZ.l
    MOVH R2, MATRIZ.h

    MOVL R3, 2
    SHL R4, R9, R3
    ADD R1, R4, R2
    STORE R13, R1, 0
    
    SHL R4, R10, R3
    ADD R1, R4, R2
    STORE R13, R1, 0
    
    SHL R4, R11, R3
    ADD R1, R4, R2
    STORE R13, R1, 0

    SHL R4, R12, R3
    ADD R1, R4, R2
    STORE R13, R1, 0
    RET

; recebe posições de r9 até r12 e faz tudo ficar preto
CLEAR_OLD:
    MOVL R5, PRETO.l
    MOVH R5, PRETO.h
    MOVL R2, MATRIZ.l
    MOVH R2, MATRIZ.h

    MOVL R3, 2
    SHL R4, R9, R3
    ADD R1, R4, R2
    STORE R5, R1, 0
    
    SHL R4, R10, R3
    ADD R1, R4, R2
    STORE R5, R1, 0
    
    SHL R4, R11, R3
    ADD R1, R4, R2
    STORE R5, R1, 0

    SHL R4, R12, R3
    ADD R1, R4, R2
    STORE R5, R1, 0
    RET

; define posições de r9 até r12 e r13 deve ser a cor
DRAW_L:
    MOVL R9,  4
    MOVL R10, 14 ; pivo eterno :)
    MOVL R11, 24
    MOVL R12, 25
    MOVL R13, VERMELHO.l
    MOVH R13, VERMELHO.h

    CALL SAVE_POS

    RET

; le o vetor MATRIZ e desenha ele na tela. versão Segura para Ri >= R9
DRAW_MATRIZ:
    POP R1
    ; faz store dos registradores mágicos antes de seguir na função
    PUSH R9
    PUSH R10
    PUSH R11
    PUSH R12
    PUSH R13

    MOVL R2, MATRIZ_S        ; TAMANHO TOTAL DA MATRIZ
    MOVL R3, 0          ; CONTADOR
    MOVL R4, MATRIZ.l   ; PONTEIRO MATRIZ (low)
    MOVH R4, MATRIZ.h   ; PONTEIRO MATRIZ (high)
    MOVL R5, BLOCK_W
    MOVL R6, ROW_N
    MOVL R7, COLL_N
    ADDI R8, R8, 2      ; (era R13)

    LOOP_DRAW_MATRIZ:
        LOAD R9, R4, 0      ; R9 = Mem[R4]
        ADDI R4, R4, 4

        MOD R10, R3, R7     ; coluna = contador % COLL_N
        MUL R11, R10, R5    ; coluna * BLOCK_W
        ADDI R11, R11, START_X

        DIV R10, R3, R7     ; linha = contador / COLL_N
        MUL R12, R10, R5    ; linha * BLOCK_H
        ADDI R12, R12, START_Y

        BEQ R9, R0, NO_SQUARE
        RECT R11, R12, R5, R5, R9
        NO_SQUARE:
        INC R3
    BNE R2, R3, LOOP_DRAW_MATRIZ
    
    POP R13
    POP R12
    POP R11
    POP R10
    POP R9

    PUSH R1
    RET

PRINT_MATRIZ:
    MOVL R1, MATRIZ.l
    MOVH R1, MATRIZ.h
    MOVL R2, 0
    MOVL R3, MATRIZ_S
    MOVL R4, 2
    LOOP_PRINT_MATRIZ:
        SHL R5, R2, R4        ; R5 = índice * 4 (byte offset)
        ADD R5, R1, R5       ; R5 = endereço_base + offset
        LOAD R5, R5, 0       ; R5 = MATRIZ[i]
        SYSCALL R4, R5, R0, R0, R0
        INC R2
        BLE R2, R3, LOOP_PRINT_MATRIZ
    RET

ROTATE_PIECE:
    ADD R1, R9, R0
    CALL ROTATE_BLOCK
    ADD R4, R1, R0

    ADD R1, R11, R0
    CALL ROTATE_BLOCK
    ADD R5, R1, R0

    ADD R1, R12, R0
    CALL ROTATE_BLOCK
    ADD R6, R1, R0

    MOVL R7, 140
    BEQ R4, R7, CANCEL_ROT
    BEQ R5, R7, CANCEL_ROT
    BEQ R6, R7, CANCEL_ROT

    MOVL R1, 2
    MOVL R2, PRETO.l
    MOVH R2, PRETO.h
    MOVL R3, MATRIZ.l
    MOVH R3, MATRIZ.h

    SHL R7, R4, R1
    ADD R7, R7, R3
    LOAD R8, R7, 0
    BNE R8, R2, CANCEL_ROT

    SHL R7, R5, R1
    ADD R7, R7, R3
    LOAD R8, R7, 0
    BNE R8, R2, CANCEL_ROT

    SHL R7, R6, R1
    ADD R7, R7, R3
    LOAD R8, R7, 0
    BNE R8, R2, CANCEL_ROT

    ADD R9, R4, R0
    ADD R11, R5, R0
    ADD R12, R6, R0

CANCEL_ROT:
    RET

ROTATE_BLOCK:
    PUSH R2
    PUSH R3
    PUSH R4
    PUSH R5
    PUSH R6
    PUSH R7
    PUSH R8

    MOVL R8, COLL_N
    
    DIV R4, R10, R8
    MOD R5, R10, R8

    DIV R2, R1, R8
    MOD R3, R1, R8

    SUB R2, R2, R4
    SUB R3, R3, R5

    ADD R6, R3, R0
    SUB R7, R0, R2

    ADD R2, R4, R6
    ADD R3, R5, R7

    BLT R2, R0, ROT_FAIL
    MOVL R6, 13
    BGT R2, R6, ROT_FAIL
    
    BLT R3, R0, ROT_FAIL
    MOVL R6, 9
    BGT R3, R6, ROT_FAIL

    MUL R1, R2, R8
    ADD R1, R1, R3
    JMP ROT_SUCCESS

ROT_FAIL:
    MOVL R1, 140

ROT_SUCCESS:
    POP R8
    POP R7
    POP R6
    POP R5
    POP R4
    POP R3
    POP R2
    RET
