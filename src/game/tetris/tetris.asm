; Exemplo de programa que desenha um retângulo e 
; espera pela tecla ESPAÇO ser pressionada para continuar

.data
.equ SPACE_KEYCODE, 0x04
.equ BRANCO, 0xFFFFFFFF
.equ PRETO, 0xFF000000
.equ VERDE, 0xFF6ABE30
.equ AZUL, 0xFF1835E5
.equ VERMELHO , 0xFFAC3232
.equ BLOCK_W, 8
.equ BLOCK_H, 8
msg: .string "Pressione ESPACO para continuar..."

.text

; Aqui é desenhar o layout básico usando apenas retângulos.
START:
    ; Limpa a tela
    MOVL R1, PRETO.l         ; color = preto (parte baixa)
    MOVH R1, PRETO.h         ; color = preto (parte alta)
    CLEAR R1
;13 10 
;184 14
;13 229
;184 229

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

    ; Imprime a mensagem
    MOVL R1, 10            ; x = 160
    MOVL R2, 10            ; y = 120
    MOVL R3, msg.l          ; endereço da string (parte baixa)
    MOVH R3, msg.h          ; endereço da string (parte alta)
    MOVL R4, BRANCO.l         ; color = branco (ARGB)
    MOVH R4, BRANCO.h         ; color = branco (ARGB)
    PSTR R1, R2, R3, R4    

WAIT_KEY:
    ; Espera até que a tecla ESPAÇO seja pressionada
    MOVL R2, SPACE_KEYCODE  ; keyID = ESPAÇO
    GKEY R1, R2             ; R1 = 1 se ESPAÇO estiver pressionado, 
                            ; 0 caso contrário
    BEQ R1, R0, WAIT_KEY    ; Se R1 == 0, continua esperando

    ; Limpa a tela com azul após a tecla ser pressionada
    MOVL R1, AZUL.l         ; color = azul (parte baixa)
    MOVH R1, AZUL.h         ; color = azul (parte alta)
    CLEAR R1                ; Limpa a tela com azul

END: ; espra 1s e fecha a VM
    HALT
