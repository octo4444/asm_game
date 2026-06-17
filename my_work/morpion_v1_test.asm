;first version !!!!
section .data 
    pipe db " | "
    len_pipe equ $-pipe

    msg_j1 db "ready player one (X) ? it is your turn : "
    len_j1 equ $-msg_j1

    msg_j2 db "ready player two (O)? it is your turn : "
    len_j2 equ $-msg_j2

    msg_err db "you try somethings impossible... retry?", 10
    len_err equ $-msg_err

    msg_win1 db "player one (X) you win !!!! GG", 10
    len_win1 equ $-msg_win1

    msg_win2 db "player two (O) you win !!!! GG", 10
    len_win2 equ $-msg_win2

    msg_nul db "nobody win...", 10
    len_nul equ $-msg_nul


    sep db "---|---|---", 10
    len_sep equ $-sep
    newline db 10

    ;0=nothing here     1=X     2=O
    board db 0, 0, 0, 0, 0, 0, 0, 0, 0

    win_lines db 0,1,2, 3,4,5, 6,7,8
              db 0,3,6, 1,4,7, 2,5,8
              db 0,4,8, 2,4,6

section .bss
    input_buf resb 2
    current_player resb 1 ;1 for X, 2 for O
    turn_count resb 1

section .text
    global _start

_start:
    mov byte [current_player], 1
    mov byte [turn_count], 0

game_loop:
    call print_board

    cmp byte [turn_count], 9
    jge declare_draw

    call ask_input

    call check_win
    cmp al, 1
    je declare_win

    inc byte [turn_count]
    mov al, byte [current_player]
    xor al, 3
    mov byte [current_player], al

    jmp game_loop

print_board:
    mov r12, 0

.row_loop:
    mov r13, 0

.col_loop:
    mov rax, r12
    imul rax, 3     ;multiplication
    add rax, r13
    
    mov bl, byte [board + rax]

    mov cl, ' '
    cmp bl, 1
    jne .check_o
    mov cl, 'X'
    jmp .print_char

.check_o:
    cmp bl, 2
    jne .print_char
    mov cl, 'O'

.print_char:
    push rcx
    mov rax, 1
    mov rdi, 1
    mov rsi, rsp
    mov rdx, 1
    syscall
    pop rcx

    cmp r13, 2
    je .end_col
    mov rax, 1
    mov rdi, 1
    mov rsi, pipe
    mov rdx, len_pipe
    syscall

.end_col:
    inc r13
    cmp r13, 3
    jl .col_loop

    mov rax, 1
    mov rdi, 1
    mov rsi, newline
    mov rdx, 1
    syscall

    cmp r12, 2
    je .end_row
    mov rax, 1
    mov rdi, 1
    mov rsi, sep
    mov rdx, len_sep
    syscall

.end_row:
    inc r12
    cmp r12, 3
    jl .row_loop

    mov rax, 1
    mov rdi, 1
    mov rsi, newline
    mov rdx, 1
    syscall
    ret

ask_input:
    cmp byte [current_player], 1
    je .print_j1
    mov rsi, msg_j2
    mov rdx, len_j2
    jmp .print
.print_j1:
    mov rsi, msg_j1
    mov rdx, len_j1

.read_input:
    mov rax, 0
    mov rdi, 0
    mov rsi, input_buf
    mov rdx, 2
    syscall

    mov al, byte [input_buf]
    sub al, "0"
    dec al 

    cmp al, 0
    jl .invalid
    cmp al, 8
    jg .invalid

    movzx rbx, al
    cmp byte [board + rbx], 0
    jne .invalid

    mov cl, byte [current_player]
    mov byte [board + rbx], cl
    ret 

.invalid:
    mov rax, 1
    mov rdi, 1
    mov rsi, msg_err
    mov rdx, len_err
    syscall
    jmp ask_input

check_win:
    mov rcx, 0

.check_loop:
    movzx r8,  byte [win_lines + rcx]
    movzx r9,  byte [win_lines + rcx + 1]
    movzx r10, byte [win_lines + rcx + 2]

    mov al, byte [board + r8]
    mov bl, byte [board + r9]
    mov dl, byte [board + r10]

    cmp al, 0
    je .next_line

    ; Les 3 cases doivent être identiques
    cmp al, bl
    jne .next_line

    cmp al, dl
    jne .next_line

    mov al, 1
    ret

.next_line:
    add rcx, 3
    cmp rcx, 24
    jl .check_loop

    mov al, 0
    ret

declare_win:
    call print_board

    cmp byte [current_player], 1
    je .win_p1

    mov rsi, msg_win2
    mov rdx, len_win2
    jmp .print

.win_p1:
    mov rsi, msg_win1
    mov rdx, len_win1

.print:
    mov rax, 1
    mov rdi, 1
    syscall
    jmp exit

.end:
    mov rax, 1
    mov rdi, 1
    mov rsi, msg_nul
    mov rdx, len_nul
    syscall
    jmp exit

declare_draw:
    mov rax, 1
    mov rdi, 1
    mov rsi, msg_nul
    mov rdx, len_nul
    syscall
    jmp exit

exit:
    mov rax, 60
    xor rdi, rdi
    syscall
