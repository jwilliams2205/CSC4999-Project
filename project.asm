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
valueEntryText3 byte "Enter value for row ",0
valueEntryText4 byte " column ",0
emptySpaceB byte " for matrix B: ",0
emptyCR byte " ",13,10,0

xPos DWORD 0	;These two values are important for array indexing. xPos refers to the current column in the 2D matrix, yPos refers to the row
yPos DWORD 0

matrixA DWORD 100 DUP(0)
matrixB DWORD 100 DUP(0)
matrixC DWORD 100 DUP(0)

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

	mov ecx,matrixSize
	xor eax,eax
	xor ebx,ebx

initOuterA:
	mov eax,matrixSize
	mov yPos,eax
	sub yPos,ecx
	sub ecx,1
	push ecx
	mov ecx,matrixSize
	mov eax,matrixSize
	jmp initInnerA

initInnerA: ;Most of this is nonsense to get the text out, but below is the array initialization. 
		   ;Because ASM doesn't have the abstraction of 2D arrays, you must create the appearance of 2D using pointer math
	
	mov eax,matrixSize
	mov xPos,eax
	sub xPos,ecx
	mov eax,xPos
	mov ebx,matrixSize
	mul ebx
	mov edx,OFFSET valueEntryText1
	call WriteString
	mov eax,yPos
	call WriteDec
	mov edx,OFFSET valueEntryText2
	call WriteString
	mov eax,xPos
	call WriteDec
	mov edx,OFFSET emptySpaceA
	call WriteString
	add eax,yPos
	mov ebx,4
	mul ebx
	mov ebx,eax
	call ReadDec
	mov [matrixA + ebx],eax


	loop initInnerA

	pop ecx
	cmp ecx,0
	jg initOuterA ;Loop continues if ecx in stack still had number > 0


	mov ecx,matrixSize
	xor eax,eax
	xor ebx,ebx

initOuterB:
	mov eax,matrixSize
	mov yPos,eax
	sub yPos,ecx
	sub ecx,1
	push ecx
	mov ecx,matrixSize
	mov eax,matrixSize
	jmp initInnerB

initInnerB: ;Most of this is nonsense to get the text out, but below is the array initialization. 
		   ;Because ASM doesn't have the abstraction of 2D arrays, you must create the appearance of 2D using pointer math
	
	mov eax,matrixSize
	mov xPos,eax
	sub xPos,ecx
	mov eax,xPos
	mov ebx,matrixSize
	mul ebx
	mov edx,OFFSET valueEntryText3
	call WriteString
	mov eax,yPos
	call WriteDec
	mov edx,OFFSET valueEntryText4
	call WriteString
	mov eax,xPos
	call WriteDec
	mov edx,OFFSET emptySpaceB
	call WriteString
	add eax,yPos
	mov ebx,4
	mul ebx
	mov ebx,eax
	call ReadDec
	mov [matrixA + ebx],eax


	loop initInnerB

	pop ecx
	cmp ecx,0
	jg initOuterB ;Loop continues if ecx in stack still had number > 0


	exit

errorMSGChoice:
	mov edx,OFFSET errorChoice
	call WriteString
	jmp startPath
main ENDP
END main