; ʵ����
assume cs:codesg

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
    db 21 dup ('year summ ne ?? ')
table ends

codesg segment

start:    mov ax, data
          mov ds, ax
          mov ax, table
          mov es, ax
          mov si, 0
          mov di, 168
          mov bx, 0
          mov cx, 21

s:        mov ax, [si]
          mov es:[bx].0[0], ax
          mov ax, [si+2]
          mov es:[bx].0[2], ax

          mov ax, [si+84]
          mov es:[bx].5[0], ax
          mov ax, [si+86]
          mov es:[bx].5[2], ax

          mov ax, [di]
          mov es:[bx].10, ax

          mov ax, [si+84]
          mov dx, [si+86]
          div word ptr es:[bx].10
          mov es:[bx].13, ax

          add si, 4
          add di, 2
          add bx, 10H
          loop s

          mov ax, 4c00H
          int 21H

codesg ends

end start