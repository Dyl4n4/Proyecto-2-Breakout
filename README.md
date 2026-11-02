# Proyecto 2 – Breakout en Ensamblador 8086

## Descripción

Videojuego tipo Breakout desarrollado en ensamblador Intel 8086 para el Proyecto 2 del curso EIF205 — Arquitectura de Computadoras.

El jugador controla una barra para mantener una pelota en movimiento, destruir bloques y acumular puntos.

La versión integrada incorpora los aportes de los tres integrantes en un único archivo [src/breakout.asm](src/breakout.asm), conforme a la autorización del profesor. El tablero contiene 160 bloques (8 filas por 20 columnas), con 10 puntos por bloque destruido. Cada partida comienza con tres vidas; al perder una, la pelota vuelve al punto de salida si quedan vidas. Destruir todos los bloques muestra la victoria; agotar las vidas muestra la derrota.

## Herramientas necesarias

- **emu8086:** utilizado para editar y compilar el código ensamblador.
- **DOSBox 0.74-3:** utilizado para ejecutar y probar el videojuego.
- **Git y GitHub:** utilizados para el control de versiones y el trabajo colaborativo.

**Importante:** el entorno de ejecución definido para el proyecto es DOSBox.

## 1. Instalación de DOSBox

1. Ingresar a la página oficial: https://www.dosbox.com/download.php?main=1
2. Buscar la versión **DOSBox 0.74-3**.
3. Descargar el instalador correspondiente a Windows.
4. Ejecutar el archivo descargado.
5. Seguir los pasos del asistente de instalación.
6. Abrir **DOSBox 0.74-3** desde el menú Inicio.

Al abrirse, aparecerá una ventana de comandos de DOSBox.

## 2. Preparar emu8086

1. Instalar emu8086 en la computadora.
2. Abrir el programa.
3. Seleccionar **File → Open**.
4. Buscar el archivo `src/breakout.asm` dentro del repositorio.
5. Presionar **Compile**.
6. Guardar el ejecutable generado en la carpeta `pruebas/base` con el nombre `BASE.EXE`.

La carpeta `pruebas/base` puede crearse manualmente si todavía no existe.

Los archivos auxiliares que genere emu8086 no son necesarios para ejecutar el videojuego.

## 3. Ejecutar el juego en DOSBox

Primero se debe compilar el código fuente y generar `BASE.EXE`.

### Montar el repositorio

Abrir DOSBox y ejecutar:

```dos
mount c "C:\ruta\Proyecto-2-Breakout"
c:
```

Sustituir `C:\ruta\Proyecto-2-Breakout` por la ubicación real del repositorio en la computadora.

### Ingresar a la carpeta del ejecutable

```dos
cd \pruebas\base
dir
```

Verificar que aparezca `BASE.EXE`.

### Iniciar el juego

```dos
BASE
```

El menú principal del videojuego debería aparecer en pantalla.

## 4. Configuración de velocidad

Las pruebas iniciales documentadas usaron **DOSBox 0.74-3 con aproximadamente 694 ciclos de CPU**. Esta velocidad es una referencia; no constituye una validación completa de la versión integrada.

Si la pelota se mueve demasiado rápido:

- Presionar **Ctrl + F11** para disminuir los ciclos.
- Presionar **Ctrl + F12** para aumentarlos.

Se recomienda ajustar la velocidad hasta aproximadamente **694 ciclos** antes de jugar.

## 5. Controles y funcionamiento

| Contexto | Tecla | Acción |
|---|---|---|
| Menú | 1 o J | Iniciar una partida con tres vidas |
| Menú | 2 o I | Mostrar instrucciones |
| Menú | 3 o S | Salir del programa |
| Partida | A / flecha izquierda | Mover la barra a la izquierda |
| Partida | D / flecha derecha | Mover la barra a la derecha |
| Partida | P | Pausar; pulsar P otra vez para reanudar |
| Partida activa | Esc | Volver al menú |
| Instrucciones | Cualquier tecla | Volver al menú |
| Victoria o derrota | Enter | Volver al menú y poder iniciar otra partida |

Los atajos con letras aceptan mayúsculas y minúsculas. Durante la pausa se espera P para continuar; la pelota y la barra permanecen detenidas.

El marcador muestra puntos, bloques restantes y vidas. El **High Score** se actualiza al finalizar una partida y se muestra en el menú y en las pantallas finales. Se conserva entre partidas durante la misma ejecución del programa; no se guarda en disco. Volver al menú con Esc no pasa por la actualización del récord de fin de partida.

La física integrada limita los rebotes en paredes y techo, detecta la paleta solo cuando la pelota baja y orienta el rebote según la mitad de la barra alcanzada. Las colisiones con bloques distinguen espacios vacíos e impactos laterales o verticales, permiten alcanzar la última columna y evitan volver a puntuar un bloque destruido.

## 6. Estructura del repositorio

```text
Proyecto-2-Breakout/
├── README.md
├── .gitignore
├── src/
│   └── breakout.asm
├── original/
│   ├── breakdown_original.asm
│   └── ORIGEN_Y_CREDITOS.md
└── docs/
    ├── CONTRIBUCION_INTEGRANTE_1.md
    ├── CONTRIBUCION_INTEGRANTE_2.md
    ├── CONTRIBUCION_INTEGRANTE_3.md
    ├── evidencias-integrante-1/  (5 capturas)
    └── evidencias-integrante-3/  (5 capturas)
```

El código integrado permanece en un solo archivo, sin módulos `.inc`. La copia [original/breakdown_original.asm](original/breakdown_original.asm) conserva el punto de partida sin modificaciones.

`pruebas/base/` puede contener el ejecutable y los auxiliares locales de emu8086, excluidos por `.gitignore`. También se excluye el ejecutable local `original/breakdown.exe`. Estos archivos se conservan en disco. `pruebas/` y `entrega/` no necesitan archivos de relleno: la entrega se incorporará cuando existan archivos definitivos. No se excluyen indiscriminadamente todos los ejecutables, por lo que se puede versionar uno de entrega cuando corresponda.

## 7. Organización del equipo

| Integrante | Aportes integrados | Documentación |
|---|---|---|
| Integrante 1 | Interfaz, colores, controles A/D y flechas, atajos del menú y presentación de pantallas finales | [Contribución 1](docs/CONTRIBUCION_INTEGRANTE_1.md) |
| Integrante 2 | Física, límites, rebotes en paleta y colisiones con bloques | [Contribución 2](docs/CONTRIBUCION_INTEGRANTE_2.md) |
| Integrante 3 | Tres vidas, pausa, impresión numérica, puntuación y High Score de sesión | [Contribución 3](docs/CONTRIBUCION_INTEGRANTE_3.md) |

Las capturas se conservan en [evidencias del Integrante 1](docs/evidencias-integrante-1/) y [evidencias del Integrante 3](docs/evidencias-integrante-3/).

Los tres aportes están integrados en `dev`. Los documentos individuales conservan su historial técnico y sus consideraciones de integración. La revisión y validación del conjunto preceden a la entrega estable en `main`.

## 8. Estado actual y pruebas documentadas

La implementación integrada incluye controles, vidas, pausa, puntuación, récord de sesión, física mejorada y pantallas de victoria y derrota. Esta descripción se basa en el código actual; no implica que se haya ejecutado una nueva prueba completa durante la organización del repositorio.

- El documento del Integrante 1 registra compilación con emu8086 y ejecución en DOSBox 0.74-3 a aproximadamente 694 ciclos, con comprobaciones de controles, menú y presentación visual.
- El documento del Integrante 3 registra pruebas de pausa, vidas, puntuación, bloques restantes, High Score, reinicio y estados finales, con capturas conservadas.
- El documento del Integrante 2 recoge ocho comprobaciones funcionales reportadas y una matriz con validaciones pendientes. Faltan evidencias de física y casos límite como espacios entre bloques, última columna, bloques ya destruidos, techo y último bloque.

Debe completarse la validación de la versión integrada en DOSBox, incluido el High Score tras los cambios de física. Las pruebas de las contribuciones no sustituyen esa comprobación conjunta. Las instrucciones anteriores de compilación y ejecución siguen siendo el procedimiento para realizarla.

## 9. Créditos y referencia del código original

Este proyecto utiliza como punto de partida el código de Breakout publicado por **Benjamín Solano Ortega**.

Repositorio original: https://github.com/Benjamin-Solano/Breakout

El código original aportó la base del juego, el movimiento, las colisiones, los bloques y los estados básicos. Las mejoras de interfaz y controles, física y colisiones, vidas, pausa y récord descritas en este README corresponden al equipo académico y se detallan en sus documentos de contribución.

La procedencia y los créditos se conservan en [original/ORIGEN_Y_CREDITOS.md](original/ORIGEN_Y_CREDITOS.md), junto con la copia del código original.
