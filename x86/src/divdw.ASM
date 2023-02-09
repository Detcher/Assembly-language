assume cs:code
; 具体接口见P208
code segment
    start:  mov ax, 4240H
            mov dx, 000FH
            mov cx, 0AH
            call divdw
            
            mov ax, 4c00H
            int 21H

    divdw:  push ax
            mov ax, dx
            mov dx, 0
            div cx
            mov bx, ax

            pop ax
            div cx

            mov cx, dx
            mov dx, bx

            ret
code ends
end start