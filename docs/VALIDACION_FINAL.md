# Validación técnica final de Breakout 8086

Fecha: 2 de noviembre de 2026 (America/Costa_Rica). Curso EIF205.

## Estado vigente — revisión del 2 de noviembre de 2026

Este resumen incorpora el complemento final del equipo sobre el artefacto de entrega y prevalece sobre los estados pendientes de C01/R01 de las secciones históricas. Se revisó `origin/dev` en `aa5d687d23abafab957d4756bfd5454b7473f122`.

| Comprobación | Estado vigente | Origen y alcance de la evidencia |
|---|---|---|
| C01 — compilación y ejecución del artefacto definitivo | Aprobado por comprobación manual del equipo | El equipo reporta compilación con emu8086 y ejecución de `entrega/BREAKOUT.EXE` en DOSBox. Codex no repitió esa ejecución ni la compilación en esta revisión. |
| R01 — restauración a 160 bloques | Aprobado por comprobación manual del equipo, con contraste estático independiente | El equipo observó 160 bloques, 0 puntos y 3 vidas al iniciar. Codex comprobó fuente, hash, tamaño e inmediato del contador en el EXE definitivo. El `BASE.exe` temporal no es el artefacto de entrega. |
| V02 — pantalla de victoria con contador temporal 100 | Resultado reportado por el equipo; evidencia específica pendiente de incorporar | El arreglo conservaba 160 entradas. La captura histórica `evidencias-integrante-3/05-victoria.png` no identifica esta prueba y no se reutiliza para acreditarla. |
| V01 — partida manual completa con 160 bloques | Pendiente | Ni los 59 casos controlados ni la victoria con contador 100 acreditan una partida normal completa hasta victoria. |

**Artefacto vigente:** [entrega/BREAKOUT.EXE](../entrega/BREAKOUT.EXE), 3.796 bytes. SHA-256 comprobado independientemente en esta revisión:

`C3CF31B9BFC256D22D2F211E1777A0ACFCB9DC363F211A2EB3A94FED3482499D`

La inspección estática del EXE encuentra `C7 06 AA 00 A0 00` en el offset de archivo 0B84h: inicializa `bloques_restantes` en 160. Sus 1.876 bytes de código coinciden con el ejecutable histórico utilizado en la validación original. Esto es una comparación de artefactos, no una prueba nueva de ejecución. El fuente integrado conserva 160 entradas activas, reinicio a 160, 0 puntos y 3 vidas; “volder” está corregido a “volver”.

Los resultados **59/59** y el barrido de **65.536 coordenadas** siguen perteneciendo a las ejecuciones independientes originales de Codex, con los binarios y configuraciones identificados en su ZIP histórico. No se atribuyen de nuevo al EXE de entrega por el solo hecho de que su código coincida. Se conservan íntegros los registros anteriores para trazabilidad.

La revisión del inventario encuentra diez capturas PNG versionadas y catorce capturas JPEG en el ZIP histórico. `evidencias-integrante-3/05-victoria.png` se incorporó en el commit `67e4fe2` del 20/10/2026 y muestra GANASTE con 10 puntos y récord 10: no es evidencia inequívoca de la prueba posterior con contador 100. Las capturas JPEG del ZIP tampoco documentan esa prueba posterior. Se debe incorporar la captura específica con su procedencia; V02 no cambia por ello a ejecución independiente de Codex.

**Pendientes de entrega:** incorporar el informe técnico final elaborado por otro integrante en LaTeX (y su PDF para lectura), incorporar la evidencia específica de V02 y mantener V01 como pendiente hasta documentarla. El repositorio sigue parcialmente validado; no debe describirse como completamente validado.

## Resultado y alcance de la ejecución original

La versión de la ejecución original fue `dev`, commit `738b1a6797e48f15827c59fcf6aa6b5e4519cd9e`, igual a `origin/dev` tras `git fetch origin`. Se conservó el archivo local sin seguimiento `pruebas/base/BASE.exe_BKP17636` y los ejecutables/auxiliares ignorados. No había cambios en archivos versionados al comenzar.

**59/59 casos controlados pasaron en DOSBox**, además de un barrido de **65.536 combinaciones x,y sin discrepancias de datos ni pila**. También se ejecutó el binario sin instrumentación mediante la interfaz gráfica. Se encontró **un error menor de texto**. La matriz de aquella ejecución conserva **26 aprobados, 1 fallido y 2 pendientes**; “aprobado” se limita al procedimiento y estados realmente probados.

**Al cerrar aquella revisión**, el `BASE.exe` local conservaba el contador temporal de 100 y se dejó pendiente confirmar el ejecutable definitivo de 160 bloques y documentar una partida libre completa hasta victoria. C01/R01 se resolvieron posteriormente para `entrega/BREAKOUT.EXE`, según el resumen vigente; V01 continúa pendiente. No se confunden las pruebas aisladas con una campaña completa de integración.

Durante la ejecución original Codex no modificó `src/breakout.asm`, no lo dividió en módulos y no se editaron documentos o evidencias existentes. No se hicieron commits, push, merges ni PR. Solo se añaden este informe y su paquete de evidencias. El trabajo se hizo sobre `dev` sin cambiar de rama.

## Entorno y procedencia

- emu8086 instalado en `C:\emu8086\emu8086.exe`; los auxiliares del binario existente identifican assembler 4.08.
- DOSBox 0.74-3 instalado. **Sí hubo acceso gráfico** y observación independiente de instrucciones, partida, pausa, reanudación, controles, derrota, récord y menú.
- FASM 1.64 ya instalado como parte de emu8086: se utilizó para ensamblar exclusivamente los controladores de prueba temporales. Python 3.14 procesó los registros. No se instalaron herramientas.
- Pruebas aisladas: DOSBox `core=normal`, `cputype=auto`, `cycles=max`. Sesión gráfica sin instrumentación: `cycles=fixed 694`. DOSBox no se presenta como una comprobación de tiempos eléctricos de un 8086 físico. Un primer arranque especificó `cputype=8086`, valor que DOSBox rechazó y sustituyó por `auto`; las configuraciones finales guardadas usan explícitamente `auto`.
- La nueva instancia de emu8086 no pudo iniciarse (`Reasignación no válida del archivo DLL del sistema` / `spawn UNKNOWN`). Se usó el editor abierto para intentar compilar una copia byte a byte. El ensamblado llegó al diálogo de guardado, pero las ventanas anidadas no mantuvieron el foco fiable. La entrada accidental afectó solo al búfer de la copia temporal, no se guardó y no afectó al fuente del equipo. **No se certifica una compilación nueva ni se atribuye este problema del entorno al programa.**
- Se reutilizó una copia de `pruebas/base/BASE.exe` (3.796 bytes). Sus instrucciones, declaraciones y cadenas en `BASE.exe.~asm` coinciden con el fuente actual al quitar comentarios y espacios externos. Se compararon **2.257 bytes descritos por el listado** contra el ejecutable, incluyendo **los 1.876/1.876 bytes de código**. La coincidencia no sustituye una compilación reproducible desde cero.

SHA-256 del fuente antes y después: `1c3e6e2e1726c719d10af65f02f827086f96809dc6525becc2bd276e1662042c`.

SHA-256 del EXE reutilizado: `c959b3ab614de8fe27c7cfafc45733390bb3758e0f6bd673c691effc1cb2293d`.

## Metodología e instrumentación temporal

El directorio temporal estuvo fuera del repositorio: `C:\Users\sophie\Documents\Codex\2026-11-02\files-pasted-by-the-user-tarea\work\validacion-8086`.

1. `BASE.EXE` es una copia sin cambios del ejecutable existente. La sesión gráfica cargó esta copia, con su cabecera y reubicación originales.
2. `HARNESS.ASM` incluye los bytes originales de datos y código, configura su propio segmento DS y llama a las rutinas reales. No reimplementa la física en Python. Solo en esa copia se sustituyen por `RET` los primeros bytes de `NO_TECLA`, `ESPERAR_ENTER` y `MOSTRAR_MENU` (offsets de código 00FFh, 019Dh y 0008h). Así se puede regresar al controlador en lugar de continuar un bucle, esperar Enter o entrar al menú. Esto limita las afirmaciones sobre temporización y navegación hechas a partir de ese controlador.
3. Los estados controlados cambian únicamente datos de la copia: posiciones y direcciones, puntos, bloques, vidas y récord. Para controles se inyectan teclas mediante BIOS INT 16h/AH=05h. La prueba de 160 bloques posiciona la pelota sobre cada bloque: **no es una partida ganada jugando de principio a fin**.
4. Cada caso escribe ID, 1.152 bytes del segmento de datos y 4.000 bytes de memoria de video B800h. `RESULT.BIN` tiene 59 registros de 5.154 bytes (304.086 bytes). `evaluar_pruebas.py` coteja resultados explícitos y extrae las 59 pantallas TXT. Estos TXT son lecturas de memoria de video real, **no capturas inventadas ni imágenes generadas**.
5. `MEMORIA.ASM` incluye el código de colisiones sin los tres parches anteriores. Recorre todos los pares x,y de 0 a 255, reinicia la matriz antes de cada llamada, establece la posición previa fuera de la franja de bloques y compara todo el segmento de datos del juego contra un estado esperado independiente basado en sus rectángulos. También comprueba SP. Resultado: 0 discrepancias y 472 coordenadas con impacto (8 filas × (19×3+2) posiciones). No comprueba toda la RAM, ni toda combinación de direcciones, registros o estado corrupto; complementa los casos laterales y de movimiento del otro controlador.
6. El análisis estático revisó los procedimientos y las condiciones de límites. Solo complementa la ejecución: ninguna aprobación de la matriz se basa exclusivamente en que el código parece correcto.

## Antecedentes del equipo

La Integrante 1 reportó como correctas en DOSBox las seis pruebas de interfaz solicitadas: menú J/I/S, A/D, flechas, límites de barra, textos/instrucciones y Escape. Se registra ese antecedente como **reporte previo**, no como ejecución independiente de Codex. La documentación está en [CONTRIBUCION_INTEGRANTE_1.md](CONTRIBUCION_INTEGRANTE_1.md) y sus cinco capturas originales permanecen intactas en [evidencias-integrante-1](evidencias-integrante-1/). La afirmación específica de que las seis fueron correctas procede también de la solicitud del usuario.

Los [documentos del Integrante 2](CONTRIBUCION_INTEGRANTE_2.md) y [del Integrante 3](CONTRIBUCION_INTEGRANTE_3.md), y las capturas del Integrante 3, son antecedentes conservados. Sus resultados no se contabilizan como nuevas aprobaciones. La matriz siguiente describe las comprobaciones realizadas ahora.

## Matriz histórica de resultados de la ejecución original

Evidencia técnica completa: [VALIDACION_FINAL_evidencias.zip](VALIDACION_FINAL_evidencias.zip). “Caso NN” identifica `resultados.json` y `pantalla-NN.txt` dentro del paquete. Las capturas citadas están en `capturas/`; el manifiesto conserva sus fechas en UTC−06:00 y sus hashes. Los nombres 10 y 13 se corrigieron en el paquete para reflejar que esas imágenes muestran derrota, no retorno al menú.

| ID | Funcionalidad evaluada | Procedimiento utilizado | Resultado esperado | Resultado obtenido | Tipo de verificación | Estado | Evidencia disponible |
|---|---|---|---|---|---|---|---|
| I01 | Menú J/I/S y opciones numéricas | I, J, S, 1 y 2 en sesión sin instrumentar; inspección de pantalla | Navegar y salir correctamente | I/2: instrucciones; J/1: partida; S: salida de BASE y DOSBox (código 0). Opción 3 no ejercitada directamente | ejecución | aprobado | Capturas 02,03,04,12,15; registro-sesion.json |
| I02 | Movimiento A/D | Inyectar A y D en cola BIOS y ejecutar GAME_LOOP real; observar A en partida | Mover dos columnas por pulsación | x=35→33 con A; x=35→37 con D. A observado también en ejecución libre | automatización y ejecución | aprobado | Casos 39,40,43,44; captura 08 |
| I03 | Flechas | Inyectar scan codes 4Bh/4Dh; observar flecha derecha | Desplazamiento izquierdo/derecho | x=33 y x=37, respectivamente; flecha derecha observada en ejecución libre | automatización y ejecución | aprobado | Casos 45,46; captura 09 |
| I04 | Límites horizontales de barra | Ejecutar 40 desplazamientos por dirección desde x=35 | Mantener barra dentro del área visible | Satura en x=1 y x=67; ancho visible 12 caracteres | automatización | aprobado | Casos 41,42 |
| I05 | Textos e instrucciones | Leer instrucciones en DOSBox y memoria B800h | Textos legibles y sin errores ortográficos | Se muestran los textos; aparece “Presiona ESC para volder al menu” | ejecución y automatización | fallido | Capturas 02,15; caso 49; hallazgo D01 |
| I06 | Escape | Escape durante partida activa; comprobar pantalla siguiente | Volver al menú | Menú visible y récord de sesión conservado | ejecución y automatización | aprobado | Captura 14; caso 48 |
| E01 | Inicialización | REINICIAR_JUEGO, dibujar y leer datos/video; iniciar con J | 3 vidas, 0 puntos, 160 bloques | 3 / 0 / 160; 160 entradas activas | automatización y ejecución | aprobado | Caso 01; captura 04 |
| E02 | Pausa | P en partida, esperar 4,6 s y pulsar A; cola BIOS P,A,D,P en ensayo aislado | Detener pelota y barra | Misma posición en capturas separadas 4,6 s; A/D ignoradas durante pausa | ejecución y automatización | aprobado | Capturas 05,06; caso 47 |
| E03 | Reanudación | Volver a pulsar P en sesión pausada | Quitar PAUSA y continuar desde el estado detenido | Desaparece el aviso y cambia la posición de pelota | ejecución y automatización | aprobado | Capturas 06,07; caso 47 |
| E04 | Puntuación | Impactar bloques activos, volver a impactar uno eliminado y recorrer tablero | +10 por bloque; sin duplicados | 10 por primer impacto; 1600 tras 160 eliminaciones únicas | automatización | aprobado | Casos 14,31,34; RESULT.BIN |
| E05 | Pérdida de una vida | MOVER_PELOTA desde (20,23), dx=dy=+1 fuera de barra | Restar una vida y reubicar pelota | Vidas 3→2; pelota (40,18), dy=-1 | automatización | aprobado | Caso 08 |
| E06 | Conservar progreso | Destruir un bloque y después forzar caída por MOVER_PELOTA | Mantener puntos y bloques restantes | 2 vidas, 10 puntos, 159 bloques y 159 entradas activas | automatización | aprobado | Caso 12 |
| E07 | Derrota | PERDER_VIDA tres veces y FIN_JUEGO; observar también derrota natural | Terminar al agotar tres vidas | vidas=0, juego_activo=0 y texto PERDISTE; derrota natural observada | automatización y ejecución | aprobado | Caso 13; captura 10-derrota-natural.jpg |
| E08 | High Score de sesión | Puntajes 200,100,200 en final; regresar al menú de partida natural | Actualizar máximo y conservarlo en nuevas partidas | 200 se conserva con 100 e igualdad; récord natural 150 visible en menú. No es persistencia en disco | automatización y ejecución | aprobado | Casos 35–38; capturas 10,11,14 |
| E09 | Reinicio desde menú | Enter tras derrota, opción 1 y lectura inicial | Restaurar partida conservando récord | 3 vidas, 0 puntos, 160 bloques; high_score aislado=200 y menú de sesión=150 | ejecución y automatización | aprobado | Caso 38; capturas 11,12 |
| E10 | Dígitos residuales | MOSTRAR_INFO sin limpiar entre 160,100,99,98,10,9,8,1,0; reinicio real | No dejar cifras anteriores | B:99 y B:9 quedan seguidos de espacios; reinicio muestra 0 y V:3 sin restos. No es una prueba de todas las cadenas posibles | automatización y ejecución | aprobado | Casos 51–59, pantallas TXT; captura 12 |
| F01 | Ambas paredes | MOVER_PELOTA desde x=1 con dx=-1 y x=79 con dx=+1 | Rebotar y mantener límites | x=1/dx=+1 y x=79/dx=-1 | automatización | aprobado | Casos 02,03 |
| F02 | Techo | MOVER_PELOTA desde y=1 y dy=-1 | No invadir fila 0; bajar | y=1 y dy=+1 | automatización | aprobado | Caso 04 |
| F03 | Mitad izquierda de barra | Desde (36,22), dirección (+1,+1) | Subir hacia izquierda | (37,22), dx=-1, dy=-1 | automatización | aprobado | Caso 05; borde en caso 09 |
| F04 | Mitad derecha de barra | Desde (43,22), dirección (+1,+1) | Subir hacia derecha | (44,22), dx=+1, dy=-1 | automatización | aprobado | Caso 06; borde en caso 10 |
| F05 | Caída sin tocar barra | Posición fuera del ancho visible; comprobar dirección ascendente por separado | No inventar rebote; descontar vida al llegar a fila 24 | Fuera de barra sigue bajando; caída resta una vida; al subir no rebota | automatización | aprobado | Casos 07,08,11 |
| F06 | Bloques activos | Colisión en posiciones activas y lectura de matriz/video | Eliminar una entrada y sumar 10 | 160→159 entradas; +10; dirección lateral/vertical distinguida | automatización | aprobado | Casos 14,15,17,32,33 |
| F07 | Espacios entre bloques | Colisión x=5 y x=77; barrido completo de coordenadas | No eliminar ni puntuar espacios | 0 puntos y 160 bloques; barrido coincide con geometría esperada | automatización | aprobado | Casos 16,18; MEMORIA.BIN |
| F08 | Bloque ya destruido | Llamar dos veces con la misma posición | No sumar ni restar dos veces | 10 puntos y 159 bloques tras ambos impactos | automatización | aprobado | Caso 31 |
| F09 | Columnas 78 y 79 | Colisiones directas en ambas coordenadas | Alcanzar último bloque y borrar dos caracteres | En ambos casos +10 y 159 bloques; índices válidos | automatización | aprobado | Casos 19,20; barrido de memoria |
| F10 | Victoria al eliminar 160 bloques | Recorrer una posición de cada bloque; ejecutar FIN_JUEGO | 1600 puntos, 0 bloques y GANASTE | 1600 / 0; matriz vacía, juego_activo=0 y GANASTE en memoria de video | automatización | aprobado | Caso 34; pantalla-34.txt. Partida libre hasta victoria: V01 pendiente |
| F11 | Límites de memoria e índices | 65.536 pares x,y de byte; comparar 1.152 bytes de datos con oráculo y SP tras cada colisión; revisar bucles | Solo cambios de bloque/puntos/dirección autorizados; pila equilibrada | 0 discrepancias; 472 posiciones válidas. Estáticamente índice=(y-2)*20+col, rango 0..159 | automatización y análisis estático | aprobado | MEMORIA.ASM, MEMORIA.BIN, memoria-resumen.json; casos 14–30 |
| C01 | Nueva compilación emu8086 | Abrir copia idéntica y pulsar Compile | Guardar nuevo EXE y ejecutar ese artefacto | Llegó al diálogo de guardado; el control de foco falló y no se confirmó un EXE nuevo. Se probó BASE.exe existente cotejado | ejecución | pendiente | Descripción de entorno y procedencia.json; sin aprobación de compilación nueva |
| V01 | Partida completa integrada hasta victoria | Jugar de inicio a victoria sin alterar estados | Confirmar todo el recorrido y presentación final en uso real | No realizada; victoria únicamente en banco controlado | ejecución | pendiente | Plan manual mínimo; caso 34 no sustituye esta prueba |

## Validación complementaria del equipo — 2 de noviembre de 2026

### Reporte recibido y alcance

El usuario comunica que corrigió “volder” por “volver”, recompiló en emu8086, obtuvo una captura de victoria con una configuración temporal descrita como 100 bloques activos y, después, restauró 160 y recompiló. Se registra como **reporte del equipo**, no como ejecución independiente de Codex. La prueba de victoria es controlada y no equivale a una partida normal de 160 bloques.

La captura nueva se menciona en el reporte, pero no se adjuntó ni se identificó una ruta nueva en este complemento. No se ha inspeccionado esa imagen ni se atribuyen a ella valores de marcador no comunicados. Las evidencias del ZIP anterior permanecen intactas y corresponden a la ejecución original.

### Contraste histórico con los archivos locales (anterior al artefacto de entrega)

- Fuente actual en `dev`: commit `97b7f9d6d99d74cc12a9b9fd5b2339dfce8fd1bf`. Tiene “volver”, `bloques DB 160 DUP(1)`, `MOV CX, 160` en el reinicio y `MOV bloques_restantes, 160`. **La restauración del fuente sí queda comprobada mediante análisis estático.**
- SHA-256 actual de `src/breakout.asm`: `741ceff9113f11814467f3f78d3ef27c679d582b4a64ada7dd8b79725a78bdab`. Difiere del hash histórico por la corrección posterior del equipo; Codex no modificó ese archivo.
- `pruebas/base/BASE.exe.~asm` difiere del fuente actual en una instrucción: conserva `MOV bloques_restantes, 100`. El listado del compilador muestra `C7 06 AA 00 64 00` en LOC 0984h.
- El EXE confirma esos mismos bytes en el offset de archivo **0B84h** (offset de código 0404h): `64 00` es el inmediato 100. Con 160 el inmediato sería `A0 00`. Su SHA-256 es `fb5a0dc382adb5eb698b570afacec2177c7d223fdaad529b7e9d226dcd6229a2`; tamaño 3.796 bytes.
- El código de ese EXE difiere del ejecutable histórico en un único byte: el inmediato del contador pasó de A0h a 64h. Por tanto, no puede considerarse comprobado como ejecutable definitivo restaurado a 160.
- En la copia compilada siguen declarándose 160 entradas activas y el bucle de reinicio recorre 160; **el cambio observable afecta al contador a 100, no a una matriz reducida a 100 entradas activas**. Esa condición puede disparar la victoria después de 100 eliminaciones, aunque queden 60 entradas activas. Esto explica la condición controlada sin convertirla en una victoria normal del tablero completo.

Estas observaciones no niegan que exista otra compilación restaurada en una ruta distinta; esa ruta no está identificada aquí. Se conservan los archivos tal como se encontraron.

| ID | Funcionalidad evaluada | Procedimiento utilizado | Resultado esperado | Resultado obtenido | Tipo de verificación | Estado | Evidencia disponible |
|---|---|---|---|---|---|---|---|
| C01 (complemento) | Compilación definitiva restaurada | Reporte del usuario; comparar fuente, copia del compilador y bytes EXE | Artefacto compilado con contador 160 | Recompilación reportada; BASE.exe local conserva 100 | reporte previo y análisis estático del artefacto | pendiente | BASE.exe.~asm, listado, bytes y hashes arriba |
| V02 | Presentación de victoria bajo condición temporal | Prueba controlada comunicada por el usuario | Mostrar pantalla de victoria | Pantalla y captura obtenidas según el usuario; imagen no examinada por Codex | reporte previo | aprobado | Reporte del usuario de 2/11/2026; captura mencionada sin ruta identificada |
| R01 | Restauración de la versión definitiva | Leer inicialización del fuente y contrastar el EXE local | Fuente y ejecutable con contador 160 | Fuente restaurado; EXE local todavía con 100 | análisis estático | pendiente | Fuente, diferencia con BASE.exe.~asm e inmediato 64 00 en el EXE |
| V01 | Partida normal completa hasta victoria | Revisión del alcance de las pruebas comunicadas | Ganar con 160 bloques sin cambios temporales | Sigue sin documentarse; la prueba de 100 no la sustituye | reporte previo | pendiente | Declaración explícita del usuario |

La aprobación V02 expresa un resultado **reportado por el equipo**; no se suma a los 59 casos automatizados ni a las ejecuciones independientes anteriores. Los estados de este complemento corresponden a esa revisión del BASE.exe; el resumen vigente al inicio recoge la resolución posterior de C01/R01 para BREAKOUT.EXE y mantiene V01 pendiente. La matriz anterior conserva la trazabilidad de lo observado antes de la corrección.

## Errores y observaciones

### D01 — Error ortográfico visible (menor)

La ejecución original mostró **“volder al menu”**, en DOSBox y en la lectura B800h del caso 49. La causa estaba en `inst_linea4` de `.DATA`. **Corrección posterior confirmada en el fuente local:** el commit `97b7f9d6d99d74cc12a9b9fd5b2339dfce8fd1bf` sustituye “volder” por “volver”; la diferencia de fuente entre ambos commits se limita a esa cadena. El usuario reporta recompilación. Codex no volvió a ejecutar la pantalla corregida. El fallo de la matriz se conserva como resultado histórico anterior a la corrección.

### Aspectos de diseño que requieren criterio del equipo

- El High Score se actualiza en `MOSTRAR_MSG`, al finalizar por victoria o derrota. Escape abandona la partida sin pasar por esa actualización. El README ya lo distingue. No se clasifica como fallo sin un requisito de que abandonar también deba registrar récord; conviene confirmar el criterio académico antes de cambiarlo.
- Durante la pausa solo P reanuda; Escape se ignora. Es coherente con la rutina implementada. Si se desea salida directa desde pausa, requiere un cambio de alcance y una nueva prueba.
- Las instrucciones no explican P, las tres vidas ni el récord. Es una oportunidad de documentación de la interfaz, además del error ortográfico. No se cambió la aplicación.
- No se detectaron fallos funcionales en los 59 casos ejecutados ni discrepancias en el barrido de la rutina de colisiones. Esto no demuestra ausencia universal de defectos de integración, temporización o entrada física sostenida.

## Análisis estático complementario

`REINICIAR_JUEGO` inicializa 160 entradas, puntos, vidas y estado; conserva `high_score`. `PERDER_VIDA` no reinicia la matriz ni puntos. La colisión valida 2≤y≤9 y 2≤x≤79 antes de calcular `(y-2)*20+columna`, con columna 0..19 y comprobación adicional de índice menor que 160. Los espacios con resto 3 se excluyen y la última columna acepta sus dos caracteres. Los bucles de reinicio/dibujo recorren índices 0..159.

`MOVER_PELOTA` solo rebota en la barra cuando baja; discrimina las dos mitades. El marcador borra un espacio tras el número de bloques y el reinicio limpia la pantalla. El valor máximo normal de puntos es 1600, dentro de una palabra de 16 bits. Las rutinas examinadas preservan los registros declarados y equilibran PUSH/POP; el barrido verificó SP para las llamadas de colisión. Estas son conclusiones estáticas complementadas por los casos indicados, no nuevas pruebas manuales aprobadas.

## Intervención manual registrada antes del ejecutable de entrega

Esta lista se conserva como antecedente: C01/R01 ya se completaron por comprobación manual del equipo para BREAKOUT.EXE; V01 sigue pendiente.

1. **C01 / R01:** el usuario reporta recompilación después de restaurar 160 bloques, pero el `BASE.exe` local y sus auxiliares conservan `MOV bloques_restantes, 100`. Confirmar si el EXE definitivo se guardó en otra ruta o compilar el fuente restaurado y guardarlo con un nombre nuevo. Cotejar fuente/auxiliares/binario y ejecutar esa versión comprobando B:160 al iniciar. Registrar ruta y hash; no reemplazar archivos del equipo sin autorización.
2. **V01:** realizar una partida completa hasta victoria con el ejecutable sin instrumentación, guardar la pantalla final de 1600 puntos/0 bloques, volver con Enter e iniciar otra partida comprobando el récord. El caso controlado ya validó la eliminación de las 160 entradas y la salida GANASTE, por lo que no hace falta repetir manualmente cada coordenada de bloque.

Como comprobación de usabilidad adicional, se recomienda mantener pulsadas A/D y flechas, alternarlas rápidamente y pausar cerca de una colisión. Los casos existentes cubren pulsaciones y saturación de límites, pero no todas las condiciones de repetición del teclado físico. No se presenta esta recomendación como un fallo observado.

## Evidencias y reproducción

El paquete incluye las copias de fuente y binario usadas, listado/símbolos del compilador, generadores, controladores ASM/EXE, configuraciones, registros binarios, resultados JSON y capturas reales. Los EXE instrumentados son exclusivamente de prueba y no deben entregarse como videojuego final. `procedencia.json` y `MANIFIESTO.json` permiten identificar los artefactos.

Para repetir en este mismo equipo, extraer el paquete en una carpeta de pruebas, conservar allí `BASE.EXE` y usar el FASM existente para ensamblar `HARNESS.ASM` y `MEMORIA.ASM`. Las configuraciones guardadas usan la ruta temporal de esta sesión: adaptar solo la ruta del `mount c` a la carpeta extraída antes de ejecutar DOSBox con `-conf`. `HARNESS.EXE` produce `RESULT.BIN`; `MEMORIA.EXE` produce `MEMORIA.BIN`. `evaluar_pruebas.py` procesa el primero. No es necesario instalar dependencias Python adicionales.

Las capturas 05 y 06 están separadas por aproximadamente 4,6 segundos y muestran la pausa sin desplazamiento; 07 muestra la reanudación. La captura 10 muestra la primera derrota natural, 11 el menú con récord 150, 12 el reinicio a 0/160/3 y 14 el retorno al menú con Escape durante otra partida. La salida con S se comprobó por cierre de BASE y código de salida 0 de la sesión nueva de DOSBox; la sesión de DOSBox que estaba abierta antes de la tarea se conservó.

Comprobaciones de conservación de la ejecución original (históricas): SHA-256 del fuente idéntico al inicial; `git diff` de archivos versionados vacío; `git diff --check` sin errores. No se cambió ningún archivo existente del equipo. El estado final de Git contiene únicamente este informe y su ZIP como archivos nuevos, además del archivo local sin seguimiento que ya existía.

## Conclusión histórica de la revisión de BASE.exe

Los resultados originales siguen documentando 59 casos controlados aprobados y el barrido de 65.536 coordenadas sin discrepancias de datos o pila. El equipo corrigió el texto en el fuente y reporta recompilación y una pantalla de victoria en una prueba controlada. Esa victoria no representa una partida normal con 160 bloques.

El contraste actual confirma la restauración del fuente, pero encuentra el contador temporal de 100 en `pruebas/base/BASE.exe`. Se debe identificar o producir el ejecutable definitivo restaurado antes de cerrar C01/R01. Permanece pendiente V01: documentar una partida normal completa hasta victoria con la configuración original de 160 bloques. El proyecto sigue parcialmente validado.

## Complemento final — Verificación del ejecutable de entrega

**Fecha:** 2 de noviembre de 2026.

Posteriormente a la validación original, el equipo generó mediante emu8086 un nuevo ejecutable denominado `FINAL.EXE`, correspondiente al código fuente restaurado a su configuración original de 160 bloques.

El ejecutable fue incorporado al repositorio como `entrega/BREAKOUT.EXE`, con un tamaño de 3796 bytes y la siguiente identificación SHA-256:

`C3CF31B9BFC256D22D2F211E1777A0ACFCB9DC363F211A2EB3A94FED3482499D`

El equipo confirmó manualmente su ejecución en DOSBox, verificando que una nueva partida comienza con 160 bloques restantes, 0 puntos y 3 vidas.

En consecuencia, se considera **completada la comprobación manual de compilación y ejecución del artefacto de entrega**. Esta verificación complementa los registros históricos correspondientes al ejecutable anterior `BASE.exe`, que conservaba un contador temporal de 100.

La prueba visual de victoria se realizó con una configuración temporal del contador de 100 bloques. Las pruebas automatizadas comprobaron separadamente la condición de victoria mediante la eliminación de los 160 bloques. No se documentó una partida manual completa de inicio a victoria con la configuración original.

## Conclusión vigente

El ejecutable de entrega está identificado y versionado; C01/R01 están completados según la comprobación manual del equipo, complementada con la inspección estática independiente del artefacto. Los hallazgos del BASE.exe temporal se mantienen como antecedentes y no describen BREAKOUT.EXE. V01 sigue pendiente y falta incorporar la captura inequívoca de V02. La incorporación del informe técnico final en LaTeX y su revisión deben preceder a la integración final hacia main.
