.data
#crear registro para guardar todas las posiciones de arreglo
arreglo:.space 4000
salto: .asciiz "\n"

.text

#Generar la cardinalidad del arreglo 
#$s0 es la cardinalidad 

addiu $v0,$0,42
addiu $a1,$0,10
syscall
move $t0,$a0
add $s0,$0,$t0

beqz $s0,Termino

#addiu $s3,$0,5
#addiu $s0,$0,5


#Crear contador
addiu $t2,$0,0

#Ciclo para generar y guardar los numeros en el arreglo 

volver:

slt $t1,$0,$t0
beq $t1,$0,Salirciclo

addiu $v0,$0,42
addiu $a1,$0,10
syscall
move $t3,$a0
sw $t3,arreglo($t2) 
addiu $v0,$0,1 #Instruccion para imprimir 
lw $a0,arreglo($t2) 
syscall
addiu $t2,$t2,4


addi $t0,$t0,-1

j volver

# Recorrer el arreglo y ordenarlo  

Salirciclo:
addiu $s4,$0,0 # se mueve de uno en uno (Z)
addiu $t8,$0,1 # contador para el primer ciclo de len i
addiu $s6,$0,0 # contador  j se mueve de 4 en 4
addiu $t6,$0,0 # temporal para para el ciclo
addiu $t5,$0,0 # temporal guarda una posicion n del arreglo
addiu $t9,$0,0 #temporal
addiu $t1,$0,0 # Guarda Temporalmente la posicion n+1

#Imprimir un salto de linea
li $v0,4
la $a0,salto
syscall


	for1:
		beq $t8,$s0,Exit # Recorre todas las posiciones del arreglo
 		
 		for2:

 		sub $t6,$s0,$t8 # va corriendo a medida de que el ultimo numero ya esta ordenado
 		slt $s5,$s4,$t6 
 		beq $s5,$0,a # sale del for 2 a el for 1
	        lw $t5,arreglo($s6) #carga la posicion n
	        lw $t7,arreglo+4($s6)# carga la posicion n+1
	        slt $t9,$t5,$t7
		bne $t9,$0,nocambia
		add $t1,$0,$t7 # para no perder el valor
		add $t7,$0,$t5
		add $t5,$0,$t1
		sw $t5,arreglo($s6)# lo meto en la memoria
		sw $t7,arreglo+4($s6)
		addiu $s4,$s4,1 
		addiu $s6,$s6,4
		
		j for2
				
a:
addiu $t8,$t8,1
addiu $s4,$0,0 #reinicio  z
addiu $s6,$0,0 #reinicio  j

j for1

nocambia:

addiu $s6,$s6,4
addiu $s4,$s4,1
j for2


Exit:
addiu $t0,$0,0
addiu $t1,$0,0

superexit:

beq $t1,$s0,Termino

lw $s2,arreglo($t0)
addiu $v0,$0,1
add $a0,$0,$s2
syscall
addiu $t1,$t1,1
addiu $t0,$t0,4

j superexit 

Termino:




