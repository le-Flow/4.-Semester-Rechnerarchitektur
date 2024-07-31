.data
num: .float 0.5 
epsilon: .float 0.00001
result: .float 1.0
prompt: .asciiz "Geben Sie eine nicht-negative Zahl ein: "
result_msg_part1: .asciiz "Die Quadratwurzel von "
result_msg_part2: .asciiz " ist: "
result_msg_part3: .asciiz "\nDas Quadrat der Wurzel ist: "	

.text
.globl main

main:
    # Prompt anzeigen
    li $v0, 4              # Systemaufruf für die Anzeige von Zeichenketten
    la $a0, prompt         # Adresse der Nachricht in $a0 laden
    syscall                # Nachricht anzeigen
    
    # Eingabe lesen (Floating Point)
    li $v0, 6              # Systemaufruf für die Eingabe einer Gleitkommazahl
    syscall                # Die vom Benutzer eingegebene Gleitkommazahl wird in $f0 gespeichert
    mov.s $f12, $f0        # Kopieren der Eingabe in $f12
    
    # Initialisiere result mit 1.0
    l.s $f0, result
    
    j loop

loop:
    # delta = (input / result + result) * 0.5 - result
    div.s $f2, $f12, $f0   # f2 = input / result
    add.s $f2, $f2, $f0    # f2 = (input / result) + result
    l.s $f4, num           # Lade 0.5
    mul.s $f2, $f2, $f4    # f2 = ((input / result) + result) * 0.5
    sub.s $f14, $f2, $f0   # delta = f2 - result

    # Absoluter Wert von delta
    abs.s $f14, $f14

    # epsilon = 0.00001 laden
    l.s $f4, epsilon

    # Vergleiche delta mit epsilon
    c.lt.s $f14, $f4       # Setze Bedingungsflag, wenn $f14 < $f4 (delta < epsilon)
    bc1t exit              # Springe zu exit, wenn Bedingung wahr

    # Aktualisiere result
    mov.s $f0, $f2         # result = f2
    j loop

exit:
    # Ergebnis anzeigen - Teil 1 der Nachricht
    li $v0, 4              # Systemaufruf für die Anzeige von Zeichenketten
    la $a0, result_msg_part1 # Lade Adresse des ersten Teils der Nachricht in $a0
    syscall                # Ersten Teil der Nachricht anzeigen
    
    # Eingabewert anzeigen
    li $v0, 2              # Systemaufruf für die Anzeige einer Gleitkommazahl
    mov.s $f12, $f12       # Kopiere die Eingabe in $f12
    syscall                # Eingabe anzeigen
    
    # Ergebnis anzeigen - Teil 2 der Nachricht
    li $v0, 4              # Systemaufruf für die Anzeige von Zeichenketten
    la $a0, result_msg_part2 # Lade Adresse des zweiten Teils der Nachricht in $a0
    syscall                # Zweiten Teil der Nachricht anzeigen
    
    # Berechnetes Ergebnis anzeigen
    li $v0, 2              # Systemaufruf für die Anzeige einer Gleitkommazahl
    mov.s $f12, $f0        # Kopiere das Ergebnis in $f12
    syscall                # Ergebnis anzeigen
    
    # Ergebnis anzeigen - Teil 3 der Nachricht
    li $v0, 4              # Systemaufruf für die Anzeige von Zeichenketten
    la $a0, result_msg_part3 # Lade Adresse des zweiten Teils der Nachricht in $a0
    syscall                # Zweiten Teil der Nachricht anzeigen
    
    # Berechnetes Quadrat anzeigen
    li $v0, 2              # Systemaufruf für die Anzeige einer Gleitkommazahl
    mul.s $f1, $f0, $f0	   # Quadrat berechnen
    mov.s $f12, $f1        # Kopiere das Ergebnis in $f12
    syscall                # Ergebnis anzeigen
    
    # Programm beenden
    li $v0, 10             # Systemaufruf zum Beenden des Programms
    syscall                # Programm beenden
