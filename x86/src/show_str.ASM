assume cs:code
data segment
    db 'welcome to masm!', 0
data ends
; dh表示行号, dl表示列号, cl表示颜色, ds:si指向字符串的首地址  
code segment
start:    mov dh, 8
          mov dl, 3
          mov cl, 2
          mov ax, data
          mov ds, ax
          mov si, 0
          call show_str

          mov ax, 4c00H
          int 21H

show_str: mov ax, 0B800H
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
          
s:        mov ch, [si]
          jcxz done
          mov al, ch
          mov es:[di], ax
          inc si
          add di, 2
          jmp short s

done:     ret

code ends
end start