    .ORIG x3000
    
; Name: Lonoehu Wacasey
; Date: 10/27/24
; Lab #3
;
;

; BLOCK 1
; Register R0 is loaded with x4000, which will serve as a pointer to the numbers.
;  

	LD R0,PTR

;BLOCK 2
; In this block, we will be setting up, and clearing registers. On top of this, this is where the main chunk of
; code will be located for easier access
;

AND R6, R6, #0
ADD R6, R6, #-1
LDR R3, R0, #1
BRZ DONE
JSR ARRAYCNTR        ;supposed to be jsr
LDR R1, R0, #0
ST R1, NUM1
JSR SHIFT1
AND R5, R5, #0
BR ARRANGE

;Block 3
; In this block, we will have the jump instructions for more set up, including counting the array elements and 
; more set up of registers
;

ARRAYCNTR
    AND R3, R3, #0
    LDR R3, R0, #0      ;calculates how many elements are in the array via loading the r0 values into r3
    BRZ ASTR
    ADD R6, R6, #1      ;if an element is calculated, adds 1 to r6, 1 to r0 (for next address), and clears r3
    ADD R0, R0, #1
    AND R3, R3, #0
    BR  ARRAYCNTR
    
ASTR
    ST R6, ANUM     ;stores r6 in a placeholder spot
    AND R3, R3, #0
    LD R0, PTR
    RET


;Block 4
; In this block, the shifting code is included
;

SHIFT1
    ST R7, SHIFTSAVE
    AND R4, R4, #0
    LD R4, MASK
    AND R1, R1, R4
    ADD R3, R3, #8  ;r3 designated as a counter to count the shifts we need to make
    AND R4, R4, #0
    LD R4, OFCHK    ;clears r4 and loads in a number which we can use to detect overflow
    BR RGHTSHFT
RGHTSHFT
    AND R7, R7, #0
    AND R7, R4, R1  ;clears r5 and then checks if rightmost value of number 2 is a 1
    BRZ NOONE
    BR  HAYONE
NOONE
    ADD R1, R1, R1  ;if no 1 in the MSB, we shift the values of number 2 to the right, causing a 0 in the LSB
    BR COUNTER
HAYONE
    ADD R1, R1, R1  ;if there is a 1 in the MSB, we shift number 2 to the right and then add 1
    ADD R1, R1, #1
    BR COUNTER
COUNTER
    ADD R3, R3, #-1 ;negates counter by 1, if we are down to zero, we have fully shifted the number, otherwise restart
    BRZ COMEBACK
    BR RGHTSHFT
COMEBACK
    LD R7, SHIFTSAVE
    RET





SHIFT2
    ST R7, SHIFTSAVE
    AND R7, R7, #0
    AND R4, R4, #0
    LD R4, MASK
    AND R2, R2, R4
    ADD R3, R3, #8  ;r3 designated as a counter to count the shifts we need to make
    AND R4, R4, #0
    LD R4, OFCHK   ;clears r4 and loads in a number which we can use to detect overflow
RGHTSHFT2
    AND R7, R7, #0
    AND R7, R4, R2  ;clears r5 and then checks if rightmost value of number 2 is a 1
    BRZ NOONE2
    BR  HAYONE2
NOONE2
    ADD R2, R2, R2  ;if no 1 in the MSB, we shift the values of number 2 to the right, causing a 0 in the LSB
    BR COUNTER2
HAYONE2
    ADD R2, R2, R2  ;if there is a 1 in the MSB, we shift number 2 to the right and then add 1
    ADD R2, R2, #1
    BR COUNTER2
COUNTER2
    ADD R3, R3, #-1 ;negates counter by 1, if we are down to zero, we have fully shifted the number, otherwise restart
    BRZ COMEBACK2
    BR RGHTSHFT2
COMEBACK2
    LD R7, SHIFTSAVE
    RET


;BLOCK 5
;In this block, the actual arranging code is contained in the block
;

ARRANGE
    ST R0, ADDR1
    ADD R0, R0, #1
    ST R0, ADDR2
    LDR R2, R0, #0
    ST R2, NUM2
    JSR SHIFT2
    ST R2, NUM2SHIFT
;r1 and r2 are now numbers that have been shifted, so no negatives

    AND R7, R7, #0
    JSR MAKENEG
    AND R4, R4, #0
    ADD R4, R1, R2
    BRNZ SUMNEG
    BR POSSUM
    
    




;BLOCK 6
;This is where the additional code for BLOCK 5 comes from
;

MAKENEG
    NOT R2, R2
    ADD R2, R2, #1
    RET

SUMNEG
    AND R4, R4, #0
    LD R2, NUM2
    LD R1, NUM1
    LD R4, ADDR1
    STR R1, R4, #0
    LD R4, ADDR2
    STR R2, R4, #0
    BR ACNTR
    
POSSUM
    AND R4, R4, #0
    LD R1, NUM1
    LD R2, NUM2
    LD R4, ADDR1
    STR R2, R4, #0
    LD R4, ADDR2
    STR R1, R4, #0
    ST R2, NUM1
    ST R1, NUM2
    JSR SHIFT1
    ST R1, NUM2SHIFT
    ADD R5, R5, #1
    BR ACNTR
    
ACNTR
    ADD R6, R6, #-1
    BRZ DONE
    BR SETUP
    
SETUP
    AND R1, R1, #0
    AND R2, R2, #0
    LD R1, NUM2
    ST R1, NUM1
    LD R1, NUM2SHIFT
    BR ARRANGE
  


DONE
    HALT
    
    
PTR .FILL x4000
ANUM .BLKW x1
NUM1 .BLKW x1
NUM2 .BLKW x1
NUM2SHIFT .BLKW x1

SHIFTSAVE  .BLKW x1
ADDR1   .BLKW x1
ADDR2   .BLKW x1

MASK	.FILL	xFF00
OFCHK   .FILL   x8000

    .END

