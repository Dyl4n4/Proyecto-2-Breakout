# Contribución del Integrante 3: Estados del juego y puntuación

## 1. Objetivo

Desarrollar y mejorar la lógica de estados y puntuación del videojuego Breakout implementado en lenguaje ensamblador Intel 8086, conservando su funcionalidad original y utilizando DOSBox como entorno de ejecución.

## 2. Herramientas utilizadas

- **Lenguaje:** ensamblador Intel 8086.
- **Compilador:** emu8086.
- **Entorno de ejecución:** DOSBox 0.74-3.
- **Configuración de prueba:** ciclos de CPU indicados en el README del proyecto.
- **Control de versiones:** Git y GitHub.

## 3. Modificaciones realizadas

### 3.1. Implementación del sistema de vidas

Se agregó la variable `vidas` en la sección `.DATA` y se modificó el procedimiento `REINICIAR_JUEGO` para que cada partida comience con tres vidas.

También se modificó el procedimiento `MOSTRAR_INFO` para mostrar las vidas restantes en la última fila de la pantalla con el formato `V:3`.

Se creó el procedimiento `PERDER_VIDA`, que resta una vida cuando la pelota cae. Si quedan vidas, la pelota regresa a su posición y dirección iniciales; si no quedan, se establece `juego_activo` en 0 para terminar la partida. También se verificó la pérdida de una vida al caer la pelota, el Game Over al perder la tercera vida y la pantalla de victoria.

Para conectar PERDER_VIDA con el juego, se reemplazó la instrucción MOV juego_activo, 0 por CALL PERDER_VIDA en la etiqueta PERDER: del procedimiento MOVER_PELOTA.
### 3.2. Implementación de la pausa y reanudación

Se modificó la lectura del teclado dentro del ciclo principal del juego para permitir que el jugador pause la partida mediante la tecla P.

Al pausar, se muestra el mensaje `** PAUSA **` y el programa espera una nueva pulsación de la tecla P. Mientras tanto, no se ejecuta el código que mueve la pelota ni la barra. Al reanudar, se borra el mensaje y el juego continúa desde donde estaba.

La lectura de teclado se realiza mediante la interrupción `INT 16h` del BIOS.

### 3.3. Corrección de impresión de números

Se modificó el procedimiento `IMPRIMIR_NUMERO` para que imprima el número recibido en el registro `AX`, en lugar de imprimir siempre la variable `puntos`.

También se actualizaron las llamadas en `MOSTRAR_INFO` y en la pantalla final para cargar el valor correspondiente en `AX` antes de llamar al procedimiento. Esta corrección permite mostrar correctamente el contador de bloques restantes.

### 3.4. Implementación del High Score

Se agregaron la variable `high_score` y el mensaje `msg_record` en la sección `.DATA`.

Al terminar la partida, el programa compara el puntaje obtenido con `high_score` y, si es mayor, lo reemplaza. El récord se muestra en las pantallas de victoria y derrota, y también en el menú principal.

El procedimiento `REINICIAR_JUEGO` no modifica `high_score`, por lo que el récord se conserva mientras el programa permanezca ejecutándose.

Estas modificaciones utilizan funciones de video de la interrupción `INT 10h` y funciones de impresión de la interrupción `INT 21h`.

### 3.5. Pantallas de victoria, derrota y reinicio

Se conservó la lógica original encargada de determinar el resultado de la partida y de reiniciarla desde el menú mediante el procedimiento `REINICIAR_JUEGO`.

Estas pantallas se integraron con el nuevo sistema de vidas y con el High Score.

## 4. Procedimientos principales

| Procedimiento o sección | Función |
|---|---|
| `.DATA` (`vidas`, `high_score`, `msg_record`, `msg_pausa`, `msg_pausa_borra`) | Nuevas variables y mensajes |
| `REINICIAR_JUEGO` | Inicialización de las vidas al comenzar la partida |
| `PERDER_VIDA` | Resta de una vida y reubicación de la pelota o fin de la partida |
| `GAME_LOOP` | Lectura de la tecla P |
| `PAUSAR` y `REANUDAR` | Pausa y reanudación de la partida |
| `MOSTRAR_INFO` | Información de vidas durante la partida |
| `IMPRIMIR_NUMERO` | Impresión del número recibido en `AX` |
| `FIN_JUEGO` | Actualización y presentación del High Score |
| `DIBUJAR_MENU` | Presentación del High Score en el menú |

## 5. Pruebas realizadas

El videojuego se compiló utilizando emu8086 y se ejecutó en DOSBox 0.74-3.

Durante las pruebas se verificaron el funcionamiento de la pausa y la reanudación con la tecla P, la visualización de las vidas, el aumento del puntaje al destruir bloques, el conteo de bloques restantes, la actualización del High Score en la pantalla final y en el menú, la conservación del récord cuando una partida obtiene menos puntos, y el reinicio de la partida desde el menú sin cerrar el programa.

También se identificó y corrigió un problema en la impresión de números: el contador de bloques restantes mostraba el puntaje.


## 6. Consideraciones para la integración

Las modificaciones se concentran en la lógica de estados y puntuación. Las funciones de física y colisiones deberán integrarse con el trabajo de los demás integrantes, en particular la línea modificada en MOVER_PELOTA para llamar a PERDER_VIDA.

El procedimiento `IMPRIMIR_NUMERO` ahora recibe el número en `AX`, por lo que cualquier llamada nueva debe cargar el valor antes de llamarlo. También se agregó una línea de información en `MOSTRAR_INFO`.

La integración completa deberá someterse a nuevas pruebas para confirmar la compatibilidad entre los diferentes módulos del proyecto.

## 7. Conclusión

Las modificaciones permitieron incorporar la pausa, el registro del High Score y la base del sistema de vidas al videojuego Breakout, aprovechando las interrupciones del BIOS y del DOS disponibles en el entorno Intel 8086.

Los cambios fueron probados progresivamente en DOSBox y registrados mediante Git, manteniendo una versión base funcional como referencia para el desarrollo colaborativo. 
