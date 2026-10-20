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
    
    ; Bloques
    bloques DB 160 DUP(1)    
    bloques_restantes DW 160
    puntos DW 0
    
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
    ; Mensajes de victoria y derrota
    titulo_perdiste DB '*** PERDISTE ***$'
    titulo_ganaste DB '*** GANASTE ***$'
    msg_volver_menu DB 'Presiona ENTER para volver al menu$'
    linea_final DB '========================================$'
    msg_controles DB 'A/D: MOVER  ESC: MENU$'
    
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
    ; Mostrar puntuacion final
    MOV DH, 13
    MOV DL, 30
    CALL MOVER_CURSOR

    LEA DX, msg_puntos
    MOV AH, 09h
    INT 21h

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
    
    MOV AX, puntos
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
    MOV juego_activo, 1
    MOV frame_counter, 0
    
    POP CX
    POP BX
    POP AX
    RET
REINICIAR_JUEGO ENDP

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

MOVER_PELOTA PROC
    PUSH AX
    PUSH BX
    PUSH CX
    
    MOV AL, pelota_x
    MOV BL, pelota_dx
    ADD AL, BL
    MOV pelota_x, AL
    
    MOV AL, pelota_y
    MOV BL, pelota_dy
    ADD AL, BL
    MOV pelota_y, AL
    
    ; Colisión pared izquierda
    MOV AL, pelota_x
    CMP AL, 1
    JLE REBOTAR_X
    
    ; Colisión pared derecha
    MOV AL, pelota_x
    CMP AL, 78
    JGE REBOTAR_X
    JMP CHECK_Y
    
REBOTAR_X:
    MOV AL, pelota_dx
    NEG AL
    MOV pelota_dx, AL
    MOV AL, pelota_x
    MOV BL, pelota_dx
    ADD AL, BL
    MOV pelota_x, AL
    
CHECK_Y:
    ; Colisión techo
    MOV AL, pelota_y
    CMP AL, 1
    JLE REBOTAR_Y_UP
    
    ; Colisión paleta
    MOV AL, pelota_y
    MOV BL, paleta_y
    CMP AL, BL
    JNE CHECK_BLOQUES
    
    MOV AL, pelota_x
    MOV BL, paleta_x
    CMP AL, BL
    JL CHECK_BLOQUES
    
    MOV AL, pelota_x
    MOV BL, paleta_x
    MOV CL, paleta_ancho
    ADD CL, 2
    ADD BL, CL
    CMP AL, BL
    JGE CHECK_BLOQUES
    
REBOTAR_Y_UP:
    MOV AL, pelota_dy
    NEG AL
    MOV pelota_dy, AL
    MOV AL, pelota_y
    MOV BL, pelota_dy
    ADD AL, BL
    MOV pelota_y, AL
    
CHECK_BLOQUES:
    CALL VERIFICAR_COLISION_BLOQUES
    
    MOV AL, pelota_y
    CMP AL, 24
    JGE PERDER
    
    POP CX
    POP BX
    POP AX
    RET
    
PERDER:
    MOV juego_activo, 0
    POP CX
    POP BX
    POP AX
    RET
MOVER_PELOTA ENDP

VERIFICAR_COLISION_BLOQUES PROC
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    
    MOV AL, pelota_y
    CMP AL, 2
    JL FIN_VERIFICAR
    CMP AL, 10
    JGE FIN_VERIFICAR
    
    MOV AL, pelota_x
    CMP AL, 2
    JL FIN_VERIFICAR
    CMP AL, 78
    JGE FIN_VERIFICAR
    
    ; Calcular fila
    MOV AL, pelota_y
    SUB AL, 2
    MOV BL, 20
    MUL BL
    MOV BX, AX
    
    ; Calcular columna
    MOV AL, pelota_x
    SUB AL, 2
    MOV CL, 4
    XOR AH, AH
    DIV CL
    
    CMP AL, 20
    JAE FIN_VERIFICAR
    
    XOR AH, AH
    ADD BX, AX
    
    CMP BX, 160
    JAE FIN_VERIFICAR
    
    MOV AL, bloques[BX]
    CMP AL, 0
    JE FIN_VERIFICAR
    
    ; Destruir bloque
    MOV bloques[BX], 0
    DEC bloques_restantes
    ADD puntos, 10
    
    ; Borrar el bloque
    PUSH BX
    MOV AX, BX
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
    MOV AH, 02h
    MOV DL, ' '
    INT 21h
    MOV DL, ' '
    INT 21h
    MOV DL, ' '
    INT 21h
    POP BX
    
    ; Rebotar
    MOV AL, pelota_dy
    NEG AL
    MOV pelota_dy, AL
    
    MOV AX, bloques_restantes
    CMP AX, 0
    JE GANAR
    
FIN_VERIFICAR:
    POP DX
    POP CX
    POP BX
    POP AX
    RET
    
GANAR:
    MOV juego_activo, 0
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