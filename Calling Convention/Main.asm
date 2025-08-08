extern GetStdHandle : proc
extern WriteFile    : proc
extern ExitProcess  : proc

.data
helloText   BYTE "Hello World", 13, 10, 0
stdout      QWORD ?
stdin       QWORD ?

.code
main PROC
    push    rbp
    mov     rbp, rsp
    
    call init
    
    lea rcx, [helloText]
    call writeline

    xor ecx, ecx
    call ExitProcess
main ENDP

; WriteLine(string text); text null terminated
writeline PROC
    push    rbp
    mov     rbp, rsp
    sub rsp, 32

    xor r8, r8 ; nint i = 0

loop_start:
    
    movzx r10, byte ptr [rcx+r8]
    cmp r10, 0
    je loop_end
    inc r8
    jmp loop_start
    
loop_end:
    
    mov rdx, rcx ; pass in string
    mov rcx, stdout ; pass in handle
    ; r8 is already num bytes
    xor r9, r9 ; optional out parameter

    call WriteFile

    add rsp, 32
    pop     rbp
    ret
writeline ENDP

init PROC
    push    rbp
    mov     rbp, rsp

    sub rsp, 32 ; 32 bytes of shadow space

    mov rcx, -11 ; constant for stdout
    call GetStdHandle
    mov [stdout], rax

    mov rcx, -10 ; constant for stdin
    call GetStdHandle
    mov [stdin], rax

    add rsp, 32

    pop     rbp ; pop previous base pointer back
    ret ; pop return address placed by call
init ENDP
END
