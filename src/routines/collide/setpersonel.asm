; Put team a2's wanted players on the ice, keeping the ones already there
;
; Takes a2 = team offset (tmsort index) and the wanted lines in PlList (built by SetPlList). Fills newpos and
; newpnum of the team's 6 sort objects; a player already on the ice keeps his object. Saves and restores
; d0-d5 and a0-a4 around the work. Returns X = a3, the last object of the team.
setpersonel:						; put the wanted players of team a2 on the ice
	stx.b xsave						; keep X
	ldx.w #$0000
.save:								; save d0 and the words after it (12 words)
	lda.b d0,x
	pha
	inx
	inx
	cpx.w #$0018
	bne .save
	ldx.b xsave						; restore X
	stx.b xsave
	ldx.w #$0000
.savea:								; save a0 and the words after it (10 words)
	lda.b a0,x
	pha
	inx
	inx
	cpx.w #$0014
	bne .savea
	ldx.b xsave						; restore X
	ldy.b a2						; team of the list
	ldx.w tmsort,y					; first object of the team
	stx.b a3
	lda.w #$0005					; 6 players
	sta.b d4
.l0:								; clear the request of each of the 6 sort objects
	lda.w #$FFFF					; newpos = newpnum = -1 for the object
	sta.w newpos,x
	sta.w newpnum,x
	inx
	inx
	stx.b a3						; next object
	dec.b d4
	bpl .l0
	jsl.l SetPlList					; build the wanted player list
	lda.w #$0005					; 6 slots
	sta.b d4
	lda.w #PlList>>16				; a4 = pointer to PlList
	sta.b a4+2
	lda.w #PlList
	sta.b a4
.3:									; first pass: wanted players already on the ice keep their object
	ldy.b d4						; slot
	lda.b [a4],y					; wanted player number
	and.w #$00FF
	sta.b d5
	beq .4							; none: next slot
	dec.b d5						; zero based
	lda.w #$0005					; search 6 objects
	sta.b d3
	ldy.b a2
	ldx.w tmsort,y
	dex
	dex
.2:									; next object
	inx
	inx
	stx.b a3
	lda.w pnum,x					; player number of the object
	and.w #$00FF
	sta.b tmp0
	lda.b d5
	and.w #$00FF
	cmp.b tmp0						; same player?
	beq .t1							; already on the ice: keep the object
	dec.b d3
	bpl .2
	bra .4

.t1:								; already on the ice: keep the object
	lda.b d4						; slot
	clc
	adc.w #$0006					; position entry offset in PlList
	tay
	lda.b [a4],y					; wanted position
	and.w #$00FF
	bit.w #$0080
	beq .1
	ora.w #$FF00					; sign extend
.1:									; set the new position
	sta.w newpos,x					; new position
	lda.b d5
	and.w #$00FF
	bit.w #$0080
	beq .2x
	ora.w #$FF00
.2x:								; set the new player number
	sta.w newpnum,x					; new player number
	ldy.b d4
	sep #$20						; 8-bit A
	lda.b #$00
	sta.b [a4],y					; clear the list entry
	rep #$20						; 16-bit A
.4:									; next PlList slot
	dec.b d4
	bpl .3
	lda.w #$0005
	sta.b d4
	lda.w #PlList>>16
	sta.b a4+2
	lda.w #PlList
	sta.b a4
.5:									; second pass: the rest go to objects with no requested player
	ldy.b d4
	lda.b [a4],y					; wanted player number
	and.w #$00FF
	sta.b d5
	beq .8
	dec.b d5
	lda.w #$0005					; search 6 objects
	sta.b d3
	ldy.b a2
	ldx.w tmsort,y
	dex
	dex
.6:									; next object
	inx
	inx
	stx.b a3
	lda.w newpnum,x					; free object (no requested player)?
	bit.w #$0080
	bne .t1x						; free: remember it
	dec.b d3
	bpl .6
	bra .7

.t1x:								; free object: remember it
	stx.b a0						; keep it
.7:									; does this object have a position yet?
	lda.w position,x				; position
	bpl .1x
	dec.b d3
	bpl .6
.1x:								; put the wanted player in the free object
	lda.b d4
	clc
	adc.w #$0006
	tay
	lda.b [a4],y
	and.w #$00FF
	bit.w #$0080
	beq .2xx
	ora.w #$FF00
.2xx:
	ldy.b a0
	sta.w newpos,y					; new position
	lda.b d5
	and.w #$00FF
	bit.w #$0080
	beq .3x
	ora.w #$FF00
.3x:								; set the new player number
	sta.w newpnum,y					; new player number
	ldy.b d4
	sep #$20
	lda.b #$00
	sta.b [a4],y
	rep #$20
.8:									; next PlList slot
	dec.b d4
	bpl .5
	stx.b xsave						; keep X
	ldx.w #$0012
.loop:								; pull a0 and the words after it back
	pla
	sta.b a0,x
	dex
	dex
	bpl .loop
	ldx.b xsave						; restore X
	stx.b xsave
	ldx.w #$0016
.loop2:								; pull d0 and the words after it back
	pla
	sta.b d0,x
	dex
	dex
	bpl .loop2
	ldx.b xsave						; restore X
	ldx.b a3						; last object of the team
	rtl
