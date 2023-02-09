; 需要测试程序
assume cs:code

code segment
start:      mov ax, cx
            mov ds, ax
            mov si, offset int7c
            mov ax, 0
            mov es, ax
            mov di, 0200H
            mov cx, offset int7cend-offset int7c
            cld
            rep movsb
            
            mov ax, 0
            mov es, ax
            cli
            mov word ptr es:[7cH*4], 200H
            mov word ptr es:[7cH*4+2], 0
            sti

            mov ax, 4c00H
            int 21H

int7c:      push cx
            push bx
            push ax

            mov ax, dx
            mov bl, 1440
            div bl
            mov dh, al ; 面号
            mov cl, 4
            shr ax, cl
            mov bl, 18
            div bl
            mov ch, al ; 磁道号
            mov cl, ah
            add cl, 1 ; 扇区号
            mov dl, 0

            pop ax
            mov al, 1
            add ah, 2
            int 13H

            pop bx
            pop cx

int7cend:   nop
code ends
end start