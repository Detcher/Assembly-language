assume cs:code, ds:data
; 具体接口见P209
data segment
    db 10 dup (0)
data ends

code segment
start:    mov ax, 12666
          mov bx, data
          mov ds, bx
          mov si, 0
          call dtoc

          mov dh, 8
          mov dl, 3
          mov cl, 2
          call show_str

          mov ax, 4c00H
          int 21H

dtoc:     mov dx, 0
          mov bx, 10
          div bx
          mov cx, ax
          push dx
          inc si
          jcxz finish
          jmp short dtoc

finish:   mov cx, si
          mov si, 0
s1:       pop ax
          add ax, 30H
          mov [si], al
          inc si
          loop s1

          mov [si], cl
          mov si, 0
          ret

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

; 升级版dtoc，适用于数据大于65535，即大于16位小于等于32位的
assume cs:code, ds:data

data segment
    db 10 dup (0)
data ends

code segment
start:    mov ax, 9768H
          mov dx, 975Ah
          mov bx, data
          mov ds, bx
          mov si, 0
          call dtoc

          mov dh, 8
          mov dl, 3
          mov cl, 2
          call show_str

          mov ax, 4c00H
          int 21H

dtoc:     mov cx, 10
          call divdw
          push cx
          mov cx, ax
          inc si
          jcxz finish
          jmp short dtoc

finish:   mov cx, si
          mov si, 0
s1:       pop ax
          add ax, 30H
          mov [si], al
          inc si
          loop s1

          mov [si], cl
          mov si, 0
          ret

divdw:    push ax
          mov ax, dx
          mov dx, 0
          div cx
          mov bx, ax

          pop ax
          div cx

          mov cx, dx
          mov dx, bx

          ret

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