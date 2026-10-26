; Reset in FastROM: clear the PPU and CPU registers, then start the game
Reset_Fast:							; called from Reset
	phk								; data bank = program bank
	plb
	sep #$20
	lda.b #$01
	sta.w MEMSEL
	stz.w NMITIMEN
	lda.b #$8F
	sta.w INIDISP
	stz.w OBSEL
	stz.w OAMADDL
	stz.w OAMADDH
	stz.w OAMDATA
	stz.w OAMDATA
	ldx.w #BGMODE
.loop:								; loop: r0,x = 0, X + 1, if not zero go to .loop
	stz.b r0,x
	inx
	cpx.w #BG1HOFS
	bne .loop
.loop2:								; loop: r0,x = 0, r0,x = 0, X + 1, ...
	stz.b r0,x
	stz.b r0,x
	inx
	cpx.w #VMAIN
	bne .loop2
	lda.b #$80
	sta.w VMAIN
	inx
.loop3:								; loop: r0,x = 0, X + 1, if not zero go to .loop3, ...
	stz.b r0,x
	inx
	cpx.w #M7A
	bne .loop3
	ldy.w #$0000
.loop4:								; loop: r0,x = 0, r0,x = Mode7Identity,y, Y + 1, ...
	stz.b r0,x
	lda.w Mode7Identity,y
	sta.b r0,x
	iny
	inx
	cpx.w #CGADD
	bne .loop4
.loop5:								; loop: r0,x = 0, X + 1, if not zero go to .loop5, ...
	stz.b r0,x
	inx
	cpx.w #CGWSEL
	bne .loop5
	lda.b #$30
	sta.w CGWSEL
	stz.w CGADSUB
	lda.b #$E0
	sta.w COLDATA
	stz.w SETINI
	rep #$20
	lda.w #$008F
	sta.w IniDispShadow
	lda.w #$0000
	tax
	tay
	jsl.l FillVRAM					; fill VRAM with a word
	sep #$20
	stz.w NMITIMEN
	lda.b #$FF
	sta.w WRIO
	ldx.w #WRMPYA
.loop6:								; loop: r0,x = 0, X + 1, if not zero go to .loop6, ...
	stz.b r0,x
	inx
	cpx.w #HDMAEN
	bne .loop6
	rep #$20
	lda.w #SoundDriver
	sta.b p0
	stz.b p0+2
	jsl.l SPCUpload				; send the stream at [p0] through the boot loader: blocks of length
	sep #$20
	rep #$20
	lda.w #$0000
	tax
.loop7:								; loop: Ram7E,x = A, Ram7F,x = A, X - 1, ...
	sta.l Ram7E,x
	sta.l Ram7F,x
	dex
	dex
	bne .loop7
	sep #$20
	ldx.w #$0005
.loop8:								; loop: RAMTag,x = InitTag,x, RAMTag2,x = InitTag,x, ReplayBufferEnd,x...
	lda.w InitTag,x
	sta.w RAMTag,x
	sta.w RAMTag2,x
	sta.l ReplayBufferEnd,x
	dex
	bpl .loop8
	ldx.w #$0010
	beq .1
.loop9:								; loop: OAMHiMasks-1,x = OAMHighMasks-1,x, X - 1, if X not yet 0 go to...
	lda.l OAMHighMasks-1,x
	sta.l OAMHiMasks-1,x
	dex
	bne .loop9
.1:									; call ResetStub, IniDispShadow = $8F
	jsl.l ResetStub					; does nothing
	sep #$20
	rep #$10
	lda.b #$8F
	sta.w IniDispShadow
	ldx.w #$000C
.loop10:							; loop: FrameHook,x = InitHooks,x, X - 1, if X still >= 0 go to .loop10...
	lda.w InitHooks,x
	sta.w FrameHook,x
	dex
	bpl .loop10
	ldx.w #$0024
.loop11:							; loop: FrameCount,x = 0, X - 1, if X still >= 0 go to .loop11, ...
	stz.w FrameCount,x
	dex
	bpl .loop11
	rep #$20
	lda.w #$0000
	tax
	tay
	jsl.l InitSprites
	sep #$20
	lda.b #$81
	sta.w NMITIMEN
	rep #$30
	jsl.l SoundInit					; reset the sound player
	stz.w brightness
	jsl.l forceblack				; turn the screen black: default interrupt handlers, forced blank
	jml.l Opening					; the cold start after Reset_Fast: password and default options
