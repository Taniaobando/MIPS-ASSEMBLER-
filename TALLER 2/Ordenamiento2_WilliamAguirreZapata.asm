# ===================================================================================================================================
# Estudiante:	William Aguirre Zapata
# Archivo:      Ordenamiento2_WilliamAguirreZapata.asm
# Descripción:  Genere un arreglo de números aleatorios de 111 elementos,
#		A continuación, utilice MergeSort para ordenar el arreglo.
#		Durante cada iteración de merge, imprima los dos arreglos que van a ser juntados y el arreglo
#		resultado.
# Nota: 	La impresión recursiva no la logré hacer así que es la única excepción que tengo
# ===================================================================================================================================
#
#===( Data )=========================================================================================================================
.data
	miArreglo:	.space 444			# Reservo un espacio de 444 por 111 numeros para el arreglo aleatorio
	miArreglo2: 	.space 444			# Reservo un espacio de 444 por 111 numeros para el arreglo ordenado por MergeSort
	espacio:	.asciiz " "			# String que me sirve para separar los numeros
	salto:		.asciiz "\n"			# Salto de linea
	mensaje1:	.asciiz "Arreglo Aleatorio:"	# Letrero de arreglo Aleatorio
	mensaje2:	.asciiz "Arreglo Ordenado:"	# Letrero de arreglo Ordenado
	
	
	
#===( Text )=========================================================================================================================
.text
#===( Imprimir letrero de Arreglo no ordenado )======================================================================================
li 	$v0, 4 		# Codigo para llamado del sistema con el 4
la 	$a0, mensaje1 	# Carga la direccion de la palabra a mostrar
syscall
li 	$v0, 4		# Codigo para llamado del sistema con el 4
la 	$a0, salto	# Carga la direccion del salto de linea
syscall



#===( Creamos el arreglo de numeros aleatorios )=====================================================================================
addi	$t0, $t0, 0			# $t0 = 0
while:
	beq	$t0, 444, inicio	# 444 espacios de memoria por 111 numeros
	#-------( Guarda los valores aleatorios en miArreglo )--------------------------------------
	addi	$v0, $0, 42		# Funcion Random de $v0 numero 42
	addi	$a1, $0, 1000		# El limite de numeros de 0 a 1000
	syscall
	
	sw	$a0, miArreglo($t0)	# Almacena en el caracter de memoria direccionada por miArreglo($t0), el contenido del registro $a0
	addi	$t0, $t0, 4		# $t0 es el indice para recorrer miArreglo
	j	while
inicio:
	sub	$t0, $t0, $t0		# $t0 = 0
while1:
	beq	$t0, 444, printSinOrdenado # Dentra en printSinOrdenado si $t0(indice) = 10 (ultima posicion del indice)
	addi 	$t0, $t0, 4		# indice = indice + 1
	sub 	$t1, $t1, $t1   	# $t1 = 0
	sub 	$t2, $t2, $t2   	# $t2 = 0
	addi 	$t2,$t1,4		# $t2 = $t1 + 1
	while1.1: 
		beq 	$t1, 3996, while1	# Dentra al while1 si $t1 = 999			
		lw 	$s0, miArreglo($t1)	# $s0 = miArreglo[j]
		lw 	$s1, miArreglo($t2)  	# Siguiente posicion $s1 = miArreglo [j+1]
		slt 	$t3, $s1, $s0  		# miArreglo[j+1] < miArreglo[j]      $t2 = 1 o 0 si s1 < s0 
		bne 	$t3,$zero , if 		# si miArreglo[j+1] < miArreglo[j]
		addi	$t1, $t1, 4		# $t1 = $t1 + 1
		addi 	$t2, $t2, 4		# $t2 = $t2 +1
		j 	while1.1
		if:
			move 	$t4, $s0		# temp =  miArreglo[j];
			sw   	$s1, miArreglo($t1)	# miArreglo[j] =  miArreglo[j+1];
			sw  	$t4, miArreglo($t2) 	# miArreglo[j+1] = temp;
			addi 	$t1, $t1, 4		# $t1 = $t1 + 1
			j 	while1.1



#===( Mostrar arreglo sin ordenar generado aleatoriamente )=========================================================================
printSinOrdenado:
	sub 	$t0, $t0, $t0  		# $t0 = 0	
imprimirNum:
	beq 	$t0, 444, letrero2	# Dentra a letrero2 si $t0 = 111
	#--- Mostrar el arreglo	------------------------------			
	lw 	$t1, miArreglo($t0) 	# $t1 es el registro donde se guarda el numero aleatorio
	addi 	$v0 , $zero, 1 		# funcion imprimir
	move 	$a0, $t1		# copia lo que hay en $t1 a $a0
	syscall
	addi 	$t0, $t0, 4		# $t0 es el indice para recorrer miArreglo 
	#--- Muestra el espacio-------------------------------
	li 	$v0, 4
	la 	$a0, espacio  		# " "
	syscall
	j 	imprimirNum
	

#===( Imprimir letrero de Arreglo Ordenado )=========================================================================================
letrero2:
	li 	$v0, 4		# Codigo para llamado del sistema con el 4
	la 	$a0, salto	# Carga la direccion del salto de linea
	syscall
	li 	$v0, 4 		# Codigo para llamado del sistema con el 4
	la 	$a0, mensaje2	# Carga la direccion de la palabra a mostrar
	syscall
	li 	$v0, 4		# Codigo para llamado del sistema con el 4
	la 	$a0, salto	# Carga la direccion del salto de linea
	syscall



#===( Preparativos del MergeSort )===================================================================================================
sw 	$ra, 0($sp) 		# Guarda la dirección del retorno
la 	$a0, miArreglo2 	# Carga la direccion del arreglo temporal miArreglo2 en $a0
la 	$a1, miArreglo 		# Carga la direccion del arreglo aleatorio de 111 numeros en $a1
addi 	$a2, $0, 111 		# Carga el tamaño del arreglo en $a2
add 	$a3, $0, $0 		# $a3 = 0
or 	$t0, $a1, $0		# $t0 = direccion del arreglo aleatorio
or 	$t3, $a2, $0 		# $t3 = longitud del arreglo
add 	$t4, $0, $0 		# $t4 = 0
addi 	$sp, $sp, -16 		# Reservar espacio en la pila
sw 	$ra, 0($sp) 		# Retornar la direccion de memoria
sw 	$a1, 8($sp) 		# Guardar la direccion del arreglo aleatorio
add 	$a2, $a2, -1 		# El tamaño del arreglo -1; $a2 = $a2 - 1
sw 	$a2, 4($sp) 		# Guarda el tamaño - 1 del arreglo en la pila
sw 	$a3, 0($sp) 		# Guarda el ultimo parámetro de la pila
jal 	MergeSort 		# Salta al MergeSort los parametros del arreglo en la pila con su parámetro Derecho e Izquierdo.



#===( Mostrar arreglo ordenado por el MergeSort )====================================================================================
printOrdenado:
	sub 	$t0, $t0, $t0		# $t0 = 0
imprimirNum2:
	beq 	$t0, 444, Salir		# Dentra a Salir si $t0 = 111
	#--- Mostrar el arreglo	------------------------------			
	lw 	$t1, miArreglo2($t0) 	# $t1 es el registro donde se guarda el numero ordenado
	addi 	$v0 , $zero, 1 		# funcion imprimir
	move 	$a0, $t1		# copia lo que hay en $t1 a $a0
	syscall
	addi 	$t0, $t0, 4		# $t0 es el indice para recorrer miArreglo2
	#--- Muestra el espacio-------------------------------
	li 	$v0, 4
	la 	$a0, espacio  		# " "
	syscall
	j 	imprimirNum2


#===( Función del MergeSort )=======================================================================================================
MergeSort:
	addi 	$sp, $sp, -20 		# Reservar espacio en la pila
	sw 	$ra, 16($sp) 		# Guardar la direccion de retorno
	sw 	$s1, 12($sp)	 	# Guarda la direccion de memoria del parámetro  del arreglo aleatorio
	sw 	$s2, 8($sp) 		# Guarda el parámetro Derecho del tamaño del arreglo
	sw 	$s3, 4($sp) 		# Guarda el parámetro Izquierdo del tamaño del arreglo de la pila
	sw 	$s4, 0($sp) 		# Guarda el parámetro de la mitad
	or 	$s1, $0, $a1 		# $s1 = direccion de memoria del arreglo
	or 	$s2, $0, $a2 		# $s2 = Tamaño del arreglo - 1 = Derecho
	or 	$s3, $0, $a3 		# $s3 = tamaño del Izquierdo
	slt 	$t3, $s3, $s2 		# Izquierdo < Derecho
	beq 	$t3, $0, Completado 	# Salta a Completado si $t3 == 0
	add 	$s4, $s3, $s2 		# $s4 = $s3 + $s2 ( Indice Izquierdo + Indice Derecho )
	div 	$s4, $s4, 2 		# $s4 = ( $s3 + $s2 )/ 2  -> la mitad de los dos Indices sumados (Promedio)
	or 	$a2, $0, $s4 		# Parámetro  Izquierdo
	or 	$a3, $0, $s3 		# Parámetro Intermedio
	jal 	MergeSort 		# Llamado recursivo de MergeSort
	# MergeSort (Arreglo, Mitad+1, indice Derecho)
	addi 	$t4, $s4, 1 		# Parámetro Mitad +1
	or 	$a3, $0, $t4 		# Obtener izquierdo (mitad+1)
	or 	$a2, $0, $s2 		# Obtener derecho
	jal 	MergeSort 		# Llamado recursivo de MergeSort con sus parámetros (Arreglo, mitad+1, ind. derecho)

	or 	$a1, $zero, $s1 	# Parámetro 1 Obtiene direccion de memoria del Arreglo
	or 	$a2, $zero, $s2 	# Parámetro 2 Obtiene ind. Derecho
	or 	$a3, $zero, $s3 	# Parámetro 3 Obtiene ind. Izquierdo
	or 	$a0, $zero, $s4 	# Parámetro 4 Obtiene ind. Mitad
	jal	Merge 			# Salta a Merge con los parámetros (Arreglo, Derecho, Izquierdo, Mitad)


Completado:
	lw 	$ra, 16($sp) 		# Carga la direccion de retorno
	lw 	$s1, 12($sp) 		# Carga el parámetro de la direccion del Arreglo
	lw 	$s2, 8($sp) 		# Carga el parámetro del tamaño del arreglo que va a ser igual al ind. derecho		
	lw 	$s3, 4($sp) 		# Carga el ind. del tamaño del arreglo izquierdo
	lw 	$s4, 0($sp) 		# Carga el registro de la mitad
	addi 	$sp, $sp, 20 		# Reestablece el espacio de la pila
	jr 	$ra 			# Salta al registro de retorno


Merge:
	addi 	$sp, $sp, -20 		# Reserva espacio de memoria en la pila
	sw 	$ra, 16($sp) 		# Guarda la direccion de retorno
	sw 	$s1, 12($sp) 		# Guarda el parámetro de la direccion del arreglo aleatorio
	sw 	$s2, 8($sp) 		# Guarda el parámetro del tamaño del arreglo Derecho
	sw 	$s3, 4($sp) 		# Guarda el tamaño del arreglo Izquierdo
	sw 	$s4, 0($sp) 		# Guarda el registro de la Mitad
	or 	$s1, $0, $a1 		# Dirección del arreglo
	or 	$s2, $0, $a2 		# $s2 <- Tamaño del arreglo Derecho
	or 	$s3, $0, $a3 		# $s3 <- Tamaño del arreglo Izquierdo
	or 	$s4, $0, $a0 		# $s4 <- Mitad del arreglo
	or 	$t1, $0, $s3 		# $t1 Obtiene el Izquierdo -> i
	or 	$t2, $0, $s4 		# $t2 Obtiene la Mitad
	addi 	$t2, $t2, 1 		# $t2 Obtiene Mitad + 1	  -> j
	or 	$t3, $0, $a3 		# $t3 = Izquierdo  -> k


while2:
	slt 	$t4, $s4, $t1 		# Mitad < i ( i >= Mitad)
	bne 	$t4, $zero, while2.1 	# Va a el while2.1 Si  i >= Mitad
	slt 	$t5, $s2, $t2 		# Derecho < j (j>=Derecho)
	bne 	$t5, $zero, while2.1 	# Va para el while2.1 Si j >= Mitad
	sll 	$t6, $t1, 2 		# i*4
	add 	$t6, $s1, $t6 		# $t6 = direccion de Arreglo[i]
	lw 	$s5, 0($t6) 		# $s5 = Arreglo[i]
	sll 	$t7, $t2, 2 		# j*4
	add 	$t7, $s1, $t7 		# $t7 = direccion de Arreglo[j]
	lw 	$s6, 0($t7) 		# $s6 = Arreglo[j]
	slt 	$t4, $s5, $s6 		# Arreglo[i] < Arreglo[j]
	beq 	$t4, $0, Else 		# Va para el Else Si Arreglo[i] >= Arreglo[j}
	sll 	$t8, $t3, 2 		# k*4
	la 	$a0, miArreglo2 	# Carga la direccion de memoria del Arreglo temporal miArreglo2
	add 	$t8, $a0, $t8 		# $t8 = direccion de miArreglo2[k]
	sw 	$s5, 0($t8) 		# miArreglo2[k] = Arreglo[i]
	addi 	$t3, $t3, 1 		# k++
	addi 	$t1, $t1, 1 		# i++
	j 	while2


Else:
	sll 	$t8, $t3, 2 		# i*4
	la 	$a0, miArreglo2 	# Carga la direccion de memoria del arreglo temporal miArreglo2
	add 	$t8, $a0, $t8 		# $t8 = direccion de miArreglo2[k]
	sw 	$s6, 0($t8) 		# miArreglo2[k] = Arreglo[j]
	addi 	$t3, $t3, 1 		# k++
	addi 	$t2, $t2, 1 		# j++
	j 	while2


while2.1:
	slt 	$t4, $s4, $t1 		# Mitad < i (i>=Mitad)
	bne 	$t4, $0, while2.2 	# Salta a while2.2 Si  i >= Mitad
	sll 	$t6, $t1, 2 		# i*4
	add 	$t6, $s1, $t6 		# $t6 = direccion de Arreglo[i]
	lw 	$s5, 0($t6) 		# $s5 = Arreglo[i]
	sll 	$t8, $t3, 2 		# i*4
	la 	$a0, miArreglo2 	# Carga la direccion del arreglo temporal	
	add 	$t8, $a0, $t8 		# $t8 = direccion de miArreglo2[k]
	sw 	$s5, 0($t8) 		# miArreglo2[k] = Arreglo[i]
	addi 	$t3, $t3, 1 		# k++
	addi 	$t1, $t1, 1 		# i++
	j 	while2.1


while2.2:
	slt 	$t5, $s2, $t2 		# Derecha < j (j>=Derecha)
	bne 	$t5, $0, seguimos 	# Salta a seguimos si j >= Derecha
	sll 	$t7, $t2, 2 		# i*4
	add 	$t7, $s1, $t7 		# $t7 = direccion de Arreglo[j]
	lw 	$s6, 0($t7) 		# $s6 = Arreglo[j]
	sll 	$t8, $t3, 2 		# i*4
	la 	$a0, miArreglo2 	# Carga la direccion del arreglo temporal
	add 	$t8, $a0, $t8 		# $t8 = direccion de miArreglo2[k]
	sw 	$s6, 0($t8) 		# miArreglo2[k] = Arreglo[j]
	addi 	$t3, $t3, 1 		# k++
	addi 	$t2, $t2, 1 		# j++
	j 	while2.2


seguimos:
	or 	$t1, $0, $s3 		# i <- izquierdo


for:
	slt 	$t5, $t1, $t3 		# i < k
	beq 	$t5, $zero, Completado 	# Salta a Completado si Merge está terminado
	sll 	$t6, $t1, 2 		# i*4
	add 	$t6, $s1, $t6 		# $t6 = direccion de Arreglo[i]
	sll 	$t8, $t1, 2 		# i*4
	la 	$a0, miArreglo2 	# Carga direccion de memoria del arreglo temporal miArreglo2
	add 	$t8, $a0, $t8 		# $t8 = direccion de miArreglo2[i]
	lw 	$s7, 0($t8) 		# $s7 = miArreglo2[i]
	sw 	$s7, 0($t6) 		# Arreglo[i]
	addi 	$t1, $t1, 1 		# i++
	j 	for


#===( Salir del programa )=====================================================================
Salir:
	addi 	$sp, $sp, 20 		# Restablece toda la pila
	li 	$v0, 10 		# Termina el programa
	syscall