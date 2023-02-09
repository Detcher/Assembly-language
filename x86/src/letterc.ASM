assume cs:codesg

data segment
    db "Beginner's All-purpose Symbolic Instruction Code.", 0
data ends

codesg segment
    begin:  mov ax, data
            mov ds, ax
            mov si, 0
            mov ch, 0
            call letterc

            mov ax, 4c00H
            int 21H

  letterc:  mov cl, [si]
            jcxz done
            cmp cl, 97
            jb s0
            cmp cl, 122
            ja s0
            sub byte ptr [si], 32

       s0:  inc si
            jmp short letterc

     done:  ret
codesg ends
end begin