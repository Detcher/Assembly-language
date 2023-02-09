assume cs:code, ds:data

data segment
	a dw 1, 2, 3, 4, 5, 6, 7, 8
	b dd 0
data ends

code segment
start:	mov cx, 4
		mov si, 0001H
s:		mov ax, si
		add si, 2
		loop s
		mov ax, 4c00H
		int 21H
code ends
end start