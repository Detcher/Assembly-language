assume cs:codesg, ds:datasg

datasg segment
    db 'welcome to masm!'
    db 2, 36, 113
datasg ends

codesg segment
start:  mov ax, datasg
        mov ds, ax
        mov ax, 0B800H
        mov es, ax

        mov si, 160*12+35*2
        mov di, 0
        mov bx, 16

        mov cx, 3
    s:  mov ah, [bx]
        push cx
        mov cx, 16

    s0: mov al, [di]
        mov es:[si], ax
        add si, 2
        inc di
        loop s0

        pop cx
        add si, 128
        inc bx
        mov di, 0
        loop s

        mov ax, 4c00H
        int 21H
codesg ends
end start