; ʵ���� ��2��
assume cs:codesg, ss:stacksg, ds:datasg

stacksg segment
      dw 0,0,0,0,0,0,0,0
stacksg ends

datasg segment
      db '1. display      '
      db '2. brows        '
      db '3. replace      '
      db '4. modify       '
datasg ends

codesg segment
start:    mov ax, stacksg
          mov ss, ax
          mov sp, 16
          mov ax, datasg
          mov ds, ax
          mov cx, 4
          mov bx, 0
      s0: push cx
          mov si, 0
          mov cx, 4
      s:  mov al, [3+bx+si]
          and al, 11011111b
          mov [3+bx+si], al
          inc si
          loop s
          
          pop cx
          add bx, 16
          loop s0

          mov ax, 4c00H
          int 21H

codesg ends

end start