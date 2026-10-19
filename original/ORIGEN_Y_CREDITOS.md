# Origen y créditos del código fuente

## 1. Información general

**Proyecto:** Breakout — Proyecto 2 de Arquitectura de Computadoras  
**Curso:** EIF205 — Arquitectura de Computadoras  
**Institución:** Universidad Nacional de Costa Rica  
**Lenguaje:** Ensamblador Intel 8086  
**Emulador:** emu8086

## 2. Código fuente original

El desarrollo de este proyecto toma como referencia una implementación existente del videojuego Breakout, publicada en GitHub por Benjamín Solano Ortega.

**Información de referencia:**

- **Autor original:** Benjamín Solano Ortega.
- **Repositorio:** https://github.com/Benjamin-Solano/Breakout
- **Archivo fuente:** https://github.com/Benjamin-Solano/Breakout/blob/main/Codigo/breakdown.asm
- **Nombre del archivo original:** `breakdown.asm`.
- **Copia conservada en este proyecto:** `original/breakdown_original.asm`.
- **Lenguaje de programación:** Ensamblador 8086.
- **Entorno indicado por el autor:** emu8086.
- **Fecha de consulta:** 19 de octubre de 2026.

El repositorio de referencia contiene una implementación funcional según la descripción de su autor, con rutinas para controlar la barra, mover la pelota, detectar colisiones, destruir bloques y administrar los estados básicos del juego.

La ejecución y compatibilidad de la versión original en el entorno utilizado por nuestro equipo se verificarán durante la etapa inicial del proyecto.

## 3. Justificación de la selección

Se seleccionó este código porque utiliza ensamblador Intel 8086 y está orientado al entorno emu8086, empleado en el curso.

Su estructura incluye procedimientos identificables para la representación de los elementos, el movimiento de la pelota, la detección de colisiones y la administración general del juego.

Estas características permiten estudiar su funcionamiento, corregir problemas e incorporar modificaciones propias sin desarrollar toda la aplicación desde cero.

## 4. Modificaciones previstas

El equipo realizará las siguientes modificaciones respecto al código original:

### Cambio 1. Interfaz gráfica y controles

- Sustituir los controles originales mediante flechas por las teclas A y D.
- Modificar las dimensiones y la apariencia de la barra.
- Rediseñar los bloques y su distribución en pantalla.
- Mejorar la presentación de los menús y los indicadores del juego.
- Corregir problemas detectados en la visualización de información.

**Responsable:** Integrante 1.

### Cambio 2. Sistema de vidas y pausa

- Implementar un sistema de tres vidas.
- Permitir que la pelota se reinicie después de perder una vida.
- Agregar una función de pausa y reanudación.
- Adaptar la lógica de movimiento y colisiones a las nuevas condiciones del juego.

**Responsables principales:** Integrantes 2 y 3, según la distribución de módulos.

### Cambio 3. Puntuación máxima y estados finales

- Incorporar un sistema de High Score.
- Mejorar la visualización de la puntuación.
- Modificar las pantallas de victoria y derrota.
- Permitir iniciar una nueva partida sin reiniciar el emulador.

**Responsable:** Integrante 3, con apoyo del Integrante 1 para la visualización.

Estas modificaciones corresponden a la planificación inicial y podrán ajustarse durante el desarrollo, documentando los cambios realizados.

## 5. Organización del trabajo

El proyecto será desarrollado por tres integrantes mediante un repositorio compartido de GitHub.

Cada integrante trabajará en una rama independiente:

- `feature/interfaz-controles`: interfaz y controles.
- `feature/fisica-colisiones`: movimiento, rebotes y colisiones.
- `feature/estados-puntuacion`: vidas, pausa, puntuación y estados.

La rama `dev` se utilizará para integrar y probar los cambios, mientras que `main` conservará la versión estable del proyecto.

## 6. Conservación del código original

El archivo `original/breakdown_original.asm` se mantendrá sin modificaciones para conservar una referencia verificable del programa utilizado como punto de partida.

Las modificaciones del equipo se realizarán en archivos independientes dentro de `src/`.

Esta separación permitirá comparar el funcionamiento y la estructura de la versión original con la versión desarrollada para el Proyecto 2.

## 7. Reconocimiento de autoría y condiciones de uso

Se reconoce a Benjamín Solano Ortega como autor del código fuente original utilizado como referencia.

El equipo académico será responsable de las modificaciones, nuevas funcionalidades, pruebas, documentación e integración realizadas durante el proyecto.

La descripción del repositorio original indica un propósito educativo y permite su utilización y modificación para fines no comerciales. No obstante, esta declaración no se considera por sí sola una licencia de software formal.

Antes de distribuir públicamente versiones modificadas, se deberán revisar las condiciones aplicables y, cuando corresponda, obtener la autorización del autor original.

El presente documento busca mantener la transparencia sobre la procedencia del código y diferenciar el trabajo original de las contribuciones realizadas por el equipo.

## 8. Referencias

Solano Ortega, B. (2025). *Breakout* [Código fuente en ensamblador 8086]. GitHub. https://github.com/Benjamin-Solano/Breakout

**Fecha de consulta:** 19 de octubre de 2026.
