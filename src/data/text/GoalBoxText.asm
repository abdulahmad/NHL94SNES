GoalBoxText:						; a word (2 + the bytes), then the bytes: position codes and text
	dw $000D : db CC_Font1Pri,$0F,$03,"GOAL!",CC_Font1Pri,$0C,$05
	dw $0012 : db CC_Font1Pri,$0C,$03,"HAT TRICK!",CC_Font1Pri,$0C,$05
