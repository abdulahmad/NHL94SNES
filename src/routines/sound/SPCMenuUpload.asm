; Upload the menu sample set (MenuSampleList, sound table MenuSfxTable) and mark $1D68 = 2, unless it is
; loaded
SPCMenuUpload:
	stz.w cursong
	lda.w sndbank
	cmp.w #$0002
	beq .1
	jsl.l forceblack
	lda.w #$0002
	sta.w sndbank
	sep #$20
	dec.w SoundLock
	rep #$20
	jsl.l SPCCmd01
	sep #$20
	inc.w SoundLock
	rep #$20
	lda.w #MenuSfxTable>>16
	sta.b SoundTable+2
	lda.w #MenuSfxTable
	sta.b SoundTable
	jsl.l SoundInit
	ldx.w #$0000
.loop:
	lda.l MenuSampleList,x
	sta.b p0
	lda.l MenuSampleList+2,x
	sta.b p0+2
	phx
	jsl.l SPCUploadBlock
	plx
	inx
	inx
	inx
	inx
	cpx.w #$0040
	bne .loop
.1:
	lda.w #$0000
	sta.l streamloaded
	rtl
