; Pause menu confirm: B, Start, or A leaves
PauseResume:						; called from PauseMenuHandlers
	lda.b d1
	bit.w #$9080
	bne PauseResumeRtl
	jmp.w PauseMenuPoll

PauseResumeRtl:						; called from PauseMenuPoll, PauseResume
	lda.w #$0000
	rtl
