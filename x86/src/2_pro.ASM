assume ss:stack, cs:code

stack segment
    db 128 dup (0)
stack ends

code segment
start:              mov ax, data
                    mov ds, ax
                    mov ax, stack
                    mov ss, ax
                    mov sp, 128
;¡ý===================nums of sectors the core needs??============================================
                    mov ax, offset core_ends - offset corestrap
                    mov bl, 512
                    div bl
                    cmp ah, 0
                    jne plus
back:               push ax
;================================================================================================¡ü
                    call mov_boot_to_disk
                    call mov_core_to_disk

                    mov ax, 4c00H
                    int 21H

plus:               add al, 1
                    jmp back
;¡ý===================move "move core from hard-disk to memory 0:7e00" to disk 1===================
mov_boot_to_disk:   push ax
                    push es
                    push bx
                    push cx
                    push dx

                    mov ax, cs
                    mov es, ax
                    mov bx, offset bootstrap

                    mov al, 1
                    mov ch, 0
                    mov cl, 1
                    mov dl, 0
                    mov dh, 0
                    mov ah, 3
                    int 13H

                    pop dx
                    pop cx
                    pop bx
                    pop es
                    pop ax
                    ret
;================================================================================================¡ü
bootstrap:          mov ax, 0
                    mov es, ax
                    mov bx, 7e00H
                    
                    pop ax
                    push ax         ; restore the num of sectors CORE needs
                    mov ch, 0
                    mov cl, 2
                    mov dl, 0
                    mov dh, 0
                    mov ah, 2
                    int 13H

                    push es
                    push bx
                    retf            ; skip the redundant "0" that u filled in before
                  ; "write in sectors" function for int13H has no "end" but uses the value of "al" as the end, 
                  ; therefore, u need to fill the part after "bootstrap" with at least 512 bytes 0 (one sector's BYTES),
                  ; Just in case some unrelated program is written in sectors!!
boot_ends:          db 512 dup (0)
                    nop
;¡ý===================move "core" to disk whatever=================================================
mov_core_to_disk:   mov ax, cs
                    mov es, ax
                    mov bx, offset corestrap

                    pop ax
                    push ax
                    mov ch, 0
                    mov cl, 2
                    mov dl, 0
                    mov dh, 0

                    mov ah, 3
                    int 13H

                    ret
;================================================================================================¡ü
corestrap:          jmp short core_start

option1          db '1) reset pc', '$'
option2          db '2) start system', '$'
option3          db '3) clock', '$'
option4          db '4) set clock', '$'

option_address   dw option1 -offset corestrap + 7e00H
                 dw option2 -offset corestrap + 7e00H
                 dw option3 -offset corestrap + 7e00H
                 dw option4 -offset corestrap + 7e00H

chosen_address   dw offset chosen_one-offset corestrap + 7e00H
                 dw offset chosen_two-offset corestrap + 7e00H
                 dw offset chosen_three-offset corestrap + 7e00H
                 dw offset chosen_four-offset corestrap + 7e00H

time_str         db '2000/00/00 00:00:00', '$'
where_em_at      db 9, 8, 7, 4, 2, 0

table            dw charpush - offset corestrap + 7e00H, charpop - offset corestrap + 7e00H, charshow - offset corestrap + 7e00H
char_stack       db 13 dup (0)

core_start:         call clear_screen
                    call show_option

                    jmp short choose_option

                    mov ax, 4c00H
                    int 21H

;¡ý==========================================================
clear_screen:       push bx
                    push es
                    push cx
                    
                    mov bx, 0b800H
                    mov es, bx
                    mov bx, 0
                    mov cx, 2000
clear:              mov byte ptr es:[bx], ' '
                    add bx, 2
                    loop clear

                    pop cx
                    pop es
                    pop bx
                    ret
;==========================================================¡ü
;¡ý==========================================================
show_option:        push bx
                    push ax
                    push ds
                    push si
                    push dx
                    push cx

                    mov bh, 0
                    mov ax, cs
                    mov ds, ax
                    mov si, 0
                    mov dh, 9
                    mov cx, 4
show:               mov dl, 32
                    mov ah, 2
                    int 10H

                    mov dx, option_address[si]
                    mov ah, 9
                    int 21H

                    add dh, 2
                    add si, 2
                    loop show

                    pop cx
                    pop dx
                    pop si
                    pop ds
                    pop ax
                    pop bx
                    ret
;==========================================================¡ü
                  ; forget to clear keyboard buffer, shit
choose_option:      call clear_buffer
                    
                    mov ah, 0
                    int 16H

                    sub al, 30H
                    cmp al, 4
                    ja choose_option
                    cmp al, 1
                    jb choose_option
                    
                    mov ah, 0
                    mov bx, ax
                    sub bx, 1
                    add bx, bx
                    jmp word ptr cs:chosen_address[bx]
;¡ý==========================================================
clear_buffer:       push ax

                    mov ah, 1
                    jz clear_buffer_ret
                    mov ah, 0
                    int 16H
                    jmp short clear_buffer

clear_buffer_ret:   pop ax
                    ret
;==========================================================¡ü
chosen_one:         call change_color
                    call reset_pc

chosen_two:         call change_color
                    call start_system
                    jmp short choose_option

chosen_three:       call change_color
                    call clock
                    jmp short core_start

chosen_four:        call change_color
                    call set_clock
                    jmp short core_start
;¡ý==========================================================
change_color:       push bx
                    push es
                    push cx
                    push ax
                    
                    mov bx, 0b800H
                    mov es, bx
                    mov bx, 160*9+1
                    mov cx, 80*4
to_white:           mov byte ptr es:[bx], 07H
                    add bx, 2
                    loop to_white

                    add ax, ax
                    add ax, 7
                    mov bl, 160
                    mul bl
                    mov bx, ax
                    inc bx
                    mov cx, 80
to_green:           mov byte ptr es:[bx], 02H
                    add bx, 2
                    loop to_green

                    pop ax
                    pop cx
                    pop es
                    pop bx
                    ret
;==========================================================¡ü
;¡ý==========================================================
reset_pc:           mov ax, 0FFFFH
                    push ax
                    mov ax, 0
                    push ax
                    retf
;==========================================================¡ü
;¡ý==========================================================
start_system:       mov ax, 0
                    mov es, ax
                    mov bx, 07c00H

                    mov al, 1
                    mov ch, 0
                    mov cl, 1
                    mov dh, 0
                    mov dl, 80H

                    mov ah, 2
                    int 13H

                    push es
                    push bx
                    retf

                    ret   
;==========================================================¡ü
clock:              call save_old_int9
                    call set_new_int9

show_clock:         mov ax, cs
                    mov ds, ax
                    mov si, time_str -offset corestrap + 7e00H + 2
                    mov di, where_em_at -offset corestrap + 7e00H
                    mov cx, 6
s0:                 push cx
                    mov al, [di]
                    out 70H, al
                    in al, 71H

                    mov ah, al
                    mov cl, 4
                    shr ah, cl
                    and al, 00001111B

                    add ah, 30H
                    add al, 30H

                    mov [si], ah
                    mov [si+1], al
                    inc di
                    add si, 3
                    pop cx
                    loop s0

                    mov ah, 2
                    mov bh, 0
                    mov dh, 5
                    mov dl, 32
                    int 10H

                    mov dx, 0
                    mov ah, 9
                    int 21H

                    jmp short show_clock

show_clock_ret:     call set_old_int9
                    ret
;¡ý==========================================================
save_old_int9:      push es
                    push bx

                    mov bx, 0
                    mov es, bx

                    push es:[9*4]
                    pop es:[200H]
                    push es:[9*4+2]
                    pop es:[202H]

                    pop bx
                    pop es

                    ret
;==========================================================¡ü
;¡ý==========================================================
set_new_int9:       push bx
                    push es
                    mov bx, 0
                    mov es, bx

                    cli
                    mov word ptr es:[9*4], offset new_int9 - offset corestrap + 7e00H
                    mov es:[9*4+2], cs
                    sti

                    pop es
                    pop bx
                    ret
;==========================================================¡ü
;¡ý==========================================================
set_old_int9:       push bx
                    push es

                    mov bx, 0
                    mov es, bx

                    cli
                    push es:[200H]
                    pop es:[9*4]
                    push es:[202H]
                    pop es:[9*4+2]
                    sti

                    pop es
                    pop bx

                    ret
;==========================================================¡ü
new_int9:           push ax

                    in al, 60H
                    pushf
                    pushf
                    pop ax
                    and ah, 11111100B
                    push ax
                    popf
                    call dword ptr cs:[200H]

                    cmp al, 01H
                    je isesc
                    cmp al, 3bH
                    jne int9_ret
                    call f1_change_color

int9_ret:           pop ax
                    iret

isesc:              pop ax
                    add sp, 4
                    popf
                    jmp show_clock_ret
;¡ý==========================================================
f1_change_color:    push es
                    push bx
                    push cx

                    mov ax, 0b800H
                    mov es, ax
                    mov bx, 160*5+32*2+1
                    mov cx, 19
s1:                 inc byte ptr es:[bx]
                    add bx, 2
                    loop s1

                    pop cx
                    pop bx
                    pop es
                    ret
;==========================================================¡ü
set_clock:          mov ax, cs
                    mov ds, ax
                    mov si, char_stack - offset corestrap + 7e00H
                    mov bx, 0
                    call get_str
                    call set_time
                    ret
;¡ý==========================================================
get_str:            push ax
                    call clear_buffer
get_strs:           mov ah, 0
                    int 16H
                    cmp al, 20H
                    jb nochar
                    mov ah, 0
                    call charstart
                    mov ah, 2
                    call charstart
                    jmp get_strs

nochar:             cmp ah, 0eH
                    je backspace
                    cmp ah, 1cH
                    je enter
                    jmp get_strs

backspace:          mov ah, 1
                    call charstart
                    mov ah, 2
                    call charstart
                    jmp get_strs

enter:              mov al, 0
                    mov ah, 0
                    call charstart
                    mov ah, 2
                    call charstart
                    pop ax
                    ret
;==========================================================¡ü
;¡ý==========================================================
charstart:          push dx
                    push di
                    push es
                    push cx

                    push bx
                    cmp ah, 2
                    ja sret
                    mov bl, ah
                    mov bh, 0
                    add bx, bx
                    jmp word ptr table[bx]

charpush:           pop bx
                    cmp bx, 11
                    ja sret
                    mov [si][bx], al
                    inc bx
                    jmp sret

charpop:            pop bx
                    cmp bx, 0
                    je sret
                    dec bx
                    mov al, [si][bx]
                    jmp sret

charshow:           pop bx
                    mov ax, 0b800H
                    mov es, ax
                    mov al, 160
                    mov ah, 0
                    mul dh
                    mov di, ax
                    add dl, dl
                    mov dh, 0
                    add di, dx

                    mov cx, bx
                    mov bx, 0

charshows:          cmp bx, cx
                    jne noempty
                    mov byte ptr es:[di], ' '
                    jmp sret
npempty:            mov al, [si][bx]
                    mov es:[di], al
                    mov byte ptr es:[di+2], ' '
                    inc bx
                    add di, 2
                    jmp charshows
 
sret:               pop cx
                    pop es
                    pop di
                    pop dx
                    ret
;==========================================================¡ü
;¡ý==========================================================
set_time:           push bx
                    push cx
                    push dx
                    push ax
                    push si

                    mov bx, offset where_em_at - offset corestrap + 7e00h
                    mov cx, 6

set_times:          mov dx, [si]
                    sub dh, 30h
                    sub dl, 30h
                    shl dl, 1
                    shl dl, 1
                    shl dl, 1
                    shl dl, 1
                    and dh, 00001111b
                    or dl, dh

                    mov al, [bx]
                    out 70h, al
                    mov al, dl
                    out 71h, al

                    add si, 2
                    inc bx
                    loop set_times

                    pop si
                    pop ax
                    pop dx
                    pop cx
                    pop bx
                    ret
;==========================================================¡ü
core_ends:          db 512 dup (0)
                    nop
code ends
