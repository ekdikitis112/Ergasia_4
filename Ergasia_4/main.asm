title program
include Irvine32.inc

.data
array sword 10,20,30,40,50,60,70,80,90,100   ; Define an array 'array' with 10 signed words
varmessage byte "The variance is: ",0       ; Define a null-terminated string for variance output
meanmessage byte "The mean is: ",0          ; Define a null-terminated string for mean output

.code

mean proc
    push ebp
    mov ebp,esp
    push edi
    push esi

    mov edi,[ebp+8]    ; edi points to the array parameter
    mov esi,0           ; Initialize esi (index) to 0
    mov eax,0           ; Initialize eax (sum) to 0
    jmp cond            ; Jump to condition check

lp:
    add ax,[edi+2*esi]  ; Add value at array[esi] to ax (sum)
    inc esi             ; Increment index
cond:
    cmp esi,[ebp+12]    ; Compare index with array length
    jl lp               ; Jump to loop if index < array length

    movsx eax,ax        ; Sign-extend ax to eax for division
    cdq                  ; Clear edx for division
    idiv sdword ptr [ebp+12]  ; Divide sum by array length

    mov edi,[ebp+16]    ; edi points to the mean result parameter
    mov [edi],eax       ; Store mean in the provided memory location

    pop esi
    pop edi
    mov esp,ebp
    pop ebp
    ret 12              ; Return, cleaning up 12 bytes from the stack

mean endp

variance proc
    push ebp
    mov ebp,esp
    push edi
    push esi
    push ebx
    push edx

    mov edi,[ebp+8]     ; edi points to the array parameter
    mov esi,0           ; Initialize esi (index) to 0
    mov eax,0           ; Initialize eax (sum of squared differences) to 0
    mov ebx,[ebp+16]    ; ebx holds the mean value
    jmp cond            ; Jump to condition check

lp:
    movsx edx,sword ptr [edi+2*esi]  ; Load array element to edx, sign-extend
    sub edx,ebx         ; Subtract mean from the array element
    imul edx,edx        ; Square the difference
    add eax,edx         ; Add squared difference to sum
    inc esi             ; Increment index
cond:
    cmp esi,[ebp+12]    ; Compare index with array length
    jl lp               ; Jump to loop if index < array length

    cdq                  ; Clear edx for division
    idiv sdword ptr [ebp+12]  ; Divide sum by array length

    mov edi,[ebp+20]    ; edi points to the variance result parameter
    mov [edi],eax       ; Store variance in the provided memory location

    pop edx
    pop ebx
    pop esi
    pop edi
    mov esp,ebp
    pop ebp
    ret 16              ; Return, cleaning up 16 bytes from the stack

variance endp

main proc
    push ebp
    mov ebp,esp
    sub esp,8           ; Reserve space on the stack for local variables
    mov [ebp-4],dword ptr 0   ; Initialize [ebp-4] (mean)
    mov [ebp-8],dword ptr 0   ; Initialize [ebp-8] (variance)

    lea edi,[ebp-4]     ; edi points to [ebp-4] (mean)
    push edi            ; Push mean address as parameter
    push lengthof array ; Push array length as parameter
    push offset array   ; Push array address as parameter
    call mean           ; Call mean function

    mov edx, offset meanmessage ; Load meanmessage address into edx
    call WriteString    ; Output "The mean is: "
    call WriteInt       ; Output mean value
    call Crlf           ; Output newline

    lea edi,[ebp-8]     ; edi points to [ebp-8] (variance)
    push edi            ; Push variance address as parameter

    push sdword ptr [ebp-4]   ; Push mean value as parameter
    push lengthof array ; Push array length as parameter
    push offset array   ; Push array address as parameter
    call variance       ; Call variance function

    mov edx,offset varmessage  ; Load varmessage address into edx
    call WriteString    ; Output "The variance is: "
    call WriteInt       ; Output variance value
    call Crlf           ; Output newline

exit
main endp

end main
