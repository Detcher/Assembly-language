assume cs:code

stack segment
    db 128 dup (0)
stack ends

code segment
start:      mov ax, stack
            mov ss, ax
            mov sp, 128

            push cs
            pop ds

            mov ax, 0
            mov es, ax

            mov si, offset int9
            mov di, 204H
            mov cx, offset int9end-offset int9
            cld
            rep movsb

            cli
            push es:[9*4]
            pop es:[200H]
            push es:[9*4+2]
            pop es:[202H]
            sti

            cli
            mov word ptr es:[9*4], 204H
            mov word ptr es:[9*4+2], 0
            sti

            mov ax, 4c00H
            int 21H

int9:       push ax
            push ds
            push si
            push cx

            pushf
            call dword ptr cs:[200H]

            in al, 60H
            cmp al, 9EH
            jne int9ret

            mov ax, 0b800H
            mov ds, ax
            mov si, 0
            mov cx, 2000
fill:       mov byte ptr [si], 'A'
            add si, 2
            loop fill
            
int9ret:    pop cx
            pop si
            pop ds
            pop ax
            iret

int9end:    nop
code ends
end start