; final project

; Bubble Sort

; This program takes as its input 8 user inputted numbers and uses a bubble sort
; to sort them in ascending order. This bubble sort works by comparing adjacent
; numbers and swapping them if the left value is less than the right value, until
; all numbers are in ascending order. It then outputs the sorted list of numbers.

; INPUT: ARRAY (8 numbers between 0-100)
; OUTPUT: ARRAY (8 numbers sorted in ascending order)

; Variables:    PNTR: sorting pointer (left value)
;        TEMP: temporary hold for values
;        COMP: comparing pointer (right value)
;        FIRST: hold for left value in comparison
;        SECOND: hold for right value in comparison
;        ARRAY: array for 8 numbers

; Subroutines:    LOOP: user inputs 8 numbers for sorting
;        ZERO: clears registers, sets pointers to first address in array,
;              sets counters
;        SORT: sets sorting pointer to address in R3, decrements counter
;              until reaching zero, then calls on ISSORT
;        COMPARE: increments address in R3 to set comparing pointer,
;             sets left and right values into FIRST & SECOND,
;             compares by checking if left value is greater
;        SWAP: if left value was greater, swap is called to swap values
;              from respective addresses, increments swap counter
;        ISSORT: is called after SORT has gone through all 8 comparisons,
;            if swap counter is positive then it loops back to SORT,
;            if zero then it moves on to outputting results
;        FINAL: outputs sorted list

.ORIG x3000

LEA R3, ARRAY			; load array address
ST R3, PNTR			; store array address into pointer
AND R5, R5, x0			; clear R5
ADD R5, R5, #8			; add 8 to use as counter (decrement)
LD R6, OFF 			; load #-30 into R6 for ASCII conversion
LEA R0, PROMPT			; output prompt to console for input
PUTS

LOOP	LEA R0, NEWLIN		; loop requesting number 0-100
	PUTS
	LEA R0, PROMP3
	PUTS
	AND R0, R0, x0		; clear registers
	AND R1, R1, x0
	AND R2, R2, x0
	GETC 			; get first character from keyboard
	OUT 			; print character on screen
	ADD R0, R0, R6 		; ASCII conversion to hex for manipulation
	ADD R1, R0, R0 		; R1 = 2 x R0
	ADD R2, R1, #0 		; copy R1 into R2
	ADD R2, R2, R2 		; R2 = 4 x R0
	ADD R2, R2, R2 		; R2 = 8 x R0
	ADD R2, R2, R1 		; R2 = 10 x R0
	GETC 			; get second character
	OUT 			; print character on screen
	ADD R0, R0, R6 		; ASCII conversion to hex
	ADD R2, R2, R0 		; R2 = decimal number
	ST R2, TEMP		; store number into TEMP
	LD R4, TEMP		; load TEMP into R4
	STI R4, PNTR		; store content of R4 into address at pointer
	ADD R3, R3, #1		; increment address
	ST R3, PNTR		; store new address into pointer
	ADD R5, R5, #-1		; decrement counter R5
	BRp LOOP		; if counter is positive, loop

ZERO	AND R0, R0, x0		; clear registers
	AND R1, R1, x0
	AND R2, R2, x0
	AND R3, R3, x0
	AND R4, R4, x0
	AND R7, R7, x0
	LEA R3, ARRAY		; load first array address ito R3
	ST R3, PNTR		; store address into pointer
	ST R3, COMP		; store same address into compare pointer
	AND R5, R5, x0		; clear R5
	ADD R5, R5, #8		; add 8 to use as counter

SORT	ST R3, PNTR		; store address in R3 into pointer
	ADD R5, R5, #-1		; decrement counter
	BRz ISSORT		; if counter reaches zero, go to ISSORT
	
COMPARE	ADD R3, R3, #1		; increment address in R3
	ST R3, COMP		; store address in compare pointer
	LDI R1, PNTR		; load content at pointer address into R1
	ST R1, FIRST		; store value in R1 to FIRST variable
	LDI R2, COMP		; load content at compare pointer into R2
	ST R2, SECOND		; store value in R2 to SECOND variable
	AND R1, R1, x0		; clear registers
	AND R2, R2, x0
	LD R1, FIRST		; load value in FIRST to R1 (left value)
	LD R2, SECOND		; load value in SECOND to R2 (right value)
	NOT R1, R1		; 1s complement of left value
	ADD R1, R1, #1		; 2s complement
	ADD R4, R2, R1		; R2 - R1 = R4	
	BRzp SORT		; if R4 is zero or positive, then the values 
				; are in ascending order and we can loop back
				; to SORT
				; if negative, continue to SWAP the numbers

SWAP	LDI R1, PNTR		; load contents of pointer into R1
	ST R1, TEMP		; store value in R1 to TEMP (left value)
	LD R2, SECOND		; load value in SECOND (right value) to R2
	STI R2, PNTR		; store value in R2 into address at pointer (left)
	LD R1, TEMP		; load value in TEMP to R1
	STI R1, COMP		; store value in R1 into address at compare pointer (right)
	ADD R7, R7, #1		; increment SWAP counter
	BRp SORT		; loop back to SORT

ISSORT	ADD R7, R7, #0		; load value of R7 SWAP counter
	BRp ZERO		; if at least one swap was made in a full turn,
				; loop back to ZERO to begin sort again
				; if no swap was made, continue to output results
	
LEA R0, NEWLIN			; output sorted prompt
PUTS
LEA R0, PROMP2
PUTS
AND R0, R0, #0			; clear registers
AND R1, R1, #0
AND R3, R3, #0
LEA R0, ARRAY     		; load first array address into R0
ADD R1, R1, R0    		; Store the pointer address in R0 into R1
LD R2, SET      		; load the ASCII offset into R2

CONSOL	LDR R4, R1, #0    	; load the contents of array address in R1 into R4
  	BRz FINAL		; if content is x00, end loop
  	ADD R4, R4, R2    	; ASCII convert value in R4
  	STR R4, R1, #0    	; store the new value in R4 into array address in R1
  	ADD R1, R1, #1    	; increment array address pointer
  	BRnzp CONSOL    	; loop until reaching an x00 char

FINAL	PUTS

HALT

OFF .FILL xFFD0 		; x-30 for ASCII conversion
SET .FILL x30			; x30 for ASCII conversion
 
PROMPT .STRINGZ "Enter 8 numbers (0-100) (format 00, 01, 10)"
PROMP2 .STRINGZ "Sorted: "
PROMP3 .STRINGZ "Enter a number: "
NEWLIN .STRINGZ "\n"
;COMMA  .STRINGZ ", "

PNTR	.FILL x3100
TEMP	.FILL x3109
COMP	.FILL x3110
FIRST	.FILL x3111
SECOND	.FILL x3112
ARRAY	.FILL x4000

.END