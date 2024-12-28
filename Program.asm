.data
    currSysPrompt:  .asciiz "Enter the current system: "
    numberPrompt:   .asciiz "Enter the number: "
    newSysPrompt:   .asciiz "Enter the new system: "
    resultMsg:      .asciiz "The number in the new system: "
    newLine:        .asciiz "\n"
    errorMsg:       .asciiz "The given number doesn't belong to the: "
    systemMsg:      .asciiz " System."

    currentSystem:  .word 0
    newSystem:      .word 0

    numberString:   .space 50
    stringResult:   .space 50
    intResult:      .word 0

.text
main:
    # Prompt for current system
    la $a0, currSysPrompt
    jal printMsg

    # Read current system
    jal readInteger
    sw $v0, currentSystem

    # Prompt for the number
    la $a0, numberPrompt
    jal printMsg

    # Read number as string
    li $v0, 8
    la $a0, numberString
    li $a1, 50
    syscall

    # Prompt for new system
    la $a0, newSysPrompt
    jal printMsg

    # Read new system
    jal readInteger
    sw $v0, newSystem

    # Print new line
    la $a0, newLine
    jal printMsg

    # Validate the input number
    la $a0, numberString
    jal validate

    # Perform conversion
    lw $t0, currentSystem   # Load current system
    lw $t1, newSystem       # Load new system
    jal otherToDecimal      # Convert input number to decimal
    sw $v1, intResult       # Store the decimal result

    lw $a0, intResult       # Load decimal result
    lw $a1, newSystem       # Load new system
    jal decimalToOther      # Convert decimal to target base

    la $a0, stringResult    # Load final result
    jal reverseString       # Reverse the result

    # Print result
    la $a0, resultMsg
    jal printMsg
    move $a0, $v1
    jal printMsg

    # End program
    j endProgram

endProgram:
    li $v0, 10
    syscall

# Helper Functions
printMsg:
    li $v0, 4
    syscall
    jr $ra

readInteger:
    li $v0, 5
    syscall
    jr $ra

# Validate Input
validate:
    lw $t0, currentSystem
    move $t1, $a0

    sle $s0, $t0, 10
    beq $s0, 1, loop_dec
    beqz $s0, loop_nonDec

loop_dec:
    lbu $t2, 0($t1)
    beq $t2, $zero, endValid
    addi $t2, $t2, -48
    bge $t2, $t0, errorHappened
    addi $t1, $t1, 1
    j loop_dec

loop_nonDec:
    lbu $t2, 0($t1)
    beq $t2, $zero, endValid
    bge $t2, 65, doAction
    li $t2, 0
    j continue

doAction:
    addi $t2, $t2, -55
    j continue

continue:
    bge $t2, $t0, errorHappened
    addi $t1, $t1, 1
    j loop_nonDec

endValid:
    jr $ra

errorHappened:
    li $v0, 4
    la $a0, errorMsg
    syscall
    li $v0, 1
    lw $a0, currentSystem
    syscall
    li $v0, 4
    la $a0, systemMsg
    syscall
    j endProgram

# Convert other base to decimal
otherToDecimal:
    li $t1, 0
    lw $t2, currentSystem
    li $t6, 0
    j findLength

otherToDecimalLoop:
    lb $t4, ($t5)
    beq $t6, $t7, break
    ble $t4, 57, convertNum
    j convertChar

convertNum:
    sub $t4, $t4, 48
    j otherToDecimalLoopElse

convertChar:
    sub $t4, $t4, 55
    j otherToDecimalLoopElse

otherToDecimalLoopElse:
    move $t8, $t2
    move $t9, $t6
    j power

remain:
    mul $t4, $t4, $t3
    addu $t1, $t1, $t4
    addi $t5, $t5, -1
    add $t6, $t6, 1
    move $t3, $t6
    j otherToDecimalLoop

break:
    move $v1, $t1
    jr $ra

findLength:
    la $t0, numberString
    li $t7, 0
findLengthLoop:
    lb $t1, ($t0)
    beq $t1, $zero, findLengthLoopBreak
    move $t5, $t0
    addi $t0, $t0, 1
    addi $t7, $t7, 1
    j findLengthLoop

findLengthLoopBreak:
    sub $t7, $t7, 1
    addi $t5, $t5, -1
    j otherToDecimalLoop

power:
    li $t3, 1
    beq $t9, 0, powerEnd
powerLoop:
    mul $t3, $t3, $t8
    subi $t9, $t9, 1
    bgtz $t9, powerLoop
powerEnd:
    j remain

# Convert decimal to other base
decimalToOther:
    move $t0, $a0
    move $t1, $a1
    la $t2, stringResult
convertDecimalToOtherLoop:
    beqz $t0, returnFromDecimalToOther
    div $t0, $t1
    mflo $t0
    mfhi $t3
    bgt $t3, 9, charCase
    ble $t3, 9, numCase

charCase:
    addi $t3, $t3, 55
    sb $t3, 0($t2)
    addi $t2, $t2, 1
    j convertDecimalToOtherLoop

numCase:
    addi $t3, $t3, 48
    sb $t3, 0($t2)
    addi $t2, $t2, 1
    j convertDecimalToOtherLoop

returnFromDecimalToOther:
    sb $zero, 0($t2)
    la $v1, stringResult
    jr $ra

# Reverse a string
reverseString:
    move $t0, $a0
    li $t1, 0
findLength2:
    lb $t2, 0($t0)
    beqz $t2, doneFindLength
    addi $t0, $t0, 1
    addi $t1, $t1, 1
    j findLength2

doneFindLength:
    move $t2, $a0
    add $t3, $a0, $t1
    sub $t3, $t3, 1

reverseLoop:
    bge $t2, $t3, doneReverse
    lb $t4, 0($t2)
    lb $t5, 0($t3)
    sb $t4, 0($t3)
    sb $t5, 0($t2)
    addi $t2, $t2, 1
    subi $t3, $t3, 1
    j reverseLoop

doneReverse:
    jr $ra
