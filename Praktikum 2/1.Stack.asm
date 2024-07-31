.data
string: .asciiz "Das sollte nun auf dem Stack zu sehen sein"

.text
main:
    # String auf den Stack kopieren
    la $a0, string    # Adresse des Strings übergeben
    move $a1, $sp     # Zieladresse auf dem Stack
    jal strlen        # Stringlänge ermitteln
    
    # Platz auf dem Stack reservieren für den String
    sub $sp, $sp, $v0 # Stackpointer verschieben
    addi $sp, $sp, -1 # Stackpointer verschieben

    # String auf dem Bildschirm ausgeben
    la $a0, string    # Adresse des Strings übergeben
    jal printit

    # Stack wieder freigeben
    add $sp, $sp, $t0 # Stackpointer zurücksetzen

    # Programm beenden
    li $v0, 10        # syscall 10 = exit
    syscall

# Funktion zur Ermittlung der Stringlänge
strlen:
    li $v0, 0         # Länge auf 0 setzen
loop:
    lb $t0, 0($a0)    # Nächstes Zeichen laden
    beqz $t0, end     # Wenn Null-Zeichen erreicht, beenden
    addi $a0, $a0, 1  # Zeiger auf nächstes Zeichen verschieben
    addi $v0, $v0, 1  # Länge um 1 erhöhen
    j loop            # Nächstes Zeichen verarbeiten
end:
    jr $ra             # Rückkehr

# Funktion zum Ausgeben des Strings
printit:
    li $v0, 4         # syscall 4 = printf
    syscall
    jr $ra            # Rückkehr
