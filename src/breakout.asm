.MODEL SMALL
.STACK 100h

.DATA
    ; Configuración del juego
    ANCHO EQU 80
    ALTO EQU 25
    BLOQUES_FILAS EQU 8
    BLOQUES_COLS EQU 20
    TOTAL_BLOQUES EQU 160
    
    ; Paleta
    paleta_x DB 35          
    paleta_y DB 23          
    paleta_x_anterior DB 35
    paleta_ancho DB 10      
    
    ; Pelota
    pelota_x DB 40          
    pelota_y DB 18          
    pelota_dx DB 1                 
    pelota_dy DB 255        ; -1

    ; INTEGRANTE 2: posicion previa para determinar el lado del impacto.
    ; El motor actualiza estos datos al iniciar cada movimiento.
    fisica_x_previa DB 40
    fisica_y_previa DB 18 
    
    ; Bloques
    bloques DB 160 DUP(1)    
    bloques_restantes DW 160
    puntos DW 0   
    vidas DB 3
    high_score DW 0
    
    ; Mensajes del menú
    titulo1 DB '  ____  ____  _____    _    _  _____  _   _ _____ $'
    titulo2 DB ' | __ )|  _ \| ____|  / \  | |/ / _ \| | | |_   _|$'
    titulo3 DB ' |  _ \| |_) |  _|   / _ \ | '' / | | | | | | | |  $'
    titulo4 DB ' | |_) |  _ <| |___ / ___ \|  <| |_| | |_| | | |  $'
    titulo5 DB ' |____/|_| \_\_____/_/   \_\_|\_\___/ \___/  |_|  $'
    
    menu_opcion1 DB '           1. JUGAR$'
    menu_opcion2 DB '           2. INSTRUCCIONES$'
    menu_opcion3 DB '           3. SALIR$'
    menu_prompt DB  '        Selecciona 1-3 o J/I/S $'
    menu_pie DB 'PROYECTO BREAKOUT 8086 - CONTROLES A/D$'
    ; Elementos decorativos del titulo arcade
    marco_horizontal DB '+-------------------------------------------------------------+$'
    marco_lateral DB '|$'
    menu_subtitulo DB '*** THE CLASSIC ARCADE GAME ***$'
    
    ; Instrucciones
    inst_titulo DB '           INSTRUCCIONES$'
    inst_linea1 DB '   Usa A y D o las flechas para mover la paleta$'
    inst_linea2 DB '   Destruye todos los bloques con la pelota$'
    inst_linea3 DB '   No dejes que la pelota caiga$'
    inst_linea4 DB '   Presiona ESC para volder al menu$'
    inst_linea5 DB '   Presiona cualquier tecla para volver...$'
    
    ; Mensajes del juego
    msg_perdiste DB 'PERDISTE! Presiona ENTER para menu$'
    msg_ganaste DB 'GANASTE! Presiona ENTER para menu$'
    msg_puntos DB '     Puntos: $'      
    msg_record DB '     Record: $'
    ; Mensajes de victoria y derrota
    titulo_perdiste DB '*** PERDISTE ***$'
    titulo_ganaste DB '*** GANASTE ***$'
    msg_volver_menu DB 'Presiona ENTER para volver al menu$'
    linea_final DB '========================================$'
    msg_controles DB 'A/D: MOVER  ESC: MENU$'
    msg_pausa DB '** PAUSA **$'
    msg_pausa_borra DB 11 DUP(' '), '$'
    
    juego_activo DB 1
    frame_counter DB 0

.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX
    
    CALL OCULTAR_CURSOR
    
MOSTRAR_MENU:
    CALL LIMPIAR_PANTALLA
    CALL DIBUJAR_MENU
    
    MOV AH, 00h
    INT 16h
    
    ; OPCION 1: JUGAR
    CMP AL, '1'
    JE INICIAR_JUEGO
    CMP AL, 'j'
    JE INICIAR_JUEGO
    CMP AL, 'J'
    JE INICIAR_JUEGO

    ; OPCION 2: INSTRUCCIONES
    CMP AL, '2'
    JE MOSTRAR_INSTRUCCIONES
    CMP AL, 'i'
    JE MOSTRAR_INSTRUCCIONES
    CMP AL, 'I'
    JE MOSTRAR_INSTRUCCIONES

    ; OPCION 3: SALIR
    CMP AL, '3'
    JE SALIR_PROGRAMA
    CMP AL, 's'
    JE SALIR_PROGRAMA
    CMP AL, 'S'
    JE SALIR_PROGRAMA
    
    JMP MOSTRAR_MENU
    
MOSTRAR_INSTRUCCIONES:
    CALL LIMPIAR_PANTALLA
    CALL DIBUJAR_INSTRUCCIONES
    
    MOV AH, 00h
    INT 16h
    JMP MOSTRAR_MENU
    
INICIAR_JUEGO:
    CALL REINICIAR_JUEGO
    CALL LIMPIAR_PANTALLA
    CALL DIBUJAR_CAMPO_INICIAL
    
GAME_LOOP:
    MOV AL, juego_activo
    CMP AL, 0
    JE FIN_JUEGO
    
    CALL MOSTRAR_INFO
    CALL BORRAR_PALETA_ANTERIOR
    CALL DIBUJAR_PALETA
    CALL DIBUJAR_PELOTA
    
    CALL DELAY_GAME
    
    ; Leer tecla
    MOV AH, 01h
    INT 16h
    JZ NO_TECLA
    
    MOV AH, 00h
    INT 16h
    
    ; Salir al menu con ESC
    CMP AL, 27
    JE VOLVER_MENU
    ; Pausar con P
    CMP AL, 'p'
    JE PAUSAR
    CMP AL, 'P'
    JE PAUSAR

    ; Mover la paleta a la izquierda con A
    CMP AL, 'a'
    JE MOVER_IZQ
    CMP AL, 'A'
    JE MOVER_IZQ

    ; Mover la paleta a la derecha con D
    CMP AL, 'd'
    JE MOVER_DER
    CMP AL, 'D'
    JE MOVER_DER

    ; Mantener las flechas originales
    CMP AH, 4Bh
    JE MOVER_IZQ

    CMP AH, 4Dh
    JE MOVER_DER

    JMP NO_TECLA
    
VOLVER_MENU:
    JMP MOSTRAR_MENU  
      
PAUSAR:
    ; Mostrar mensaje de pausa en amarillo
    MOV DH, 12
    MOV DL, 34
    LEA SI, msg_pausa
    MOV BL, 0Eh
    CALL IMPRIMIR_MENU_COLOR

ESPERAR_REANUDAR:
    MOV AH, 00h
    INT 16h
    CMP AL, 'p'
    JE REANUDAR
    CMP AL, 'P'
    JE REANUDAR
    JMP ESPERAR_REANUDAR

REANUDAR:
    ; Borrar el mensaje de pausa
    MOV DH, 12
    MOV DL, 34
    LEA SI, msg_pausa_borra
    MOV BL, 07h
    CALL IMPRIMIR_MENU_COLOR
    JMP NO_TECLA
    
; ==========================================
; MOVIMIENTO DE LA PALETA - IZQUIERDA
; ==========================================

MOVER_IZQ:
    MOV AL, paleta_x
    MOV paleta_x_anterior, AL

    ; Limite izquierdo: columna 1
    CMP AL, 3
    JB LIMITE_IZQUIERDO

    ; Mover dos posiciones
    SUB AL, 2
    MOV paleta_x, AL
    JMP NO_TECLA

LIMITE_IZQUIERDO:
    MOV paleta_x, 1
    JMP NO_TECLA


; ==========================================
; MOVIMIENTO DE LA PALETA - DERECHA
; ==========================================

MOVER_DER:
    MOV AL, paleta_x
    MOV paleta_x_anterior, AL

    ; Limite derecho: columna 67
    ; La paleta ocupa 12 caracteres
    CMP AL, 65
    JA LIMITE_DERECHO

    ; Mover dos posiciones
    ADD AL, 2
    MOV paleta_x, AL
    JMP NO_TECLA

LIMITE_DERECHO:
    MOV paleta_x, 67
    JMP NO_TECLA
    
NO_TECLA:
    INC frame_counter
    MOV AL, frame_counter
    AND AL, 01h
    JNZ GAME_LOOP
    
    CALL BORRAR_PELOTA
    CALL MOVER_PELOTA
    JMP GAME_LOOP
    
FIN_JUEGO:
    CALL LIMPIAR_PANTALLA

    ; Linea decorativa superior
    MOV DH, 7
    MOV DL, 20
    LEA SI, linea_final
    MOV CL, 40
    MOV BL, 0Bh
    CALL IMPRIMIR_MENU_COLOR

    ; Comprobar resultado del juego
    MOV AX, bloques_restantes
    CMP AX, 0
    JE MOSTRAR_GANASTE_MSG

    ; Mensaje de derrota - Rojo brillante
    MOV DH, 10
    MOV DL, 32
    LEA SI, titulo_perdiste
    MOV CL, 16
    MOV BL, 0Ch
    CALL IMPRIMIR_MENU_COLOR

    JMP MOSTRAR_MSG

MOSTRAR_GANASTE_MSG:
    ; Mensaje de victoria - Verde brillante
    MOV DH, 10
    MOV DL, 32
    LEA SI, titulo_ganaste
    MOV CL, 15
    MOV BL, 0Ah
    CALL IMPRIMIR_MENU_COLOR

MOSTRAR_MSG:      
    ; Actualizar High Score si se supero
    MOV AX, puntos
    CMP AX, high_score
    JBE NO_NUEVO_RECORD
    MOV high_score, AX
NO_NUEVO_RECORD:

    ; Mostrar puntuacion final
    MOV DH, 13
    MOV DL, 30
    CALL MOVER_CURSOR

    LEA DX, msg_puntos
    MOV AH, 09h
    INT 21h  
    MOV AX, puntos

    CALL IMPRIMIR_NUMERO    
    
        ; Mostrar High Score
    MOV DH, 14
    MOV DL, 30
    CALL MOVER_CURSOR

    LEA DX, msg_record
    MOV AH, 09h
    INT 21h

    MOV AX, high_score
    CALL IMPRIMIR_NUMERO

    ; Linea decorativa inferior
    MOV DH, 15
    MOV DL, 20
    LEA SI, linea_final
    MOV CL, 40
    MOV BL, 0Bh
    CALL IMPRIMIR_MENU_COLOR

    ; Instruccion para regresar
    MOV DH, 18
    MOV DL, 23
    LEA SI, msg_volver_menu
    MOV CL, 34
    MOV BL, 0Eh
    CALL IMPRIMIR_MENU_COLOR
    
ESPERAR_ENTER:
    MOV AH, 00h
    INT 16h
    CMP AL, 13
    JNE ESPERAR_ENTER
    
    JMP MOSTRAR_MENU
    
SALIR_PROGRAMA:
    CALL MOSTRAR_CURSOR
    MOV AH, 4Ch
    INT 21h
MAIN ENDP

OCULTAR_CURSOR PROC
    PUSH AX
    PUSH CX
    MOV AH, 01h
    MOV CX, 2000h
    INT 10h
    POP CX
    POP AX
    RET
OCULTAR_CURSOR ENDP

MOSTRAR_CURSOR PROC
    PUSH AX
    PUSH CX
    MOV AH, 01h
    MOV CX, 0607h
    INT 10h
    POP CX
    POP AX
    RET
MOSTRAR_CURSOR ENDP

DIBUJAR_MENU PROC
    PUSH BX
    PUSH CX
    PUSH DX
    PUSH SI

    ; ===================================
    ; MARCO ARCADE - CELESTE
    ; ===================================

    ; Borde superior
    MOV DH, 3
    MOV DL, 8
    LEA SI, marco_horizontal
    MOV CL, 63
    MOV BL, 0Bh
    CALL IMPRIMIR_MENU_COLOR

    ; Borde inferior
    MOV DH, 11
    MOV DL, 8
    LEA SI, marco_horizontal
    MOV CL, 63
    MOV BL, 0Bh
    CALL IMPRIMIR_MENU_COLOR

    ; Bordes laterales
    MOV DH, 4

DIBUJAR_LADOS_MENU:
    ; Lado izquierdo
    MOV DL, 8
    LEA SI, marco_lateral
    MOV CL, 1
    MOV BL, 0Bh
    CALL IMPRIMIR_MENU_COLOR

    ; Lado derecho
    MOV DL, 70
    LEA SI, marco_lateral
    MOV CL, 1
    MOV BL, 0Bh
    CALL IMPRIMIR_MENU_COLOR

    INC DH
    CMP DH, 11
    JB DIBUJAR_LADOS_MENU

    ; ===================================
    ; TITULO BREAKOUT - AMARILLO
    ; ===================================

    MOV DH, 4
    MOV DL, 15
    LEA SI, titulo1
    MOV CL, 50
    MOV BL, 0Eh
    CALL IMPRIMIR_MENU_COLOR

    MOV DH, 5
    MOV DL, 15
    LEA SI, titulo2
    MOV CL, 50
    MOV BL, 0Eh
    CALL IMPRIMIR_MENU_COLOR

    MOV DH, 6
    MOV DL, 15
    LEA SI, titulo3
    MOV CL, 50
    MOV BL, 0Eh
    CALL IMPRIMIR_MENU_COLOR

    MOV DH, 7
    MOV DL, 15
    LEA SI, titulo4
    MOV CL, 50
    MOV BL, 0Eh
    CALL IMPRIMIR_MENU_COLOR

    MOV DH, 8
    MOV DL, 15
    LEA SI, titulo5
    MOV CL, 50
    MOV BL, 0Eh
    CALL IMPRIMIR_MENU_COLOR

    ; Subtitulo arcade - Blanco brillante
    MOV DH, 10
    MOV DL, 24
    LEA SI, menu_subtitulo
    MOV CL, 31
    MOV BL, 0Fh
    CALL IMPRIMIR_MENU_COLOR

    ; ===================================
    ; OPCIONES DEL MENU
    ; ===================================

    ; JUGAR - Amarillo
    MOV DH, 13
    MOV DL, 20
    LEA SI, menu_opcion1
    MOV CL, 19
    MOV BL, 0Eh
    CALL IMPRIMIR_MENU_COLOR

    ; INSTRUCCIONES - Celeste
    MOV DH, 15
    MOV DL, 20
    LEA SI, menu_opcion2
    MOV CL, 27
    MOV BL, 0Bh
    CALL IMPRIMIR_MENU_COLOR

    ; SALIR - Rojo claro
    MOV DH, 17
    MOV DL, 20
    LEA SI, menu_opcion3
    MOV CL, 19
    MOV BL, 0Ch
    CALL IMPRIMIR_MENU_COLOR

    ; Mensaje de seleccion
    MOV DH, 20
    MOV DL, 20
    CALL MOVER_CURSOR
    LEA DX, menu_prompt
    MOV AH, 09h
    INT 21h 
    ; Mostrar High Score en el menu
    MOV DH, 22
    MOV DL, 28
    CALL MOVER_CURSOR
    LEA DX, msg_record
    MOV AH, 09h
    INT 21h
    MOV AX, high_score
    CALL IMPRIMIR_NUMERO

    ; Informacion del proyecto en celeste
    MOV DH, 23
    MOV DL, 20
    LEA SI, menu_pie
    MOV CL, 38
    MOV BL, 0Bh
    CALL IMPRIMIR_MENU_COLOR

    POP SI
    POP DX
    POP CX
    POP BX
    RET
DIBUJAR_MENU ENDP

DIBUJAR_INSTRUCCIONES PROC
    PUSH BX
    PUSH CX
    PUSH DX
    PUSH SI

    ; ===================================
    ; TITULO - CELESTE BRILLANTE
    ; ===================================
    MOV DH, 8
    MOV DL, 33
    LEA SI, inst_titulo
    ADD SI, 11
    MOV CL, 13
    MOV BL, 0Bh
    CALL IMPRIMIR_MENU_COLOR

    ; ===================================
    ; CONTROLES - CELESTE BRILLANTE
    ; ===================================
    MOV DH, 11
    MOV DL, 18
    LEA SI, inst_linea1
    ADD SI, 3
    MOV CL, 44
    MOV BL, 0Bh
    CALL IMPRIMIR_MENU_COLOR

    ; ===================================
    ; OBJETIVO - BLANCO BRILLANTE
    ; ===================================
    MOV DH, 13
    MOV DL, 18
    LEA SI, inst_linea2
    ADD SI, 3
    MOV CL, 40
    MOV BL, 0Fh
    CALL IMPRIMIR_MENU_COLOR

    ; ===================================
    ; ADVERTENCIA - BLANCO BRILLANTE
    ; ===================================
    MOV DH, 15
    MOV DL, 18
    LEA SI, inst_linea3
    ADD SI, 3
    MOV CL, 28
    MOV BL, 0Fh
    CALL IMPRIMIR_MENU_COLOR

    ; ===================================
    ; ESC - AMARILLO BRILLANTE
    ; ===================================
    MOV DH, 17
    MOV DL, 18
    LEA SI, inst_linea4
    ADD SI, 3
    MOV CL, 40
    MOV BL, 0Eh
    CALL IMPRIMIR_MENU_COLOR

    ; ===================================
    ; REGRESAR - GRIS CLARO
    ; ===================================
    MOV DH, 20
    MOV DL, 18
    LEA SI, inst_linea5
    ADD SI, 3
    MOV CL, 39
    MOV BL, 07h
    CALL IMPRIMIR_MENU_COLOR

    POP SI
    POP DX
    POP CX
    POP BX
    RET
DIBUJAR_INSTRUCCIONES ENDP

DIBUJAR_CAMPO_INICIAL PROC
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX

    ; ==================================
    ; BORDE SUPERIOR CELESTE
    ; ==================================

    ; Colocar cursor en fila 0, columna 0
    MOV DH, 0
    MOV DL, 0
    CALL MOVER_CURSOR

    ; Dibujar 80 bloques solidos
    MOV AH, 09h
    MOV AL, 219
    MOV BH, 00h
    MOV BL, 0Bh
    MOV CX, 80
    INT 10h

    ; Dibujar los bloques del juego
    CALL DIBUJAR_BLOQUES

    POP DX
    POP CX
    POP BX
    POP AX
    RET
DIBUJAR_CAMPO_INICIAL ENDP

MOSTRAR_INFO PROC
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    PUSH SI
    
    ; Mostrar puntos en la última línea
    MOV DH, 24
    MOV DL, 2
    CALL MOVER_CURSOR
    LEA DX, msg_puntos
    MOV AH, 09h
    INT 21h     
    MOV AX, puntos
    CALL IMPRIMIR_NUMERO
    
    ; Mostrar bloques restantes
    MOV DH, 24
    MOV DL, 20
    CALL MOVER_CURSOR
    MOV AH, 02h
    MOV DL, 'B'
    INT 21h
    MOV DL, ':'
    INT 21h
    
    MOV AX, bloques_restantes
    CALL IMPRIMIR_NUMERO 
    MOV AH, 02h
    MOV DL, ' '
    INT 21h    
    
    ; Mostrar vidas
    MOV DH, 24
    MOV DL, 32
    CALL MOVER_CURSOR
    MOV AH, 02h
    MOV DL, 'V'
    INT 21h
    MOV DL, ':'
    INT 21h
    MOV DL, vidas
    ADD DL, '0'
    INT 21h

    ; Mostrar controles en celeste brillante
    MOV DH, 24
    MOV DL, 45
    LEA SI, msg_controles
    MOV CL, 21
    MOV BL, 0Bh
    CALL IMPRIMIR_MENU_COLOR
    
    POP SI
    POP DX
    POP CX
    POP BX
    POP AX
    RET
MOSTRAR_INFO ENDP

IMPRIMIR_NUMERO PROC
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    
    ;MOV AX, puntos(ahora el numero a imprimir llega en AX)  
    
    MOV CX, 0
    MOV BX, 10
    
DIVIDIR:
    XOR DX, DX
    DIV BX
    PUSH DX
    INC CX
    CMP AX, 0
    JNE DIVIDIR
    
IMPRIMIR_DIGITOS:
    POP DX
    ADD DL, '0'
    MOV AH, 02h
    INT 21h
    LOOP IMPRIMIR_DIGITOS
    
    POP DX
    POP CX
    POP BX
    POP AX
    RET
IMPRIMIR_NUMERO ENDP

REINICIAR_JUEGO PROC
    PUSH AX
    PUSH BX
    PUSH CX
    
    MOV paleta_x, 35
    MOV paleta_x_anterior, 35
    MOV paleta_y, 23
    
    MOV pelota_x, 40
    MOV pelota_y, 18
    MOV pelota_dx, 1
    MOV pelota_dy, 255
    
    MOV CX, 160
    XOR BX, BX
    
REINICIAR_BLOQUES_LOOP:
    MOV bloques[BX], 1
    INC BX
    LOOP REINICIAR_BLOQUES_LOOP
    
    MOV bloques_restantes, 160
    MOV puntos, 0
    MOV vidas, 3
    MOV juego_activo, 1
    MOV frame_counter, 0
    
    POP CX
    POP BX
    POP AX
    RET
REINICIAR_JUEGO ENDP     

; ==========================================
; PERDER_VIDA
; Se llama cuando la pelota cae.
; Resta una vida. Si quedan, reubica la pelota.
; Si no quedan, termina el juego.
; ==========================================
PERDER_VIDA PROC
    PUSH AX

    DEC vidas
    CMP vidas, 0
    JE SIN_VIDAS

    ; Quedan vidas: la pelota vuelve al punto de salida
    MOV pelota_x, 40
    MOV pelota_y, 18
    MOV pelota_dx, 1
    MOV pelota_dy, 255
    JMP FIN_PERDER_VIDA

SIN_VIDAS:
    MOV juego_activo, 0

FIN_PERDER_VIDA:
    POP AX
    RET
PERDER_VIDA ENDP

LIMPIAR_PANTALLA PROC
    PUSH AX

    ; Establecer modo texto 80x25
    MOV AH, 00h
    MOV AL, 03h
    INT 10h

    ; Ocultar cursor despues del cambio de modo
    CALL OCULTAR_CURSOR

    POP AX
    RET
LIMPIAR_PANTALLA ENDP

MOVER_CURSOR PROC
    PUSH AX
    PUSH BX
    MOV AH, 02h
    MOV BH, 0
    INT 10h
    POP BX
    POP AX
    RET
MOVER_CURSOR ENDP

DIBUJAR_BLOQUES PROC
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    PUSH SI
    
    XOR BX, BX
    MOV DH, 2
    
FILA_BLOQUES:
    CMP DH, 10
    JGE FIN_DIBUJAR_BLOQUES
    
    MOV DL, 2
    MOV CL, 0
    
COLUMNA_BLOQUES:
    CMP CL, 20
    JGE SIGUIENTE_FILA_BLOQUES
    
    MOV AL, bloques[BX]
    CMP AL, 0
    JE SALTAR_BLOQUE
    
    ; Guardar registros importantes
    PUSH BX
    PUSH CX
    PUSH DX
    
    ; Posicionar cursor
    CALL MOVER_CURSOR
    
    ; Color segun la fila de bloques
    MOV BL, 0Ch       ; Rojo brillante

    CMP DH, 4
    JB COLOR_BLOQUE_LISTO

    MOV BL, 0Eh       ; Amarillo
    CMP DH, 6
    JB COLOR_BLOQUE_LISTO

    MOV BL, 0Ah       ; Verde brillante
    CMP DH, 8
    JB COLOR_BLOQUE_LISTO

    MOV BL, 0Bh       ; Celeste

COLOR_BLOQUE_LISTO:
    ; Dibujar bloque con color
    MOV AH, 09h
    MOV AL, 178
    MOV BH, 00h

    MOV CX, 3

    ; Evitar que el ultimo bloque
    ; se dibuje fuera de la pantalla
    CMP DL, 78
    JB DIBUJAR_BLOQUE_COLOR
    MOV CX, 2

DIBUJAR_BLOQUE_COLOR:
    INT 10h
    
    ; Restaurar registros
    POP DX
    POP CX
    POP BX
    
SALTAR_BLOQUE:
    INC BX
    INC CL
    ADD DL, 4
    CMP CL, 20
    JL COLUMNA_BLOQUES
    
SIGUIENTE_FILA_BLOQUES:
    INC DH
    CMP DH, 10
    JL FILA_BLOQUES
    
FIN_DIBUJAR_BLOQUES:
    POP SI
    POP DX
    POP CX
    POP BX
    POP AX
    RET
DIBUJAR_BLOQUES ENDP

DIBUJAR_PALETA PROC
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX

    ; Posicionar la paleta
    MOV DH, paleta_y
    MOV DL, paleta_x
    CALL MOVER_CURSOR

    ; Dibujar paleta en celeste brillante
    MOV AH, 09h
    MOV AL, 223
    MOV BH, 00h
    MOV BL, 0Bh

    ; Mantener el ancho original
    XOR CH, CH
    MOV CL, paleta_ancho
    ADD CX, 2

    ; Mostrar caracteres con color
    INT 10h

    POP DX
    POP CX
    POP BX
    POP AX
    RET
DIBUJAR_PALETA ENDP

BORRAR_PALETA_ANTERIOR PROC
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX

    MOV DH, paleta_y
    MOV DL, paleta_x_anterior

    XOR CH, CH
    MOV CL, paleta_ancho
    ADD CL, 2

LOOP_BORRAR_PALETA:
    PUSH CX
    PUSH DX

    ; Posicionar cursor
    CALL MOVER_CURSOR

    ; Borrar caracter y su color anterior
    MOV AH, 09h
    MOV AL, ' '
    MOV BH, 00h
    MOV BL, 07h
    MOV CX, 1
    INT 10h

    POP DX
    POP CX

    INC DL
    LOOP LOOP_BORRAR_PALETA

    POP DX
    POP CX
    POP BX
    POP AX
    RET
BORRAR_PALETA_ANTERIOR ENDP

DIBUJAR_PELOTA PROC
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX

    ; Posicionar la pelota
    MOV DH, pelota_y
    MOV DL, pelota_x
    CALL MOVER_CURSOR

    ; Dibujar pelota en amarillo brillante
    MOV AH, 09h
    MOV AL, 254
    MOV BH, 00h
    MOV BL, 0Eh
    MOV CX, 1
    INT 10h

    POP DX
    POP CX
    POP BX
    POP AX
    RET
DIBUJAR_PELOTA ENDP

BORRAR_PELOTA PROC
    PUSH AX
    PUSH DX
    MOV DH, pelota_y
    MOV DL, pelota_x
    CALL MOVER_CURSOR
    
    MOV AH, 02h
    MOV DL, ' '
    INT 21h
    POP DX
    POP AX
    RET
BORRAR_PELOTA ENDP

; ===============================================================
; INTEGRANTE 2 - MOTOR DE MOVIMIENTO Y COLISIONES
; Coordenadas: modo texto 80x25; fila 0 es borde superior.
; dx/dy: 1 = positivo, 255 = -1 (byte con signo).
; La paleta se dibuja con paleta_ancho + 2 caracteres.
;
; Procedimiento MOVER_PELOTA:
; - guarda posicion previa
; - actualiza posicion con velocidad en x/y
; - invierte velocidad en paredes y techo sin salirse de pantalla
; - rebota contra paleta solo cuando baja
; - controla direccion horizontal segun mitad de la paleta
; - delega impactos a VERIFICAR_COLISION_BLOQUES
; - delega perdida de vida a PERDER_VIDA (Integrante 3)
; Conserva AX, BX, CX, DX.
; ===============================================================
MOVER_PELOTA PROC
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX

    ; Guardar el punto anterior para analizar impactos laterales.
    MOV AL, pelota_x
    MOV fisica_x_previa, AL
    MOV BL, pelota_dx
    ADD AL, BL
    MOV pelota_x, AL

    MOV AL, pelota_y
    MOV fisica_y_previa, AL
    MOV BL, pelota_dy
    ADD AL, BL
    MOV pelota_y, AL

    ; Limites horizontales: columna 1 a 79.
    ; Se permite llegar a 78 y 79, donde se dibuja el ultimo bloque.
    MOV AL, pelota_x
    CMP AL, 1
    JA FIS_VER_DERECHA
    MOV pelota_x, 1
    MOV pelota_dx, 1
    JMP FIS_VER_TECHO

FIS_VER_DERECHA:
    CMP AL, 79
    JB FIS_VER_TECHO
    MOV pelota_x, 79
    MOV pelota_dx, 255

FIS_VER_TECHO:
    ; Fila 0: borde. La pelota permanece en fila >= 1.
    MOV AL, pelota_y
    CMP AL, 1
    JA FIS_VER_PALETA
    MOV pelota_y, 1
    MOV pelota_dy, 1

FIS_VER_PALETA:
    ; Evitar colision falsa cuando la pelota va hacia arriba.
    CMP pelota_dy, 1
    JE FIS_PALETA_BAJANDO
    JMP FIS_VER_BLOQUES

FIS_PALETA_BAJANDO:
    MOV AL, pelota_y
    CMP AL, paleta_y
    JE FIS_PALETA_FILACORRECTA
    JMP FIS_VER_BLOQUES

FIS_PALETA_FILACORRECTA:
    ; Coordenadas validas: paleta_x ... paleta_x + ancho + 1.
    MOV AL, pelota_x
    CMP AL, paleta_x
    JAE FIS_PALETA_DENTRO_IZQ
    JMP FIS_VER_BLOQUES

FIS_PALETA_DENTRO_IZQ:
    MOV BL, paleta_x
    ADD BL, paleta_ancho
    ADD BL, 2
    CMP AL, BL
    JB FIS_PALETA_IMPACTO
    JMP FIS_VER_BLOQUES

FIS_PALETA_IMPACTO:
    ; Situar pelota encima de la paleta y subir.
    MOV AL, paleta_y
    DEC AL
    MOV pelota_y, AL
    MOV pelota_dy, 255

    ; Posicion de contacto con respecto a inicio de la paleta.
    ; Primera mitad rebota a izquierda; segunda, a derecha.
    MOV AL, pelota_x
    SUB AL, paleta_x
    MOV BL, paleta_ancho
    ADD BL, 2
    SHR BL, 1
    CMP AL, BL
    JAE FIS_GOLPE_DERECHO
    MOV pelota_dx, 255
    JMP FIS_VER_BLOQUES

FIS_GOLPE_DERECHO:
    MOV pelota_dx, 1

FIS_VER_BLOQUES:
    CALL VERIFICAR_COLISION_BLOQUES

    ; Si llego a la ultima fila, la pelota se perdio.
    MOV AL, pelota_y
    CMP AL, 24
    JB FIS_MOVIMIENTO_FIN
    CALL PERDER_VIDA

FIS_MOVIMIENTO_FIN:
    POP DX
    POP CX
    POP BX
    POP AX
    RET
MOVER_PELOTA ENDP

; ===============================================================
; INTEGRANTE 2 - COLISION REAL CON BLOQUES (8 filas x 20 columnas)
; Fila de juego: 2..9. Bloques inician en x=2+4*columna.
; Un bloque comun ocupa 3 caracteres; el cuarto es separacion.
; Ultima columna inicia en x=78, y solo caben x=78 y 79.
; Conserva AX, BX, CX, DX, SI.
; ===============================================================
VERIFICAR_COLISION_BLOQUES PROC
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    PUSH SI

    ; Validar fila antes de calcular indice.
    MOV AL, pelota_y
    CMP AL, 2
    JAE FIS_COL_MIN_Y_OK
    JMP FIS_COL_FIN
FIS_COL_MIN_Y_OK:
    CMP AL, 10
    JB FIS_COL_Y_OK
    JMP FIS_COL_FIN
FIS_COL_Y_OK:

    ; Validar columna. Debe incluir x=78 y 79.
    MOV AL, pelota_x
    CMP AL, 2
    JAE FIS_COL_MIN_X_OK
    JMP FIS_COL_FIN
FIS_COL_MIN_X_OK:
    CMP AL, 79
    JBE FIS_COL_X_OK
    JMP FIS_COL_FIN
FIS_COL_X_OK:

    ; Calcular columna y desplazamiento dentro de la celda.
    ; (x - 2) / 4 => AL: columna, AH: resto 0..3.
    XOR AX, AX
    MOV AL, pelota_x
    SUB AL, 2
    MOV CL, 4
    DIV CL

    CMP AL, 20
    JB FIS_COL_COLUMNA_OK
    JMP FIS_COL_FIN
FIS_COL_COLUMNA_OK:
    ; Resto 3 representa el espacio ENTRE bloques: sin choque.
    CMP AH, 3
    JB FIS_COL_NO_ES_HUECO
    JMP FIS_COL_FIN
FIS_COL_NO_ES_HUECO:
    ; El ultimo bloque solo dispone de dos caracteres (78 y 79).
    CMP AL, 19
    JNE FIS_COL_CALC_INDICE
    CMP AH, 2
    JB FIS_COL_CALC_INDICE
    JMP FIS_COL_FIN

FIS_COL_CALC_INDICE:
    MOV DL, AL

    ; Indice lineal: (pelota_y - 2) * 20 + columna.
    XOR AX, AX
    MOV AL, pelota_y
    SUB AL, 2
    MOV BL, 20
    MUL BL
    XOR BH, BH
    MOV BL, DL
    ADD AX, BX
    MOV SI, AX

    CMP SI, 160
    JB FIS_COL_INDICE_OK
    JMP FIS_COL_FIN
FIS_COL_INDICE_OK:
    ; Un bloque solo puede destruirse una vez.
    CMP BYTE PTR bloques[SI], 0
    JNE FIS_COL_GOLPE_VALIDO
    JMP FIS_COL_FIN

FIS_COL_GOLPE_VALIDO:
    MOV BYTE PTR bloques[SI], 0
    DEC bloques_restantes
    ADD puntos, 10

    ; Dibujar vacio exactamente donde estaba el bloque destruido.
    ; SI / 20 => AL = fila, AH = columna.
    MOV AX, SI
    MOV BL, 20
    DIV BL
    MOV DH, AL
    ADD DH, 2
    MOV AL, AH
    MOV BL, 4
    MUL BL
    ADD AL, 2
    MOV DL, AL
    CALL MOVER_CURSOR

    ; Escribir espacios con color estandar para borrar tambien atributo.
    MOV AH, 09h
    MOV AL, ' '
    MOV BH, 0
    MOV BL, 07h
    MOV CX, 3
    CMP DL, 78
    JB FIS_COL_BORRAR
    MOV CX, 2          ; el ultimo bloque ocupa columnas 78-79
FIS_COL_BORRAR:
    INT 10h

    ; Tipo de impacto: si antes estabamos en una columna de bloque
    ; distinta o sobre un hueco, venimos desde un lado. Si la pelota
    ; venia DESDE FUERA de las filas de bloques, el golpe es vertical.
    MOV AL, fisica_y_previa
    CMP AL, 2
    JB FIS_COL_REBOTE_VERTICAL
    CMP AL, 10
    JAE FIS_COL_REBOTE_VERTICAL
    MOV AL, fisica_x_previa
    CMP AL, 2
    JAE FIS_COL_ANT_X_MIN
    JMP FIS_COL_REBOTE_VERTICAL
FIS_COL_ANT_X_MIN:
    CMP AL, 79
    JBE FIS_COL_ANT_X_MAX
    JMP FIS_COL_REBOTE_VERTICAL
FIS_COL_ANT_X_MAX:
    SUB AL, 2
    XOR AH, AH
    MOV CL, 4
    DIV CL
    MOV DL, AL       ; columna previa
    MOV CH, AH       ; posicion previa dentro de su celda
    MOV AX, SI
    MOV BL, 20
    DIV BL
    CMP AH, DL
    JNE FIS_COL_REBOTE_LATERAL
    CMP CH, 3       ; venia desde el espacio de esta celda
    JAE FIS_COL_REBOTE_LATERAL

FIS_COL_REBOTE_VERTICAL:
    NEG pelota_dy
    JMP FIS_COL_COMPROBAR_VICTORIA

FIS_COL_REBOTE_LATERAL:
    NEG pelota_dx

FIS_COL_COMPROBAR_VICTORIA:
    MOV AX, bloques_restantes
    CMP AX, 0
    JNE FIS_COL_FIN
    MOV juego_activo, 0

FIS_COL_FIN:
    POP SI
    POP DX
    POP CX
    POP BX
    POP AX
    RET
VERIFICAR_COLISION_BLOQUES ENDP

DELAY_GAME PROC
    PUSH CX
    PUSH DX
    
    MOV CX, 0001h
    
DELAY_OUTER:
    MOV DX, 5000h
DELAY_INNER:
    DEC DX
    JNZ DELAY_INNER
    LOOP DELAY_OUTER
    
    POP DX
    POP CX
    RET
DELAY_GAME ENDP
  
; ==========================================
; IMPRIMIR TEXTO CON COLOR
; ==========================================
; ENTRADA:
; DS:SI = direccion del texto
; BL = color
; DH = fila
; DL = columna
;
; Detecta automaticamente el final '$'
; ==========================================

IMPRIMIR_MENU_COLOR PROC
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    PUSH SI
    PUSH BP
    PUSH ES

    ; Preparar segmento del texto
    PUSH DS
    POP ES

    ; Guardar inicio de la cadena
    MOV BP, SI

    ; Contar caracteres hasta encontrar '$'
    XOR CX, CX

CONTAR_TEXTO_COLOR:
    CMP BYTE PTR [SI], '$'
    JE IMPRIMIR_TEXTO_COLOR

    INC SI
    INC CX
    JMP CONTAR_TEXTO_COLOR

IMPRIMIR_TEXTO_COLOR:
    ; Funcion BIOS para mostrar texto con color
    MOV AX, 1301h
    MOV BH, 00h
    INT 10h

    POP ES
    POP BP
    POP SI
    POP DX
    POP CX
    POP BX
    POP AX
    RET
IMPRIMIR_MENU_COLOR ENDP  
  
END MAIN