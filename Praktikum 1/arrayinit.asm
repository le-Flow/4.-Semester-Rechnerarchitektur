# work with an array
      .data
sieve: 	.word   0 : 100      # "array" of 100 words to contain the the array, initialized with 0
size: 	.word  100          # size of sieve "array", initialized to 100
      .text

main: # our main function, there is just one...
	
      # Save saved registers on the stack
      addi $sp, $sp, -32     # Make room on the stack for 8 words (8 saved registers)
      sw $s0, 0($sp)         # Save $s0
      sw $s1, 4($sp)         # Save $s1
      sw $s2, 8($sp)         # Save $s2
      sw $s3, 12($sp)        # Save $s3
      sw $s4, 16($sp)        # Save $s4
      sw $s5, 20($sp)        # Save $s5
      sw $s6, 24($sp)        # Save $s6
      sw $s7, 28($sp)        # Save $s7
      
      la   $t0, sieve       # load base address of array, an assembler pseudo operation
      la   $t1, size        # load address of size variable: t1 is our loop counter
      lw   $t1, 0($t1)	# load size 
      add $t2, $zero, $zero # initialize t2 to 0

initloop:
      mul $t3, $t2, $t2 #square of $t2
      sw $t3, 0($t0) # store initial i value into array element			$t2 -> $t3
      addi $t2, $t2, 1 # increment i by one
      addi $t0, $t0, 4 # move pointer into array by 1 position
      addi $t1, $t1, -1 # decrement our loop counter 
      bne $t1, $zero, initloop # we are done once loop counter reaches 0
      # now array is initialized with values from 0 to size - 1

      #print all values,
      add $s0, $zero, $zero # loop index
      la  $t0, size        # load address of size variable: 
      lw  $s1, 0($t0)	    # load size in s1
      la  $s2, sieve    # base address of array in s2
printloop:
      sll $t1, $s0, 2 # 4 * i
      add $t1, $t1, $s2  # address of sieve[i] now in t1
      lw $t1, 0($t1) # load value at seive[i]
      
      li  $v0, 1           # service 1 is print integer, li is an assembler pseudo-operation
      add $a0, $t1, $zero  # put the value in a0 which is where the print routine expects it 
      syscall  # print the value
      
      li $v0, 11 # print a char, sevice 11
      addi $a0, $zero, '\n' # newline char
      syscall # print the char
      
      addi $s0, $s0, 1 # increment the loop counter 
      bne $s0, $s1, printloop # continue if we have not reached i == size yet
      
      # Restore saved registers from the stack
      lw $s7, 28($sp)        # Restore $s7
      lw $s6, 24($sp)        # Restore $s6
      lw $s5, 20($sp)        # Restore $s5
      lw $s4, 16($sp)        # Restore $s4
      lw $s3, 12($sp)        # Restore $s3
      lw $s2, 8($sp)         # Restore $s2
      lw $s1, 4($sp)         # Restore $s1
      lw $s0, 0($sp)         # Restore $s0
      addi $sp, $sp, 32      # Move the stack pointer back to its original position
      
      # we are done
  
      li   $v0, 10          # system call for exit
      syscall               # we are out of here.
		
