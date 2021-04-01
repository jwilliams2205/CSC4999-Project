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
emptySpace byte ": ",0
emptyCR byte " ",13,10,0

xPos DWORD 0
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

initOuter:
	mov eax,matrixSize
	mov yPos,eax
	sub yPos,ecx
	sub ecx,1
	push ecx
	mov ecx,matrixSize
	mov eax,matrixSize
	jmp initInner

initInner: ;Most of this is nonsense to get the text out, but below is the array initialization. 
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
	mov edx,OFFSET emptySpace
	call WriteString
	add eax,yPos
	mov ebx,4
	mul ebx
	mov ebx,eax
	call ReadDec
	mov [matrixA + ebx],eax


	loop initInner

	pop ecx
	cmp ecx,0
	jg initOuter ;Loop continues if ecx in stack still had number > 0





	exit

errorMSGChoice:
	mov edx,OFFSET errorChoice
	call WriteString
	jmp startPath
main ENDP
END main