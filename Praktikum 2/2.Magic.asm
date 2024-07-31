.data
newline: .asciiz "\n"

.text
main:
    # Eingabe eines Integer-Wertes
    li $v0, 5           # Lade den Systemaufruf-Code f�r die Eingabe eines Integer-Wertes
    syscall             # Systemaufruf ausf�hren
       
    # Aufruf der magic Funktion mit der eingegebenen Zahl
    move $a0, $v0       # Kopiere den eingelesenen Wert in das Argument-Register $a0
    jal magic           # Springe zu magic

    # Ergebnis ausgeben
    move $a0, $v0       # Lade das Ergebnis der magic Funktion in das Argument-Register $a0
    li $v0, 1           # Lade den Systemaufruf-Code f�r die Ausgabe eines Integer-Wertes
    syscall             # Systemaufruf ausf�hren

    # Zeilenumbruch ausgeben
    la $a0, newline     # Lade die Adresse der Zeilenumbruch-Zeichenkette in $a0
    li $v0, 4           # Lade den Systemaufruf-Code f�r die Ausgabe einer Zeichenkette
    syscall             # Systemaufruf ausf�hren

    # Programm beenden
    li $v0, 10          # Lade den Systemaufruf-Code f�r das Programmende
    syscall             # Systemaufruf ausf�hren

magic:
    addi $sp, $sp, -4   # Reserviere Platz auf dem Stapel f�r das $ra Register
    sw $ra, 0($sp)      # Sichere den R�ckkehr-Adressenwert auf dem Stapel

    li $t0, 100         # Schwelle f�r den Fall n <= 100

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

    jr $ra              # Springe zur�ck zur aufrufenden Funktion
