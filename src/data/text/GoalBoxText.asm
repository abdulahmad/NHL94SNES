GoalBoxText:						; a word (2 + the bytes), then the bytes: position codes and text
	dw $000D : db $BF,$0F,$03,"GOAL!",$BF,$0C,$05
	dw $0012 : db $BF,$0C,$03,"HAT TRICK!",$BF,$0C,$05
