assume cs:code

data segment
    db 'conversion', 0
data ends

code segment
start:  mov ax, cs
        mov ds, ax
        mov si, offset jump
        mov ax, 0
        mov es, ax
        mov di, 200H
        mov cx, offset jumpend-offset jump
        cld
        rep movsb

        mov ax, 0
        mov es, ax
        mov word ptr es:[7cH*4], 200H
        mov word ptr es:[7cH*4+2], 0

        mov ax, data
        mov ds, ax
        mov si, 0
        mov ax, 0b800H
        mov es, ax
        mov di, 12*160+35*2

    s:  cmp byte ptr [si], 0
        je ok
        mov al, [si]
        mov es:[di], al
        mov byte ptr es:[di+1], 2
        inc si
        add di, 2
        mov bx, offset s-offset ok
        int 7cH
    ok: mov ax, 4c00H
        int 21H

jump:   push bp
        mov bp, sp
        add [bp+2], bx
        pop bp
        iret
jumpend:nop
code ends
end start