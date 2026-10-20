; Replace X's assignment with assdumpin ($14)
StartDumpIn:						; called from chk4shot
	lda.w #$0014
	sta.b d0
	jmp.w assreplace
