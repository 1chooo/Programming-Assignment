include Irvine32.inc
include startScene.asm

; eax = 1 play game
; eax = 2 pause
; eax = 3 endScene
; eax = 4 leave program

.data
	windowTitleStr BYTE "Tank vs Monster",0
	consoleHandle DWORD ?
	windowBound SMALL_RECT <0,0,100,25>    ; �����j�p
	;score WORD 0
	changeScene BYTE 0
	;levelNow BYTE 0

main EQU start@0

.code
main PROC

	;get output handle
	invoke GetstdHandle, STD_OUTPUT_HANDLE
	mov consoleHandle, eax

	;�]�w�������D
	invoke SetConsoleTitle, ADDR windowTitleStr

	;�]�w�����j�p
	invoke SetConsoleWindowInfo,
		consoleHandle,
		TRUE,
		ADDR windowBound

	invoke printStart, consoleHandle

	.IF eax == 3
		jmp ExitProgram
	.ENDIF

	
ExitProgram:
	exit

main ENDP

END main