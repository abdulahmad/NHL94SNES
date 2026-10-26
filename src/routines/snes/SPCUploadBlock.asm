; send the sample at [p0] with SPCSendSample: loop point and length (big-endian words), then the BRR blocks
SPCUploadBlock:						; called from SPCGameUpload, SPCIntroUpload, SPCMenuUpload, SPCTitleToM...
	sep #$20
	dec.w SoundLock
	rep #$20
	ldy.w #$0000
	lda.b [p0],y
	xba
	sta.b r3
	ldy.w #$0002
	lda.b [p0],y
	xba
	tax
	ldy.b r3
	lda.b p0
	clc
	adc.w #$0004
	sta.b p0
	jsl.l SPCSendSample			; send one sample to the sound CPU
	sep #$20
	inc.w SoundLock
	rep #$20
	rtl
