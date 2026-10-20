; Switch the sound driver to the in-game sample set (GameSampleList, sound table GameSfxTable): the game sound
; effects the sound queue plays. Nothing happens when SoundBankGame is already loaded. Called from setupice,
; SaveRegsStartHL2, ReplayMode and PeriodOver.
SPCGameUpload:						; upload the Game sample set
	lda.w sndbank					;the sample set loaded in the SPC
	cmp.w #SoundBankGame
	beq .rtl						;already loaded
	jsl.l forceblack				;black screen: the SPC is silent and busy during the upload
	lda.w #SoundBankGame
	sta.w sndbank					;the in-game set is loaded
	sep #$20						;8-bit A
	dec.w SoundLock					;sound update off
	rep #$20						;16-bit A
	jsl.l SPCCmd01					;driver command 1: empty the sample area
	sep #$20
	inc.w SoundLock					;sound update on
	rep #$20
	lda.w #GameSfxTable>>16			;SoundTable = the game sound effect table
	sta.b SoundTable+2
	lda.w #GameSfxTable
	sta.b SoundTable
	jsl.l SoundInit					;reset the player on that table
	ldx.w #$0000					;sample list offset
.loop:								; send each sample of the list
	lda.l GameSampleList,x
	sta.b p0						;long pointer to the sample
	lda.l GameSampleList+2,x
	sta.b p0+2
	phx								;keep the offset
	jsl.l SPCUploadBlock			;send the sample
	plx
	inx								;next entry (4 bytes)
	inx
	inx
	inx
	cpx.w #$0050					;20 entries of the list
	bne .loop
.rtl:								; done
	rtl
