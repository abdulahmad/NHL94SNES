; sound driver command $01 (empty the sample area and key off every voice)
SPCReset:							; called from SPCGameUpload, SPCIntroUpload, SPCMenuUpload, SPCTitleUpload
	sep #$20
.wait:								; loop: if APUIO0 != 0 go to .wait, ...
	lda.w APUIO0
	bne .wait
	lda.b #$01
	sta.w APUIO0
.ack:								; loop: if not zero go to .ack, ...
	cmp.w APUIO0
	bne .ack
	stz.w APUIO0
	rep #$20
	rtl
