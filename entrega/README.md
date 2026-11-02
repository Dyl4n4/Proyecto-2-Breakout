# Breakout 8086 - Instrucciones de ejecucion

## Contenido

- BREAKOUT.EXE: videojuego compilado para DOS.
- README.md: instrucciones de ejecucion.

El codigo fuente se encuentra en src/breakout.asm,
dentro del repositorio del proyecto.

## Requisitos

- DOSBox 0.74-3 o una version compatible.

## Ejecutar el videojuego

1. Abrir DOSBox.
2. Montar la carpeta principal del repositorio:

   mount c "C:\ruta\Proyecto-2-Breakout"

3. Ejecutar:

   c:
   cd \entrega
   BREAKOUT

Sustituir la ruta de ejemplo por la ubicacion real
del repositorio en la computadora.

## Controles

- J o 1: iniciar partida.
- I o 2: mostrar instrucciones.
- S o 3: salir del programa.
- A / D: mover la barra.
- Flechas izquierda / derecha: mover la barra.
- P: pausar o reanudar la partida.
- Esc: regresar al menu durante la partida.
- Enter: regresar al menu despues de ganar o perder.

## Caracteristicas

- 160 bloques distribuidos en 8 filas y 20 columnas.
- 3 vidas al iniciar.
- 10 puntos por bloque destruido.
- Puntuacion maxima: 1600 puntos.
- Registro de High Score durante la sesion.

## Compilacion

El programa fue desarrollado y compilado con emu8086.
La ejecucion fue comprobada mediante DOSBox 0.74-3.

Para consultar las pruebas realizadas, revisar
docs/VALIDACION_FINAL.md en el repositorio.
