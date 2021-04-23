TITLE Matrix Mather

; This program does matrix math.

INCLUDE Irvine32.inc

.386
.model flat,stdcall
.stack 4096
ExitProcess proto,dwExitCode:dword

.data

userChoice byte "Select Operation -- (1) for Matrix Multiplication, (2) To find Matrix Inverse, (3) To find Matrix Determinant, (4) for Matrix Addition, (5) for Matrix Subtraction",13,10,0
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
kPos DWORD 0
tempValPos DWORD 0	;Need a temp variable to store for indexing
tempMulResult DWORD 0
tempCResult DWORD 0
factor REAL4 ?
divisor REAL4 ?
dividend REAL4 ?
showNum REAL4 ?
zero REAL4 0.0
one REAL4 1.0

matrixA REAL4 100 DUP(?)
matrixB REAL4 100 DUP(?)
matrixC REAL4 100 DUP(?)
identityMatrix REAL4 100 DUP(?)

iVal DWORD -1	;The i, j, k simplify indexing for operations.
jVal DWORD -1
kVal DWORD -1

.code

main PROC

	FINIT

startPath:
;Decision Pathing for the user
	mov edx,OFFSET userChoice
	call WriteString
	call ReadInt
	mov userSelection,al
	cmp userSelection,6
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

	cmp userSelection,2
	je matInverse	;If user selects 2, goto matrix inverse because Matrix B is not needed
	cmp userSelection,3
	je matInverse
	;If user selects 3, goto matrix det because Matrix B is not needed

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

	cmp userSelection,1
	je multPre

	cmp userSelection,5
	je subPre

;***********BEGIN ADD HERE*******************
addPre:

	; this calculates the total size of the Matrix memory ((matrixSize*matrixSize)*4)-4 = tempMatrixSize (i.e [matrixSize+60])
	mov ebx, 4
	mov eax, matrixSize
	mul eax
	mul ebx
	sub eax, ebx
	;mov tempMatrixSize, eax


	; this zeroes out all the registes and preps for the actual addfunctions
	mov ecx, matrixSize
	xor eax,eax
	xor ebx,ebx

	
	mov tempValPos, 0
	mov iPos, 0
	mov jPos, 0

	


addOuter:	;this is kinda setup for the next outer loop iteration	
	mov jPos, 0
	

	mov eax, matrixSize					; This moves the matrix size into eax and MULs it by 4 to get its position in memory
	mov ebx, 4
	mul ebx

	; MUL resets edx so restore value
	; this subs 1 from the matrixSize and stores in edx for the outerLoopCounter
	mov edx, matrixSize
	sub edx, 1

	;mov ecx, tempMatrixSize				
	mov ebx, matrixSize					
	cmp iPos, ebx						
	jge displayMatrixCPre				; Adding is completed so jmp to matrixC
	

addInner:	
	
	; This is where the adding gets done
	mov ecx, tempValPos
	mov eax, [matrixA+ecx]
	add eax, [matrixB+ecx]
	mov [matrixC+ecx], eax

	; add BEFORE THIS SECTION
	mov eax, tempValPos		; this adds 4 to maintain the memory position of the var
	add eax, 4
	mov tempValPos, eax

	cmp jPos, edx
	jge  addInnerDone
	inc jPos
	jmp addInner

addInnerDone:
	inc iPos				
	mov eax, tempValPos
	jmp addOuter


;***********BEGIN SUB HERE*********************

subPre:

	; this calculates the total size of the Matrix memory ((matrixSize*matrixSize)*4)-4 = tempMatrixSize (i.e [matrixSize+60])
	mov ebx, 4
	mov eax, matrixSize
	mul eax
	mul ebx
	sub eax, ebx
	;mov tempMatrixSize, eax


	; this zeroes out all the registes and preps for the actual subfunctions
	mov ecx, matrixSize
	xor eax,eax
	xor ebx,ebx

	
	mov tempValPos, 0
	mov iPos, 0
	mov jPos, 0

	


subOuter:	;this is kinda setup for the next outer loop iteration	
	mov jPos, 0
	

	mov eax, matrixSize					; This moves the matrix size into eax and MULs it by 4 to get its position in memory
	mov ebx, 4
	mul ebx

	; MUL resets edx so restore value
	; this subs 1 from the matrixSize and stores in edx for the outerLoopCounter
	mov edx, matrixSize
	sub edx, 1

	;mov ecx, tempMatrixSize				
	mov ebx, matrixSize					
	cmp iPos, ebx						
	jge displayMatrixCPre				; Subtraction is completed so jmp to matrixC
	

subInner:	
	
	; This is where the SUBTRACTION gets done
	mov ecx, tempValPos
	mov eax, [matrixA+ecx]
	sub eax, [matrixB+ecx]

	js signedSub
	mov [matrixC+ecx], eax				; sign flag is PL
	jmp afterSignedSub

signedSub:
	; IMPLMENT CONVERSION
	not eax
	add eax, 1
	mov [matrixC+ecx], eax				; sign flag is PL

afterSignedSub:
	; sub BEFORE THIS SECTION
	mov eax, tempValPos		; this adds 4 to maintain the memory position of the var
	add eax, 4
	mov tempValPos, eax

	cmp jPos, edx
	jge subInnerDone
	inc jPos
	jmp subInner

subInnerDone:
	inc iPos				
	mov eax, tempValPos
	jmp subOuter


;***********BEGIN MULT OPERATION HERE********************

multPre:
	mov ecx,matrixSize
	xor eax,eax
	xor ebx,ebx

multOuter:	;for(i = 0; i < matrix.length; i++)
	mov eax,matrixSize
	mov iVal,eax
	sub iVal,ecx
	dec ecx
	push ecx	;Stack has OUTER LOOP COUNTER ONLY
	mov ecx,matrixSize
	jmp multMiddle

multMiddle:	;for(j = 0; j < matrix.length; j++)
	mov eax,matrixSize
	mov jVal,eax
	sub jVal,ecx
	dec ecx
	push ecx	;TOP OF STACK MIDDLE LOOP -> OUTER LOOP VALUES
	mov ecx,matrixSize
	mov eax,jVal
	mov ebx,4
	mul ebx
	mov tempCResult,eax
	mov eax,iVal
	mov ebx,4
	mul ebx
	mov ebx,matrixSize
	mul ebx
	add tempCResult,eax
	mov ebx,tempCResult
	jmp multInner

multInner:	;for(k = 0; k < matrix.length; k++)
	mov esi,OFFSET matrixC
	push esi	;TOP OF STACK MATRIX C ADDRESS -> MIDDLE LOOP -> OUTER LOOP
	mov eax,matrixSize
	sub eax,ecx
	mov kVal,eax
	mov ebx,4
	mul ebx
	mov tempValPos,eax
	mov eax,iVal
	mov ebx,4
	mul ebx
	mov ebx,matrixSize
	mul ebx
	add tempValPos,eax
	mov ebx,tempValPos
	mov esi,OFFSET matrixA
	mov eax,[esi+ebx]
	mov tempMulResult,eax	;Have element A[i][k] stored

	mov eax,jVal
	mov ebx,4
	mul ebx
	mov tempValPos,eax
	mov eax,kVal
	mov ebx,4
	mul ebx
	mov ebx,matrixSize
	mul ebx
	add tempValPos,eax
	mov ebx,tempValPos
	mov esi,OFFSET matrixB
	mov eax,[esi+ebx]
	mov ebx,tempMulResult
	mul ebx
	pop esi	;TOP OF STACK MIDDLE LOOP -> OUTER LOOP VALUES
	mov ebx,tempCResult
	add [esi+ebx],eax

	dec ecx
	jnz multInner

	pop ecx	;Stack has OUTER LOOP COUNTER ONLY
	cmp ecx,0
	jg multMiddle	;Loop continues if ecx in stack still had number > 0 goto middle loop

	pop ecx	;STACK EMPTY
	cmp ecx,0
	jg multOuter	;Loop continues if ecx in stack still had number > 0 goto outer loop



;*********************DISPLAY MATRIX C HERE****************************

displayMatrixCPre:
	mov ecx,matrixSize
	xor eax,eax
	xor ebx,ebx

displayMatrixCOuter:
	mov eax,matrixSize
	mov iPos,eax
	sub iPos,ecx	;As loop counter decreases, iPos remains constant, therefore iPos represents the current row.
	sub ecx,1
	push ecx
	mov ecx,matrixSize	;Init inner loop size
	mov edx,OFFSET emptyCR
	call WriteString
	jmp displayMatrixCInner

displayMatrixCInner:

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
	mov esi,OFFSET matrixC
	mov eax,[esi+ebx]
	call WriteDec
	mov edx,OFFSET displaySeparator
	call WriteString

	loop displayMatrixCInner

	pop ecx
	cmp ecx,0
	jg displayMatrixCOuter ;Loop continues if ecx in stack still had number > 0

	mov edx,OFFSET emptyCR
	call WriteString
	jmp SKIP


matInverse:

initIDPre:
	xor eax,eax
	xor ebx,ebx
	mov ecx,matrixSize
	mov iPos,0
	mov jPos,0

initIDOuter:
	mov eax,matrixSize
	dec ecx
	push ecx
	mov ecx,matrixSize
	mov jPos,0

initIDInner:
	mov tempValPos,0
	mov eax,iPos
	mov ebx,jPos
	inc jPos
	cmp eax,ebx
	jne InitIDNE
	mov ebx,4
	mul ebx
	mov ebx,matrixSize
	mul ebx
	mov tempValPos,eax
	mov eax,iPos
	mov ebx,4
	mul ebx
	add tempValPos,eax
	mov ebx,tempValPos
	mov esi,OFFSET identityMatrix
	fld one
	fstp REAL4 PTR[ebx+esi]
	jmp InitIDReset

InitIDNE:
	mov ebx,4
	mul ebx
	mov ebx,matrixSize
	mul ebx
	mov tempValPos,eax
	mov eax,jPos
	mov ebx,4
	mul ebx
	add tempValPos,eax
	mov ebx,tempValPos
	mov esi,OFFSET identityMatrix
	fld zero
	fstp REAL4 PTR[ebx+esi]

	dec ecx
	jnz initIDInner

	jmp InitIDResetOuter

InitIDReset:
	dec ecx
	jnz initIDInner

InitIDResetOuter:
	
	inc iPos
	pop ecx
	cmp ecx,0
	jg initIDOuter

	mov edx,OFFSET emptyCR
	call WriteString

initInversePre:
	xor eax,eax
	xor ebx,ebx
	mov ecx,matrixSize

initInverseOuter:
	mov eax,matrixSize
	mov iPos,eax
	sub iPos,ecx
	dec ecx
	push ecx
	mov ecx,matrixSize
	mov jPos,0

initInverseInner:

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

	mov eax,iPos
	mov ebx,4
	mul ebx
	mov ebx,matrixSize
	mul ebx
	mov tempValPos,eax
	mov eax,jPos
	mov ebx,4
	mul ebx
	add tempValPos,eax
	mov ebx,tempValPos
	mov esi,OFFSET matrixA
	call ReadFloat
	fstp REAL4 PTR[ebx+esi]

	inc jPos
	dec ecx
	jnz initInverseInner

	pop ecx
	cmp ecx,0
	jg initInverseOuter

	mov edx,OFFSET emptyCR
	call WriteString

EliminationPre:
	mov ecx,matrixSize
	xor eax,eax
	xor ebx,ebx
	mov jPos,0
	mov iPos,0
	mov kPos,0

EliminationOuter:
	
	dec ecx
	push ecx
	mov ecx,matrixSize
	mov iPos,0

EliminationMiddle:
	dec ecx
	push ecx
	mov tempValPos,0
	mov eax,jPos
	mov ebx,iPos
	cmp eax,ebx
	je EliminationConditional
	mov ebx,4
	mul ebx
	mov tempValPos,eax
	mov eax,iPos
	mul ebx
	mov ebx,matrixSize
	mul ebx
	add eax,tempValPos
	mov ebx,eax
	mov esi,OFFSET matrixA
	fld REAL4 PTR[ebx+esi]	;ST(0): MatrixA[i][j]
	mov eax,jPos
	mov ebx,4
	mul ebx
	mov tempValPos,eax
	mov eax,jPos
	mul ebx
	mov ebx,matrixSize
	mul ebx
	add eax,tempValPos
	mov ebx,eax
	mov esi,OFFSET matrixA
	fld REAL4 PTR[ebx+esi]	;ST(0): MatrixA[j][j] -> ST(1): MatrixA[i][j]
	fdiv	;ST(0): (short)MatrixA[i][j]/MatrixA[j][j]
	fstp factor	;FPU empty
	mov kPos,0

	mov ecx,matrixSize

EliminationInner:

;****MATRIX A PORTION****
	mov tempValPos,0
	mov eax,iPos
	mov ebx,4
	mul ebx
	mov ebx,matrixSize
	mul ebx
	mov tempValPos,eax
	mov eax,kPos
	mov ebx,4
	mul ebx
	add tempValPos,eax
	mov esi,OFFSET matrixA
	mov ebx,tempValPos
	fld REAL4 PTR[ebx+esi]	;ST(0): A[i][k]
	mov eax,jPos
	mov ebx,4
	mul ebx
	mov ebx,matrixSize
	mul ebx
	mov tempValPos,eax
	mov eax,kPos
	mov ebx,4
	mul ebx
	add tempValPos,eax
	mov ebx,tempValPos
	fld REAL4 PTR[ebx+esi]	;ST(0): A[j][k] -> ST(1) A[i][k]
	fld factor	;ST(0) factor -> A[j][k] -> A[i][k]
	fmul	;ST(0): A[j][k] -> ST(1) A[i][k]
	fsub	;ST(0): A[i][k]-factor*A[j][k]
	mov eax,iPos
	mov ebx,4
	mul ebx
	mov ebx,matrixSize
	mul ebx
	mov tempValPos,eax
	mov eax,kPos
	mov ebx,4
	mul ebx
	add tempValPos,eax
	mov ebx,tempValPos
	fstp REAL4 PTR[ebx+esi]

;****IDENTITY MATRIX PORTION****
	mov tempValPos,0
	mov eax,iPos
	mov ebx,4
	mul ebx
	mov ebx,matrixSize
	mul ebx
	mov tempValPos,eax
	mov eax,kPos
	mov ebx,4
	mul ebx
	add tempValPos,eax
	mov esi,OFFSET identityMatrix
	mov ebx,tempValPos
	fld REAL4 PTR[ebx+esi]	;ST(0): A[i][k]
	mov eax,jPos
	mov ebx,4
	mul ebx
	mov ebx,matrixSize
	mul ebx
	mov tempValPos,eax
	mov eax,kPos
	mov ebx,4
	mul ebx
	add tempValPos,eax
	mov ebx,tempValPos
	fld REAL4 PTR[ebx+esi]	;ST(0): A[j][k] -> ST(1) A[i][k]
	fld factor	;ST(0) factor -> A[j][k] -> A[i][k]
	fmul	;ST(0): A[j][k] -> ST(1) A[i][k]
	fsub	;ST(0): A[i][k]-factor*A[j][k]
	mov eax,iPos
	mov ebx,4
	mul ebx
	mov ebx,matrixSize
	mul ebx
	mov tempValPos,eax
	mov eax,kPos
	mov ebx,4
	mul ebx
	add tempValPos,eax
	mov ebx,tempValPos
	fstp REAL4 PTR[ebx+esi]

	;;SO FAR THIS WORKS, BELOW BEWARE

	inc kPos
	dec ecx
	jnz EliminationInner

EliminationConditional:
	inc iPos
	pop ecx
	cmp ecx,0
	jg EliminationMiddle

	inc jPos
	pop ecx
	cmp ecx,0
	jg EliminationOuter



finalElimPre:
	xor eax,eax
	xor ebx,ebx
	mov ecx,matrixSize
	mov iPos,0

finalElimOuter:
	mov tempValPos,0
	dec ecx
	push ecx
	mov jPos,0
	mov eax,iPos
	mov ebx,4
	mul ebx
	mov ebx,matrixSize
	mul ebx
	mov tempValPos,eax
	mov eax,iPos
	mov ebx,4
	mul ebx
	add tempValPos,eax
	mov ebx,tempValPos
	mov esi,OFFSET matrixA
	fld REAL4 PTR[esi+ebx]
	fstp divisor
	fld divisor	;Going to push this down the stack for determinant calculations
	mov ecx,matrixSize

finalElimInner:
	mov tempValPos,0
	mov eax,iPos
	mov ebx,4
	mul ebx
	mov ebx,matrixSize
	mul ebx
	mov tempValPos,eax
	mov eax,jPos
	mov ebx,4
	mul ebx
	add tempValPos,eax
	mov ebx,tempValPos
	mov esi,OFFSET identityMatrix
	fld REAL4 PTR[esi+ebx]
	fstp dividend
	fld dividend
	fld divisor
	fdiv
	fstp REAL4 PTR[esi+ebx]

	inc jPos
	dec ecx
	jnz finalElimInner

	inc iPos
	pop ecx
	cmp ecx,0
	jg finalElimOuter

	cmp userSelection,3
	je matDeterminant
	

;*********************DISPLAY I HERE****************************

displayMatrixIPre:
	mov ecx,matrixSize
	xor eax,eax
	xor ebx,ebx

displayMatrixIOuter:
	mov eax,matrixSize
	mov iPos,eax
	sub iPos,ecx	;As loop counter decreases, iPos remains constant, therefore iPos represents the current row.
	sub ecx,1
	push ecx
	mov ecx,matrixSize	;Init inner loop size
	mov edx,OFFSET emptyCR
	call WriteString
	jmp displayMatrixIInner

displayMatrixIInner:

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
	mov esi,OFFSET identityMatrix
	fld REAL4 PTR[esi+ebx]
	call WriteFloat
	fstp showNum
	mov edx,OFFSET displaySeparator
	call WriteString

	loop displayMatrixIInner

	pop ecx
	cmp ecx,0
	jg displayMatrixIOuter ;Loop continues if ecx in stack still had number > 0

	mov edx,OFFSET emptyCR
	call WriteString
	jmp SKIP

matDeterminant:

	xor eax,eax
	xor ebx,ebx
	mov ecx,matrixSize
	dec ecx

matDetCalc:
	fmul
	loop matDetCalc

showDet:
	call WriteFloat




SKIP:
	exit

errorMSGChoice:
	mov edx,OFFSET errorChoice
	call WriteString
	jmp startPath

main ENDP
END main