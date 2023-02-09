assume cs:code

data segment
    db "welcome to masm!", 0
data ends

code segment
start:    mov ax, cs
          mov ds, ax
          mov si, offset show
          mov ax, 0
          mov es, ax
          mov di, 200H
          mov cx, offset showend-offset show
          cld
          rep movsb

          mov word ptr es:[7cH*4], 200H
          mov word ptr es:[7cH*4+2], 0

          mov dh, 10
          mov dl, 10
          mov cl, 2
          mov ax, data
          mov ds, ax
          mov si, 0
          int 7cH
          mov ax, 4c00H
          int 21H

show:     push ax
          push es
          push bx
          push di
          push si

          mov ax, 0b800H
          mov es, ax
          mov al, dh
          mov bl, 160
          mul bl
          push ax
          mov al, dl
          mov bl, 2
          mul bl
          pop di
          add di, ax

          mov ah, cl
          mov cl, 0

s0:       mov ch, [si]
          jcxz done
          mov al, ch
          mov es:[di], ax
          inc si
          add di, 2
          jmp short s0

done:     pop si
          pop di
          pop bx
          pop es
          pop ax
          iret

showend:  nop
code ends
end start