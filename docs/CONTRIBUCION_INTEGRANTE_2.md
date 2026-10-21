# Contribución del Integrante 2 — Física y colisiones

**Proyecto:** Breakout EIF205, emu8086 (8086, modo texto 80×25).  
**Rama de trabajo:** `feature/fisica-colisiones`.  
**Archivo de producción modificado:** `src/breakout.asm`.  
**Base:** archivo `breakout.asm` compartido por el equipo (rama `dev`), con controles A/D, tres vidas, pausa, marcador y High Score implementados por los demás integrantes.  
**Estado (21/10/2026):** el integrante informó que compiló el código y ejecutó la versión modificada en DOSBox. Ocho pruebas funcionales básicas fueron reportadas como correctas; aún faltan evidencias y pruebas de casos límite. El reporte se basa en observaciones del integrante, no en ejecución independiente aquí.

## Alcance exacto del cambio

El equipo continúa usando un solo archivo `.asm`; **no se introdujeron nuevos módulos `.inc`**. Se conservan la pantalla de 80 columnas, **8 filas × 20 columnas = 160 bloques**, los menús, los controles A/D, la pausa y el sistema de tres vidas. La parte del Integrante 2 se concentró en:

- Dos variables añadidas a `.DATA`, inmediatamente después de `pelota_dy`: `fisica_x_previa` y `fisica_y_previa`. Almacenan la posición anterior de la pelota antes de cada actualización.
- Sustitución completa del procedimiento `MOVER_PELOTA`. Calcula coordenadas, evita salirse de los límites, rebota en el techo y en la paleta, y llama a las rutinas existentes `VERIFICAR_COLISION_BLOQUES` y `PERDER_VIDA`.
- Sustitución completa de `VERIFICAR_COLISION_BLOQUES`. Calcula la columna y el índice de bloque, ignora los espacios entre ellos, permite destruir los bloques del extremo derecho, evita puntuar dos veces por el mismo bloque, borra solamente la zona afectada y distingue impactos horizontales/verticales.

La versión base hacía colisión al llegar a x=78 y desplazaba la pelota hacia x=77, dificultando alcanzar la última columna de bloques (que empieza en x=78). Además consideraba bloques los espacios de separación, sin comprobar el resto del cálculo `(x - 2) / 4`.

## Geometría utilizada (coincide con el código actual del grupo)

- Filas con bloques: `2..9` (8 filas).
- Columnas de bloques: `0..19` (20 columnas).
- Inicio de columna c: `x = 2 + 4*c`.
- Cada bloque ocupa tres caracteres (restos 0,1,2) y deja un espacio de separación (resto 3).
- Bloque final (columna 19): se dibuja en las columnas 78 y 79, con **solo dos caracteres** por límite del modo texto.
- Índice dentro de `bloques`: `(y - 2)*20 + columna`, entre 0 y 159.
- El jugador mueve una paleta situada en `paleta_y=23`; la paleta dibujada tiene `paleta_ancho + 2` caracteres.
- La pelota usa `dx` y `dy` de `1` o `255`, donde `255` representa `-1` como byte.

## Cambios en `MOVER_PELOTA`

1. Se almacenan `fisica_x_previa` y `fisica_y_previa`.
2. Se actualizan coordenadas con `pelota_dx` y `pelota_dy`.
3. Pared izquierda: limitar x a 1 y fijar dx a +1. Pared derecha: permitir x=79 y fijar dx a -1. Esto hace alcanzable la última columna de bloques.
4. Techo: limitar y a 1 y fijar dy a +1.
5. Rebotar contra la paleta **solo cuando `pelota_dy` es +1** y la pelota llega a `paleta_y`, con x dentro del ancho visible.
6. Después del golpe, colocar la pelota sobre la paleta, subir (`dy=-1`) y ajustar la dirección horizontal: mitad izquierda (`dx=-1`) y mitad derecha (`dx=+1`).
7. Delegar destrucción de bloques y puntuación al procedimiento de colisiones; al llegar a la fila 24 sin rebote, llamar a `PERDER_VIDA` del Integrante 3.

## Cambios en `VERIFICAR_COLISION_BLOQUES`

1. Se rechazan posiciones fuera de las filas 2 a 9 o columnas 2 a 79.
2. Se divide `(x - 2)` entre 4: cociente = columna; residuo = posición interna de la celda.
3. Se ignora `resto=3`: espacio vacío entre bloques. Para última columna, se admiten solo restos 0 y 1.
4. Se calcula el índice lineal, se confirma que esté dentro de 160 y se revisa `bloques[indice] != 0`.
5. Solo entonces se cambia el bloque a cero, se resta un bloque restante y se suman 10 puntos.
6. Se limpia visualmente el bloque mediante `INT 10h`, AH=09h, con espacio y atributo normal; ancho 3 o 2 si es el último.
7. Al chocar, si la trayectoria entró desde una celda lateral o desde un hueco (y antes estaba dentro de la franja vertical de bloques), se invierte dx. En los otros casos se invierte dy.
8. Si quedan cero bloques, se pone `juego_activo=0` para conservar la pantalla de victoria que ya existe.

**Registros preservados:** `MOVER_PELOTA` salva/restaura AX, BX, CX y DX; `VERIFICAR_COLISION_BLOQUES` salva/restaura AX, BX, CX, DX y SI con operaciones PUSH/POP balanceadas.

## Resultados funcionales reportados por el Integrante 2 — 21/10/2026

El integrante ejecutó la versión modificada y reportó **ocho comprobaciones correctas**:

| Prueba observada | Resultado informado | Evidencia pendiente |
|---|---|---|
| Inicio desde el menú y controles A/D | Correcto | Captura en partida |
| Rebote general contra paredes | Correcto | Captura o video de borde izquierdo/derecho |
| Rebote en mitad izquierda de la paleta | Correcto | Captura o video |
| Rebote en mitad derecha de la paleta | Correcto | Captura o video |
| Destrucción de bloques al impactar | Correcto | Captura de bloque desaparecido |
| Puntuación de 10 puntos por bloque | Correcto | Captura de marcador |
| Continuación después de perder una vida | Correcto | Captura del contador de vidas |
| Pausa y reanudación con P | Correcto | Captura de pausa |

**No se debe presentar como comprobado todavía:** paso entre espacios sin destruir bloques, última columna x=78/79, impacto sobre un bloque ya eliminado sin sumar otra vez, techo en y=1 y victoria después de destruir el último bloque. El High Score tampoco se ha validado explícitamente en el reporte reciente.

Al integrar, añadir en `pruebas/fisica/` las capturas correspondientes y actualizar la matriz siguiente con fecha, resultado y archivo de evidencia. Evitar afirmar «todas las pruebas aprobadas» mientras queden estos casos sin validar.

## Matriz de pruebas (marcar únicamente resultados observados)

| ID | Escenario | Resultado esperado | Resultado | Evidencia |
|---|---|---|---|---|
| FIS-01 | Pelota contra borde izquierdo | Permanece entre x=1..79, gira a derecha | Pendiente | Captura/video |
| FIS-02 | Pelota contra borde derecho | No se sale de x=79, gira a izquierda | Pendiente | Captura/video |
| FIS-03 | Pelota contra techo | No invade fila 0, empieza a bajar | Pendiente | Captura/video |
| FIS-04 | Rebote en mitad izquierda de paleta | Pelota sube hacia izquierda | Aprobado (reportado) | Captura/video pendiente |
| FIS-05 | Rebote en mitad derecha de paleta | Pelota sube hacia derecha | Aprobado (reportado) | Captura/video pendiente |
| FIS-06 | Pelota bajando fuera de la paleta | Se descuenta una sola vida | Continuación aprobada; descenso único por confirmar | Captura/video pendiente |
| FIS-07 | Pasar por espacio entre bloques (resto=3) | No desaparece bloque ni suma puntos | Pendiente | Captura/video |
| FIS-08 | Golpe sobre bloque activo | Desaparece un bloque, +10 puntos | Aprobado (reportado) | Captura/video pendiente |
| FIS-09 | Volver a pasar por bloque destruido | No hay nuevos puntos | Pendiente | Captura/video |
| FIS-10 | Impactar en la última columna (x=78/79) | Se destruye bloque del borde, sin dibujar fuera | Pendiente | Captura/video |
| FIS-11 | Destruir último bloque del tablero | Termina y muestra victoria | Pendiente | Captura/video |
| FIS-12 | Integración: A/D, pausa P, tres vidas, récord, menú | Nada de lo anterior deja de funcionar | Parcial: A/D, pausa, menú y pérdida de vida; récord pendiente | Captura/video pendiente |

En pruebas difíciles de alcanzar por juego normal, se puede usar el depurador de emu8086 para establecer temporalmente posiciones/estados. **No entregar una versión con valores de prueba permanentes.**

## Comprobación y entrega

1. Guardar una copia de seguridad del `.asm` actual; después sustituir **solo** `src/breakout.asm` por el archivo terminado suministrado.
2. Abrir `src/breakout.asm` en emu8086 y pulsar **Compile**. Si muestra error, registrar mensaje y línea; no subir sin resolverlo.
3. Ejecutar `breakout.exe` producido por emu8086 en DOSBox y completar las pruebas anteriores. Documentar fecha, resultado y capturas.
4. Comprobar los cambios con `git status` y `git diff -- src/breakout.asm`.
5. Agregar únicamente los archivos de tu aportación y realizar commit en tu rama:

```cmd
git add src/breakout.asm docs/CONTRIBUCION_INTEGRANTE_2.md
git commit -m "feat(fisica): corregir colisiones y rebotes de Breakout"
git push origin feature/fisica-colisiones
```

6. Solicitar revisión y luego un Pull Request **de `feature/fisica-colisiones` hacia `dev`**. El merge hacia `dev` requiere aprobación del grupo.

## Autoría y atribución

Código base: repositorio público [Benjamin-Solano/Breakout](https://github.com/Benjamin-Solano/Breakout), adaptado anteriormente en la rama `dev` del equipo. Conservar atribución del código original en README e informe y distinguir el código propio de las funciones previamente implementadas por los demás integrantes.
