assume cs:code

code segment
start:  mov ax, cs
        mov ds, ax
        mov si, offset int7c
        mov ax, 0
        mov es, ax
        mov di, 200H
        mov cx, offset int7end-offset int7c
        cld
        rep movsb

        mov ax, 0
        mov es, ax
        cli
        mov word ptr es:[7ch*4], 200H
        mov word ptr es:[7ch*4+2], 0
        sti

        mov ax, 4c00H
        int 21H

int7c:  jmp short set
  
        dw offset sub1-offset int7c + 200H
        dw offset sub2-offset int7c + 200H
        dw offset sub3-offset int7c + 200H
        dw offset sub4-offset int7c + 200H

set:    push bx
        cmp ah, 3
        ja sret
        mov bl, ah
        mov bh, 0
        add bx, bx
        call word ptr cs:[bx+202H]

sret:   pop bx
        iret

sub1:   push bx
        push cx
        push es
        mov bx, 0b800H
        mov es, bx
        mov bx, 0
        mov cx, 2000
sub1s:  mov byte ptr es:[bx], ' '
        add bx, 2
        loop sub1s
        pop es
        pop cx
        pop bx
        ret

sub2:   push bx
        push cx
        push es

        mov bx, 0b800H
        mov es, bx
        mov bx, 1
        mov cx, 2000
sub2s:  and byte ptr es:[bx], 11110000B
        or es:[bx], al
        add bx, 2
        loop sub2s

        pop es
        pop cx
        pop bx
        ret

sub3:   push bx
        push cx
        push es
        mov cl, 4
        shl al, cl
        mov bx, 0b800H
        mov es, bx
        mov bx, 1
        mov cx, 2000
sub3s:  and byte ptr es:[bx], 10001111B
        or es:[bx], al
        add bx, 2
        loop sub3s
        pop es
        pop cx
        pop bx
        ret

sub4:   push cx
        push si
        push di
        push es
        push ds

        mov si, 0b800H
        mov es, si
        mov ds, si
        mov si, 160
        mov di, 0
        cld
        mov cx, 24

sub4s:  push cx
        mov cx, 160
        rep movsb
        pop cx
        loop sub4s

        mov cx, 80
        mov si, 0
sub4s1: mov byte ptr [160*24+si], ' '
        add si, 2
        loop sub4s1

        pop ds
        pop es
        pop di
        pop si
        pop cx
        ret
        
int7end:nop
code ends
end start
