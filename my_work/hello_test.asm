; obj hello world 
; ressource utilisé : pwn college
; let's start code

section .data 
    msg db "YO ! Hack Club ! french people are here !!!", 10 ;10=\n=newline
    len equ $-msg

section .text
    global _start

_start:

    ;write(1, msg, len)
    mov rax, 1          ; syscall: write
    mov rdi, 1          ; file descriptor: stdout
    mov rsi, msg        ; pointer to message
    mov rdx, len        ; message length
    syscall

    ;exit(0)
    mov rax, 60         ; syscall: exit
    xor rdi, rdi        ; status: 0
    syscall

;and this is just for a simple "hello" bruh 