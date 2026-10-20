; Switch the sound driver to the menu sample set (MenuSampleList, sound table MenuSfxTable) and mark sndbank
; SoundBankMenu, unless it is loaded. Stops the song, and clears streamloaded either way
SPCMenuUpload:						; upload the Menu sample set
	stz.w cursong					;no team song plays
	lda.w sndbank					;the sample set loaded in the SPC
	cmp.w #SoundBankMenu
	beq .1							;already loaded
	jsl.l forceblack				;black screen: the SPC is silent and busy during the upload
	lda.w #SoundBankMenu
	sta.w sndbank					;the menu set is loaded
	sep #$20						;8-bit A
	dec.w SoundLock					;sound update off
	rep #$20						;16-bit A
	jsl.l SPCCmd01					;driver command 1: empty the sample area
	sep #$20
	inc.w SoundLock					;sound update on
	rep #$20
	lda.w #MenuSfxTable>>16
	sta.b SoundTable+2
	lda.w #MenuSfxTable
	sta.b SoundTable
	jsl.l SoundInit					;reset the player on that table
	ldx.w #$0000					;sample list offset
.loop:								; send each sample of the list
	lda.l MenuSampleList,x
	sta.b p0						;long pointer to the sample
	lda.l MenuSampleList+2,x
	sta.b p0+2
	phx								;keep the offset
	jsl.l SPCUploadBlock			;send the sample
	plx
	inx								;next entry (4 bytes)
	inx
	inx
	inx
	cpx.w #$0040					;16 entries of the list
	bne .loop
.1:									; clear the streamed sample flag
	lda.w #$0000
	sta.l streamloaded				;no streamed sample is in its slot
	rtl
