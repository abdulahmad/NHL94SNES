; Assignment: the player leaves the penalty box and comes onto the ice
assepen:
	lda.w pflags,x
	bit.w #$0002
	bne .t1
	jmp.w .t2

.t1:
	and.w #$FFFD
	sta.w pflags,x
	ldy.w #$0010
	lda.w pfteam,x
	beq .1
	ldy.w #$0001
.1:
	sty.b d0
	lda.w PBnum
	sec
	sbc.b d0
	sta.w PBnum
	stz.w Xvel,x
	stz.w Yvel,x
	lda.w #$003C
	sta.b d0
	lda.w pfteam,x
	bne .2
	lda.w #$FFC4
	sta.b d0
.2:
	lda.b d0
	sta.w Ypos,x
	lda.w #sideline
	sta.w Xpos,x
	lda.w #$0002
	sta.w facedir,x
	sta.w pfalock,x
	lda.w #SPAwallleft
	jsl.l SetSPAFromA
	jml.l SprSort

.t2:
	lda.w #$0004
	sta.w facedir,x
	lda.w #$FFFF
	sta.w newpnum,x
	sta.w newpos,x
	lda.w pflags,x
	and.w #$6FF7
	sta.w pflags,x
	stz.w pfnc,x
	lda.w #$F000
	sta.w Xvel,x
	ldx.b a2
	lda.w teampads,x
	cmp.w #$0004
	bcc .2x
	ldy.w padsitnext,x
.loop:
	iny
	iny
	cpy.w #$000A
	bne .1x
	ldy.w #$0000
.1x:
	lda.w padside,y
	bpl .loop
	and.w #$00FF
	cmp.b a2
	bne .loop
	sta.w padside,y
	inc a
	inc a
	lsr a
	sta.w cont1team,y
	ldx.b curobj
	tya
	sta.w playerpad,x
	txa
	sta.w c1playernum,y
.2x:
	ldx.b curobj
	jml.l assexit
