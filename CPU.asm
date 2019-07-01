%include 'io.mac'

.DATA
	menu 		db 		"Programas a cargar:",0
	opciones	db 		"1) Multiplicacion de dos numeros.",0xA,"0) Salir.",0
	pedir_op	db		"Ingrese una opcion: ",0
	error_msg	db 		"La opcion ingresada no es valida.",0
	comand		db		"Ingrese un comando o h para ver la ayuda: ",0
	comand_err	db		"El comando no ha sido encontrado. Ingrese h para ver la ayuda: ",0
	help 		db 		"Lista de comandos:",0xA,"h -> ayuda",0xA,"r -> ver registros",0xA,0
	help2 		db 		"m -> ver memoria",0xA,"e -> ejecutar instruccion",0xA,"s -> regresar al menu",0
	reg_menu	db 		"1) Ver todos los registros",0xA,"2) Ver PC",0xA,"3) Ver IR",0xA,0
	reg_menu2	db 		"4) Ver flags",0xA,"5) Ver AX",0xA,"6) Ver BX",0xA,"7) Ver CX",0xA,0
	reg_menu3	db 		"8) Ver SI",0xA,"9) Ver DS",0xA,"10) Ver CS",0xA,0
	reg_menu4 	db 		"11) Ver MAR",0xA,"0) Volver",0xA,0
	mem_menu 	db 		"1) Ver toda la memoria.",0xA,"2) Ir a una celda.",0xA,"0) Volver",0xA,0
	ing_celda	db 		"Ingrese la celda a revisar: ",0
	celda_inv	db		"La celda ingresada no existe.",0	
	msg_cargar1	db 		"Ingrese el numero a multiplicar: ",0
	msg_cargar2	db 		"Ingrese el segundo a multiplicar: ",0
	msg_cargar3	db 		"El resultado es: ",0
	msg_ins_car	db 		"Se han cargado las instruciones en la memoria.",0
	msg_dir1	db 		"Se cargo la instruccion ",0
	msg_dir2	db 		" en la direccion ",0
	msg_reg1	db 		"Se ha movido un ",0
	msg_reg2 	db 		" al registro ",0
	msg_final	db 		"Ha terminado la ejecucion del programa",0
	msg_startup	db 		"El programa empieza en la linea: ",0
	AXT 		db 		"AX:",0
	BXT 		db 		"BX:",0
	CXT 		db 		"CX:",0
	SIT 		db 		"SI:",0
	DST 		db 		"DS:",0
	CST 		db 		"CS:",0
	FLT 		db 		"flags:",0
	PCT 		db 		"PC:",0
	IRT 		db 		"IR:",0
	MART		db 		"MAR: ",0
	celda		db 		"Celda ",0
	IDATA		db 		".DATA",0
	ICODE		db 		".CODE",0
	ISTARTUP	db		".STARTUP",0
	IEXIT		db 		".EXIT",0
	Idb			db 		"db",0
	Ixor		db 		"xor",0
	IPutStr		db 		"PutStr",0
	IGetInt		db		"GetInt",0
	Iadd 		db 		"add",0
	Iloop		db 		"loop",0
	IPutInt		db		"PutInt",0
	Inwln		db 		"nwln",0
	borrar 		db 		33o, "[H",33o,"[2J",0
.UDATA
	PC 			resb 	2
	IR 			resb 	2
	FLAGSC		resb	2
	AXC			resb	2
	BXC			resb	2
	CXC			resb 	2
	SIC			resb 	2
	DSC			resb 	2
	CSC			resb 	2
	MAR			resb	2
	memoria		resb	256
	entrada		resb	2
	Buf			resb 	1
.CODE
	.STARTUP
		xor 			DL,DL
		call 			menu_inicial 			; Muestra el menu principal
	opc:
		call 			pedir_opc 				; Pide al usuario una opcion
		PutStr			borrar
		cmp 			AX, 0 					; Si el valor ingresado es 0
		je 				salir 					; Termina la ejecucion del programa
		cmp 			AX, 1 					; Si el valor es 1
		je 				ejecutar 				; Pasa a ejecutar el programa
		call 			opcion_inv 				; Si no es ninguna de las anteriores
		jmp 			opc 					; Muestra el error y vuelve a preguntar
	ejecutar:
		call 			pedir_comando 			; Pide al usuario un comando
		PutStr			borrar
		cmp 			byte[entrada], 'h' 		; Si el valor es 'h'
		je 				opc_help 				; Muestra la ayuda
		cmp 			byte[entrada], 'H' 		; Si el valor es 'h'
		je 				opc_help 				; Muestra la ayuda
		cmp 			byte[entrada], 'r' 		; Si el valor es 'r'
		je 				regs 					; Muestra el submenu
		cmp 			byte[entrada], 'R' 		; Si el valor es 'r'
		je 				regs 					; Muestra el submenu
		cmp 			byte[entrada], 'm' 		; Si es 'm'
		je 				mem 					; Muestra el submenu de la memoria
		cmp 			byte[entrada], 'M' 		; Si es 'm'
		je 				mem 					; Muestra el submenu de la memoria
		cmp 			byte[entrada], 'e'		; Si el valor es 'e'
		je 				exc_inst 				; Ejecuta una instruccion
		cmp 			byte[entrada], 'E'		; Si el valor es 'e'
		je 				exc_inst 				; Ejecuta una instruccion
		cmp 			byte[entrada], 's' 		; Si el valor es 's'
		je 				_start 					; Vuelve al menu principal
		cmp 			byte[entrada], 'S' 		; Si el valor es 's'
		je 				_start 					; Vuelve al menu principal
		call 			comand_inv 				; Si no muestra un error
		jmp 			ejecutar 				; Y vuelve a preguntar
	opc_help:
		PutStr			borrar
		call 			ayuda 					; Imprime la ayuda
		jmp 			ejecutar 				; Y vuelve a pedir un comando
	regs:
		call 			mostrar_menu_reg 		; Imprime las opciones
		call 			pedir_opc 				; Pide la opcion
		PutStr			borrar
		cmp 			AX, 0 					; Si la opcion es 0
		je 				ejecutar 				; Vuelve a pedir un comando
		cmp 			AX, 1 					; Si la opcion es 1
		je 				todos_regs 				; Muestra todos los registros
		cmp 			AX, 2 					; Si la opcion es 2
		je 				solo_PC 				; Muestra el PC
		cmp 			AX, 3 					; Si la opcion es 3
		je 				solo_IR 				; Muestra el IR
		cmp 			AX, 4 					; Si la opcion es 4
		je 				solo_flags 				; Muestra las flags
		cmp 			AX, 5 					; Si la opcion es 5
		je 				solo_AX					; Muestra el AX
		cmp 			AX, 6 					; Si la opcion es 6
		je 				solo_BX 				; Muestra el BX
		cmp 			AX, 7 					; Si la opcion es 7
		je 				solo_CX 				; Muestra el CX
		cmp 			AX, 8 					; Si la opcion es 8
		je 				solo_SI 				; Muestra el SI
		cmp 			AX, 9 					; Si la opcion es 9
		je 				solo_DS 				; Muestra el DS
		cmp 			AX, 10 					; Si la opcion es 10
		je 				solo_CS 				; Muestra el CS
		cmp 			AX, 11
		je 				solo_MAR
		call 			opcion_inv 				; si no muestra el mensaje de error
		jmp 			regs 					; Y vuelve a preguntar
	todos_regs:
		PutStr			borrar
		call 			mostrar_regs 			; Muestra todos los registros
		jmp 			regs 					; Y vuelve al menu
	solo_PC:
		PutStr			borrar
		call 			mostrar_PC 				; Muestra el PC
		jmp 			regs 					; Y vuelve al menu
	solo_IR:
		PutStr			borrar
		call 			mostrar_IR 				; Muestra el IR
		jmp 			regs 					; Y vuelve al menu
	solo_flags:
		PutStr			borrar
		call 			mostrar_Flags 			; Muestra las banderas
		jmp 			regs 					; Y vuelve al menu
	solo_AX:
		PutStr			borrar
		call 			mostrar_AX 				; Muestra el AX 
		jmp 			regs 					; Y vuelve al menu
	solo_BX:
		PutStr			borrar
		call 			mostrar_BX 				; Muestra el BX
		jmp 			regs 					; Y vuelve al menu
	solo_CX:
		PutStr			borrar
		call 			mostrar_CX 				; Muestra el CX
		jmp 			regs 					; Y vuelve al menu
	solo_SI:
		PutStr			borrar
		call 			mostrar_SI 				; Muestra SI 
		jmp 			regs 					; Y vuelve al menu
	solo_DS:
		PutStr			borrar
		call 			mostrar_DS 				; Muestra el DS
		jmp 			regs 					; Y vuelve al menu
	solo_CS:
		PutStr			borrar
		call 			mostrar_CS 				; Muestra el CS
		jmp 			regs 					; Y vuelve al menu
	solo_MAR:
		PutStr			borrar
		call 			mostrar_MAR				; Muestra el MAR
		jmp 			regs 					; Y vuelve al menu
	mem:
		PutStr 			mem_menu 				; Muestra el menu
		call 			pedir_opc 				; Y pide una opcion
		cmp 			AX, 0					; Si la opcion es 0
		PutStr			borrar
		je	 			ejecutar 				; Vuelve a preguntar un comando
		cmp 			AX, 1 					; Si la opcion es 0
		je 				todo_mem 				; Muestra toda la memoria
		cmp 			AX, 2 					; Si la opcion es 2
		je 				ver_celda 				; Va pedir la celda
		PutStr			borrar
		call 			opcion_inv 				; Si no muestra un error
		jmp 			mem 	 				; Y vuelve a pedir una opcion
	todo_mem:
		PutStr			borrar
		call 			mostrar_mem 			; Muestra toda la memoria
		jmp 			mem 					; Y vuelve al submenu
	ver_celda:
		PutStr			borrar
		xor 			EAX, EAX 				; Limpia el EAX
		PutStr			ing_celda 				; Pregunta la celda
		GetInt			AX 						; Y la guarda en el AX
		cmp 			AX, 256 				; Verifica si la celda existe
		jge 			err_celda 				; Si no muestra el error
		call 			mostrar_cel 			; Si existe muestra la celda
		jmp 			mem 					; Y vuelve al menu
	err_celda:
		PutStr			borrar
		PutStr 			celda_inv 				; Muestra el error
		nwln
		jmp 			mem 					; Y vuelve al menu de la memoria
	exc_inst:
		PutStr			borrar
		cmp 			DL, 6 					; Si el DL es 6
		je 				prog_final 				; Ya termino el programa
		cmp 			DL,0 					; Verifica si el DL es 0
		je 				cargar_inst 			; Si lo es carga las instrucciones
		call 			ciclo_fetch				; Va a realizar el ciclo de fetch
		jmp 			ejecutar  				; Y vuelve a pedir un comando
	cargar_inst:
		PutStr			borrar
		call 			cargar 					; Carga las instrucciones del programa
		inc 			DL 						; E incrementa el DL
		PutStr			msg_ins_car 			; Y dice que ya cargo las instrucciones
		nwln
		jmp 			ejecutar 				; Y vuelve a pedir un comando
	prog_final:
		PutStr			borrar
		PutStr 			msg_final 				; Imprime el aviso
		nwln 
		jmp 			ejecutar 				; Y vuelve a pedir un comando
salir:
	.EXIT

;############################################################
;# Pide al usuario que ingrese un comando					#
;#  Devuelve el valor ingresado en entrada 					#
;############################################################
pedir_comando:
	PutStr 				comand 					; Imprime el mensaje para pedir un comando
	GetStr				entrada, 1 				; Pide el comando y lo guarda en entrada
	ret

;############################################################
;# Muestra el menu principal en pantalla				 	#
;############################################################
menu_inicial:
	PutStr 			menu 						; Imprime el menu principal
	nwln
	PutStr			opciones 					; Imprime el mensaje de pedir la opcion
	nwln
	ret

;############################################################
;# Pide al usuario una opcion numerica					 	#
;#  Devuelve en el AX el valor ingresado					#
;############################################################
pedir_opc:
	PutStr			pedir_op
	GetInt			AX				; Guarda el dato ingresado en el AX
	ret

;############################################################
;# Muestra un mensaje de opcion invalida				 	#
;############################################################
opcion_inv:
	PutStr			error_msg 		; Muestra el mensaje de error
	nwln
	ret

;############################################################
;# Muestra un mensaje de comando invalida				 	#
;############################################################
comand_inv:
	PutStr			comand_err 		; Muestra el mensaje de comando invalido
	nwln
	ret

;############################################################
;# Muestra los comandos existentes						 	#
;############################################################
ayuda:
	PutStr			help 			; Muestra la primera parte de la ayuda
	PutStr			help2 			; Imprime la segunda parte de la ayuda
	nwln
	ret

;############################################################
;# Muestra las opciones para los registros				 	#
;############################################################
mostrar_menu_reg:
	PutStr			reg_menu 		; Muestra la primera parte del menu de registros
	PutStr			reg_menu2		; Muestra la segunda parte del menu de registros
	PutStr			reg_menu3		; Muestra la tercera parte del menu de registros
	PutStr			reg_menu4		; Muestra la cuarta parte del menu de registros
	ret

;#######################################################################
;# Recibe en el CX el valor a convertir y la mascara en el AX		   #
;#  Convierte numeros de decimal a binario							   #
;#######################################################################
to_bin:
	push 	CX 							; Guarda el CX
	push 	BX 							; Guarda el BX
	xor 	BX, BX 						; Limpia el BX
conver:
	test	CX, AX						; Prueba el valor del bit en el que este la mascara
	jz		poner_0						; Si es 0 lo va a imprimir
	PutInt	1							; De lo contrario, imprime 1
	inc 	BX 							; Incrementa el BX
seguir_conv:			
	shr		AX, 1						; Corre el bit de la mascara
	cmp		AX, 0						; Y si es 0
	je		terminar					; Sale del procedimiento
	cmp 	BX, 4						; Si el BX no es 4
	jne 	conver 						; Continua la conversion
	xor 	BX,BX 					 	; Si no lo limpia
	PutCh 	0x20 						; E imprime un espacio
	jmp		conver						; De lo contrario, sigue imprimiendo
poner_0:		
	PutInt	0							; Imprime el 0
	inc BX
	jmp seguir_conv						; Y continua con la conversion
terminar:
	pop 	BX 							; Restaura el BX
	pop 	CX 							; Restaura el CX
	ret

;########################################################################
;# Muestra el contenido de todos los registros							#
;########################################################################
mostrar_regs:
	call 	mostrar_AX 					; Muestra el AX	
	call 	mostrar_BX 					; Muestra el BX
	call 	mostrar_CX 					; Muestra el CX
	call 	mostrar_SI 					; Muestra el SI
	call 	mostrar_CS 					; Muestra el CS
	call 	mostrar_DS 					; Muestra el DS
	call 	mostrar_Flags 				; Muestra las banderas
	call 	mostrar_PC 					; Muestra el PC
	call 	mostrar_IR 					; Muestra el IR
	call 	mostrar_MAR 				; Muestra el MAR
	ret

;########################################################################
;# Muestra el contenido del AX 											#
;########################################################################
mostrar_AX:
	mov 	CX, [AXC] 					; Pasa al CX lo que hay en el AX simulado
	PutStr	AXT 						; Imprime el nombre del registro
	PutCh	9 							; Imprime un tab
	mov 	AX, 0x8000 					; Mueve al AX la mascara 1000 0000 0000 0000
	call 	to_bin 						; Lo imprime el binario
	nwln
	ret

;########################################################################
;# Muestra el contenido del BX 											#
;########################################################################
mostrar_BX:
	mov 	CX, [BXC] 					; Pasa al CX lo que hay en el BX simulado
	PutStr	BXT							; Imprime el nombre del registro
	PutCh	9							; Imprime un tab
	mov 	AX, 0x8000					; Mueve al AX la mascara 1000 0000 0000 0000
	call 	to_bin 						; Lo imprime el binario
	nwln
	ret

;########################################################################
;# Muestra el contenido del CX 											#
;########################################################################
mostrar_CX:
	mov 	CX, [CXC] 					; Pasa al CX lo que hay en el CX simulado
	PutStr	CXT							; Imprime el nombre del registro
	PutCh	9							; Imprime un tab
	mov 	AX, 0x8000					; Mueve al AX la mascara 1000 0000 0000 0000
	call 	to_bin 						; Lo imprime el binario
	nwln
	ret

;########################################################################
;# Muestra el contenido del SI 											#
;########################################################################
mostrar_SI:
	mov 	CX, [SIC] 					; Pasa al CX lo que hay en el CX simulado
	PutStr	SIT 						; Imprime el nombre del registro
	PutCh	9 							; Imprime un tab
	mov 	AX, 0x8000 					; Mueve al AX la mascara 1000 0000 0000 0000
	call 	to_bin 						; Lo imprime el binario
	nwln
	ret

;########################################################################
;# Muestra el contenido del CS 											#
;########################################################################
mostrar_CS:
	mov 	CX, [CSC] 					; Pasa al CX lo que hay en el CS simulado
	PutStr	CST							; Imprime el nombre del registro
	PutCh	9							; Imprime un tab
	mov 	AX, 0x8000					; Mueve al AX la mascara 1000 0000 0000 0000
	call 	to_bin 						; Lo imprime el binario
	nwln
	ret

;########################################################################
;# Muestra el contenido del DS 											#
;########################################################################
mostrar_DS:
	mov 	CX, [DSC] 					; Pasa al CX lo que hay en el CS simulado
	PutStr	DST 						; Imprime el nombre del registro
	PutCh	9 							; Imprime un tab
	mov 	AX, 0x8000 					; Mueve al AX la mascara 1000 0000 0000 0000
	call 	to_bin 						; Lo imprime el binario
	nwln
	ret

;########################################################################
;# Muestra el contenido de las banderas 								#
;########################################################################
mostrar_Flags:
	mov 	CX, [FLAGSC] 				; Pasa al CX lo que hay en el FLAGS simulado
	PutStr	FLT 						; Imprime el nombre del registro
	PutCh	9 							; Imprime un tab
	mov 	AX, 0x8000 					; Mueve al AX la mascara 1000 0000 0000 0000
	call 	to_bin 						; Lo imprime el binario
	nwln
	ret

;########################################################################
;# Muestra el contenido del PC 											#
;########################################################################
mostrar_PC:
	mov 	CX, [PC] 					; Pasa al CX lo que hay en el FLAGS simulado
	PutStr	PCT 						; Imprime el nombre del registro
	PutCh	9 							; Imprime un tab
	mov 	AX, 0x8000					; Mueve al AX la mascara 1000 0000 0000 0000
	call 	to_bin 						; Lo imprime el binario
	nwln
	ret

;########################################################################
;# Muestra el contenido del IR 											#
;########################################################################
mostrar_IR:
	mov 	CX, [IR] 					; Pasa al CX lo que hay en el FLAGS simulado
	PutStr	IRT 						; Imprime el nombre del registro
	PutCh	9 							; Imprime un tab
	mov 	AX, 0x8000 					; Mueve al AX la mascara 1000 0000 0000 0000
	call 	to_bin 						; Lo imprime el binario
	nwln
	ret

;########################################################################
;# Muestra el contenido del MAR 										#
;########################################################################
mostrar_MAR:
	mov 	CX, [MAR] 					; Pasa al CX lo que hay en el FLAGS simulado
	PutStr	MART 						; Imprime el nombre del registro
	PutCh	9 							; Imprime un tab
	mov 	AX, 0x8000 					; Mueve al AX la mascara 1000 0000 0000 0000
	call 	to_bin 						; Lo imprime el binario
	nwln
	ret

;########################################################################
;# Muestra el contenido de la memoria									#
;########################################################################
mostrar_mem:
	push 	EBX 						; Guarda el EBX
	push 	CX 							; Guarda el CX
	push 	EAX 						; Guarda el EAX
	xor 	CX, CX 						; Limpia el CX
	xor 	EBX, EBX 					; Limpia el EBX
	xor 	EAX, EAX 					; Limpia el EAX
	mov 	EBX, memoria 				; Pone la EBX a apuntar a la memoria
ciclo: 
	mov 	CH, [EBX + 1] 				; Pasa el primer byte de la instruccion al CH
	mov 	CL, [EBX] 					; Pasa el segundo byte de la instruccion al CL
	PutStr	celda 						; Imprime el texto de celda
	PutLInt EAX 						; Imprime el numero de celda
	PutCh	':' 						; Pone dos puntos
	PutCh	9 							; Pone un tab
	push 	EAX 						; Guarda el EAX
	mov 	AX, 0x8000 					; Pone en el AX la mascara 1000 0000 0000 00000
	call 	to_bin 						; Lo imprime en binario
	pop 	EAX 						; Restaura el EAX
	nwln 	
	add 	EBX, 2 						; Pone al EBX a apuntar a la siguiente instruccion
	add 	EAX, 2 						; Aumenta el numero de celda
	cmp 	EAX, 0x100 					; Si el EAX no es 256
	jne 	ciclo 						; Vuelve al ciclo
	pop 	EAX 						; Restaura el EAX
	pop 	CX 							; Restaura el CX
	pop 	EBX 						; Restaura el EBX
	ret

;########################################################################
;# Muestra el contenido de una celda de memoria							#
;########################################################################
mostrar_cel:
	push 	EBX 						; Guarda el EBX
	push 	CX 							; Guarda el CX
	push 	AX 							; Guarda el AX
	xor 	CX, CX 						; Limpia el CX
	xor 	EBX, EBX 					; Limpia el EBX
	mov 	EBX, memoria 				; Pone al EBX a apuntar a la memoria
	add 	EBX, EAX 					; Le suma al EBX el numero de celda
ciclo_cel:
	mov 	CL, byte[EBX] 				; Mueve al CL el byte que contiene la celda
	PutStr	celda 						; Muestra el mensaje de celda
	PutLInt EAX 						; Imprime el numero de celda
	PutCh	':' 						; Pone :
	PutCh	9 							; Imprime un tab
	push 	AX 							; Guarda el AX
	mov 	AX, 0x80 					; Mueve la mascara 1000 0000 en el AX
	call 	to_bin 						; Lo imprime en binario
	pop 	AX 							; Restaura el AX
	nwln
	pop 	AX 							; Restaura el AX
	pop 	CX 							; Restaura el CX
	pop 	EBX 						; Restaura el EBX
	ret

;########################################################################
;# Carga las instrucciones en memoria 									#
;########################################################################
cargar:
	push 	EBX 						; Guarda el EBX
	push 	ESI 						; Guarda el ESI
	mov 	word[PC], 0 				; Limpia el PC
	PutStr	msg_reg1 					; Muestra el mensaje de cambio
	PutInt	0 							; Muestra el cambio
	PutStr	msg_reg2 					; Muestra el mensaje de donde cambio
	PutStr	PCT 						; Muestra el registro de cambio
	nwln
	mov 	EBX, memoria 				; Pone al EBX a apuntar a la memoria
	mov 	word[EBX], 0x8000 			; Mueve la instruccion .CODE a la primera direccion
	PutStr	msg_dir1 					; Muestra el mensaje de cambio
	PutStr	ICODE						; Muestra el cambio
	PutStr	msg_dir2					; Muestra el mensaje de donde cambio
	push 	EBX							; Guarda el EBX
	sub 	EBX, memoria 				; Calcula la celda
	PutLInt	EBX							; Muestra la celda de cambio
	nwln
	pop 	EBX 						; Restaura el EBX
	add 	EBX,2 						; Y lo pone a apuntar a la siguiente instruccion
	mov 	word[EBX], 0x8004			; Mueve la instruccion db a la primera direccion
	PutStr	msg_dir1					; Muestra el mensaje de cambio
	PutStr	Idb							; Muestra el cambio
	PutStr	msg_dir2					; Muestra el mensaje de donde cambio
	push 	EBX							; Guarda el EBX
	sub 	EBX, memoria 				; Calcula la celda
	PutLInt	EBX 						; Muestra la celda de cambio
	nwln
	pop 	EBX 						; Restaura el EBX
	add 	EBX,2 						; Y lo pone a apuntar a la siguiente instruccion
	mov 	ESI, msg_cargar1 			; Mueve al ESI el mensaje que se cargara
	call 	cargar_msg 					; Y lo carga
	mov 	word[EBX], 0x8004 			; Mueve la instruccion db a la primera direccion
	PutStr	msg_dir1 					; Muestra el mensaje de cambio
	PutStr	Idb 						; Muestra el cambio
	PutStr	msg_dir2 					; Muestra el mensaje de donde cambio
	push 	EBX 						; Guarda el EBX
	sub 	EBX, memoria 				; Calcula la celda
	PutLInt	EBX 						; Muestra la celda de cambio
	nwln
	pop 	EBX							; Restaura el EBX
	add 	EBX,2						; Y lo pone a apuntar a la siguiente instruccion
	mov 	ESI, msg_cargar2 			; Mueve al ESI el mensaje que se cargara
	call 	cargar_msg 					; Y lo carga
	mov 	word[EBX], 0x8004 			; Mueve la instruccion db a la primera direccion
	PutStr	msg_dir1 					; Muestra el mensaje de cambio
	PutStr	Idb 						; Muestra el cambio
	PutStr	msg_dir2 					; Muestra el mensaje de donde cambio
	push 	EBX 						; Guarda el EBX
	sub 	EBX, memoria 				; Calcula la celda
	PutLInt	EBX 						; Muestra la celda de cambio
	nwln
	pop 	EBX 						; Restaura el EBX
	add 	EBX,2 						; Y lo pone a apuntar a la siguiente instruccion
	mov 	ESI, msg_cargar3 			; Mueve al ESI el mensaje que se cargara
	call 	cargar_msg 					; Y lo carga
	mov 	word[EBX], 0x8001 			; Mueve la instruccion .CODE a la primera direccion
	PutStr	msg_dir1 					; Muestra el mensaje de cambio
	PutStr	ICODE 						; Muestra el cambio
	PutStr	msg_dir2 					; Muestra el mensaje de donde cambio
	push 	EBX 						; Guarda el EBX
	sub 	EBX, memoria 				; Calcula la celda
	PutLInt	EBX 						; Muestra la celda de cambio
	nwln
	pop 	EBX							; Restaura el EBX
	add 	EBX,2						; Y lo pone a apuntar a la siguiente instruccion
	mov 	word[EBX], 0x8002			; Mueve la instruccion .STARTUP a la direccion
	PutStr	msg_dir1 					; Muestra el mensaje de cambio
	PutStr	ISTARTUP 					; Muestra el cambio
	PutStr	msg_dir2 					; Muestra el mensaje de donde cambio
	push 	EBX 						; Guarda el EBX
	sub 	EBX, memoria 				; Calcula la celda
	PutLInt	EBX 						; Muestra la celda de cambio
	nwln
	pop 	EBX 						; Restaura el EBX
	add 	EBX,2 						; Y lo pone a apuntar a la siguiente instruccion
	mov 	word[EBX], 0x8005 			; Mueve la instruccion xor a la direccion
	PutStr	msg_dir1 					; Muestra el mensaje de cambio
	PutStr	Ixor 						; Muestra el cambio
	PutStr	msg_dir2 					; Muestra el mensaje de donde cambio
	push 	EBX 						; Guarda el EBX
	sub 	EBX, memoria 				; Calcula la celda
	PutLInt	EBX 						; Muestra la celda de cambio
	nwln
	pop 	EBX 						; Restaura el EBX
	add 	EBX,2	 					; Y lo pone a apuntar a la siguiente instruccion
	mov 	word[EBX], 0x0801 			; Mueve la instruccion BX a la direccion
	PutStr	msg_dir1 					; Muestra el mensaje de cambio
	PutStr	BXT							; Muestra el cambio
	PutStr	msg_dir2					; Muestra el mensaje de donde cambio
	push 	EBX 						; Guarda el EBX
	sub 	EBX, memoria 				; Calcula la celda
	PutLInt	EBX 						; Muestra la celda de cambio
	nwln
	pop 	EBX 						; Restaura el EBX
	add 	EBX,2 						; Y lo pone a apuntar a la siguiente instruccion
	mov 	word[EBX], 0x0801 			; Mueve la instruccion BX a la direccion
	PutStr	msg_dir1 					; Muestra el mensaje de cambio
	PutStr	BXT 						; Muestra el cambio
	PutStr	msg_dir2					; Muestra el mensaje de donde cambio
	push 	EBX 						; Guarda el EBX
	sub 	EBX, memoria 				; Calcula la celda
	PutLInt	EBX 						; Muestra la celda de cambio
	nwln
	pop 	EBX 						; Restaura el EBX
	add 	EBX,2 						; Y lo pone a apuntar a la siguiente instruccion
	mov 	word[EBX], 0x8006 			; Mueve la instruccion PutStr a la direccion
	PutStr	msg_dir1 					; Muestra el mensaje de cambio					
	PutStr	IPutStr 					; Muestra el cambio
	PutStr	msg_dir2 					; Muestra el mensaje de donde cambio
	push 	EBX 						; Guarda el EBX
	sub 	EBX, memoria 				; Calcula la celda
	PutLInt	EBX 						; Muestra la celda de cambio
	nwln
	pop 	EBX 						; Restaura el EBX
	add 	EBX,2 						; Y lo pone a apuntar a la siguiente instruccion
	mov 	word[EBX], 0x0002 			; Mueve un 2 a la direccion
	PutStr	msg_dir1 					; Muestra el mensaje de cambio	
	PutInt 	2							; Muestra el cambio
	PutStr	msg_dir2 					; Muestra el mensaje de donde cambio
	push 	EBX 						; Guarda el EBX
	sub 	EBX, memoria 				; Calcula la celda
	PutLInt	EBX							; Muestra la celda de cambio
	nwln
	pop 	EBX 						; Restaura el EBX
	add 	EBX,2 						; Y lo pone a apuntar a la siguiente instruccion
	mov 	word[EBX], 0x8007 			; Mueve la instruccion GetInt a la direccion
	PutStr	msg_dir1 					; Muestra el mensaje de cambio	
	PutStr	IGetInt 					; Muestra el cambio
	PutStr	msg_dir2 					; Muestra el mensaje de donde cambio
	push 	EBX 						; Guarda el EBX
	sub 	EBX, memoria 				; Calcula la celda
	PutLInt	EBX 						; Muestra la celda de cambio
	nwln
	pop 	EBX 						; Restaura el EBX
	add 	EBX,2 						; Y lo pone a apuntar a la siguiente instruccion
	mov 	word[EBX], 0x0800 			; Mueve la instruccion AX a la direccion
	PutStr	msg_dir1 					; Muestra el mensaje de cambio
	PutStr	AXT 						; Muestra el cambio
	PutStr	msg_dir2 					; Muestra el mensaje de donde cambio
	push 	EBX 						; Guarda el EBX
	sub 	EBX, memoria 				; Calcula la celda
	PutLInt	EBX 						; Muestra la celda de cambio
	nwln
	pop 	EBX 						; Restaura el EBX
	add 	EBX,2 						; Y lo pone a apuntar a la siguiente instruccion
	mov 	word[EBX], 0x8006 			; Mueve la instruccion PutStr a la direccion
	PutStr	msg_dir1 					; Muestra el mensaje de cambio
	PutStr	IPutStr 					; Muestra el cambio
	PutStr	msg_dir2 					; Muestra el mensaje de donde cambio
	push 	EBX 						; Guarda el EBX
	sub 	EBX, memoria 				; Calcula la celda
	PutLInt	EBX 						; Muestra la celda de cambio
	nwln
	pop 	EBX 						; Restaura el EBX
	add 	EBX,2 						; Y lo pone a apuntar a la siguiente instruccion
	mov 	word[EBX], 0x0026 			; Mueve un 26 a la direccion
	PutStr	msg_dir1 					; Muestra el mensaje de cambio
	PutInt 	26 							; Muestra el cambio
	PutStr	msg_dir2 					; Muestra el mensaje de donde cambio
	push 	EBX 						; Guarda el EBX
	sub 	EBX, memoria 				; Calcula la celda
	PutLInt	EBX 						; Muestra la celda de cambio
	nwln
	pop 	EBX 						; Restaura el EBX
	add 	EBX,2 						; Y lo pone a apuntar a la siguiente instruccion
	mov 	word[EBX], 0x8007 			; Mueve la instruccion GetInt a la direccion
	PutStr	msg_dir1 					; Muestra el mensaje de cambio
	PutStr	IGetInt 					; Muestra el cambio
	PutStr	msg_dir2 					; Muestra el mensaje de donde cambio
	push 	EBX 						; Guarda el EBX
	sub 	EBX, memoria 				; Calcula la celda
	PutLInt	EBX							; Muestra la celda de cambio
	nwln 								
	pop 	EBX							; Restaura el EBX
	add 	EBX,2 						; Y lo pone a apuntar a la siguiente instruccion
	mov 	word[EBX], 0x0802 			; Mueve la instruccion CX a la direccion
	PutStr	msg_dir1 					; Muestra el mensaje de cambio
	PutStr	CXT 						; Muestra el cambio
	PutStr	msg_dir2 					; Muestra el mensaje de donde cambio
	push 	EBX 						; Guarda el EBX
	sub 	EBX	, memoria 				; Calcula la celda
	PutLInt	EBX 						; Muestra la celda de cambio
	nwln
	pop 	EBX 						; Restaura el EBX
	add 	EBX,2 						; Y lo pone a apuntar a la siguiente instruccion
	mov 	word[EBX], 0x8008 			; Mueve la instruccion add a la direccion
	PutStr	msg_dir1 					; Muestra el mensaje de cambio
	PutStr	Iadd 						; Muestra el cambio
	PutStr	msg_dir2 					; Muestra el mensaje de donde cambio
	push 	EBX							; Guarda el EBX
	sub 	EBX, memoria  				; Calcula la celda
	PutLInt	EBX 						; Muestra la celda de cambio
	nwln
	pop 	EBX 						; Restaura el EBX
	add 	EBX,2 						; Y lo pone a apuntar a la siguiente instruccion
	mov 	word[EBX], 0x0801 			; Mueve la instruccion BX a la direccion
	PutStr	msg_dir1 					; Muestra el mensaje de cambio
	PutStr	BXT 						; Muestra el cambio
	PutStr	msg_dir2 					; Muestra el mensaje de donde cambio
	push 	EBX 						; Guarda el EBX
	sub 	EBX, memoria 				; Calcula la celda
	PutLInt	EBX 						; Muestra la celda de cambio
	nwln 
	pop 	EBX    						; Restaura el EBX
	add 	EBX,2 						; Y lo pone a apuntar a la siguiente instruccion
	mov 	word[EBX], 0x0800 			; Mueve la instruccion AX a la direccion
	PutStr	msg_dir1 					; Muestra el mensaje de cambio
	PutStr	AXT 						; Muestra el cambio
	PutStr	msg_dir2 					; Muestra el mensaje de donde cambio
	push 	EBX 						; Guarda el EBX
	sub 	EBX, memoria 				; Calcula la celda
	PutLInt	EBX 						; Muestra la celda de cambio
	nwln
	pop 	EBX 						; Restaura el EBX
	add 	EBX,2 						; Y lo pone a apuntar a la siguiente instruccion
	mov 	word[EBX], 0x8009 			; Mueve la instruccion loop a la direccion
	PutStr	msg_dir1 					; Muestra el mensaje de cambio
	PutStr	Iloop 						; Muestra el cambio
	PutStr	msg_dir2 					; Muestra el mensaje de donde cambio
	push 	EBX 						; Guarda el EBX
	sub 	EBX, memoria 				; Calcula la celda
	PutLInt	EBX 						; Muestra la celda de cambio
	nwln
	pop 	EBX 						; Restaura el EBX
	add 	EBX,2 						; Y lo pone a apuntar a la siguiente instruccion
	mov 	word[EBX], 0xFFF6 			; Mueve un FFF6 a la direccion
	add 	EBX,2 						; Y lo pone a apuntar a la siguiente instruccion
	PutStr	msg_dir1 					; Muestra el mensaje de cambio
	PutInt	0xFFF6 						; Muestra el cambio
	PutStr	msg_dir2 					; Muestra el mensaje de donde cambio
	push 	EBX 						; Guarda el EBX
	sub 	EBX, memoria 				; Calcula la celda
	PutLInt	EBX 						; Muestra la celda de cambio
	nwln
	pop 	EBX 						; Restaura el EBX
	mov 	word[EBX], 0x8006 			; Mueve la instruccion PutStr a la direccion
	PutStr	msg_dir1 					; Muestra el mensaje de cambio
	PutStr	IPutStr 					; Muestra el cambio
	PutStr	msg_dir2 					; Muestra el mensaje de donde cambio
	push 	EBX 						; Guarda el EBX
	sub 	EBX, memoria 				; Calcula la celda
	PutLInt	EBX 						; Muestra la celda de cambio
	nwln
	pop 	EBX 						; Restaura el EBX
	add 	EBX,2 						; Y lo pone a apuntar a la siguiente instruccion
	mov 	word[EBX], 0x004B 			; Mueve un 4B a la direccion
	PutStr	msg_dir1 					; Muestra el mensaje de cambio
	PutInt 	0x004B 						; Muestra el cambio
	PutStr	msg_dir2 					; Muestra el mensaje de donde cambio
	push 	EBX 						; Guarda el EBX
	sub 	EBX, memoria 				; Calcula la celda
	PutLInt	EBX 						; Muestra la celda de cambio
	nwln
	pop 	EBX 						; Restaura el EBX
	add 	EBX,2 						; Y lo pone a apuntar a la siguiente instruccion
	mov 	word[EBX], 0x800A 			; Mueve la instruccion PutInt a la direccion
	PutStr	msg_dir1 					; Muestra el mensaje de cambio
	PutStr 	IPutInt 					; Muestra el cambio
	PutStr	msg_dir2 					; Muestra el mensaje de donde cambio
	push 	EBX 						; Guarda el EBX
	sub 	EBX, memoria 				; Calcula la celda
	PutLInt	EBX 						; Muestra la celda de cambio
	nwln
	pop 	EBX 						; Restaura el EBX
	add 	EBX,2 						; Y lo pone a apuntar a la siguiente instruccion
	mov 	word[EBX], 0x0801 			; Mueve la instruccion BX a la direccion
	PutStr	msg_dir1 					; Muestra el mensaje de cambio
	PutStr 	BXT 						; Muestra el cambio
	PutStr	msg_dir2 					; Muestra el mensaje de donde cambio
	push 	EBX 						; Guarda el EBX
	sub 	EBX, memoria 				; Calcula la celda
	PutLInt	EBX 						; Muestra la celda de cambio
	nwln
	pop 	EBX 						; Restaura el EBX
	add 	EBX,2 						; Y lo pone a apuntar a la siguiente instruccion
	mov 	word[EBX], 0x800B 			; Mueve la instruccion nwln a la direccion
	PutStr	msg_dir1 					; Muestra el mensaje de cambio
	PutStr 	Inwln 						; Muestra el cambio
	PutStr	msg_dir2 					; Muestra el mensaje de donde cambio
	push 	EBX 						; Guarda el EBX
	sub 	EBX, memoria 				; Calcula la celda
	PutLInt	EBX 						; Muestra la celda de cambio
	nwln
	pop 	EBX 						; Restaura el EBX
	add 	EBX,2 						; Y lo pone a apuntar a la siguiente instruccion
	mov 	word[EBX], 0x8003 			; Mueve la instruccion .EXIT a la direccion
	PutStr	msg_dir1 					; Muestra el mensaje de cambio
	PutStr 	IEXIT 						; Muestra el cambio
	PutStr	msg_dir2 					; Muestra el mensaje de donde cambio
	push 	EBX 						; Guarda el EBX
	sub 	EBX, memoria 				; Calcula la celda
	PutLInt	EBX  						; Muestra la celda de cambio
	nwln
	pop 	EBX 						; Restaura el EBX
	add 	EBX,2 						;  Y lo pone a apuntar a la siguiente instruccion
	pop 	ESI 						; Restaura el ESI
	pop 	EBX 						; Restaura el EBX
	ret

;########################################################################
;# Carga el primer mensaje en la memoria								#
;#  Recibe en el CX el numero de linea y la posicion de memoria a donde	#
;#   ingresar el mensaje en el EBX. Ademas el ESI debe apuntar al		#
;#    mensaje															#
;########################################################################
cargar_msg:
	push 	EAX 						; Guarda el EAX
ciclo_msg:
	cmp 	byte[ESI], 0 				; Revisa si ya llego al final del string
	je 		final_ciclo 				; Si es asi sale
	mov 	AX, [ESI] 					; Mueve el caracter al AX
	mov 	[EBX], AX 					; Mueve el caracter a la memoria
	PutStr	msg_dir1 					; Muestra el mensaje de cambio
	PutCh 	[ESI] 						; Muestra el cambio
	PutStr	msg_dir2 					; Muestra el mensaje donde cambio
	push 	EBX 						; Guarda el EBX
	sub 	EBX, memoria 				; Calcula la direccion
	PutLInt	EBX 						; Imprime el cambio
	nwln 	
	pop 	EBX 						; Restaura el EBX
	inc 	ESI 						; Pone al ESI a apuntar al caracter siguiente
	inc 	EBX 						; Pone al EBX a apuntar a la direccion siguiente
	inc 	CX 							; Incremeta el contador de caracteres
	jmp 	ciclo_msg 					; Y vuelve a hacer el ciclo
final_ciclo:
	mov 	byte[EBX], 0 				; Pone en memoria el caracter nulo
	inc 	CX 							; Incrementa el contador de caracteres
	inc 	EBX 						; Pone a apuntar al EBX a la siguiente direccion
	pop 	EAX 						; Restaura el EAX
	ret

;########################################################################
;# Realiza el ciclo de fetch											#
;#  Recibe en el DL el punto del ciclo en el que se encuentra			#
;########################################################################
ciclo_fetch:
	cmp 	DL, 1 						; Comprueba si el DL es 1
	je 		buscar 						; Si es asi pasa al subciclo de busqueda
	cmp 	DL, 2  						; Comprueba si el DL es 2
	je 		decodificacion 				; Si es asi pasa al subciclo de decodificacion
	cmp 	DL, 3 						; Comprueba si el DL es 3
	je 		ejecucion 					; Si es asi pasa al subciclo de ejecucion
	jmp 	fin_ciclo 					; Si no sale
buscar:
	push 	EBX 						; Guarda el EBX
	push 	ESI 						; Guarda el ESI
	push 	EDI 						; Guarda el EDI
	push 	EAX 						; Guarda el EAX
	xor 	EBX, EBX 					; Limpia el EBX
	xor 	AX, AX 						; Limpia el AX
	mov 	BX, word[PC] 				; Mueve al BX la direccion de la siguiente instruccion
	mov 	ESI, MAR 					; Pone al ESI a apuntar al MAR
	mov 	EDI, IR 					; Pone al EDI a apuntar al IR
	mov 	AX, word[memoria + EBX] 	; Mueve al AX lo que hay en la direccion del PC
	mov 	[ESI], AX 					; Mueve al MAR la instrucion que se encontro
	PutStr	msg_reg1 					; Muestra el mensaje de cambio
	PutInt	AX 							; Muestra el cambio
	PutStr	msg_reg2 					; Muestra el mensaje de donde cambio
	PutStr	MART 						; Imprime donde cambio
	nwln 	
	mov 	[EDI], AX 					; Mueve al IR la instrucion encontrada
	PutStr	msg_reg1 					; Muestra el mensaje de cambio
	PutInt	AX 							; Muestra el cambio
	PutStr	msg_reg2 					; Muestra el mensaje de donde cambio
	PutStr	IRT 						; Muestra donde cambio
	nwln 	
	pop 	EAX 						; Restaura el EAX
	pop 	EDI 						; Restaura el EDI
	pop 	ESI  						; Restaura el ESI
	pop 	EBX 						; Restaura el EBX
	jmp 	fin_ciclo 					; Sale
decodificacion:
	add 	word[PC], 2
	PutStr	msg_reg1
	PutInt	word[PC]
	PutStr	msg_reg2
	PutStr	PCT
	nwln
	cmp 	word[IR], 0x8005
	je	 	operandos
	cmp 	word[IR], 0x8006
	je 		operandos
	cmp 	word[IR], 0x8007
	je 		operandos
	cmp 	word[IR], 0x8008
	je 		operandos
	cmp 	word[IR], 0x8009
	je 		operandos
	cmp 	word[IR], 0x800A
	je 		operandos
	jmp 	fin_ciclo
operandos:
	mov 	SI, word[PC]
	add 	word[PC], 2
	PutStr	msg_reg1
	PutInt	word[PC]
	PutStr	msg_reg2
	PutStr	PCT
	nwln
	mov 	DL, 2
	jmp 	fin_ciclo
ejecucion:
	cmp 	word[IR], 0x8000
	je 		Data
	cmp 	word[IR], 0x8001
	je 		Code
	cmp 	word[IR], 0x8002
	je 		StartUp
	cmp 	word[IR], 0x8003
	je 		Exit
	cmp 	word[IR], 0x8004
	je 		define
	cmp 	word[IR], 0x8005
	je 		Ins_xor
	cmp 	word[IR], 0x8006
	je 		Ins_PutStr
	cmp 	word[IR], 0x8007
	je 		Ins_GetInt
	cmp 	word[IR], 0x8008
	je 		Ins_add
	cmp 	word[IR], 0x8009
	je 		Ins_loop
	cmp 	word[IR], 0x800A
	je 		Ins_PutInt
	cmp 	word[IR], 0x800B	
	je 		Ins_nwln
	jmp 	fin_ciclo
Data:
	push 	AX
	mov 	AX, [PC]
	mov 	[DSC], AX
	PutStr	msg_reg1
	PutInt	AX
	PutStr	msg_reg2
	PutStr	DST
	nwln
	mov 	word[FLAGSC], 0x0000
	PutStr	msg_reg1
	PutInt	word[FLAGSC]
	PutStr	msg_reg2
	PutStr	FLT
	nwln
	pop 	AX
	mov 	DL, 0
	jmp 	fin_ciclo
Code:
	push 	EAX
	mov 	EAX, [PC]
	dec 	EAX
	mov 	[CSC], EAX
	PutStr	msg_reg1
	PutLInt	EAX
	PutStr	msg_reg2
	PutStr	CST
	nwln
	mov 	word[FLAGSC], 0x0000
	PutStr	msg_reg1
	PutInt	word[FLAGSC]
	PutStr	msg_reg2
	PutStr	FLT
	nwln
	pop 	EAX
	mov 	DL, 0
	jmp 	fin_ciclo
StartUp:
	PutStr	msg_startup
	PutInt [PC]
	nwln
	mov 	word[FLAGSC], 0x0000
	PutStr	msg_reg1
	PutInt	word[FLAGSC]
	PutStr	msg_reg2
	PutStr	FLT
	nwln
	mov 	DL, 0
	jmp 	fin_ciclo
Exit:
	mov 	word[AXC], 1
	PutStr	msg_reg1
	PutInt	1
	PutStr	msg_reg2
	PutStr	AXT
	nwln
	mov  	word[BXC], 0
	PutStr	msg_reg1
	PutInt	0
	PutStr	msg_reg2
	PutStr	BXT
	nwln
	PutStr 			msg_final
	nwln
	mov 	word[FLAGSC], 0x0000
	PutStr	msg_reg1
	PutInt	word[FLAGSC]
	PutStr	msg_reg2
	PutStr	FLT
	nwln
	mov 	DL, 5
	jmp 	fin_ciclo
define:
	push 	ECX
	mov 	ECX, memoria
	add 	CX, word[PC]
ciclo_def:
	cmp 	byte[ECX], 0
	je 		final_def
	inc 	ECX
	inc 	word[PC]
	PutStr	msg_reg1
	PutInt	word[PC]
	PutStr	msg_reg2
	PutStr	PCT
	nwln
	jmp 	ciclo_def
final_def:
	inc 	word[PC]
	PutStr	msg_reg1
	PutInt	word[PC]
	PutStr	msg_reg2
	PutStr	PCT
	nwln
	mov 	word[FLAGSC], 0x0000
	PutStr	msg_reg1
	PutInt	word[FLAGSC]
	PutStr	msg_reg2
	PutStr	FLT
	nwln
	pop 	ECX
	mov 	DL, 0
	jmp 	fin_ciclo
Ins_xor:
	push 	EAX
	push 	EBX
	mov 	EAX, memoria
	add 	word[PC], 2
	PutStr	msg_reg1
	PutInt	word[PC]
	PutStr	msg_reg2
	PutStr	PCT
	nwln
	add 	AX, SI
	mov 	EBX, EAX
	mov 	AX, [EAX]
	add 	EBX, 2
	mov 	BX, [EBX]
	mov 	EAX, [BXC]
	xor 	[BXC], EAX
	PutStr	msg_reg1
	PutInt	word[BXC]
	PutStr	msg_reg2
	PutStr	BXT
	nwln
	mov 	word[FLAGSC], 0x0020
	PutStr	msg_reg1
	PutInt	word[FLAGSC]
	PutStr	msg_reg2
	PutStr	FLT
	nwln
	pop 	EBX
	pop 	EAX
	mov 	EDX, 0
	jmp 	fin_ciclo
Ins_PutStr:
	push 	EAX
	push 	EBX
	mov 	EAX, memoria
	add 	AX, SI
	mov 	EBX, memoria
	add 	BX, [EAX]
	add 	EBX, 2
	PutStr 	EBX
	nwln
	mov 	word[FLAGSC], 0x0000
	PutStr	msg_reg1
	PutInt	word[FLAGSC]
	PutStr	msg_reg2
	PutStr	FLT
	nwln
	pop 	EBX
	pop 	EAX
	mov 	DL, 0
	jmp 	fin_ciclo
Ins_GetInt:
	push 	EAX
	push 	EBX
	mov 	EAX, memoria
	add 	AX, SI
	cmp 	word[EAX], 0x0800
	je 		In_AX
	cmp 	word[EAX], 0x0802
	je 		In_CX
In_AX:
	GetInt	word[AXC]
	PutStr	msg_reg1
	PutInt	word[AXC]
	PutStr	msg_reg2
	PutStr	AXT
	nwln
	jmp 	continuar
In_CX:
	GetInt	word[CXC]
	PutStr	msg_reg1
	PutInt	word[CXC]
	PutStr	msg_reg2
	PutStr	CXT
	nwln
	jmp 	continuar
continuar:
	mov 	word[FLAGSC], 0x0000
	PutStr	msg_reg1
	PutInt	word[FLAGSC]
	PutStr	msg_reg2
	PutStr	FLT
	nwln
	pop 	EAX
	pop 	EBX
	mov 	DL, 0
	jmp 	fin_ciclo
Ins_add:
	push 	EAX
	push 	EBX
	add 	word[PC], 2
	PutStr	msg_reg1
	PutInt	word[PC]
	PutStr	msg_reg2
	PutStr	PCT
	nwln
	mov  	EAX, [AXC]
	add 	[BXC], AX
	PutStr	msg_reg1
	PutInt	[BXC]
	PutStr	msg_reg2
	PutStr	BXT
	nwln
	jo 		overflow_add
	jz 		zero_add
	mov 	word[FLAGSC], 0x0000
	PutStr	msg_reg1
	PutInt	word[FLAGSC]
	PutStr	msg_reg2
	PutStr	FLT
	nwln
final_add:
	pop 	EBX
	pop 	EAX
	mov 	DL, 0
	jmp 	fin_ciclo
overflow_add:
	mov 	word[FLAGSC], 0x0200
	PutStr	msg_reg1
	PutInt	word[FLAGSC]
	PutStr	msg_reg2
	PutStr	FLT
	nwln
	jmp  	final_add	
zero_add:
	mov 	word[FLAGSC], 0x0020
	PutStr	msg_reg1
	PutInt	word[FLAGSC]
	PutStr	msg_reg2
	PutStr	FLT
	nwln
	jmp 	final_add
Ins_loop:
	push 	EAX
	dec 	word[CXC]
	PutStr	msg_reg1
	PutInt	word[CXC]
	PutStr	msg_reg2
	PutStr	CXT
	nwln
	cmp 	word[CXC], 0
	je 		zero_loop
	xor 	EAX, EAX
	mov 	AX, SI
	mov 	AX, [memoria + EAX]
	add 	[PC], AX
	PutStr	msg_reg1
	PutInt	word[PC]
	PutStr	msg_reg2
	PutStr	PCT
	nwln
	mov 	word[FLAGSC], 0x0000
	PutStr	msg_reg1
	PutInt	word[FLAGSC]
	PutStr	msg_reg2
	PutStr	FLT
	jmp 	salir_loop
zero_loop:
	mov 	word[FLAGSC], 0x0020
	PutStr	msg_reg1
	PutInt	word[FLAGSC]
	PutStr	msg_reg2
	PutStr	FLT
salir_loop:
	pop 	EAX
	mov 	DL, 0
	jmp 	fin_ciclo
Ins_PutInt:
	push 	EAX
	PutInt 	[BXC]
	nwln
	mov 	word[FLAGSC], 0x0000
	PutStr	msg_reg1
	PutInt	word[FLAGSC]
	PutStr	msg_reg2
	PutStr	FLT
	pop 	EAX
	mov 	DL, 0
	jmp 	fin_ciclo
Ins_nwln:
	nwln
	mov 	word[FLAGSC], 0x0000
	PutStr	msg_reg1
	PutInt	word[FLAGSC]
	PutStr	msg_reg2
	PutStr	FLT
	mov 	DL, 0
fin_ciclo:
	inc 	DL
	ret
