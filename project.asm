TITLE Matrix Mather

; This program does matrix math.

INCLUDE Irvine32.inc

.386
.model flat,stdcall
.stack 4096
ExitProcess proto,dwExitCode:dword

.data

userChoice byte "Select Operation -- (1) for Matrix Multiplication, (2) To find Matrix Determinant, (3) To find Matrix Inverse",13,10,0
errorChoice byte "Error, selection out of range. Choose again.",13,10,0
userSelection byte ?
matrixSize DWORD ?
matrixMessage byte "Enter the size of your matrix (square matrix only, maximum size of 10x10): ",13,10,0
confirmSize byte "The size of your matrix is: ",0
valueEntryText1 byte "Enter value for row ",0
valueEntryText2 byte " column ",0
emptySpaceA byte "for matrix A: ",0
emptySpaceB byte " for matrix B: ",0
emptyCR byte " ",13,10,0
displaySeparator byte " ",0

jPos DWORD 0	;These two values are important for array indexing. jPos refers to the current column in the 2D matrix, iPos refers to the row
iPos DWORD 0
tempValPos DWORD 0	;Need a temp variable to store for indexing

matrixA DWORD 100 DUP(0)
matrixB DWORD 100 DUP(0)
matrixC DWORD 100 DUP(0)

iVal DWORD -1	;The i, j, k simplify indexing for operations.
jVal DWORD -1
kVal DWORD -1

.code

main PROC

startPath:
;Decision Pathing for the user
	mov edx,OFFSET userChoice
	call WriteString
	call ReadInt
	mov userSelection,al
	cmp userSelection,4
	jge errorMSGChoice
	cmp userSelection,1
	je matrixMul	;If user selects 1, goto matrix multiplication



matrixMul:
		mov edx,OFFSET matrixMessage	;Start of asking matrix size
	call WriteString
	call ReadInt
	mov edx,OFFSET emptyCR
	call WriteString
	mov matrixSize,eax
	mov edx,OFFSET confirmSize
	call WriteString
	mov edx,OFFSET matrixSize
	call WriteDec
	mov edx,OFFSET emptyCR
	call WriteString

;**************INIT MATRIX A HERE*******************

initAPre: ;	Zero registers, move matrixSize to ecx to begin the loop counter.
	mov ecx,matrixSize
	xor eax,eax
	xor ebx,ebx

initOuterA:
	mov eax,matrixSize
	mov iPos,eax
	sub iPos,ecx	;As loop counter decreases, iPos remains constant, therefore iPos represents the current row.
	sub ecx,1
	push ecx
	mov ecx,matrixSize	;Init inner loop size
	jmp initInnerA

initInnerA: ;Most of this is nonsense to get the text out, but below is the array initialization. 
		   ;Because ASM doesn't have the abstraction of 2D arrays, you must create the appearance of 2D using pointer math

	;**TEXT CRAP HERE BEFORE ACTUAL MEMORY VALUE MANIPULATION**
	mov edx,OFFSET valueEntryText1
	call WriteString
	mov eax,iPos
	call WriteDec
	mov edx,OFFSET valueEntryText2
	call WriteString
	mov eax,matrixSize
	sub eax,ecx
	call WriteDec	
	mov edx,OFFSET displaySeparator
	call WriteString
	mov edx,OFFSET emptySpaceA
	call WriteString
	mov edx,OFFSET emptyCR
	call WriteString
	


	mov eax,matrixSize
	sub eax,ecx
	mov ebx,4
	mul ebx
	mov tempValPos,eax
	mov eax,iPos	;**Because iPos represents the row, it needs to be multiplied by the matrixSize* TYPE matrixA to reference the correct row memory address**
	mov ebx,matrixSize
	mul ebx
	mov ebx,4
	mul ebx
	add tempValPos,eax
	mov ebx,tempValPos
	mov esi,OFFSET matrixA
	call ReadInt
	mov [esi+ebx],eax

	dec ecx
	jnz initInnerA

	pop ecx
	cmp ecx,0
	jg initOuterA ;Loop continues if ecx in stack still had number > 0


	; END INIT OF MATRIX A


;*********************DISPLAY MATRIX A HERE****************************

displayMatrixAPre:
	mov ecx,matrixSize
	xor eax,eax
	xor ebx,ebx

displayMatrixAOuter:
	mov eax,matrixSize
	mov iPos,eax
	sub iPos,ecx	;As loop counter decreases, iPos remains constant, therefore iPos represents the current row.
	sub ecx,1
	push ecx
	mov ecx,matrixSize	;Init inner loop size
	mov edx,OFFSET emptyCR
	call WriteString
	jmp displayMatrixAInner

displayMatrixAInner:

	mov eax,matrixSize
	sub eax,ecx
	mov ebx,4
	mul ebx
	mov tempValPos,eax
	mov eax,iPos	;**Because iPos represents the row, it needs to be multiplied by the matrixSize* TYPE matrixA to reference the correct row memory address**
	mov ebx,matrixSize
	mul ebx
	mov ebx,4
	mul ebx
	add tempValPos,eax
	mov ebx,tempValPos
	mov esi,OFFSET matrixA
	mov eax,[esi+ebx]
	call WriteDec
	mov edx,OFFSET displaySeparator
	call WriteString

	loop displayMatrixAInner

	pop ecx
	cmp ecx,0
	jg displayMatrixAOuter ;Loop continues if ecx in stack still had number > 0

	mov edx,OFFSET emptyCR
	call WriteString


;**************INIT MATRIX B HERE*******************

initBPre: ;	Zero registers, move matrixSize to ecx to begin the loop counter.
	mov ecx,matrixSize
	xor eax,eax
	xor ebx,ebx

initOuterB:
	mov eax,matrixSize
	mov iPos,eax
	sub iPos,ecx	;As loop counter decreases, iPos remains constant, therefore iPos represents the current row.
	sub ecx,1
	push ecx
	mov ecx,matrixSize	;Init inner loop size
	jmp initInnerB

initInnerB: ;Most of this is nonsense to get the text out, but below is the array initialization. 
		   ;Because ASM doesn't have the abstraction of 2D arrays, you must create the appearance of 2D using pointer math

	;**TEXT CRAP HERE BEFORE ACTUAL MEMORY VALUE MANIPULATION**
	mov edx,OFFSET valueEntryText1
	call WriteString
	mov eax,iPos
	call WriteDec
	mov edx,OFFSET valueEntryText2
	call WriteString
	mov eax,matrixSize
	sub eax,ecx
	call WriteDec	
	mov edx,OFFSET displaySeparator
	call WriteString
	mov edx,OFFSET emptySpaceB
	call WriteString
	mov edx,OFFSET emptyCR
	call WriteString
	


	mov eax,matrixSize
	sub eax,ecx
	mov ebx,4
	mul ebx
	mov tempValPos,eax
	mov eax,iPos	;**Because iPos represents the row, it needs to be multiplied by the matrixSize* TYPE matrixA to reference the correct row memory address**
	mov ebx,matrixSize
	mul ebx
	mov ebx,4
	mul ebx
	add tempValPos,eax
	mov ebx,tempValPos
	mov esi,OFFSET matrixB
	call ReadInt
	mov [esi+ebx],eax

	dec ecx
	jnz initInnerB

	pop ecx
	cmp ecx,0
	jg initOuterB ;Loop continues if ecx in stack still had number > 0


	; END INIT OF MATRIX B


;*********************DISPLAY MATRIX B HERE****************************

displayMatrixBPre:
	mov ecx,matrixSize
	xor eax,eax
	xor ebx,ebx

displayMatrixBOuter:
	mov eax,matrixSize
	mov iPos,eax
	sub iPos,ecx	;As loop counter decreases, iPos remains constant, therefore iPos represents the current row.
	sub ecx,1
	push ecx
	mov ecx,matrixSize	;Init inner loop size
	mov edx,OFFSET emptyCR
	call WriteString
	jmp displayMatrixBInner

displayMatrixBInner:

	mov eax,matrixSize
	sub eax,ecx
	mov ebx,4
	mul ebx
	mov tempValPos,eax
	mov eax,iPos	;**Because iPos represents the row, it needs to be multiplied by the matrixSize* TYPE matrixA to reference the correct row memory address**
	mov ebx,matrixSize
	mul ebx
	mov ebx,4
	mul ebx
	add tempValPos,eax
	mov ebx,tempValPos
	mov esi,OFFSET matrixB
	mov eax,[esi+ebx]
	call WriteDec
	mov edx,OFFSET displaySeparator
	call WriteString

	loop displayMatrixBInner

	pop ecx
	cmp ecx,0
	jg displayMatrixBOuter ;Loop continues if ecx in stack still had number > 0

	mov edx,OFFSET emptyCR
	call WriteString

	exit

errorMSGChoice:
	mov edx,OFFSET errorChoice
	call WriteString
	jmp startPath

main ENDP
END main