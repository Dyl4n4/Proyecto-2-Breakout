# Proyecto 2 — Breakout en Ensamblador Intel 8086

**Universidad Nacional de Costa Rica**  
**Curso:** EIF205 — Arquitectura de Computadoras  
**Proyecto:** Desarrollo y mejora de un videojuego Breakout en ensamblador Intel 8086

## 1. Descripción del proyecto

Este proyecto consiste en la implementación y mejora de un videojuego tipo **Breakout**, desarrollado en lenguaje ensamblador Intel 8086.

El objetivo del jugador es controlar una barra horizontal para mantener una pelota en movimiento y destruir los bloques ubicados en la parte superior de la pantalla.

El videojuego incorpora mejoras en la interfaz, controles, física de movimiento, detección de colisiones, administración de vidas, puntuación, pausa y registro de récord.

La versión integrada utiliza un tablero de **160 bloques**, distribuidos en 8 filas y 20 columnas.

El desarrollo se realizó de manera colaborativa mediante Git y GitHub, con los aportes de tres integrantes.

## 2. Características implementadas

- Menú principal con opciones para iniciar, consultar instrucciones y salir.
- Interfaz visual con colores y distribución de elementos en pantalla.
- Movimiento de la barra mediante las teclas A, D y flechas de dirección.
- Control de límites para impedir que la barra salga de la pantalla.
- Movimiento de pelota con rebotes en paredes, techo y barra.
- Detección de colisiones con los bloques.
- Eliminación de bloques destruidos y prevención de puntuación duplicada.
- Sistema de tres vidas por partida.
- Puntuación de 10 puntos por bloque.
- Puntuación máxima posible de 1600 puntos.
- Contador de bloques restantes.
- Pausa y reanudación del videojuego.
- Pantallas de victoria y derrota.
- Registro de High Score durante la sesión.
- Posibilidad de regresar al menú e iniciar nuevas partidas.

**Nota:** El High Score se conserva únicamente durante la ejecución del programa; no se almacena permanentemente en disco.

## 3. Herramientas utilizadas

| Herramienta | Función |
|---|---|
| emu8086 | Desarrollo, edición y compilación del código ensamblador |
| DOSBox 0.74-3 | Ejecución y pruebas del videojuego |
| Git | Control de versiones |
| GitHub | Repositorio y colaboración del equipo |
| Visual Studio Code / editores de texto | Revisión y documentación, cuando corresponda |

## 4. Estructura del repositorio

```text
Proyecto-2-Breakout/
|
|-- README.md
|-- .gitignore
|
|-- src/
|   |-- breakout.asm
|
|-- original/
|   |-- breakdown_original.asm
|   |-- ORIGEN_Y_CREDITOS.md
|
|-- docs/
|   |-- CONTRIBUCION_INTEGRANTE_1.md
|   |-- CONTRIBUCION_INTEGRANTE_2.md
|   |-- CONTRIBUCION_INTEGRANTE_3.md
|   |-- VALIDACION_FINAL.md
|   |-- VALIDACION_FINAL_evidencias.zip
|   |-- evidencias-integrante-1/
|   |-- evidencias-integrante-3/
|
|-- entrega/
|   |-- BREAKOUT.EXE
|   |-- README.md
```

### Descripción de las carpetas

**`src/`** contiene el código fuente integrado del videojuego, en el archivo `breakout.asm`.

**`original/`** conserva una copia del proyecto utilizado como punto de partida y su documentación de procedencia y créditos.

**`docs/`** contiene las contribuciones individuales, las evidencias de funcionamiento y el informe de validación técnica.

**`entrega/`** contiene el ejecutable definitivo y las instrucciones necesarias para ejecutarlo.

**`pruebas/`** se utiliza localmente para los archivos generados durante las comprobaciones, respaldos y ejecutables temporales. Estos archivos no forman parte de la entrega versionada.

### Organización del código

El videojuego está integrado en un único archivo:

`src/breakout.asm`

Esta organización fue autorizada por el profesor. Por lo tanto, no fue necesario dividir el programa en archivos `.inc`.

## 5. Ejecutar el videojuego

### 5.1 Requisitos

Se necesita tener instalado **DOSBox 0.74-3**, o una versión compatible.

El ejecutable definitivo ya está compilado, por lo que no es necesario instalar emu8086 para jugar.

### 5.2 Instrucciones de ejecución

1. Descargar o clonar el repositorio.
2. Abrir DOSBox.
3. Montar como unidad C la carpeta principal del proyecto:

```dos
mount c "C:\ruta\Proyecto-2-Breakout"
```

Sustituir la ruta de ejemplo por la ubicación real del repositorio.

4. Ingresar a la unidad montada y ejecutar el videojuego:

```dos
c:
cd \entrega
BREAKOUT
```

El menú principal debe aparecer en pantalla.

### 5.3 Velocidad de ejecución

Durante las pruebas manuales se utilizó DOSBox 0.74-3 con una referencia aproximada de **694 ciclos**.

La velocidad puede ajustarse mediante:

- `Ctrl + F11`: disminuir los ciclos.
- `Ctrl + F12`: aumentar los ciclos.

Se recomienda ajustar la velocidad hasta conseguir un movimiento adecuado de la pelota.

## 6. Controles del videojuego

| Contexto | Tecla | Acción |
|---|---|---|
| Menú principal | 1 o J | Iniciar partida |
| Menú principal | 2 o I | Mostrar instrucciones |
| Menú principal | 3 o S | Salir |
| Partida | A | Mover barra a la izquierda |
| Partida | D | Mover barra a la derecha |
| Partida | Flecha izquierda | Mover barra a la izquierda |
| Partida | Flecha derecha | Mover barra a la derecha |
| Partida | P | Pausar o reanudar |
| Partida activa | Esc | Regresar al menú |
| Pantalla de instrucciones | Cualquier tecla | Regresar al menú |
| Victoria o derrota | Enter | Regresar al menú |

Los controles de letras admiten mayúsculas y minúsculas.

Durante la pausa se utiliza la tecla P para reanudar.

## 7. Compilación desde el código fuente

Si se desea volver a compilar el videojuego:

1. Abrir emu8086.
2. Seleccionar **File → Open**.
3. Abrir `src/breakout.asm`.
4. Seleccionar **Compile**.
5. Guardar el archivo ejecutable generado.
6. Ejecutar el archivo desde DOSBox.

El archivo `entrega/BREAKOUT.EXE` corresponde a una compilación preparada y comprobada por el equipo el **2 de noviembre de 2026**.

**Identificación del ejecutable de entrega:**

| Propiedad | Valor |
|---|---|
| Nombre | `BREAKOUT.EXE` |
| Tamaño | 3796 bytes |
| Fecha de compilación reportada | 02/11/2026 |
| Compilador | emu8086 |
| Entorno de ejecución | DOSBox 0.74-3 |

**SHA-256:**

```text
C3CF31B9BFC256D22D2F211E1777A0ACFCB9DC363F211A2EB3A94FED3482499D
```

El equipo verificó que este ejecutable inicia una partida con **160 bloques, 0 puntos y 3 vidas**.

## 8. Organización del trabajo

El proyecto se desarrolló mediante una distribución de responsabilidades entre tres integrantes.

| Integrante | Responsabilidades |
|---|---|
| Integrante 1 — Sofía Delgado Salas | Interfaz, colores, controles, menú y presentación visual |
| Integrante 2 — Josua Cabrera Bonilla | Física de la pelota, límites, rebotes y colisiones |
| Integrante 3 — Stiven Salas Solano | Estados del juego, vidas, pausa, puntuación y High Score |

Las contribuciones se encuentran documentadas individualmente en:

- `docs/CONTRIBUCION_INTEGRANTE_1.md`
- `docs/CONTRIBUCION_INTEGRANTE_2.md`
- `docs/CONTRIBUCION_INTEGRANTE_3.md`

Los aportes se desarrollaron en ramas de trabajo y posteriormente se integraron en la rama `dev`.

## 9. Pruebas y validación

Las pruebas del proyecto incluyeron comprobaciones manuales, revisión del funcionamiento en DOSBox y pruebas automatizadas.

### 9.1 Pruebas de interfaz y controles

Se verificaron las opciones del menú, la visualización de instrucciones, el inicio de partidas, el movimiento de la barra y sus límites.

También se comprobaron visualmente las pantallas de juego y los controles implementados.

### 9.2 Pruebas automatizadas

La validación técnica documentó los siguientes resultados:

| Prueba | Resultado |
|---|---|
| Casos automatizados controlados en DOSBox | 59 de 59 satisfactorios |
| Combinaciones de coordenadas evaluadas | 65.536 |
| Comprobación de datos y pila durante el barrido | Sin discrepancias detectadas |
| Eliminación controlada de 160 bloques | Comprobada |
| Puntuación correspondiente a 160 bloques | 1600 puntos |
| Activación automatizada de la condición de victoria | Comprobada |

Estas pruebas utilizaron procedimientos controlados y no deben interpretarse como una partida manual completa.

### 9.3 Prueba visual de victoria

Se realizó una prueba controlada de victoria mediante una **configuración temporal del contador de 100 bloques restantes**.

La prueba permitió activar la condición de victoria y observar la pantalla correspondiente.

Durante esa configuración temporal, el arreglo del tablero conservaba sus 160 posiciones. Por lo tanto, no equivale a una partida normal con todos los bloques eliminados manualmente.

Después de la comprobación, se restauró la configuración original de 160 bloques y se generó nuevamente el ejecutable.

### 9.4 Comprobación del ejecutable de entrega

El ejecutable `BREAKOUT.EXE` fue probado en DOSBox por el equipo, verificando que al iniciar presenta los valores originales de:

- 160 bloques restantes.
- 0 puntos.
- 3 vidas.

También se corrigió en el código fuente un error ortográfico en las instrucciones, sustituyendo la palabra `volder` por `volver`.

### 9.5 Alcance de las validaciones

Las pruebas realizadas respaldan el funcionamiento de las principales rutinas del videojuego, incluyendo controles, física, colisiones, administración de vidas, puntuación y estados finales.

No se documentó una partida manual ininterrumpida hasta destruir los 160 bloques del tablero original.

Por esta razón, se distingue entre las pruebas automatizadas, las pruebas visuales controladas y las comprobaciones manuales del ejecutable definitivo.

La información detallada se encuentra en:

**[Informe de validación técnica](docs/VALIDACION_FINAL.md)**

Las evidencias automatizadas se encuentran en:

**[Paquete de evidencias](docs/VALIDACION_FINAL_evidencias.zip)**

## 10. Evidencias de funcionamiento

El repositorio conserva capturas de las funcionalidades desarrolladas.

**Integrante 1:**

- Menú principal.
- Pantalla de instrucciones.
- Partida en ejecución.
- Pantalla de derrota.
- Controles del videojuego.

**Integrante 3:**

- Sistema de vidas.
- Pausa.
- High Score.
- Derrota.
- Victoria.

Las evidencias se encuentran en las carpetas correspondientes dentro de `docs/`.

## 11. Control de versiones

El desarrollo del proyecto se administró mediante Git y GitHub.

Las ramas principales utilizadas fueron:

| Rama | Propósito |
|---|---|
| `main` | Versión estable del proyecto |
| `dev` | Integración y validación de los aportes |
| `feature/interfaz-controles` | Desarrollo de interfaz y controles |
| `feature/fisica-colisiones` | Desarrollo de física y detección de colisiones |
| `feature/estados-puntuacion` | Desarrollo de estados y puntuación |

Los cambios de las ramas de funcionalidades fueron integrados en `dev` para su validación conjunta.

## 12. Créditos y procedencia

Este proyecto utiliza como punto de partida el código de Breakout publicado por **Benjamín Solano Ortega**.

Repositorio original:

https://github.com/Benjamin-Solano/Breakout

El código original proporcionó la base inicial del videojuego. El equipo académico realizó las modificaciones y ampliaciones documentadas en las contribuciones individuales.

Para conservar la procedencia del código se incluyen:

- `original/breakdown_original.asm`
- `original/ORIGEN_Y_CREDITOS.md`

## 13. Estado del proyecto

La versión integrada del videojuego contiene las funcionalidades previstas de interfaz, controles, física, colisiones, vidas, pausa, puntuación y pantallas finales.

Se dispone de un ejecutable de entrega comprobado, documentación de contribuciones y evidencias de validación técnica.

El proyecto se encuentra en la etapa final de preparación de la entrega académica, incluyendo la incorporación del informe técnico elaborado en LaTeX.

---

**Universidad Nacional de Costa Rica — EIF205, Arquitectura de Computadoras — 2026.**
