# TIC TAC TOE Y TIC TAC STACK: ENSAMBLADOR 16 BITS MASM
Este proyecto implementa el juego clásico "Tres en Raya" (Tic-Tac-Toe) en lenguaje ensamblador de 16 bits.

## Descripción
El juego utiliza la consola como interfaz de usuario, permite a los jugadores alternar turnos para realizar movimientos en un tablero de juego 3x3 e ir verificando si hay un ganador.
Pueden encontrar 2 versiones del juego:
## PRIMERA VERSIÓN:
La primera fase implementa el tic tac toe que se conoce de manera general en donde su lógica de juego es por turnos ir poniendo en casillas X u O hasta formar una línea de 3 de la misma figura, logrando así vencer en el juego.
<p align="center">  
<img src="https://github.com/MonicaGilgon/tic-tac-stack-asm/issues/1" />
</p>

## SEGUNDA FASE:
<p align="center">  
<img src="https://github.com/MonicaGilgon/tic-tac-stack-asm/issues/2" />
</p>
La segunda fase implementa sobre el tic tac toe anterior, un tic tac stack el cual lo diferencia el hecho de poder quitarle una posición ya establecida por el adversario.
Esto no se hace a la ligera, sino que es permitido cuando la nueva pieza X u O es más grande que la pieza que ocupaba previamente la casilla.


Todo lo anterior fue desarrollado en lenguaje ensamblador en estructura de 16 bits, utilizando principalmente lo aprendido en clases y reforzando de manera autónoma por fuera del aula lo necesario para llevarlo 
a feliz término.

## Características
- Implementación en lenguaje ensamblador 16 bits.
- Consola como interfaz de usuario para para I/O.
- Diseñado para turnar 2 jugadores.
- Verifica ganador después de cada movimiento válido.
- Mensajes (errores, instrucciones e informes del estado de la partida).

## Instrucciones de Uso
- Descarga el código fuente a ejecutar desde este repositorio, ya sea xo1 ó xo2.
- Ejecutar Masm xo1.asm;
- Ejecutar Link xo1;
- Ejecuta el programa resultante con xo1.exe
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Desarrollado por:
- Mónica Gil González
- CLara Inés Porras Mancilla
- José Julián Contreras Veras
  
Desarrollado para insignia de tercera nota y examen final en la materia dirigida por el ingeniero Miguel Fabian Robles Angarita Arquitectura de computadores grupo B, adscrito a la Universidad Francisco de Paula Santander.
