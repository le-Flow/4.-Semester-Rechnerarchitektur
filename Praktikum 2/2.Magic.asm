.data
newline: .asciiz "\n"

.text
main:
    # Eingabe eines Integer-Wertes
    li $v0, 5           # Lade den Systemaufruf-Code für die Eingabe eines Integer-Wertes
    syscall             # Systemaufruf ausführen
       
    # Aufruf der magic Funktion mit der eingegebenen Zahl
    move $a0, $v0       # Kopiere den eingelesenen Wert in das Argument-Register $a0
    jal magic           # Springe zu magic

    # Ergebnis ausgeben
    move $a0, $v0       # Lade das Ergebnis der magic Funktion in das Argument-Register $a0
    li $v0, 1           # Lade den Systemaufruf-Code für die Ausgabe eines Integer-Wertes
    syscall             # Systemaufruf ausführen

    # Zeilenumbruch ausgeben
    la $a0, newline     # Lade die Adresse der Zeilenumbruch-Zeichenkette in $a0
    li $v0, 4           # Lade den Systemaufruf-Code für die Ausgabe einer Zeichenkette
    syscall             # Systemaufruf ausführen

    # Programm beenden
    li $v0, 10          # Lade den Systemaufruf-Code für das Programmende
    syscall             # Systemaufruf ausführen

magic:
    addi $sp, $sp, -4   # Reserviere Platz auf dem Stapel für das $ra Register
    sw $ra, 0($sp)      # Sichere den Rückkehr-Adressenwert auf dem Stapel

    li $t0, 100         # Schwelle für den Fall n <= 100

    ble $a0, $t0, _le_100  # Springe zu _le_100, wenn n <= 100

    # Fall n > 100
    subi $v0, $a0, 10   # Berechne n - 10
    j _done             # Springe zu _done

_le_100:
    # Fall n <= 100
    addi $a0, $a0, 11   # Berechne n + 11
    jal magic           # Rufe magic mit n + 11 auf
    addi $a0, $v0, 0
    jal magic
    j _done             # Springe zu _done

_done:
    lw $ra, 0($sp)      # Stelle den Wert des $ra Registers wieder her
    addi $sp, $sp, 4    # Stelle den Stapelzeiger wieder her

    jr $ra              # Springe zurück zur aufrufenden Funktion
