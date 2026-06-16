; Exemplo de programa que desenha um retângulo e 
; espera pela tecla ESPAÇO ser pressionada para continuar

; ideias gerais
; preciso que ele siga uma matriz (colisão e pontos), o desenho no tabuleiro é a ultima coisa a ser feita
; usar zero para definir um espaço vazio e usar a cor para definir um ocupado
; OBJETIVO DE HJ fazer uma peça L cair
; popular a matriZ com L
; instrução para desenhar baseada na matriz
; mover o L pela matriz

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
.equ START_Y, 16
.equ ROW_N, 13
.equ COLL_N, 10

msg: .string "Pressione ESPACO para continuar..."

.text

; Aqui é desenhar o layout básico usando apenas retângulos.
START:
    ; Limpa a tela
    MOVL R1, PRETO.l         ; color = preto (parte baixa)
    MOVH R1, PRETO.h         ; color = preto (parte alta)
    CLEAR R1

    ; Desenha 4 retângulos azuis para formar aonde as peças vão ficar
    MOVL R5, AZUL.l         ; color = azul (parte baixa)
    MOVH R5, AZUL.h         ; color = azul (parte alta)
    
    MOVL R1, 13
    MOVL R2, 10
    MOVL R3, 171
    MOVL R4, 4
    RECT R1, R2, R3, R4, R5 ; linha superior
    
    MOVL R3, 4
    MOVL R4, 219
    RECT R1, R2, R3, R4, R5 ; linha esquerda
    
    MOVL R1, 181
    MOVL R2, 10
    RECT R1, R2, R3, R4, R5 ; linha direita

    MOVL R1, 13
    MOVL R2, 226
    MOVL R3, 171
    MOVL R4, 4
    RECT R1, R2, R3, R4, R5 ; linha direita
    ; MOVL R9,  START_X
    ; MOVL R10, START_Y
    ; CALL DRAW_L


    ; inicar a matriz com zeros na pilha
    MOVL R1, ROW_N
    MOVL R2, COLL_N
    MUL R3, R1, R2
    MOVL R4, 4
    MUL R3, R3, R4
    SUB R14, R14, R3 ; garante 10*14*4 espaços na pilha

    ; Peça inicial é um L
    CALL DRAW_L
    CALL DRAW_MATRIZ
    MOVL R1, 500
    SLEEP R1

RUN:
    ; LIMPAR AONDE A PEÇA ESTAVA
    MOVL R3, PRETO.l
    MOVH R3, PRETO.h

    MOVL R2, 2
    SHL R1, R9, R2
    ADD R1, R1, R14
    STORE R3, R1, 0
    
    SHL R1, R10, R2
    ADD R1, R1, R14
    STORE R3, R1, 0
    
    SHL R1, R11, R2
    ADD R1, R1, R14
    STORE R3, R1, 0

    SHL R1, R12, R2
    ADD R1, R1, R14
    STORE R3, R1, 0

    ; SOMAR O VALOR DE UMA LINHA EM CADA UM DELES, PARA QUE ELES PASSEM PARA A COLUNA DE BAIXO
    MOVL R1, COLL_N
    ADD R9, R9, R1
    ADD R10, R10, R1
    ADD R11, R11, R1
    ADD R12, R12, R1


    MOVL R1, 129 ; ESSE VALOR MÁGICO É O MÁXIMO NO TABULEIRO
    SLEEP R1
    BGT R9, R1, COLISION_INF
    BGT R10, R1, COLISION_INF
    BGT R11, R1, COLISION_INF
    BGT R12, R1, COLISION_INF

    MOVL R3, PRETO.l
    MOVH R3, PRETO.h


    SHL R1, R9, R2
    ADD R1, R1, R14

    STORE R13, R1, 0

    SHL R1, R10, R2
    ADD R1, R1, R14
    STORE R13, R1, 0

    SHL R1, R11, R2
    ADD R1, R1, R14
    LOAD R4, R1, 0 ; Se oq tiver na próxima posição for diferente de preto, colisão
    BNE R0, R4, COLISION_INF
    STORE R13, R1, 0

    SHL R1, R12, R2
    ADD R1, R1, R14
    STORE R13, R1, 0

    CALL DRAW_MATRIZ
    MOVL R1, 200
    SLEEP R1



    MOVL R2, SPACE_KEYCODE  ; keyID = ESPAÇO
    GKEY R1, R2             ; R1 = 1 se ESPAÇO estiver pressionado, 
                            ; 0 caso contrário
    BEQ R1, R0, RUN    ; Se R1 == 0, continua esperando

COLISION_INF: ; COLIDE a peça com a parte de baixo e salva a posição dela no game

    ; RETROCEDE UMA CASA E SALVA
    MOVL R3, COLL_N
    SUB R9, R9, R3
    SUB R10, R10, R3
    SUB R11, R11, R3
    SUB R12, R12, R3


    MOVL R2, 2
    SHL R1, R9, R2
    ADD R1, R1, R14
    STORE R13, R1, 0

    SHL R1, R10, R2
    ADD R1, R1, R14
    STORE R13, R1, 0

    SHL R1, R11, R2
    ADD R1, R1, R14
    STORE R13, R1, 0

    SHL R1, R12, R2
    ADD R1, R1, R14
    STORE R13, R1, 0

    MOVL R1, 500
    SLEEP R1
    CALL DRAW_L
    CALL DRAW_MATRIZ

    JMP RUN



DRAW_L:
    POP R3
    MOVL R9,  4
    MOVL R10, 14
    MOVL R11, 24
    MOVL R12, 25
    MOVL R13, VERMELHO.l
    MOVH R13, VERMELHO.h

    MOVL R2, 2

    SHL R1, R9, R2
    ADD R1, R1, R14
    STORE R13, R1, 0

    SHL R1, R10, R2
    ADD R1, R1, R14
    STORE R13, R1, 0

    SHL R1, R11, R2
    ADD R1, R1, R14
    STORE R13, R1, 0

    SHL R1, R12, R2
    ADD R1, R1, R14
    STORE R13, R1, 0

    PUSH R3
    RET




DRAW_MATRIZ:
    POP R1
    ; faz store dos registradores mágicos antes de seguir na função
    PUSH R9
    PUSH R10
    PUSH R11
    PUSH R12

    MOVL R2, 130 ; TAMANHO TOTAL DA matriZ
    MOVL R3, 0 ; CONTADOR
    MOVL R4, START_X
    MOVL R5, START_Y
    MOVL R6, BLOCK_W
    MOVL R7, BLOCK_H
    MOVL R8, ROW_N
    MOVL R9, COLL_N
    ADDI R12, R14, 16

    ADDI R13, R13, 2
    LOOP_DRAW_MATRIZ:
        LOAD R11, R12, 0    ; R11 = Mem[R12]
        ADDI R12, R12, 4
        MOD R10, R3, R9      ; coluna
        MUL R4, R10, R6      ; coluna * BLOCK_W
        ADDI R4, R4, START_X
        
        DIV R10, R3, R9      ; linha
        MUL R5, R10, R7      ; linha * BLOCK_H
        ADDI R5, R5, START_Y
        
        BEQ R11, R0, NO_SQUARE
        RECT R4, R5, R6, R7, R11 
        NO_SQUARE:
        INC R3
    BNE R2, R3, LOOP_DRAW_MATRIZ
    
    POP R12
    POP R11
    POP R10
    POP R9

    PUSH R1
    RET


