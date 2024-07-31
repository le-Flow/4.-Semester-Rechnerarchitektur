.data
prompt: .asciiz "Geben Sie eine nicht-negative Zahl ein: "
result_msg: .asciiz "Das Ergebnis ist: "

.text 
.globl main

main:

    # Prompt anzeigen
    li $v0, 4                  # Systemaufruf für die Anzeige von Zeichenketten
    la $a0, prompt             # Adresse der Nachricht in $a0 laden
    syscall                    # Nachricht anzeigen

    # Eingabe lesen (Integer)
    li $v0, 5                  # Systemaufruf für die Eingabe einer Ganzzahl
    syscall                    # Die vom Benutzer eingegebene Ganzzahl wird in $v0 gespeichert
    move $a0, $v0              # Die Eingabe in $a0 kopieren

    jal factorial              # Unterprogramm für die Fakultätsberechnung aufrufen
    add $a0, $v0, $zero

    # Ergebnis anzeigen
    move $a0, $v0              # Ergebnis in $a0 für die Anzeige verschieben
    li $v0, 1                  # Systemaufruf für die Anzeige einer Ganzzahl
    syscall                    # Ergebnis anzeigen

    # Programm beenden
    li $v0, 10                 # Systemaufruf zum Beenden des Programms
    syscall                    # Programm beenden

factorial:
    add $t1, $zero, $zero # i = 0 in register t1
    addi $v0, $zero, 1 # 1 in result
    
loop:
    beq $t1, $a0, end
    addi $t1, $t1, 1 # i++
    j loop
    mul $v0, $v0, $t1 # result = result * i
    
end:
    jr $ra
    add $zero, $zero, $zero
