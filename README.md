# Proyecto 2 – Breakout en Ensamblador 8086

## Descripción

Desarrollo de un videojuego tipo Breakout utilizando lenguaje ensamblador Intel 8086, como parte del Proyecto 2 del curso de Arquitectura de Computadoras.

El jugador controla una barra para mantener una pelota en movimiento, destruir bloques y acumular puntos.

El proyecto parte de una implementación existente de Breakout, que será adaptada y ampliada por el equipo.

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

Durante las pruebas iniciales se comprobó que el juego funciona correctamente en **DOSBox 0.74-3 con aproximadamente 694 ciclos de CPU**.

Si la pelota se mueve demasiado rápido:

- Presionar **Ctrl + F11** para disminuir los ciclos.
- Presionar **Ctrl + F12** para aumentarlos.

Se recomienda ajustar la velocidad hasta aproximadamente **694 ciclos** antes de jugar.

## 5. Controles del juego

En la versión base original:

- **Flecha izquierda:** mover la barra hacia la izquierda.
- **Flecha derecha:** mover la barra hacia la derecha.

Los controles y las demás funcionalidades podrán cambiar durante el desarrollo del proyecto.

## 6. Estructura del repositorio

```text
Proyecto-2-Breakout/
├── original/      # Código fuente original y créditos
├── src/           # Código fuente en desarrollo
├── pruebas/       # Pruebas y ejecutables locales
├── docs/          # Documentación técnica
├── entrega/       # Archivos de entrega final
└── README.md      # Instrucciones del proyecto
```

El archivo principal de desarrollo es `src/breakout.asm`.

El código ubicado en `original/` debe conservarse sin modificaciones para mantener una referencia de la implementación utilizada como punto de partida.

## 7. Organización del equipo

El trabajo se divide en tres áreas principales:

| Integrante | Responsabilidad |
|---|---|
| Integrante 1 | Interfaz del videojuego y controles |
| Integrante 2 | Física, movimiento y colisiones |
| Integrante 3 | Estados del juego, puntuación y récord |

Cada integrante desarrollará sus modificaciones en su propia rama de Git.

La rama `dev` se utilizará para integrar y probar los cambios del equipo antes de llevarlos a `main`.

## 8. Estado actual

La versión base fue compilada satisfactoriamente mediante emu8086 y ejecutada en DOSBox 0.74-3.

**Configuración comprobada:**
- Ejecutable de prueba: `BASE.EXE`.
- Tamaño del ejecutable: 2.813 bytes.
- Velocidad de referencia: 694 ciclos.
- Estado: versión base funcional.

Las nuevas características se implementarán progresivamente y deberán probarse nuevamente en DOSBox.

## 9. Créditos y referencia del código original

Este proyecto utiliza como punto de partida el código de Breakout publicado por **Benjamín Solano Ortega**.

Repositorio original: https://github.com/Benjamin-Solano/Breakout

La información de procedencia y los créditos correspondientes se conservan también en `original/ORIGEN_Y_CREDITOS.md`.

Las modificaciones desarrolladas por el equipo serán documentadas como parte del proyecto académico.
