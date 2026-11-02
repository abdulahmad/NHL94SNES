; byte pair data at Y (after its header) to WRAM
DecompressPairs:					; byte pair data at Y (after its header) to WRAM
	iny
	iny
	lda.w #$0000
	ldx.w #$0040
.loop:								; loop: X - 1, X - 1, DecompBuf,x = A, ...
	dex
	dex
	sta.w DecompBuf,x
	sta.w DecompBuf+$40,x
	sta.w DecompBuf+$80,x
	sta.w DecompBuf+$C0,x
	bne .loop
	sep #$20
	iny
	lda.w $0000,y
	tax
	inc.w DecompBuf,x
	iny
	lda.w $0000,y
	sta.b r0
	beq .7
.loop2:								; loop: Y + 1, Y + 1, DecompTab1,x = $0000,y, ...
	iny
	lda.w $0000,y
	tax
	iny
	lda.w $0000,y
	sta.w DecompTab1,x
	iny
	lda.w $0000,y
	sta.w DecompTab2,x
	dec.w DecompBuf,x
	dec.b r0
	bne .loop2
	bra .7
.2:									; DecompBuf,x negative: if DecompBuf,x = 0 go to .1, ...
	phx
	lda.w DecompTab1,x
	tax
	lda.w DecompBuf,x
	beq .1
	jsr.w .12
.1:									; WMDATA = X, if DecompBuf,x = 0 go to .10, ...
	txa
	sta.w WMDATA
	plx
	lda.w DecompTab2,x
	tax
	lda.w DecompBuf,x
	beq .10
	jsr.w .12
	bra .10
.3:									; $0000,y = 0: return
	rts
.4:									; loop: DecompBuf,x != 0: if minus go to .8
	bmi .8
.5:									; loop: Y + 1, if $0000,y = 0 go to .3, ...
	iny
	lda.w $0000,y
	beq .3
	sta.w WMDATA
	iny
	lda.w $0000,y
	tax
	lda.w DecompBuf,x
	bne .4
.6:									; loop: WMDATA = X
	txa
	sta.w WMDATA
.7:									; Y + 1, if DecompBuf,x = 0 go to .6, ...
	iny
	lda.w $0000,y
	tax
	lda.w DecompBuf,x
	beq .6
	bpl .5
.8:									; if DecompBuf,x negative go to .11
	phx
	lda.w DecompTab1,x
	tax
	lda.w DecompBuf,x
	bmi .11
.9:									; WMDATA = X, if DecompBuf,x = 0 go to .6, ...
	txa
	sta.w WMDATA
	plx
	lda.w DecompTab2,x
	tax
	lda.w DecompBuf,x
	beq .6
	phx
	lda.w DecompTab1,x
	tax
	lda.w DecompBuf,x
	bmi .2
.10:								; WMDATA = X, if DecompBuf,x = 0 go to .6, ...
	txa
	sta.w WMDATA
	plx
	lda.w DecompTab2,x
	tax
	lda.w DecompBuf,x
	beq .6
	phx
	lda.w DecompTab1,x
	tax
	lda.w DecompBuf,x
	beq .1x
	jsr.w .12
.1x:								; WMDATA = X, if DecompBuf,x = 0 go to .6, ...
	txa
	sta.w WMDATA
	plx
	lda.w DecompTab2,x
	tax
	lda.w DecompBuf,x
	beq .6
	jsr.w .12
	bra .6
.11:								; DecompBuf,x negative: if DecompBuf,x negative go to .3x
	phx
	lda.w DecompTab1,x
	tax
	lda.w DecompBuf,x
	bmi .3x
.2x:								; WMDATA = X, if DecompBuf,x = 0 go to .9, ...
	txa
	sta.w WMDATA
	plx
	lda.w DecompTab2,x
	tax
	lda.w DecompBuf,x
	beq .9
	phx
	lda.w DecompTab1,x
	tax
	lda.w DecompBuf,x
	beq .1xx
	jsr.w .12
.1xx:								; WMDATA = X, if DecompBuf,x = 0 go to .9, ...
	txa
	sta.w WMDATA
	plx
	lda.w DecompTab2,x
	tax
	lda.w DecompBuf,x
	beq .9
	jsr.w .12
	bra .9
.3x:								; DecompBuf,x negative: if DecompBuf,x = 0 go to .1xxx, ...
	phx
	lda.w DecompTab1,x
	tax
	lda.w DecompBuf,x
	beq .1xxx
	jsr.w .12
.1xxx:								; WMDATA = X, if DecompBuf,x = 0 go to .2x, ...
	txa
	sta.w WMDATA
	plx
	lda.w DecompTab2,x
	tax
	lda.w DecompBuf,x
	beq .2x
	jsr.w .12
	bra .2x
.12:								; subroutine: if DecompBuf,x = 0 go to .1xxxx, ...
	phx
	lda.w DecompTab1,x
	tax
	lda.w DecompBuf,x
	beq .1xxxx
	jsr.w .12
.1xxxx:								; WMDATA = X, if DecompBuf,x != 0 go to .12, ...
	txa
	sta.w WMDATA
	plx
	lda.w DecompTab2,x
	tax
	lda.w DecompBuf,x
	bne .12
	rts
