assume cs:code, ds:data

data segment
    db '1975','1976','1977','1978','1979','1980','1981','1982','1983'
    db '1984','1985','1986','1987','1988','1989','1990','1991','1992'
    db '1993','1994','1995'
    
    dd 16,22,382,1356,2390,8000,16000,24486,50065,97479,140417,197514
    dd 345980,590827,803530,1183000,1843000,2759000,3753000,4649000,5937000

    dw 3,7,9,13,28,38,130,220,476,778,1001,1442,2258,2793,4037,5635,8226
    dw 11542,14430,15257,17800
data ends

table segment
    db 672 dup (0)
table ends

code segment
start:    mov ax, data
          mov ds, ax
          mov ax, table
          mov es, ax
          mov si, 0
          mov di, 168
          mov bx, 0
          mov cx, 21
        ; 将数字ASCII码写入table表
s:        mov ax, [si]
          mov es:[bx].0[0], ax
          mov ax, [si+2]
          mov es:[bx].0[2], ax

          mov ax, [si+84]
          mov dx, [si+86]
          push cx
          push si
          mov si, 0
          call fdtoc
          pop si
          pop cx
          
          mov ax, [di]
          push cx
          push si
          mov si, 0
          call sdtoc
          pop si
          pop cx

          mov ax, [si+84]
          mov dx, [si+86]
          div word ptr [di]
          push cx
          push si
          mov si, 0
          call tdtoc
          pop si
          pop cx

          add si, 4
          add di, 2
          add bx, 20H
          loop s
        ; 将table表写入显存
          mov dh, 3
          mov dl, 24
          mov cl, 2
          mov si, 0
          call show_str

          mov ax, 4c00H
          int 21H

fdtoc:    mov cx, 10
          call divdw
          push cx
          mov cx, ax
          inc si
          jcxz finish
          jmp short fdtoc

finish:   mov cx, si
          mov si, 0
s1:       pop ax
          add ax, 30H
          mov es:[bx].9[si], al
          inc si
          loop s1

          ret

divdw:    push bx
          push ax
          mov ax, dx
          mov dx, 0
          div cx
          mov bx, ax

          pop ax
          div cx

          mov cx, dx
          mov dx, bx

          pop bx
          ret               

sdtoc:    mov dx, 0
          mov cx, 10
          div cx
          mov cx, ax
          push dx
          inc si
          jcxz sfinish
          jmp short sdtoc

sfinish:  mov cx, si
          mov si, 0
s2:       pop ax
          add ax, 30H
          mov es:[bx].19[si], al
          inc si
          loop s2
          
          ret

tdtoc:    mov dx, 0
          mov cx, 10
          div cx
          mov cx, ax
          push dx
          inc si
          jcxz tfinish
          jmp short tdtoc

tfinish:  mov cx, si
          mov si, 0
s3:       pop ax
          add ax, 30H
          mov es:[bx].29[si], al
          inc si
          loop s3
        
          ret

show_str: mov ax, 0B800H
          mov ds, ax

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
          mov cx, 21

s5:       push cx
          mov cx, 32
          
s4:       mov al, es:[si]
          mov [di], ax
          inc si
          add di, 2
          loop s4

          add di, 96
          pop cx
          loop s5

          ret


code ends
end start