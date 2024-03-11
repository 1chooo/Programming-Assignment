INCLUDE Irvine32.inc

; �ŧi�禡
decToStr          PROTO, decNum:WORD, decStr:BYTE
printNum          PROTO, decNum:WORD, decStr:BYTE, xyPosInit:COORD

printGreenLine    PROTO, xyPosInit:COORD
printBullet       PROTO, xyPosInit:COORD
bulletClear       PROTO, xyPosInit:COORD
printBogy         PROTO, xyPosInit:COORD
bogyClear         PROTO, xyPosInit:COORD
printTank         PROTO, xyPosInit:COORD
tankClear         PROTO, xyPosInit:COORD

initialLevel      PROTO
printGameStage    PROTO
printBar          PROTO
printEnd     PROTO
printStartScene   PROTO

; ebx���� -> �ΨӦs���A
; ebx = 1 ���C��
; ebx = 2 �Ȱ�     -> ��ӨS�Ψ�
; ebx = 3 ����e��
; ebx = 4 ���}�{��

.data
; �ܼƭ� BYTE 1, WORD 2, DWORD 4
	consoleHandle  DWORD ?
	cells_Written  DWORD ?
	
	; �]�w�������D&�����j�p�]�w
	windowTitleStr BYTE "Hua Tank V.S Bogy", 0
	windowBound SMALL_RECT <0, 0, 125, 25>
	
	; �Ҧ��F�誺��l�y��
	xyPos COORD <?,?> ; �L��L�F��Ϊ�

	xyPosTank COORD <7,15>

	; 21���l�u����l�y��
	xPos15 WORD 15 ; �o�g������n�^�Ӫ��a��
	xyPosBullet COORD <?,6> , <?,7>,  <?,8> , <?,9> , <?,10>,
					  <?,11>, <?,12>, <?,13>, <?,14>, <?,15>,
					  <?,16>, <?,17>, <?,18>, <?,19>, <?,20>,
					  <?,21>, <?,22>, <?,23>, <?,24>, <?,25>, <?,26>

	bulletIsWork WORD 20 DUP(0) ; �N��l�u�����A 1 �N��o�g, 0�N��S��

	xyPosBogy COORD <?,5>, <?,9>, <?,13>, <?,17>, <?,21>, <?,25>
	xPosBogyLevel1 WORD 152, 123, 110, 116, 131, 136
	xPosBogyLevel2 WORD 231, 152, 124, 142, 134, 210
	xPosBogyLevel3 WORD 186, 127, 134, 132, 123, 165
	xPosBogyLevel4 WORD 153, 165, 142, 120, 152, 163
	xPosBogyLevel5 WORD 142, 123, 163, 134, 126, 146

	; �}�l�e�� ����108, ���6
	startStr BYTE " _________    _      ____  _____ ___  ____   ____   ____  ______      ______     ___      ______ ____  ____ "
			 BYTE "|  _   _  |  / \    |_   \|_   _|_  ||_  _| |_  _| |_  _|/ ____ \    |_   _ \  .'   `.  /  ___  |_  _||_  _|"
			 BYTE "|_/ | | \_| / A \     |   \ | |   | |_/ /     \ \   / / | (___ \_|     | |_) |/  .-.  \/  /   \_| \ \  / /  " 
			 BYTE "    | |    / ___ \    | |\ \| |   |  __ \      \ \ / /   _.____`.      |  __'.| |   | || |   ____  \ \/ /   " 
			 BYTE "   _| |_ _/ /   \ \_ _| |_\   |_ _| |  \ \_     \ ' /_  | \____) | _  _| |__) \  `-'  /\  \___]  | _|  |_   " 
			 BYTE "  |_____|____| |____|_____|\____|____||____|     \_/(_)  \______.'(_)|_______/ `.___.'  `._____.' |______|  "
	
	startColor WORD 44 DUP(0Ah), 25 DUP(0fh), 39 DUP(0Bh) ;���D�C��

	; �w��Z�J ����24, ���7
	startTank BYTE "       \                "
			  BYTE "       _\______         "
			  BYTE "      /        \=======D"
			  BYTE " ____|_HUA_TANK_\_____  "
			  BYTE "/ ___WHERE_ARE_YOU?__ \ "
			  BYTE "\/ _===============_ \/ "
			  BYTE "  \-===============-/   "
	startTankColor WORD 24 DUP(0Ah) ; �w��Z�J�C��

	; �w��BOGY ���� 7,��� 5
	startBogy BYTE " (\_/) "
			  BYTE " |OvO| "
			  BYTE "/ === \"
			  BYTE "\| X |/"
			  BYTE " |_|_| "
	startBogyColor WORD 7 DUP(0Bh) ; �w��BOGY�C��

	; �C���W�h ���� 65 ���16 1, 8, 13 ����
	gameIntro BYTE "*****************************************************************"
              BYTE "                       Game Introduction:                        "
              BYTE "             Control the Hua Tank to kill the Bogy.              "
              BYTE "              Don't let Bogy cross the green line,               "
			  BYTE "                 or your life will shock down!!                  "
              BYTE "   Start with 10 lives, once the live reaches zero, you lose!!   "
              BYTE "      Kill the last monsters, if you still alive, you win!!      "
              BYTE "                                                                 "
              BYTE "                    How to control the tank:                     "
              BYTE "                + press 'up'    to move up                       "
              BYTE "                + press 'down'  to move down                     "
              BYTE "                + press 'right' to fire bullet                   "
              BYTE "                                                                 "
              BYTE "                          How to play:                           "
              BYTE "                + press 'space' to start game                    "
              BYTE "                + press 'P'     to pause game                    "
              BYTE "*****************************************************************"
	gameIntroColor WORD 65 DUP(0Eh)

	; �}�l�e��&����e�������ܦr
	enterMsg  BYTE "Press 'E' to enter",0
	leaveMsg  BYTE "Press 'L' to leave",0
	restart   BYTE "Press 'R' to restart",0
	nextLevel BYTE "Press 'N' to next level",0
	finalMsg  BYTE "The day is saved, thanks to the Powerful Hua Tank!",0

	finalColor WORD 50 DUP(0Ah) ; finalMsg���C��

	; �p�Z�J ���� 8, ��� 3
	gameTank  BYTE "  __    "
			  BYTE " Hua\==D"
			  BYTE "(Tank)  "
	clearTank BYTE 8 DUP(' ')
	tankColor WORD 8 DUP(0Ah) ; �p�Z�J�C��

	; �pBOGY ���� 5, ��� 3
	gameBogy  BYTE "(\_/)"
			  BYTE "|OvO|"
			  BYTE "|_|_|"
	clearBogy BYTE 5 DUP(' ')
	gameBogyColor WORD 5 DUP(0Eh), 5 DUP(0Bh), 5 DUP(0Dh)

	; �l�u
	bullet BYTE "NOWORK",0
	clearBullet BYTE 6 DUP(' ')
	bulletColor WORD 6 DUP(0Fh) ; �l�u�C��

	; �T�Ҫ����u
	line BYTE "|",0
	greenColor WORD 0Ah

	level BYTE "Level: ",0
	state BYTE "State: ",0
	score BYTE "Score: ",0
	lives BYTE "Lives: ",0
	bogys BYTE "Bogies:",0

	numStr BYTE 4 DUP(?)

	paused BYTE "Paused ",0
	playing BYTE "Playing",0

	scoreNumInLevel WORD ?
	livesNumInLevel WORD ?

	levelNum WORD 1
	scoreNum WORD 0
	livesNum WORD 10
	bogysNum WORD ?

	; �C�����خ�
	gameBgTB BYTE 110 DUP("*"),0 ;�W�U
	gameBgM  BYTE "*", 108 DUP(" "), "*",0 ; ������

	winStr  BYTE "  ____      ____ _____ ____  _____  "
		    BYTE " |_  _|    |_  _|_   _|_   \|_   _| "
		    BYTE "   \ \  /\  / /   | |   |   \ | |   "
		    BYTE "    \ \/  \/ /    | |   | |\ \| |   "
		    BYTE "     \  /\  /    _| |_ _| |_\   |_  "
		    BYTE "      \/  \/    |_____|_____|\____| "
	winColor WORD 36 DUP(0Ah)
	
	loseStr BYTE " _____      ___    ______  ________ "
			BYTE "|_   _|   .'   `..' ____ \|_   __  |"
			BYTE "  | |    /  .-.  | (____\_| | |_ \_|"	
			BYTE "  | |   _| |   | |_.____ \  |  _| _ "
			BYTE " _| |__/ \  `-'  / \____) \_| |__/ |"
			BYTE "|________|`.___.' \_______/________|"
	loseColor WORD 36 DUP(0Bh)

.code
main PROC
	; get consoleHandle
	INVOKE GetstdHandle, STD_OUTPUT_HANDLE
	mov consoleHandle, eax
	; �]�w�������D
	INVOKE SetConsoleTitle, ADDR windowTitleStr
	; �]�w�����j�p
	INVOKE SetConsoleWindowInfo,
		consoleHandle,
		TRUE,
		ADDR windowBound

WelcomeScene:
	INVOKE printStartScene
	
	; �P�_ ebx �����A
CheckEbx:
	.IF ebx == 3 ; ����e��
		call Clrscr
		INVOKE printEnd
	.ENDIF
	.IF ebx == 4 ; �����C��
		call Clrscr
		jmp ExitProgram
	.ENDIF
	.IF ebx == 1 ; �}�l�C��
		INVOKE initialLevel
		INVOKE printGameStage
		INVOKE printBar
	.ENDIF

GameLoop:
	; �L���A�C&�T�Ҫ���u
	INVOKE printBar
	INVOKE printGreenLine, xyPos

	; �L�Z�J
	INVOKE printTank, xyPosTank

	; �T�{�l�u�O�_���ݭn�L
	mov ecx, 21
	mov esi, 0
	mov edx, 0
CheckBulletNeedToPrint:
	.IF [bulletIsWork + esi] == 1
		INVOKE printBullet, [xyPosBullet + edx]
	.ENDIF
	add esi, 2
	add edx, 4
	loop CheckBulletNeedToPrint

	; �T�{Bogy�ݤ��ݭn�L
	mov ecx, 6
	mov esi, 0
CheckBogyNeedToPrint:
	.IF [xyPosBogy + esi].x < 107
		INVOKE printBogy, [xyPosBogy + esi]
	.ENDIF
	add esi, 4
	loop CheckBogyNeedToPrint

	; �T�{��L��J(�Z�J����&�Ȱ�)
CheckKeyboard:
	call ReadKey
	.IF ax == 1970h ; �Ȱ�
		mov xyPos.x, 36
		mov xyPos.y, 2
		INVOKE WriteConsoleOutputCharacter,
			consoleHandle,
			ADDR paused,
			SIZEOF paused,
			xyPos,
			ADDR cells_Written
ToPause:
		call ReadKey
		.IF ax == 3920h
			INVOKE WriteConsoleOutputCharacter,
				consoleHandle,
				ADDR playing,
				SIZEOF playing,
				xyPos,
				ADDR cells_Written
			jmp BackToGame
		.ENDIF
		jmp ToPause
	.ENDIF
BackToGame:
	.IF ax == 4800h ; ���W
		INVOKE tankClear, xyPosTank
		sub xyPosTank.y, 2
		.IF xyPosTank.y < 5
			mov xyPosTank.y, 5
		.ENDIF
	.ENDIF
	.IF ax == 5000h ; ���U
		INVOKE tankClear, xyPosTank
		add xyPosTank.y, 2
		.IF xyPosTank.y > 25
			mov xyPosTank.y, 25
		.ENDIF
	.ENDIF
	.IF ax == 4D00h ; �o�g�l�u
		mov ax, xyPosTank.y
		sub ax, 5
		mov dx, 2
		mul dx
		mov [bulletIsWork + eax], 1
	.ENDIF
	
	; ����@�U���F���d�b�e���W
	mov eax, 150
	call Delay

	; �P�_Bogy�O�_�ݭn����
	mov ecx, 6
	mov esi, 0
	mov edx, 0
CheckBogyNeedToClear:
	.IF [xyPosBogy + esi].x < 107
		INVOKE bogyClear, [xyPosBogy + esi]
	.ENDIF

	; ��bogy�s���y��
	.IF levelNum == 1
		mov ax, 1
	.ENDIF
	.IF levelNum == 2
		mov eax, 2
		call RandomRange
		inc eax
	.ENDIF
	.IF levelNum == 3
		mov eax, 4
		call RandomRange
	.ENDIF
	.IF levelNum == 4
		mov eax, 6
		call RandomRange
	.ENDIF
	.IF levelNum == 5
		mov eax, 8
		call RandomRange
	.ENDIF
	sub [xyPosBogy + esi].x, ax
	.IF [xyPosBogy + esi].x <= 16
		dec livesNum
		.IF levelNum <= 0
			mov ebx, 3
			jmp CheckEbx
		.ENDIF
		.IF levelNum == 1
			mov ax, 100
			call RandomRange
			add ax, 130
		.ENDIF
		.IF levelNum == 2
			mov ax, 90
			call RandomRange
			add ax, 135
		.ENDIF
		.IF levelNum == 3
			mov ax, 90
			call RandomRange
			add ax, 130
		.ENDIF
		.IF levelNum == 4
			mov ax, 80
			call RandomRange
			add ax, 125
		.ENDIF
		.IF levelNum == 5
			mov ax, 80
			call RandomRange
			add ax, 120
		.ENDIF
		mov [xyPosBogy + esi].x, ax
	.ENDIF
	add esi, 4
	add edx, 2
	dec ecx
	cmp ecx, 0
	jne CheckBogyNeedToClear
	
	; �P�_�l�u�O�_�ݭn����
	mov ecx, 21
	mov esi, 0
	mov edi, 0
CheckBulletNeedToClear:
	.IF [bulletIsWork + esi] == 1
		INVOKE bulletClear, [xyPosBullet + edx]
		add [xyPosBullet + edx], 6
		.IF edx >= 0
			.IF edx < 8
				mov ax, [xyPosBogy + 0].x
				sub ax, 6
				.IF [xyPosBullet + edx].x >= ax
					dec bogysNum
					.IF bogysNum <= 0
						mov ebx, 3
						jmp CheckEbx
					.ENDIF

					mov ax, 30
					call RandomRange
					add ax, 180
					mov [xyPosBogy + 0].x, ax
				.ENDIF
			.ENDIF
		.ENDIF
	.ENDIF
	add esi, 2
	add edi, 4
	dec ecx
	cmp ecx, 0
	jne CheckBulletNeedToClear


	jmp GameLoop

ExitProgram:
	exit
main ENDP

; �L�}�l�e��
printStartScene PROC
	LOCAL cursorInfo:CONSOLE_CURSOR_INFO
	mov cursorInfo.dwSize, 100
	mov cursorInfo.bVisible, 0
	INVOKE SetConsoleCursorInfo,
		consoleHandle,
		ADDR cursorInfo

	call Clrscr

	; �L�}�l�e�������D
	mov xyPos.x, 6
	mov xyPos.y, 5

	mov ecx, 6
	mov esi, 0
ShowStartStr:
	push ecx
	INVOKE WriteConsoleOutputAttribute,
		consoleHandle,
		ADDR startColor,
		108,
		xyPos,
		ADDR cells_Written
	INVOKE WriteConsoleOutputCharacter,
		consoleHandle,
		ADDR [startStr + esi],
		108, 
		xyPos,
		ADDR cells_Written
	add esi, 108
	inc xyPos.y
	pop ecx
	loop ShowStartStr

	; �L�ﶵ
printOption:
	add xyPos.y, 7
	add xyPos.x, 48
	INVOKE WriteConsoleOutputCharacter,
		consoleHandle,
		ADDR enterMsg,
		SIZEOF enterMsg, 
		xyPos,
		ADDR cells_Written

	add xyPos.y, 2
	INVOKE WriteConsoleOutputCharacter,
		consoleHandle,
		ADDR leaveMsg,
		SIZEOF leaveMsg, 
		xyPos,
		ADDR cells_Written

	; �L�w��Z�J
	mov ecx, 7
	mov esi, 0
	mov xyPos.x, 20
	mov xyPos.y, 15
PrintStartTank:
	push ecx
	INVOKE WriteConsoleOutputAttribute,
		consoleHandle,
		ADDR startTankColor,
		24,
		xyPos,
		ADDR cells_Written
	INVOKE WriteConsoleOutputCharacter,
		consoleHandle, 
		ADDR [startTank + esi],
		24,
		xyPos,
		ADDR cells_Written
	add esi, 24
	inc xyPos.y
	pop ecx
	loop PrintStartTank

	mov ecx, 5
	mov esi, 0
	mov xyPos.x, 85
	mov xyPos.y, 16
PrintStartBogy:
	push ecx
	INVOKE WriteConsoleOutputAttribute,
		consoleHandle,
		ADDR startBogyColor,
		7,
		xyPos,
		ADDR cells_Written
	INVOKE WriteConsoleOutputCharacter,
		consoleHandle, 
		ADDR [startBogy + esi],
		7,
		xyPos,
		ADDR cells_Written
	add esi, 7
	inc xyPos.y
	pop ecx
	loop PrintStartBogy

	; �P�_�O�_�i�J�C��
StartOrNot:
	call ReadKey
	.IF ax == 1265h ; ��E�i�JIntro
		call Clrscr
		mov xyPos.x, 28
		mov xyPos.y, 7
		mov ecx, 17
		mov esi, 0
		jmp PrintIntro
	.ENDIF
	.IF ax == 266ch ; ��L���}
		mov ebx, 4
		ret
	.ENDIF
	jmp StartOrNot

	; �LIntro
PrintIntro:
	push ecx
	.IF xyPos.y == 8
		INVOKE WriteConsoleOutputAttribute,
		consoleHandle,
		ADDR gameIntroColor,
		65,
		xyPos,
		ADDR cells_Written
	.ENDIF
	.IF xyPos.y == 15
		INVOKE WriteConsoleOutputAttribute,
		consoleHandle,
		ADDR gameIntroColor,
		65,
		xyPos,
		ADDR cells_Written
	.ENDIF
	.IF xyPos.y == 20
		INVOKE WriteConsoleOutputAttribute,
		consoleHandle,
		ADDR gameIntroColor,
		65,
		xyPos,
		ADDR cells_Written
	.ENDIF
	INVOKE WriteConsoleOutputCharacter,
		consoleHandle,
		ADDR [gameIntro + esi],
		65,
		xyPos,
		ADDR cells_Written
	add esi, 65
	inc xyPos.y
	pop ecx
	dec ecx
	cmp ecx, 0
	jne PrintIntro

	; �P�_�O�O�_���U�ťի�
GameOrNot:
	call ReadKey
	.IF ax == 3920h
		call Clrscr
		mov ebx, 1
		ret
	.ENDIF
	jmp GameOrNot
	ret
printStartScene ENDP

; �L�����e��
printEnd PROC
	mov xyPos.x, 40
	mov xyPos.y, 5
	mov ecx, 6
	mov esi, 0
	.IF bogysNum == 0
printWin:
		push ecx
		INVOKE WriteConsoleOutputAttribute,
			consoleHandle,
			ADDR winColor,
			36,
			xyPos,
			ADDR cells_Written
		INVOKE WriteConsoleOutputCharacter,
			consoleHandle,
			ADDR [winStr + esi],
			36,
			xyPos,
			ADDR cells_Written
		pop ecx
		add esi, 36
		inc xyPos.y
		loop printWin
		mov ax, 10
		mul livesNum
		add scoreNum, ax
	.ENDIF
	.IF livesNum == 0
printLose:
		push ecx
		INVOKE WriteConsoleOutputAttribute,
			consoleHandle,
			ADDR loseColor,
			36,
			xyPos,
			ADDR cells_Written
		INVOKE WriteConsoleOutputCharacter,
			consoleHandle,
			ADDR [loseStr + esi],
			36,
			xyPos,
			ADDR cells_Written
		pop ecx
		add esi, 36
		inc xyPos.y
		loop printLose
	.ENDIF

	mov xyPos.x, 32
	mov xyPos.y, 15
	INVOKE WriteConsoleOutputCharacter,
		consoleHandle,
		ADDR score,
		SIZEOF score,
		xyPos,
		ADDR cells_Written

	add xyPos.x, 7
	INVOKE printNum, scoreNum, numStr, xyPos

	add xyPos.x, 15
	INVOKE WriteConsoleOutputCharacter,
		consoleHandle,
		ADDR lives,
		SIZEOF lives,
		xyPos,
		ADDR cells_Written

	add xyPos.x, 7
	INVOKE printNum, livesNum, numStr, xyPos

	add xyPos.x, 15
	INVOKE WriteConsoleOutputCharacter,
		consoleHandle,
		ADDR bogys,
		SIZEOF bogys,
		xyPos,
		ADDR cells_Written

	add xyPos.x, 7
	INVOKE printNum, bogysNum, numStr, xyPos

	add xyPos.y, 3
	mov xyPos.x, 50
	INVOKE WriteConsoleOutputCharacter,
		consoleHandle,
		ADDR restart,
		SIZEOF restart,
		xyPos,
		ADDR cells_Written

	add xyPos.y, 2
	INVOKE WriteConsoleOutputCharacter,
		consoleHandle,
		ADDR leaveMsg,
		SIZEOF leaveMsg,
		xyPos,
		ADDR cells_Written

	.IF bogysNum == 0
		add xyPos.y, 2
		.IF levelNum < 5
			INVOKE WriteConsoleOutputCharacter,
				consoleHandle,
				ADDR nextLevel,
				SIZEOF nextLevel,
				xyPos,
				ADDR cells_Written
		.ENDIF
		.IF levelNum == 5
			sub xyPos.x, 15
			INVOKE WriteConsoleOutputAttribute,
				consoleHandle,
				ADDR finalColor,
				50,
				xyPos,
				ADDR cells_Written
			INVOKE WriteConsoleOutputCharacter,
				consoleHandle,
				ADDR finalMsg,
				SIZEOF finalMsg,
				xyPos,
				ADDR cells_Written
		.ENDIF
	.ENDIF
	
EndOptions:
	call ReadKey
	; restart
	.IF ax == 1372h
		mov ax, livesNumInLevel
		mov livesNum, ax
		mov ax, scoreNumInLevel
		mov scoreNum, ax
		mov ebx, 1
		call Clrscr
		jmp ExitEndScene
	.ENDIF
	; exit
	.IF ax == 266ch
		mov ebx, 4
		jmp ExitEndScene
	.ENDIF
	; next level
	.IF bogysNum == 0
		.IF ax == 316eh
			mov ebx, 1
			.IF levelNum < 5
				inc levelNum
			.ENDIF
			jmp ExitEndScene
		.ENDIF
	.ENDIF
ExitEndScene:
	ret
printEnd ENDP

; �L�C�����خ�
printGameStage PROC
printGameSceneTop:
	mov xyPos.x, 5
	mov xyPos.y, 4
	INVOKE WriteConsoleOutPutCharacter,
		consoleHandle,
		ADDR gameBgTB,
		110,
		xyPos,
		ADDR cells_Written
	inc xyPos.y
	
	mov ecx, 24
printGameSceneMiddle:
	push ecx
	INVOKE WriteConsoleOutPutCharacter,
		consoleHandle,
		ADDR gameBgM,
		110,
		xyPos,
		ADDR cells_Written
	inc xyPos.y
	pop ecx
	loop printGameSceneMiddle
PrintGameSceneButtom:
	INVOKE WriteConsoleOutPutCharacter,
		consoleHandle,
		ADDR gameBgTB,
		110,
		xyPos,
		ADDR cells_Written
	inc xyPos.y
	ret
printGameStage ENDP

; printBar
printBar PROC
	mov xyPos.x, 5
	mov xyPos.y, 2
	INVOKE WriteConsoleOutputCharacter,
		consoleHandle,
		ADDR level,
		SIZEOF level,
		xyPos,
		ADDR cells_Written
	mov xyPos.x, 12
	INVOKE printNum, levelNum, numStr, xyPos

	mov xyPos.x, 29
	INVOKE WriteConsoleOutputCharacter,
		consoleHandle,
		ADDR state,
		SIZEOF state,
		xyPos,
		ADDR cells_Written

	mov xyPos.x, 36
	INVOKE WriteConsoleOutputCharacter,
		consoleHandle,
		ADDR playing,
		SIZEOF playing,
		xyPos,
		ADDR cells_Written

	mov xyPos.x, 56
	INVOKE WriteConsoleOutputCharacter,
		consoleHandle,
		ADDR score,
		SIZEOF score,
		xyPos,
		ADDR cells_Written
	
	mov xyPos.x, 63
	INVOKE printNum, scoreNum, numStr, xyPos

	mov xyPos.x, 80
	INVOKE WriteConsoleOutputCharacter,
		consoleHandle,
		ADDR lives,
		SIZEOF lives,
		xyPos,
		ADDR cells_Written
	
	mov xyPos.x, 87
	INVOKE printNum, livesNum, numStr, xyPos

	mov xyPos.x, 104
	INVOKE WriteConsoleOutputCharacter,
		consoleHandle,
		ADDR bogys,
		SIZEOF bogys,
		xyPos,
		ADDR cells_Written
	
	mov xyPos.x, 111
	INVOKE printNum, bogysNum, numStr, xyPos
	ret
printBar ENDP

; ���d��l��
initialLevel PROC
	; �����i�J���d���e�� lives & score
	mov ax, scoreNum
	mov scoreNumInLevel, ax
	mov ax, livesNum
	mov livesNumInLevel, ax
	; ��l��Bogy�ƶq
	mov ax, levelNum
	mov dx, 4
	mul dx
	mov bogysNum, ax
	; ��l�ƩZ�J��m
	mov xyPosTank.y, 15
	; ��l�Ƥl�u���A
	mov ecx, 21
	mov esi, 0
SetBulletIsWorkN0:
	mov [bulletIsWork + esi], 0
	add esi, 2
	loop SetBulletIsWorkN0
	; ��l�Ƥl�u��m
	mov ecx, 21
	mov esi, 0
SetBulletPos:
	mov [xyPosBullet + esi].x, 15
	add esi, 4
	loop SetBulletPos
	; ��l��Bogy��m
	mov ecx, 6
	mov esi, 0
	mov edx, 0
SetBogyPosNum:
	.IF levelNum == 1
		mov ax, [xPosBogyLevel1 + esi]
		mov [xyPosBogy + edx].x, ax
	.ENDIF
	.IF levelNum == 2
		mov ax, [xPosBogyLevel2 + esi]
		mov [xyPosBogy + edx].x, ax
	.ENDIF
	.IF levelNum == 3
		mov ax, [xPosBogyLevel3 + esi]
		mov [xyPosBogy + edx].x, ax
	.ENDIF
	.IF levelNum == 4
		mov ax, [xPosBogyLevel4 + esi]
		mov [xyPosBogy + edx].x, ax
	.ENDIF
	.IF levelNum == 5
		mov ax, [xPosBogyLevel5 + esi]
		mov [xyPosBogy + edx].x, ax
	.ENDIF
	add esi, 2
	add edx, 4
	loop SetBogyPosNum
	ret
initialLevel ENDP

; �L��⪺�u
printGreenLine PROC, 
	xyPosInit:COORD

	mov xyPosInit.x, 20
	mov xyPosInit.y, 5
	
	mov ecx, 24
	mov esi, 0
PrintLine:
	push ecx
	INVOKE WriteConsoleOutputAttribute,
		consoleHandle,
		ADDR greenColor,
		1,
		xyPosInit,
		ADDR cells_Written

	INVOKE WriteConsoleOutputCharacter,
		consoleHandle,
		ADDR line,
		1,
		xyPosInit,
		ADDR cells_Written
	inc xyPosInit.y
	pop ecx
	loop PrintLine
	ret
printGreenLine ENDP

; �LBOGY
printBogy PROC,
	xyPosInit:COORD
	mov ecx, 3
	mov esi, 0
BogyPrint:
	push ecx
	.IF xyPosInit.x >15
		.IF xyPosInit.x <= 58
			INVOKE WriteConsoleOutputAttribute,
				consoleHandle,
				ADDR [gameBogyColor + 0],
				5,
				xyPosInit,
				ADDR cells_Written	
		.ENDIF
	.ENDIF
	.IF xyPosInit.x >58
		.IF xyPosInit.x <= 83
			INVOKE WriteConsoleOutputAttribute,
				consoleHandle,
				ADDR [gameBogyColor + 10],
				5,
				xyPosInit,
				ADDR cells_Written	
		.ENDIF
	.ENDIF
	.IF xyPosInit.x > 83
		INVOKE WriteConsoleOutputAttribute,
			consoleHandle,
			ADDR [gameBogyColor + 20],
			5,
			xyPosInit,
			ADDR cells_Written	
	.ENDIF
	INVOKE WriteConsoleOutputCharacter,
		consoleHandle,
		ADDR [gameBogy + esi],
		5,
		xyPosInit,
		ADDR cells_Written
	add esi, 5
	inc xyPosInit.y
	pop ecx
	dec ecx
	cmp ecx, 0
	jne BogyPrint
	ret
printBogy ENDP

; �M��BOGY
bogyClear PROC,
	xyPosInit:COORD
	mov ecx, 3
	mov esi, 0
removeBogy:
	push ecx
	INVOKE WriteConsoleOutputCharacter,
		consoleHandle,
		ADDR [clearBogy + esi],
		5,
		xyPosInit,
		ADDR cells_Written
	add esi, 5
	inc xyPosInit.y
	pop ecx
	loop removeBogy
	ret
bogyClear ENDP

; �L�Z�J
printTank PROC,
	xyPosInit:COORD
	mov ecx, 3
	mov esi, 0
TankPrint:
	push ecx
	INVOKE WriteConsoleOutputAttribute,
		consoleHandle,
		ADDR tankColor,
		8,
		xyPosInit,
		ADDR cells_Written
	INVOKE WriteConsoleOutputCharacter,
		consoleHandle,
		ADDR [gameTank + esi],
		8,
		xyPosInit,
		ADDR cells_Written
	add esi, 8
	inc xyPosInit.y
	pop ecx
	loop TankPrint
	ret
printTank ENDP

; �M�ũZ�J
tankClear PROC,
	xyPosInit:COORD
	mov ecx, 3
	mov esi, 0
removeTank:
	push ecx
	INVOKE WriteConsoleOutputCharacter,
		consoleHandle,
		ADDR [clearTank + esi],
		8,
		xyPosInit,
		ADDR cells_Written
	add esi, 8
	inc xyPosInit.y
	pop ecx
	loop removeTank
	ret
tankClear ENDP

; �L�l�u
printBullet PROC, 
	xyPosInit:COORD

	INVOKE WriteConsoleOutputAttribute,
	consoleHandle,
	ADDR bulletColor,
	6,
	xyPosInit,
	ADDR cells_Written

	INVOKE WriteConsoleOutputCharacter,
	consoleHandle,
	ADDR bullet,
	6,
	xyPosInit,
	ADDR cells_Written
	ret
printBullet ENDP

; �M�Ťl�u
bulletClear PROC,
	xyPosInit:COORD

	INVOKE WriteConsoleOutputCharacter,
	consoleHandle,
	ADDR clearBullet,
	6,
	xyPosInit,
	ADDR cells_Written
	ret
bulletClear ENDP

; �L�Ʀr�X��
printNum PROC USES eax, 
	decNum:WORD,
	decStr:BYTE,
	xyPosInit:COORD

	INVOKE decToStr, decNum, decStr
	INVOKE WriteConsoleOutputCharacter, 
		consoleHandle,
		ADDR decStr,
		SIZEOF decStr,
		xyPosInit,
		ADDR cells_Written
	ret
printNum ENDP

; �N�Q�i��Ʀr��i�H�L�X�Ӫ��r��
decToStr PROC USES ecx edx eax,
	decNum:WORD,
	decStr:BYTE
	
	mov ecx, 4 ; WORD �̰��s4���
	mov dl, 10 ; ����
	mov ax, decNum ; �Q����
change:
	push ecx
	div dl
	add ah, '0'
	dec ecx
	mov [decStr + ecx], ah ; �N��X�Ӫ��Ʀr��^decStr
	movzx ax, al; ���~��
	pop ecx
	loop change
	ret
decToStr ENDP

END main