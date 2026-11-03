# Breakout 8086 - Instrucciones de ejecucion

## Contenido

- BREAKOUT.EXE: videojuego compilado para DOS.
- README.md: instrucciones de ejecucion.

El codigo fuente integrado se encuentra en [src/breakout.asm](../src/breakout.asm),
dentro del repositorio del proyecto, en un unico archivo autorizado por el profesor.

## Requisitos

- DOSBox 0.74-3 o una version compatible.

## Ejecutar el videojuego

1. Abrir DOSBox.
2. Montar la carpeta principal del repositorio:

   ```dos
   mount c "C:\ruta\Proyecto-2-Breakout"
   ```

3. Ejecutar:

   ```dos
   c:
   cd \entrega
   BREAKOUT
   ```

Sustituir la ruta de ejemplo por la ubicacion real
del repositorio en la computadora.

## Controles

- J o 1: iniciar partida.
- I o 2: mostrar instrucciones.
- S o 3: salir del programa.
- A / D: mover la barra.
- Flechas izquierda / derecha: mover la barra.
- P: pausar o reanudar la partida.
- Esc: regresar al menu durante la partida activa; durante la pausa se espera P.
- Enter: regresar al menu despues de ganar o perder.
- Cualquier tecla en instrucciones: regresar al menu.

Las letras aceptan mayusculas y minusculas.

## Caracteristicas

- 160 bloques distribuidos en 8 filas y 20 columnas.
- 3 vidas al iniciar.
- 10 puntos por bloque destruido.
- Puntuacion maxima: 1600 puntos.
- Registro de High Score durante la sesion; se actualiza al terminar por victoria o derrota y no se guarda en disco. Salir al menu con Esc no actualiza el record.

## Compilacion

El programa fue desarrollado y compilado con emu8086.
La ejecucion fue comprobada mediante DOSBox 0.74-3.

El artefacto de entrega tiene 3796 bytes y SHA-256:

```text
C3CF31B9BFC256D22D2F211E1777A0ACFCB9DC363F211A2EB3A94FED3482499D
```

El equipo confirmo manualmente que inicia en DOSBox con 160 bloques, 0 puntos y 3 vidas. La revision de Codex comprobo hash, tamano e inicializacion del contador en el binario; no repitio esa ejecucion. Las pruebas originales de Codex documentan 59/59 casos controlados y 65.536 coordenadas sin discrepancias en los artefactos historicos.

La victoria visual con contador temporal de 100 fue una prueba controlada, con un arreglo de 160 entradas; no corresponde a una partida normal completa y su captura especifica esta pendiente de incorporar. V01 (partida manual completa hasta victoria con 160 bloques) sigue pendiente. No se declara validacion completa.

El informe tecnico final en LaTeX y su PDF todavia estan siendo preparados por otro integrante y no forman parte de esta carpeta. El detalle de resultados y antecedentes se conserva en [VALIDACION_FINAL.md](../docs/VALIDACION_FINAL.md).

## Creditos y condiciones de uso

Codigo original: Benjamin Solano Ortega, [Benjamin-Solano/Breakout](https://github.com/Benjamin-Solano/Breakout). Los aportes del equipo se distinguen en el README principal y en las contribuciones individuales. La ausencia de una licencia formal identificable y el alcance de la declaracion de uso educativo/no comercial quedan como asunto de revision antes de ampliar la distribucion publica; no se agregan permisos en nombre del autor. Consultar [ORIGEN_Y_CREDITOS.md](../original/ORIGEN_Y_CREDITOS.md).
