extern GetStdHandle : proc
extern WriteFile    : proc
extern ExitProcess  : proc

.data
toSort   BYTE "pneumonoultramicroscopicsilicovolcanoconiosis", 13, 10, 0
msg1   BYTE "Sorted Is:", 13, 10, 0

zeroChar BYTE '0'
stdout      QWORD ?
stdin       QWORD ?

.code
main PROC
    push    rbp
    mov     rbp, rsp
    
    call init

    lea rcx, [toSort]
    call writeline

    lea rcx, [msg1]
    call writeline

    ; get the length of the string
    lea r12, [toSort]
    mov rcx, r12
    call strlen

    ; bubbleSortByte(toSort, strlen(toSort) - 2) ; ignore \r\n
    mov rcx, r12
    mov rdx, rax
    sub rdx, 2
    call bubbleSortByte

    ; writeline(toSort)
    mov rcx, r12
    call writeline

    xor ecx, ecx
    call ExitProcess
main ENDP

; sort(nint* arr, nint length)
bubbleSort PROC
    push rbp
    mov rbp, rsp
    ; rcx arr
    ; rdx len
    ; r8 i
    ; r9 j

    dec rdx
    ; nint i = 0
    xor r8, r8
outer_loop:
    cmp r8, rdx
    jge end_outer_loop
    
    xor r9, r9
inner_loop:
    mov r10, rdx
    sub r10, r8
    cmp r9, r10
    jge end_inner_loop
    
    mov r10, [rcx+r9*8]
    mov r11, [rcx+r9*8+8]
    cmp r10, r11
    jl skip_swap
    
    ; swap elements

    mov [rcx+r9*8], r11
    mov [rcx+r9*8+8], r10
    
skip_swap:
    inc r9
    jmp inner_loop
end_inner_loop:

    inc r8
    jmp outer_loop
end_outer_loop:

    pop rbp
    ret
bubbleSort ENDP

; sort(byte* arr, nint length)
bubbleSortByte PROC
    push rbp
    mov rbp, rsp
    ; rcx arr
    ; rdx len
    ; r8 i
    ; r9 j

    dec rdx
    ; nint i = 0
    xor r8, r8
outer_loop:
    cmp r8, rdx
    jge end_outer_loop
    
    xor r9, r9
inner_loop:
    mov r10, rdx
    sub r10, r8
    cmp r9, r10
    jge end_inner_loop
    
    movzx r10, byte ptr [rcx+r9] ; instead of zx we can also use r10d
    movzx r11, byte ptr [rcx+r9+1]
    cmp r10, r11
    jl skip_swap
    
    ; swap elements

    mov byte ptr [rcx+r9], r11b
    mov byte ptr [rcx+r9+1], r10b
    
skip_swap:
    inc r9
    jmp inner_loop
end_inner_loop:

    inc r8
    jmp outer_loop
end_outer_loop:

    pop rbp
    ret
bubbleSortByte ENDP

; WriteLine(string text); text null terminated
writeline PROC
    push    rbp
    mov     rbp, rsp
    sub rsp, 32

    mov r12, rcx ; save string for call

    call strlen
    
    mov rdx, r12 ; pass in string
    mov rcx, stdout ; pass in handle
    mov r8, rax ; num bytes
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

; nint strlen(byte* start)

strlen PROC
    push    rbp
    mov     rbp, rsp

    xor rax, rax ; nint i = 0

loop_start:
    
    movzx r10, byte ptr [rcx+rax]
    cmp r10, 0
    je loop_end
    inc rax
    jmp loop_start
    
loop_end:
    
    pop     rbp
    ret
strlen ENDP
END