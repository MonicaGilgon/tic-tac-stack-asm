.model small	;inicio del modelo de memoria a manejar
.386		
.stack 512	;inicio del SS 
.data		;inicio del DS tradicional
    salto_linea db 13, 10, "$"
    jugador db "x$"
    cambio_jugador db "                     Turno jugador $"
    GF db 0	;bandera ganador 
    ganador db "                     Gana jugador: $"
    puntero db 9 DUP(?)
    pos_casilla db " Ingresa una casilla (1-9):$"
    casillas db "                          _|_|_", 13, 10
             db "                          _|_|_", 13, 10
             db "                          _|_|_", 13, 10, "$"
   mensaje_tama db " Ingrese medida ficha (1-2):$"
   tam_pieza db 0
   mensaje_error1 db "Casilla no admitida, intente nuevamente :D$"
   mensaje_error2 db "Medida no admitida, intente nuevamente :D$"
   mensaje_error3 db "No puedes reemplazar esta casilla, intente nuevamente :D$"

    
.code		;inicio del CS tradicional
inicio proc near	;inicio del proceso principal del programa
    mov     ax, @data	;cargar la dir. DS en el AX con @Data
    mov     ds, ax	;copia la dir. al ds
    mov     es, ax	;copia la dir. al es
    call    limpiar_pantalla   
    call    puntero_juego  ;inicio juego


main:
    call    limpiar_pantalla

    lea     dx, cambio_jugador
    call    sout

    lea     dx, jugador
    call    sout

    lea     dx, salto_linea
    call    sout

    lea     dx, casillas
    call    sout

    lea     dx, salto_linea
    call    sout

    lea     dx, pos_casilla
    call    sout

    call    cap_pos_casilla    ;captura por teclado la posición de casilla a ocupar
    sub     al, 49 	;calcula para dibujar la casilla a ocupar
    mov     bh, 0
    mov     bl, al

    lea     dx, salto_linea
    call    sout
   
    call   cap_tam    ;captura tamaño de la pieza

    call    act_casillas
         
    call    revisa_ganador	;revisa si hay ganador	   
    cmp     GF, 1
    je      GF_on    
    call    turnar	;else sigue jugando
    jmp     main


turnar:
    lea     si, jugador
    cmp     byte ptr ds:[si], "x"
    je      turnar_o
    jmp     turnar_x
    ret

turnar_x:
    mov byte ptr ds:[si], "x"
    ret
turnar_o:
    mov byte ptr ds:[si], "o"
    ret


act_casillas:
    mov bl, puntero[bx]
    mov dl, ds:[bx]

    ; Verificar si la casilla está vacía
    cmp dl, "_"
    je mov_casilla

    lea si, jugador
    cmp byte ptr ds:[si], "x"
    je validar_reemplazo_x
    jmp validar_reemplazo_o

validar_reemplazo_x:
    cmp tam_pieza, 1
    je tam1
    jmp tam2  
    jmp mov_casilla

validar_reemplazo_o:
    cmp tam_pieza, 1
    je tam1
    jmp tam2
    jmp mov_casilla

tam1:
    cmp dl, "x"
    je error_reemplazo
    cmp dl, "X"
    je error_reemplazo
    cmp  dl, "o"
    je   error_reemplazo
    cmp  dl, "O"
    je   error_reemplazo
    jmp mov_casilla

tam2:
    cmp dl, "O"
    je error_reemplazo
    cmp dl, "X"
    je error_reemplazo
    jmp mov_casilla


error_reemplazo:
    lea dx, salto_linea
    call sout
    lea dx, mensaje_error3
    call sout
    lea dx, salto_linea
    call sout
    jmp main

mov_casilla:
    lea si, jugador
    cmp ds:[si], byte ptr "x"
    je mov_x
    jmp mov_o

mov_x:
    cmp tam_pieza, 1
    je mov_x1
    jmp mov_x2

mov_o:
    cmp tam_pieza, 1
    je mov_o1
    jmp mov_o2

mov_x1:
    mov cl, "x"
    jmp act

mov_x2:
    mov cl, "X"
    jmp act

mov_o1:
    mov cl, "o"
    jmp act

mov_o2:
    mov cl, "O"
    jmp act

act:
    mov ds:[bx], cl
    ret

revisa_ganador:
    call revisa_cruz
    call revisa_diagonales
    ret

revisa_cruz:	;revisa filas y columnas    
    mov si, 0	;revisa primera fila y columna
    mov di, 0
    call rev_cruz
    
    mov si, 3	;revisa segunda fila y columna
    mov di, 1
    call rev_cruz

    mov si, 6	;revisa tercera fila y columna
    mov di, 2
    call rev_cruz
    ret

rev_cruz:    ;revisa fila
    mov bh, 0
    mov bl, puntero[si]
    mov al, ds:[bx]
    cmp al, "_"
    je fin_rev
    
    inc si
    mov bl, puntero[si]
    call es_equivalente
    jne fin_rev

    inc si
    mov bl, puntero[si]
    call es_equivalente
    jne fin_rev

    mov GF, 1	;hay ganador
    ret

fin_rev:	;revisa columna
    mov si, di
    mov bh, 0
    mov bl, puntero[si]
    mov al, ds:[bx]
    cmp al, "_"
    je fin_rev_columna

    add si, 3
    mov bl, puntero[si]
    call es_equivalente
    jne fin_rev_columna

    add si, 3
    mov bl, puntero[si]
    call es_equivalente
    jne fin_rev_columna

    mov GF, 1	;hay ganador
    ret

fin_rev_columna:
    ret

revisa_diagonales:    
    mov si, 0	;revisa primera diagonal
    mov dx, 4
    call rev_diagonal
    
    mov si, 2	;revisa segunda diagonal
    mov dx, 2
    call rev_diagonal
    ret

rev_diagonal:
    mov bh, 0
    mov bl, puntero[si]
    mov al, ds:[bx]
    cmp al, "_"
    je fin_rev_diagonal

    add si, dx
    mov bl, puntero[si]
    call es_equivalente
    jne fin_rev_diagonal

    add si, dx
    mov bl, puntero[si]
    call es_equivalente
    jne fin_rev_diagonal
    
    mov GF, 1	;hay ganador
    ret

fin_rev_diagonal:
    ret


es_equivalente: 	;compara la celda actual con la celda siguiente, teniendo en cuenta las equivalencias en la medida de las fichas
    cmp    al, ds:[bx]
    je     iguales
    cmp    al, 'x'
    je     es_x1
    cmp    al, 'X'
    je     es_x2
    cmp    al, 'o'
    je     es_o1
    cmp    al, 'O'
    je     es_o2
    jmp    diferentes

iguales:
    ret

es_x1:
    cmp    byte ptr ds:[bx], 'X'
    je     iguales
    jmp    diferentes

es_x2:
    cmp    byte ptr ds:[bx], 'x'
    je     iguales
    jmp    diferentes

es_o1:
    cmp    byte ptr ds:[bx], 'O'
    je     iguales
    jmp    diferentes

es_o2:
    cmp    byte ptr  ds:[bx], 'o'
    je     iguales
    jmp    diferentes

diferentes:
    mov    ax, 0
    ret

GF_on:		;ya hay ganador
    call    limpiar_pantalla

    lea     dx, salto_linea
    call    sout
    lea     dx, salto_linea
    call    sout
    lea     dx, salto_linea
    call    sout

    lea     dx, casillas
    call    sout

    lea     dx, salto_linea
    call    sout
    lea     dx, salto_linea
    call    sout

    lea     dx, ganador
    call    sout

    lea     dx, jugador
    call    sout

    lea     dx, salto_linea
    call    sout
    lea     dx, salto_linea

    call    sout

    jmp fin


puntero_juego:
    lea     si, casillas+26
    lea     bx, puntero
    mov     cx, 9

    ciclo:
    cmp     cx, 6
    je      suma_1

    cmp     cx, 3
    je      suma_1
    jmp     suma_2

    suma_1:
    add     si, 27
    jmp     suma_2


    suma_2:
    mov     ds:[bx], si
    add     si, 2

    inc     bx
    loop    ciclo
    ret


sout:	;muestra en pantalla dx
    mov     ah, 09h	;función
    int     21h 	;interrupción
    ret


limpiar_pantalla:
    mov     ax, 0600h	;función y pagina toda la pantalla
    mov     bh, 71h	;color fondo-letra "blanco-azul"
    mov     cx, 0000h	;pos inicio
    mov     dx, 184fh	;pos final
    int     10h		;interrupción 
    
   ; Restablecer el cursor en la posición superior izquierda
    mov ah, 02h
    mov bh, 00h
    mov dh, 00h
    mov dl, 00h
    int 10h
    ret


cap_tam:		;captura por teclado el tamaño de la pieza
    lea dx, mensaje_tama
    call sout
cap_tam_bucle:
    call    cap_tecl
    sub     al, '0'
    cmp     al, 1
    je      tam_1
    cmp     al, 2
    je      tam_2
    lea     dx, salto_linea
    call    sout
    lea     dx, mensaje_error2
    call    sout
    lea     dx, salto_linea
    call    sout   
    jmp cap_tam_bucle


tam_1:
mov tam_pieza, 1
ret

tam_2:
mov tam_pieza, 2
ret


cap_pos_casilla:
    call    cap_tecl
    cmp     al, '1'
    jb      entrada_invalida
    cmp     al, '9'
    ja      entrada_invalida
    ret
entrada_invalida:
    lea    dx, salto_linea
    call   sout
    lea    dx, mensaje_error1
    call   sout
    lea    dx, salto_linea
    call   sout
    jmp    cap_pos_casilla


cap_tecl:		;captura por teclado
    mov     ah, 1	;función
    int     21h		;interrupción
    ret


fin:
    mov ax, 4c00h	;mueve el 4C al AH para hacer una llamado a una rutina del DOS
    int 21h		;invoca la interrupción de finalizar programa con el valor del AH
inicio endp		;finaliza el procedimiento principal
end			;finaliza el CS
