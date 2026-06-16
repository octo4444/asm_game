;test brk for allocate memory manually
section .data
    msg db "work ?", 10
    len equ $-msg

section .text
    global _start

_start
    ;get the actual addr (heap)
    mov rax, 12 ;syscall for brk
    xor rdi, rdi    ;if rdi=0 the program give the actual addr
    syscall

    ;now the addr is in rax so
    mov r8, rax ;addr is save in r8
    
    ;now allocate 32 byte more
    mov rdi, r8
    add rdi, 32 ;add 32 more byte
    mov rax, 12
    syscall

    ;get the message
    mov rax, 1
    mov rdi, 1
    mov rsi, msg
    mov rdx, len
    syscall

    ;quit
    mov rax, 60
    xor rdi, rdi
    syscall

; now we know how addr work !!!