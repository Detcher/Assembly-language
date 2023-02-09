assume cs:code

code segment
start:  mov ah, 1
        mov al, 1
        int 7cH
        call delay

        mov ah, 2
        mov al, 7
        int 7cH
        call delay

        mov ah, 3
        int 7cH
        call delay

        mov ah, 0
        int 7cH
        call delay

        mov ax, 4c00H
        int 21H

delay:  push ax
        push dx
        mov dx, 100H
        mov ax, 0
s1:     sub ax, 1
        sbb dx, 0
        cmp ax, 0
        jne s1
        cmp dx, 0
        jne s1
        pop dx
        pop ax
        ret
code ends
end start
