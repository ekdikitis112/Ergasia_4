title program
include Irvine32.inc

.data
array sword 10,20,30,40,50,60,70,80,90,100
varmessage byte "The variance is: ",0
meanmessage byte "The mean is: ",0

.code

mean proc
	push ebp
	mov ebp,esp
	push edi
	push esi

	mov edi,[ebp+8]
	mov esi,0
	mov eax,0
	jmp cond
lp:
	add ax,[edi+2*esi]
	inc esi
cond: cmp esi,[ebp+12]
	jl lp

	movsx eax,ax
	cdq
	idiv sdword ptr [ebp+12]

	mov edi,[ebp+16]
	mov [edi],eax
	
	pop esi
	pop edi
	mov esp,ebp
	pop ebp
	ret 12
mean endp

variance proc
	push ebp
	mov ebp,esp
	push edi
	push esi
	push ebx
	push edx

	mov edi,[ebp+8]
	mov esi,0
	mov eax,0
	mov ebx,[ebp+16]
	jmp cond
lp:
	movsx edx,sword ptr [edi+2*esi]
	sub edx,ebx
	imul edx,edx
	add eax,edx
	inc esi
cond: cmp esi,[ebp+12]
	jl lp

	cdq
	idiv sdword ptr [ebp+12]
	mov edi,[ebp+20]
	mov [edi],eax

	pop edx
	pop ebx
	pop esi
	pop edi
	mov esp,ebp
	pop ebp
	ret 16

variance endp

main proc
	push ebp
	mov ebp,esp
	sub esp,8
	mov [ebp-4],dword ptr 0
	mov [ebp-8],dword ptr 0

	lea edi,[ebp-4]
	push edi
	push lengthof array
	push offset array
	call mean

	mov edx, offset meanmessage
	call WriteString
	call WriteInt
	call Crlf

	lea edi,[ebp-8]
	push edi

	push sdword ptr [ebp-4]
	push lengthof array
	push offset array
	call variance

	mov edx,offset varmessage
	call WriteString
	call WriteInt
	call Crlf


exit
main endp
end main