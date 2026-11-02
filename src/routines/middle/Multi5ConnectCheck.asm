; read 16 signature bits from each port; mp5connect bit 7 (port 1) or 6 (port 2) = multitap
Multi5ConnectCheck:					; called from Multi5Bios, Multi5Init
	php
	sep #$30
	stz.w mp5connect
.loop:								; loop: if HVBJOY & $01 != 0 go to .loop, ...
	lda.w HVBJOY
	and.b #$01
	bne .loop
	stz.w JOYSER0
	lda.b #$01
	sta.w JOYSER0
	ldx.b #$08
.loop2:								; loop: rol Multi5Sig+1, rol Multi5Sig+3, X - 1, ...
	lda.w JOYSER0
	lsr a
	lsr a
	rol.w Multi5Sig+1
	lda.w JOYSER1
	lsr a
	lsr a
	rol.w Multi5Sig+3
	dex
	bne .loop2
	stz.w JOYSER0
	ldx.b #$08
.loop3:								; loop: rol Multi5Sig, rol Multi5Sig+2, X - 1, ...
	lda.w JOYSER0
	lsr a
	lsr a
	rol.w Multi5Sig
	lda.w JOYSER1
	lsr a
	lsr a
	rol.w Multi5Sig+2
	dex
	bne .loop3
	lda.w Multi5Sig+1
	cmp.b #$FF
	bne .1
	lda.w Multi5Sig
	cmp.b #$FF
	beq .1
	lda.b #$80
	sta.w mp5connect
.1:									; if Multi5Sig+3 != $FF go to .2, ...
	lda.w Multi5Sig+3
	cmp.b #$FF
	bne .2
	lda.w Multi5Sig+2
	cmp.b #$FF
	beq .2
	lda.b #$40
	tsb.w mp5connect
.2:									; return
	plp
	rtl
	db "MODIFIED FROM SHVC MULTI5 CONNECT CHECK VER1.00"
	db "END OF MULTI5 CONNECT CHECK"
