;first version !!!!
section .data 
    sep db "---|---|---", 10
    sep_len equ $-sep
    fmt db " %c | %c | %c ", 10

section .text
    global _start

print_board:
    ;now you just show the board
    mov rax, 1
    mov rdi, 1
    mov rsi, sep
    mov rdx, sep_len
    syscall
    ret

;now get the entry of the user 

section .bss
    input_buf resb 2    ;1 + \n

section .text


 ;i go to sleep bye bye ! 