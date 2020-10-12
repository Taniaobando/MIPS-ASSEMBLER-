.data

 arr:.space  1000 
 arr2: .space 1000 # No tiene espacios 
 
 cadena: .asciiz "Escriba la palabra"
 sies: .asciiz "Es palidroma"
 noes: .asciiz "No es palindroma"
 
 

.text

#crear input para recibir las cadenas

addiu $v0,$0,54
la  $a0,cadena
la $a1,arr
li $a2,1000
syscall 
li $t1,0
li $t6,0
#Registro temporal $t0

#ciclo para hallar la longitud de la cadena 
#t1 contador 


ciclo:


lb $t0,arr($t1)
beq $t0,$0,salga #cuando llegue al final de la cadena salga
# Si hay un espacio no lo lee.
addiu $t9,$0,32
beq $t0,$t9,salta
sb $t0,arr2($t6) #Guarda en la memoria
addiu $t6,$t6,1 #Contador para len de arreglo 2
addiu $t1,$t1,1

j ciclo

salta:

addiu $t1,$t1,1

j ciclo

salga: 
addi $t6,$t6,-1
li $v0,1
add $a0,$0,$t6
syscall

 # t1 es len 

addiu $t2,$0,0 #empieza en uno el contador del ciclo


addiu $t3,$0,2 #Guardar el 2 para hacer la division 
div $t6,$t3
mflo $t4 # Queda la parte de la division entera
#Otro ciclo para la comparacion
addiu $s1,$0,0
addi $s2,$t6,-1 #

ciclo2:

slt $t5,$t2,$t4 
beq $t5,$0,Exit




lb $t7,arr2($s1)
lb $t8,arr2($s2)

bne $t7,$t8,nopalin

#Es palin

addiu $s2,$s2,-1
addiu $s1,$s1,1
addiu $t2,$t2,1


j ciclo2

#imprimir 




nopalin:

addiu $v0,$0,4
la $a0,noes
syscall
j Exit2


Exit:
addiu $v0,$0,4
la $a0,sies
syscall
	
Exit2:

.end
