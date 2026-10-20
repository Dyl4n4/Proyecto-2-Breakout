# Contribución del Integrante 1: Interfaz y controles

## 1. Objetivo

Desarrollar y mejorar la interfaz visual y los controles del videojuego Breakout implementado en lenguaje ensamblador Intel 8086, conservando su funcionalidad original y utilizando DOSBox como entorno de ejecución.

## 2. Herramientas utilizadas

- **Lenguaje:** ensamblador Intel 8086.
- **Compilador:** emu8086.
- **Entorno de ejecución:** DOSBox 0.74-3.
- **Configuración de prueba:** aproximadamente 694 ciclos de CPU.
- **Control de versiones:** Git y GitHub.

## 3. Modificaciones realizadas

### 3.1. Implementación de controles A y D

Se modificó la lectura del teclado dentro del ciclo principal del juego para permitir que el jugador controle la barra mediante las teclas A y D, además de conservar las flechas izquierda y derecha.

La lectura de teclado se realiza mediante la interrupción `INT 16h` del BIOS.

También se modificó el desplazamiento horizontal de la barra, pasando de una posición a dos posiciones por movimiento detectado y estableciendo límites para impedir que salga del área de juego.

### 3.2. Mejoras del menú principal

Se modificó la presentación visual del menú utilizando distintos colores para sus opciones y elementos decorativos.

Además de las opciones numéricas originales, se incorporaron atajos mediante el teclado:

- **J:** iniciar partida.
- **I:** mostrar instrucciones.
- **S:** salir del programa.

Se conservó el diseño original del título BREAKOUT.

### 3.3. Actualización de las instrucciones

Se actualizó la pantalla de instrucciones para informar sobre los controles A/D y las flechas.

También se incorporaron colores para diferenciar el título, los controles, el objetivo del juego y las indicaciones para regresar al menú.

### 3.4. Mejoras visuales durante la partida

Se realizaron las siguientes modificaciones:

- Barra del jugador en color celeste.
- Pelota en color amarillo brillante.
- Bloques distribuidos en franjas de diferentes colores.
- Borde superior celeste.
- Información de controles visible durante la partida.
- Mejoras en el borrado de la barra para evitar residuos visuales.
- Ocultamiento del cursor de texto durante la ejecución.

Estas modificaciones utilizan funciones de video de la interrupción `INT 10h` del BIOS.

### 3.5. Pantallas de victoria y derrota

Se modificó la presentación de los resultados del juego mediante títulos de colores, líneas decorativas e instrucciones para regresar al menú.

Se conservó la lógica original encargada de determinar el resultado de la partida.

### 3.6. Corrección de impresión de textos

Se mejoró el procedimiento `IMPRIMIR_MENU_COLOR` para calcular automáticamente la longitud de las cadenas terminadas en `$`.

Esta corrección evita que se impriman caracteres adicionales o fragmentos de otras variables durante la presentación de los mensajes.

## 4. Procedimientos principales

| Procedimiento o sección | Función |
|---|---|
| `GAME_LOOP` | Lectura del teclado y actualización de controles |
| `DIBUJAR_MENU` | Presentación del menú principal |
| `DIBUJAR_INSTRUCCIONES` | Presentación de instrucciones |
| `MOSTRAR_INFO` | Información durante la partida |
| `DIBUJAR_PALETA` | Representación visual de la barra |
| `BORRAR_PALETA_ANTERIOR` | Limpieza de la posición anterior de la barra |
| `DIBUJAR_PELOTA` | Representación visual de la pelota |
| `DIBUJAR_BLOQUES` | Representación de los bloques |
| `IMPRIMIR_MENU_COLOR` | Impresión de cadenas con atributos de color |
| `LIMPIAR_PANTALLA` | Preparación visual de las pantallas |

## 5. Pruebas realizadas

El videojuego se compiló utilizando emu8086 y se ejecutó en DOSBox 0.74-3 con aproximadamente 694 ciclos.

Durante las pruebas se verificaron el funcionamiento de los controles, la navegación por el menú, la visualización de los elementos gráficos y el comportamiento de la pelota después de los cambios de apariencia.

También se identificó y corrigió un problema en la impresión de las instrucciones.

## 6. Consideraciones para la integración

Las modificaciones se concentran en la interfaz y la lectura del teclado. Las funciones de física, colisiones y puntuación deberán integrarse con el trabajo de los demás integrantes.

La integración completa deberá someterse a nuevas pruebas para confirmar la compatibilidad entre los diferentes módulos del proyecto.

## 7. Conclusión

Las modificaciones permitieron mejorar la presentación visual y la interacción del usuario con el videojuego Breakout, aprovechando las interrupciones del BIOS disponibles en el entorno Intel 8086.

Los cambios fueron probados progresivamente en DOSBox y registrados mediante Git, manteniendo una versión base funcional como referencia para el desarrollo colaborativo.
