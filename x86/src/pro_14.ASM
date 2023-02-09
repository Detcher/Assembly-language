assume cs:code

data segment
    db '2000/00/00 00:00:00', '$'
    db 9, 8, 7, 4, 2, 0
data ends

code segment
start:  mov ax, data
        mov ds, ax
        mov si, 2
        mov di, 20
        mov cx, 6
    s:  push cx
        mov al, [di]
        out 70H, al
        in al, 71H

        mov ah, al
        mov cl, 4
        shr ah, cl
        and al, 00001111B

        add ah, 30H
        add al, 30H

        mov [si], ah
        mov [si+1], al
        inc di
        add si, 3
        pop cx
        loop s

        mov ah, 2
        mov bh, 0
        mov dh, 12
        mov dl, 32
        int 10H

        mov dx, 0
        mov ah, 9
        int 21H

        mov ax, 4c00H
        int 21H
code ends
end start