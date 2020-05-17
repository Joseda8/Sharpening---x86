%include "linux64.inc"


section .data
	filename db "img.txt", 0
	text1 db "Ancho de la imagen: "
	text2 db "Alto de la imagen: "
	
	sharpened db "sharp.txt", 0
	oversharpened db "oversharp.txt", 0
	
	number db ""

section .bss
	read_data resb 10
	width resb 10
	height resb 10


section .text
	global _start

	_start:
		call _getInfo ; Obtiene, del usuario, la información  de ancho y alto

		mov rdx, width
		call atoi
		mov r12, rax ; Cantidad de columnas
 
		mov rdx, height ;
		call atoi
		mov r9, rax ; Cantidad de filas
		
		mov r15, 0 ; Valor inicial i
		mov rbp, 0 ; Valor inicial j

		call _sharp

	salir:
		exit

; Función para obtener el siguiente número del archivo de texto
new_number:
	mov rax, 3
	mul r12
	mul rcx
	mov rcx, rax

	mov rax, 3
	mul r11
	mov r11, rax
	add r11, rcx

	mov r8, r11
	mov r10, 3

	call _readBytes
	;print read_data
	ret

;Función para leer del archivo 
_readBytes:
	mov rax, SYS_OPEN
	mov rdi, filename
	mov rsi, O_RDONLY
	mov rdx, 0
	syscall

	push rax
	mov     rdi, rax
	mov     rax, SYS_LSEEK
	mov     rsi, r8 ; Offset
	mov     rdx, 0  ; Desde donde los tomo
	syscall

	mov rax, SYS_READ
	mov rsi, read_data
	mov rdx, r10 ; Cuantos guardo
	syscall

	mov rax, SYS_CLOSE
	pop rdi
	syscall
	ret

; Solicita la información al usuario 
_getInfo:
	call _printText1
	call _getWidth
	call _printText2
	call _getHeigth
	ret

_getWidth:
	mov rax, 0
	mov rdi, 0
	mov rsi, width
	mov rdx, 4
	syscall
	ret

_getHeigth:
	mov rax, 0
	mov rdi, 0
	mov rsi, height
	mov rdx, 4
	syscall
	ret

_printText1:
	mov rax, 1
	mov rdi, 1
	mov rsi, text1
	mov rdx, 20
	syscall
	ret

_printText2:
	mov rax, 1
	mov rdi, 1
	mov rsi, text2
	mov rdx, 19
	syscall
	ret

; Convierte de string a entero
atoi:
	xor rax, rax ; 
.top:
	movzx rcx, byte [rdx] 
	inc rdx 
	cmp rcx, '0'  
	jb .done
	cmp rcx, '9'
	ja .done
	sub rcx, '0'  
	imul rax, 10  
	add rax, rcx  
	jmp .top  
	.done:
ret

; Convierte de entero a string
itoa:
	mov ebx, 0xCCCCCCCD             
	xor rdi, rdi
.loop:
	mov ecx, eax                    

	mul ebx                         
	shr edx, 3                      

	mov eax, edx                    

	lea edx, [edx*4 + edx]          
	lea edx, [edx*2 - '0']          
	sub ecx, edx                    

	shl rdi, 8                      
	or rdi, rcx                     

	test eax, eax
	jnz .loop   
	ret

; Escribe en el archivo de texto
_write:
	
	mov rax, SYS_OPEN
	mov rdi, sharpened
	mov rsi, O_CREAT + O_APPEND + O_WRONLY
	mov rdx, 0666o
	syscall
	
	push rax
	mov rdi, rax
	mov rax, SYS_WRITE
	mov rsi, number
	mov rdx, 4

	syscall

	mov rax, SYS_CLOSE
	pop rdi
	syscall
	ret


_sharp:
	loop:
		mov r13, 0
		cmp rbp, r12
		je new_fila

		push r15
		push rbp

	conv_alg:

	_k00:
		dec r15
		dec rbp
		cmp r15, -1
		je _k01
		cmp rbp, -1
		je _k01
		mov rcx, r15 ; Fila a consultar
		mov r11, rbp ; Columna a consultar	

		call new_number
		mov rdx, rsi
		call atoi
		mov r14, 1
		imul r14
		add r13, rax

	_k01:
		pop rbp
		pop r15	
		push r15
		push rbp
		dec r15
		cmp r15, -1
		je _k02
		mov rcx, r15 ; Fila a consultar
		mov r11, rbp ; Columna a consultar	

		call new_number
		mov rdx, rsi
		call atoi
		mov r14, -2
		imul r14
		add r13, rax

	_k02:
		pop rbp
		pop r15	
		push r15
		push rbp
		dec r15
		inc rbp
		cmp r15, -1
		je _k10
		cmp rbp, r12
		je _k10
		mov rcx, r15 ; Fila a consultar
		mov r11, rbp ; Columna a consultar	

		call new_number
		mov rdx, rsi
		call atoi
		mov r14, 1
		imul r14
		add r13, rax

	_k10:
		pop rbp
		pop r15	
		push r15
		push rbp
		dec rbp
		cmp rbp, -1
		je _k11
		mov rcx, r15 ; Fila a consultar
		mov r11, rbp ; Columna a consultar	

		call new_number
		mov rdx, rsi
		call atoi
		mov r14, -2
		imul r14
		add r13, rax

	_k11:
		pop rbp
		pop r15	
		push r15
		push rbp
		mov rcx, r15 ; Fila a consultar
		mov r11, rbp ; Columna a consultar	

		call new_number
		mov rdx, rsi
		call atoi
		mov r14, 5
		imul r14
		add r13, rax

	_k12:
		pop rbp
		pop r15	
		push r15
		push rbp
		inc rbp
		cmp rbp, r12
		je _k20
		mov rcx, r15 ; Fila a consultar
		mov r11, rbp ; Columna a consultar	

		call new_number
		mov rdx, rsi
		call atoi
		mov r14, -2
		imul r14
		add r13, rax

	_k20:
		pop rbp
		pop r15	
		push r15
		push rbp
		inc r15
		dec rbp
		cmp rbp, -1
		je _k21
		cmp r15, r9
		je _k21
		mov rcx, r15 ; Fila a consultar
		mov r11, rbp ; Columna a consultar	

		call new_number
		mov rdx, rsi
		call atoi
		mov r14, 1
		imul r14
		add r13, rax

	_k21:
		pop rbp
		pop r15	
		push r15
		push rbp
		inc r15
		cmp r15, r9
		je _k22
		mov rcx, r15 ; Fila a consultar
		mov r11, rbp ; Columna a consultar	

		call new_number
		mov rdx, rsi
		call atoi
		mov r14, -2
		imul r14
		add r13, rax

	_k22:
		pop rbp
		pop r15	
		push r15
		push rbp
		inc r15
		inc rbp
		cmp rbp, r12
		je conv_final
		cmp r15, r9
		je conv_final
		mov rcx, r15 ; Fila a consultar
		mov r11, rbp ; Columna a consultar	

		call new_number
		mov rdx, rsi
		call atoi
		mov r14, 1
		imul r14
		add r13, rax

	conv_final:
		pop rbp
		pop r15
		inc rbp

		add r13, 2000

	continue_conv:
		mov eax, r13d
		call itoa
		mov [number], rdi
		call _write

		jmp loop

	new_fila:
		inc r15
		cmp r15, r9
		je _oversharp
		mov rbp, 0
		jmp loop

	ret


_oversharp:
	mov r15, 0 ; Valor inicial i
	mov rbp, 0 ; Valor inicial j
	over_loop:
		mov r13, 0
		cmp rbp, r12
		je over_new_fila

		push r15
		push rbp

	over_conv_alg:

	over_k00:
		dec r15
		dec rbp
		cmp r15, -1
		je over_k01
		cmp rbp, -1
		je over_k01
		mov rcx, r15 ; Fila a consultar
		mov r11, rbp ; Columna a consultar	

		call new_number
		mov rdx, rsi
		call atoi
		mov r14, 0
		imul r14
		add r13, rax

	over_k01:
		pop rbp
		pop r15	
		push r15
		push rbp
		dec r15
		cmp r15, -1
		je over_k02
		mov rcx, r15 ; Fila a consultar
		mov r11, rbp ; Columna a consultar	

		call new_number
		mov rdx, rsi
		call atoi
		mov r14, -1
		imul r14
		add r13, rax

	over_k02:
		pop rbp
		pop r15	
		push r15
		push rbp
		dec r15
		inc rbp
		cmp r15, -1
		je over_k10
		cmp rbp, r12
		je over_k10
		mov rcx, r15 ; Fila a consultar
		mov r11, rbp ; Columna a consultar	

		call new_number
		mov rdx, rsi
		call atoi
		mov r14, 0
		imul r14
		add r13, rax

	over_k10:
		pop rbp
		pop r15	
		push r15
		push rbp
		dec rbp
		cmp rbp, -1
		je over_k11
		mov rcx, r15 ; Fila a consultar
		mov r11, rbp ; Columna a consultar	

		call new_number
		mov rdx, rsi
		call atoi
		mov r14, -1
		imul r14
		add r13, rax

	over_k11:
		pop rbp
		pop r15	
		push r15
		push rbp
		mov rcx, r15 ; Fila a consultar
		mov r11, rbp ; Columna a consultar	

		call new_number
		mov rdx, rsi
		call atoi
		mov r14, 5
		imul r14
		add r13, rax

	over_k12:
		pop rbp
		pop r15	
		push r15
		push rbp
		inc rbp
		cmp rbp, r12
		je over_k20
		mov rcx, r15 ; Fila a consultar
		mov r11, rbp ; Columna a consultar	

		call new_number
		mov rdx, rsi
		call atoi
		mov r14, -1
		imul r14
		add r13, rax

	over_k20:
		pop rbp
		pop r15	
		push r15
		push rbp
		inc r15
		dec rbp
		cmp rbp, -1
		je over_k21
		cmp r15, r9
		je over_k21
		mov rcx, r15 ; Fila a consultar
		mov r11, rbp ; Columna a consultar	

		call new_number
		mov rdx, rsi
		call atoi
		mov r14, 0
		imul r14
		add r13, rax

	over_k21:
		pop rbp
		pop r15	
		push r15
		push rbp
		inc r15
		cmp r15, r9
		je over_k22
		mov rcx, r15 ; Fila a consultar
		mov r11, rbp ; Columna a consultar	

		call new_number
		mov rdx, rsi
		call atoi
		mov r14, -1
		imul r14
		add r13, rax

	over_k22:
		pop rbp
		pop r15	
		push r15
		push rbp
		inc r15
		inc rbp
		cmp rbp, r12
		je over_conv_final
		cmp r15, r9
		je over_conv_final
		mov rcx, r15 ; Fila a consultar
		mov r11, rbp ; Columna a consultar	

		call new_number
		mov rdx, rsi
		call atoi
		mov r14, 0
		imul r14
		add r13, rax

	over_conv_final:
		pop rbp
		pop r15
		inc rbp

		add r13, 2000

	over_continue_conv:
		mov eax, r13d
		call itoa
		mov [number], rdi
		call over_write

		jmp over_loop

	over_new_fila:
		inc r15
		cmp r15, r9
		je salir
		mov rbp, 0
		jmp over_loop

over_write:
	
	mov rax, SYS_OPEN
	mov rdi, oversharpened
	mov rsi, O_CREAT + O_APPEND + O_WRONLY
	mov rdx, 0666o
	syscall
	
	push rax
	mov rdi, rax
	mov rax, SYS_WRITE
	mov rsi, number
	mov rdx, 4

	syscall

	mov rax, SYS_CLOSE
	pop rdi
	syscall
	ret

