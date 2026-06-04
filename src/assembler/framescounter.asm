; Exemplo de programa que desenha um retângulo e 
; espera pela tecla ESPAÇO ser pressionada para continuar

.data
.equ SPACE_KEYCODE, 0x04
.equ AZUL, 0xFF0000FF
.equ VERDE, 0xFF00FF00
.equ AMARELO, 0xFFFFDE33
.equ BRANCO, 0xFFFFFFFF
.equ PRETO, 0xFF000000
.equ RETANGULO_LARG, 8
.equ RETANGULO_ALT, 8
msg: .string "Pressione ESPACO para continuar..."

.text
START:
    ; Limpa a tela
    MOVL R1, PRETO.l         ; color = preto (parte baixa)
    MOVH R1, PRETO.h         ; color = preto (parte alta)
    CLEAR R1

    ; Desenha um retângulo azul no centro da tela
    MOVL R1, 160            ; x = 160
    MOVL R2, 120            ; y = 120
    MOVL R3, RETANGULO_LARG ; w = 8
    MOVL R4, RETANGULO_ALT  ; h = 8
    MOVL R5, AZUL.l         ; color = azul (parte baixa)
    MOVH R5, AZUL.h         ; color = azul (parte alta)
    RECT R1, R2, R3, R4, R5

    ; Imprime a mensagem
    MOVL R1, 10            ; x = 160
    MOVL R2, 10            ; y = 120
    MOVL R3, msg.l          ; endereço da string (parte baixa)
    MOVH R3, msg.h          ; endereço da string (parte alta)
    MOVL R4, AZUL.l         ; color = branco (ARGB)
    MOVH R4, AZUL.h         ; color = branco (ARGB)
    PSTR R1, R2, R3, R4    

    ;MOVL R1, 50
    ;MOVL R2, 50
    ;MOVL R3, 1
    ;MOVH R3, 1
    ;PINT R1, R2, R3, R4

    MOVL R1, 0        
    MOVL R2, 0          
    MOVL R3, 320 
    MOVL R4, 160  
    MOVL R5, AZUL.l         ; color = azul (parte baixa)
    MOVH R5, AZUL.h         ; color = azul (parte alta)
    RECT R1, R2, R3, R4, R5

    MOVL R1, 0               
    MOVL R2, 160            
    MOVL R3, 320 
    MOVL R4, 120  
    MOVL R5, VERDE.l         ; color = azul (parte baixa)
    MOVH R5, VERDE.h         ; color = azul (parte alta)
    RECT R1, R2, R3, R4, R5

    MOVL R1, 290             
    MOVL R2, 20            
    MOVL R3, 20 
    MOVL R4, 20  
    MOVL R5, AMARELO.l         ; color = azul (parte baixa)
    MOVH R5, AMARELO.h         ; color = azul (parte alta)
    RECT R1, R2, R3, R4, R5


END: ; Fica em loop infinito

    FRAMENUM R4

    MOVL R1, 10
    MOVL R2, 10
    MOVL R3, AMARELO.l       
    MOVH R3, AMARELO.h         
    PINT R1, R2, R4, R3


    MOVL R1, 0        
    MOVL R2, 0          
    MOVL R3, 320 
    MOVL R4, 160  
    MOVL R5, AZUL.l         ; color = azul (parte baixa)
    MOVH R5, AZUL.h         ; color = azul (parte alta)
    RECT R1, R2, R3, R4, R5

    BEQ R0, R0, END

