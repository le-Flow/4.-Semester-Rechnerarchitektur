.data
string: .asciiz "Das sollte nun auf dem Stack zu sehen sein"

.text
main:
    # String auf den Stack kopieren
    la $a0, string    # Adresse des Strings �bergeben
    move $a1, $sp     # Zieladresse auf dem Stack
    jal strlen        # Stringl�nge ermitteln
    
    # Platz auf dem Stack reservieren f�r den String
    sub $sp, $sp, $v0 # Stackpointer verschieben
    addi $sp, $sp, -1 # Stackpointer verschieben

    # String auf dem Bildschirm ausgeben
    la $a0, string    # Adresse des Strings �bergeben
    jal printit

    # Stack wieder freigeben
    add $sp, $sp, $t0 # Stackpointer zur�cksetzen

    # Programm beenden
    li $v0, 10        # syscall 10 = exit
    syscall

# Funktion zur Ermittlung der Stringl�nge
strlen:
    li $v0, 0         # L�nge auf 0 setzen
loop:
    lb $t0, 0($a0)    # N�chstes Zeichen laden
    beqz $t0, end     # Wenn Null-Zeichen erreicht, beenden
    addi $a0, $a0, 1  # Zeiger auf n�chstes Zeichen verschieben
    addi $v0, $v0, 1  # L�nge um 1 erh�hen
    j loop            # N�chstes Zeichen verarbeiten
end:
    jr $ra             # R�ckkehr

# Funktion zum Ausgeben des Strings
printit:
    li $v0, 4         # syscall 4 = printf
    syscall
    jr $ra            # R�ckkehr
