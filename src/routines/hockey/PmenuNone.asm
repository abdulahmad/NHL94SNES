; Append "None" (GoalieOptionText) to the pause item text
PmenuNone:							; called from SetupPauseScreen
	lda.w #GoalieOptionText>>16
	sta.b a4+2
	lda.w #GoalieOptionText+33
	sta.b a4
	ldy.w #$0001
	jsl.l PmenuAppend
	rtl
