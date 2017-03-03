TITLE  Calculating Composite Numbers    (composites.asm)

; Author: Carlos Lopez-Molina
; CS 271 / Project ID: 4                 Date: 02/19/17
; Description: Program that calculates composite numbers. User is instructed to enter the number of composits to be diplayed and is prompted to enter a number in that range [1-400]. User input if varified and then values are calculated and then displayes 10 composites per line with at least 3 spaces between the numbers.
	;Note: Program makes sure user is in range and is reprompted if not in range. 
	;**EC: Align the output columns.
INCLUDE Irvine32.inc

; (insert constant definitions here)
UPPER = 400	;upper limit
LOWER = 1	;lowest limit

.data

; (insert variable definitions here)
intro		BYTE	"Welcome to the Calculating Composite Numbers program! Programmed by Carlos Lopez-Molina.",0
extra		BYTE	"**EC: Align the output columns.",0
error		BYTE	"Error! Out of range! Enter new number: ",0
intro_2		BYTE	"Enter the number of composite numbers you would like to see. I'll accept orders for up to 400 composites.",0
intro_3		BYTE	"Enter the number of composite numbers you would like to display [1-400]: ",0
bye			BYTE	"Results certified by Carlos. Goodbye.",0

input		DWORD	?
temp		DWORD	4
num			DWORD	2
row			DWORD	1
line		DWORD	10

.code
main PROC

; (insert executable instructions here - procedures)
	;introduction
	call	introduction
	;get user data and validate
	call	getUserData
		;call	validate
	;show composites and make sure input is a composite
	call	showComposites
		;call	isComposite
	;end the program
	call	farewell

	exit	; exit to operating system
main ENDP

; (insert additional procedures here)
;---------------------------------------------------------
;introduction
;
; Displays Introduction for the program/user
; Receives: edx
; Returns: Displays a string variable
;---------------------------------------------------------
introduction		PROC
	call	Clrscr
	mov		edx, OFFSET intro
	call	WriteString
	call	CrLf
	mov		edx, OFFSET extra
	call	WriteString
	call	CrLf
	call	CrLf
	mov		edx, OFFSET intro_2
	call	WriteString
	call	CrLf
	call	CrLf

	ret
introduction	ENDP

;---------------------------------------------------------
;getUserData
;
; Asks and gets the input from the user to fill in the data variable 
;	and then calls the validate procedure to validate the value inputed.
; Receives: edx, input variable
; Returns: eax = input - variable with new input
;---------------------------------------------------------
getUserData			PROC
	mov		edx, OFFSET intro_3
	call	WriteString
	call	CrLf
	call	ReadInt	
	mov		input, eax
	call	CrLf
	call	validate

	ret
getUserData		ENDP

;---------------------------------------------------------
;validate
;
; Validates the users data to make sure it is in range specified by program, if not then prompts for new input until input meets requirement
; Receives: eax, edx, ecx
; Returns: input = EAX - input is updated with acceptable input
;---------------------------------------------------------
validate			PROC
	;loop until input is between the upper and lower value
	.while ((input < LOWER) || (input > UPPER))
		mov		edx, OFFSET error
		call	WriteString
		call	ReadInt	
		mov		input, eax
		call	CrLf
	.endw

	ret
validate		ENDP

;---------------------------------------------------------
;showComposites
;
; Displays Calls the iscomposites prodecure to check values for composite and then displays
;  all the composites using the input from the user into 10 composites per line with at least 
;  3 spaces between the numbers.
; Receives: input, eax, eab, ecx 
; Returns: Nothing, displays of the composites
;---------------------------------------------------------
showComposites		PROC
	;loop to calculate and display the composites
	mov		ecx, input ;31
_turn:
	call	isComposite
	;isComposite will return composite eax value
	call	WriteDec
	mov		al, ' '
	call	WriteChar
	call	WriteChar
	call	WriteChar

	add		temp, 1
	;for displaying in rows of 10
	add		row, 1
	.if		row == 11
		call	CrLf
		mov		row, 1
	.endif
	loop	_turn
	
	ret
showComposites	ENDP

;---------------------------------------------------------
;isComposite
;
; Checks if input is a composite number
; Receives: eax input
; Returns: eax value that is a composite
;---------------------------------------------------------
isComposite			PROC
	;A number k is composite if it can be factored into a product of smaller integers. Every integer greater than one is either prime or composite. Note that this implies that
		;we know it can always divide itself by 1 and k so need to find other numbers up to k
	;number dividng and outputing
		;mov		temp, 4
	;number dividing to see if composite
	mov		num, 2
	_div:
		mov		edx, 0
		mov		eax, temp 
		mov		ebx, num  
		cdq
		div		ebx
		cmp		edx, 0
		JE		_iscomposite
		JNE		_notcomposite

		loop	_div
	_notcomposite:
		add		num, 1
		mov		eax, temp
		cmp		num, eax
		JE		_next
		jmp		_div
	_next:	
		add		temp, 1
		mov		num, 2
		jmp		_div

	_iscomposite:
	mov		eax, temp
	
	ret	
isComposite		ENDP

;---------------------------------------------------------
;farewell
;
; Displays farewell output for the user as the program has ended
; Receives: edx
; Returns: Displays the bye string variable
;---------------------------------------------------------
farewell			PROC
	call	CrLf
	mov		edx, OFFSET bye
	call	WriteString
	call	CrLf
	
	ret
farewell		ENDP

END main
