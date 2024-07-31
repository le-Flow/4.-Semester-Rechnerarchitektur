.data
newline: .asciiz "\n"
male_string: .asciiz "male("
equals_space: .asciiz ") = "
comma_space: .asciiz ", "
female_string: .asciiz "female("

.text
.globl main

main:
    # Initialisiere die Schleifenvariable i auf 0
    li $t0, 0
    
loop:
    # Wenn i > 10, beende die Schleife
    li $t1, 10
    bgt $t0, $t1, end
    
    # Berechne Male(i) und Female(i)
    move $a0, $t0
    jal male
    move $s0, $v0
    
    move $a0, $t0
    jal female
    move $s1, $v0
    
    # Ausgabe der Ergebnisse
    # male(%d) = %d, female(%d) = %d\n
    
    # male(
    li $v0, 4
    la $a0, male_string
    syscall
    
    # Argument 1: i
    move $a0, $t0
    li $v0, 1
    syscall
    
    # ) = 
    la $a0, equals_space
    li $v0, 4
    syscall
    
    # Argument 2: male(i)
    move $a0, $s0
    li $v0, 1
    syscall
    
    # , female(
    la $a0, comma_space
    li $v0, 4
    syscall
    la $a0, female_string
    li $v0, 4
    syscall
    
    # Argument 3: i
    move $a0, $t0
    li $v0, 1
    syscall
    
    # ) = 
    la $a0, equals_space
    li $v0, 4
    syscall
    
    # Argument 4: female(i)
    move $a0, $s1
    li $v0, 1
    syscall
    
    # newline
    la $a0, newline
    li $v0, 4
    syscall
    
    # Inkrementiere die Schleifenvariable i
    addi $t0, $t0, 1
    
    # Gehe zum Schleifenanfang
    j loop
    
end:
    # Beende das Programm
    li $v0, 10
    syscall

# Funktion male
# Male(n) = n - Female(Male(n-1)) für n > 0
# Male(0) = 0
male:
    addi $sp, $sp, -8      # Platz für $ra und $a0
    sw $ra, 0($sp)
    sw $a0, 4($sp)
    
    # Base case: Male(0) = 0
    beqz $a0, male_base_case
    
    # Rekursiver Fall: Male(n) = n - Female(Male(n-1))
    addi $a0, $a0, -1
    jal male
    move $a0, $v0
    jal female
    
    lw $a0, 4($sp)
    sub $v0, $a0, $v0
    j male_end
    
male_base_case:
    li $v0, 0

male_end:
    lw $ra, 0($sp)
    addi $sp, $sp, 8
    jr $ra

# Funktion female
# Female(n) = n - Male(Female(n-1)) für n > 0
# Female(0) = 1
female:
    addi $sp, $sp, -8      # Platz für $ra und $a0
    sw $ra, 0($sp)
    sw $a0, 4($sp)
    
    # Base case: Female(0) = 1
    beqz $a0, female_base_case
    
    # Rekursiver Fall: Female(n) = n - Male(Female(n-1))
    addi $a0, $a0, -1
    jal female
    move $a0, $v0
    jal male
    
    lw $a0, 4($sp)
    sub $v0, $a0, $v0
    j female_end
    
female_base_case:
    li $v0, 1

female_end:
    lw $ra, 0($sp)
    addi $sp, $sp, 8
    jr $ra
