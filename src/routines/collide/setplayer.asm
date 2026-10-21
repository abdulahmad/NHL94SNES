; Bring roster player d3 onto the ice as object X and set his stats
;
; Takes d3 = roster number of the player, X = the sort object (pflags index) to fill. Clears his injured flag,
; takes him out of the penalty box or bench if he came from there, marks him on the ice and copies the 12
; ratings of his roster record into the object, adjusted by the power play, penalty kill, home/visitor, third
; period and hot/cold bonuses. Keeps X and Y.
;
; Called from assbench, releasepl and forcepldata.
setplayer:							; put roster player d3 on the ice as object X
	phx								; keep X and Y
	phy
	lda.w pflags,x
	and.w #(~pf2inj&$FFFF)			; clear pf2inj (injured)
	sta.w pflags,x
	stz.b a0						; a0 = team offset (0 home, 2 visitors)
	lda.w pfteam,x
	beq .0							; home: keep 0
	inc.b a0
	inc.b a0
.0:									; store the player number
	lda.b d3
	and.w #$00FF
	sta.w pnum,x					; pnum = roster number
	asl a
	sta.b d3						; d3 = number times 2 (word index)
	lda.w #$000B					; d0 = assignment 11 (leaves the penalty box)
	sta.b d0
	lda.b a0
	beq .idx						; home: no team offset
	lda.w #$0034					; visitors: offset $34
.idx:								; index into tmpdst
	adc.b d3
	tay
	lda.w tmpdst,y
	sta.b d1						; d1 = his state before (box time, bench, out)
	tya								; r3 = Y times 6, the offset of his 12 hot/cold bytes
	sta.b r3
	asl a
	adc.b r3
	asl a
	sta.b r3
	lda.b d1
	bpl .da							; box time: insert the assignment
	lda.w #$000A					; negative state: d0 = assignment 10 (leaves the bench)
	sta.b d0
	lda.b d1
	cmp.w #TMPDBENCH
	bne .nda						; not on the bench (out): skip
.da:								; insert the assignment d0 for him
	jsl.l assinsert
	stz.w pfalock,x					; clear his lock and SPA
	stz.w SPA,x
.nda:								; mark him on the ice
	lda.b a0
	beq .nda1
	lda.w #$0034
.nda1:								; add the player number
	clc
	adc.b d3
	tay
	lda.w #TMPDICE					; tmpdst = TMPDICE
	sta.w tmpdst,y
	lsr.b d3						; d3 = roster index
	ldy.b a0
	lda.w tmdata,y					; a0 = long pointer to his team data
	sta.b a0
	lda.w #TeamList>>16
	sta.b a0+2
	lda.b a0						; save the pointer for the second use
	pha
	lda.b a0+2
	pha
	ldy.w #$0008					; a0 = start of the bonus bytes
	lda.b [a0],y
	clc
	adc.b a0
	sta.b a0
	stz.w PPBonus					; all four bonuses = 0
	stz.w PKBonus
	stz.w ThirdPBonus
	stz.w HmAwBonus
	lda.w position,x
	bne .t1
	jmp.w .6						; goalie: no bonuses

.t1:								; power play / penalty kill bonus
	lda.w sflags
	bit.w #$2000
	beq .5							; sf2pwrplay not set: skip
	jsl.l chkpk2					; which side is short handed?
	beq .t2							; Z: this team is short handed
	ldy.w #$0001					; power play: PPBonus = low nibble of byte 1
	lda.b [a0],y
	and.w #$000F
	sta.w PPBonus
	bra .5

.t2:								; short handed: PKBonus = minus the high nibble of byte 1
	ldy.w #$0001
	lda.b [a0],y
	lsr a
	lsr a
	lsr a
	lsr a
	and.w #$000F
	eor.w #$FFFF
	inc a
	sta.w PKBonus
.5:									; home / visitor bonus from byte 2
	ldy.w #$0002					; visitors: HmAwBonus = minus the low nibble of byte 2
	lda.b [a0],y
	and.w #$000F
	eor.w #$FFFF
	inc a
	sta.b d0
	lda.w pfteam,x
	bne .1							; visitors keep it
	lda.b [a0],y					; home: high nibble of byte 2
	lsr a
	lsr a
	lsr a
	lsr a
	and.w #$000F
	sta.b d0
.1:									; store HmAwBonus
	lda.b d0
	sta.w HmAwBonus
	lda.w gsp						; period number minus 2
	sec
	sbc.w #$0002
	bmi .6							; before the 3rd period: no third period bonus
	bne .2							; overtime: check the score
	jsl.l GetPeriodTime				; 3rd period: compare the clock with half the period time
	lsr.b d0
	lda.b d0
	sec
	sbc.w gameclock
	beq .2
	bpl .6							; first half of the period (probably): no bonus
.2:									; score check
	lda.w tmscore					; home goals minus visitor goals
org $9FD000
	sec
	sbc.w tmscore+2
	sta.b tmp0
	beq .4							; tied: bonus
	lda.w pfteam,x
	beq .3
	lda.w #$0000					; visitors: negate the difference
	sec
	sbc.b tmp0
	sta.b tmp0
.3:									; a trailing team gets the bonus
	lda.b tmp0
	bpl .6							; leading: no bonus
.4:									; tied or trailing late: ThirdPBonus = 2
	lda.w #$0002
	sta.w ThirdPBonus
.6:									; restore the team data pointer
	pla
	sta.b a0+2
	pla
	sta.b a0
	ldy.w #$0000					; a0 = start of the roster records
	lda.b [a0],y
	clc
	adc.b a0
	sta.b a0
.loop:								; skip the roster records before player d3
	lda.b [a0]						; record length plus 8 bytes of header
	clc
	adc.b a0
	adc.w #$0008
	sta.b a0
	dec.b d3						; d3 more records
	bpl .loop
	lda.b a0						; back to the record of the player
	sec
	sbc.w #$0008
	sta.b a0
	lda.b [a0]						; byte 0: rostnum
	and.w #$00FF
	sta.w rostnum,x
	ldy.w #$0001					; byte 1: weight = high nibble times 8, legstr = low 3 bits
	lda.b [a0],y
	and.w #$00F0
	lsr a
	sta.w weight,x
	lda.b [a0],y					; ratings are 3 bit values scaled by 5/2
	and.w #$0007
	sta.b r0
	asl a
	asl a
	adc.b r0
	lsr a
	ldy.w #$0000
	jsl.l .8						; add the hot/cold adjustment, clamp 0-15 (stat 0)
	sta.w legstr,x
	ldy.w #$0002					; byte 2: legspd = high 3 bits, aioff = low 3 bits
	lda.b [a0],y
	lsr a
	lsr a
	lsr a
	lsr a
	and.w #$0007
	sta.b r0
	asl a
	asl a
	adc.b r0
	lsr a
	ldy.w #$0001					; stat 1 (legspd)
	jsl.l .8
	sta.w legspd,x
	ldy.w #$0002					; aioff = low 3 bits plus all four bonuses
	lda.b [a0],y
	and.w #$0007
	sta.b r0
	asl a
	asl a
	adc.b r0
	lsr a
	clc
	adc.w PPBonus
	clc
	adc.w PKBonus
	clc
	adc.w HmAwBonus
	clc
	adc.w ThirdPBonus
	ldy.w #$0002					; stat 2 (aioff)
	jsl.l .8
	eor.w #$000F					; aioff = (15-n+15)/2
	clc
	adc.w #$000F
	lsr a
	sta.w aioff,x
	ldy.w #$0003					; byte 3: aidef = high 3 bits plus HmAwBonus
	lda.b [a0],y
	lsr a
	lsr a
	lsr a
	lsr a
	and.w #$0007
	sta.b r0
	asl a
	asl a
	adc.b r0
	lsr a
	clc
	adc.w HmAwBonus
	ldy.w #$0003					; stat 3 (aidef)
	jsl.l .8
	pha
	lda.w position,x				; goalie?
	beq .t1x						; goalie: other formula
	pla
	eor.w #$000F					; skater: aidef = 15-n+7
	clc
	adc.w #$0007
	sta.w aidef,x
	bra .7							; done

.t1x:								; goalie: aidef = (15-n+15)/2
	pla
	eor.w #$000F
	clc
	adc.w #$000F
	lsr a
	sta.w aidef,x
.7:									; shotspd = low 3 bits of byte 3 (stat 4)
	ldy.w #$0003
	lda.b [a0],y
	and.w #$0007
	sta.b r0
	asl a
	asl a
	adc.b r0
	lsr a
	ldy.w #$0004
	jsl.l .8
	sta.w shotspd,x
	ldy.w #$0004					; byte 4: checking = high 3 bits plus ThirdPBonus (stat 5)
	lda.b [a0],y
	lsr a
	lsr a
	lsr a
	lsr a
	and.w #$0007
	sta.b r0
	asl a
	asl a
	adc.b r0
	lsr a
	clc
	adc.w ThirdPBonus
	ldy.w #$0005
	jsl.l .8
	sta.w checking,x
	lda.w attribute,x
	and.w #$F7FF					; clear attrxflip
	sta.w attribute,x
	ldy.w #$0004
	lda.b [a0],y
	and.w #$0001					; handed = inverted bit 0 of byte 4
	eor.w #$0001
	sta.w handed,x
	bne .1x							; right handed: done
	lda.w attribute,x				; left handed: set attrxflip
	ora.w #$0800
	sta.w attribute,x
.1x:								; fighting = bits 1-3 of byte 4
	lda.b [a0],y
	and.w #$000E
	sta.w fighting,x
	ldy.w #$0005					; byte 5: stickhand = high 3 bits plus PP, PK and HmAw bonuses (stat 6)
	lda.b [a0],y
	lsr a
	lsr a
	lsr a
	lsr a
	and.w #$0007
	sta.b r0
	asl a
	asl a
	adc.b r0
	lsr a
	clc
	adc.w PPBonus
	clc
	adc.w PKBonus
	clc
	adc.w HmAwBonus
	ldy.w #$0006
	jsl.l .8
	sta.w stickhand,x
	ldy.w #$0005					; shotacc = low 3 bits plus the same bonuses (stat 7)
	lda.b [a0],y
	and.w #$0007
	sta.b r0
	asl a
	asl a
	adc.b r0
	lsr a
	clc
	adc.w PPBonus
	clc
	adc.w PKBonus
	clc
	adc.w HmAwBonus
	ldy.w #$0007
	jsl.l .8
	sta.w shotacc,x
	ldy.w #$0006					; byte 6: endurance = high 3 bits (stat 8)
	lda.b [a0],y
	lsr a
	lsr a
	lsr a
	lsr a
	and.w #$0007
	sta.b r0
	asl a
	asl a
	adc.b r0
	lsr a
	ldy.w #$0008
	jsl.l .8
	sta.w endurance,x
	ldy.w #$0006					; spodds = low 3 bits plus twice ThirdPBonus (stat 9)
	lda.b [a0],y
	and.w #$0007
	sta.b r0
	asl a
	asl a
	adc.b r0
	lsr a
	clc
	adc.w ThirdPBonus
	clc
	adc.w ThirdPBonus
	ldy.w #$0009
	jsl.l .8
	sta.w spodds,x
	ldy.w #$0007					; byte 7: passacc = high 3 bits plus PPBonus and HmAwBonus (stat 10)
	lda.b [a0],y
	lsr a
	lsr a
	lsr a
	lsr a
	and.w #$0007
	sta.b r0
	asl a
	asl a
	adc.b r0
	lsr a
	clc
	adc.w PPBonus
	clc
	adc.w HmAwBonus
	ldy.w #$000A
	jsl.l .8
	sta.w passacc,x
	ldy.w #$0007					; GGSleft = low 3 bits (stat 11)
	lda.b [a0],y
	and.w #$0007
	sta.b r0
	asl a
	asl a
	adc.b r0
	lsr a
	ldy.w #$000B
	jsl.l .8
	sta.w GGSleft,x
	ply								; restore Y and X
	plx
	rtl
.8:									; local subroutine (jsl): A = scaled rating, Y = stat index; returns 0-15
	sta.b r3+2						; keep the rating
	tya								; index = player offset times 6 plus the stat index
	clc
	adc.b r3
	tay
	sep #$20						; 8-bit A
	lda.w HotColdTable,y			; hot/cold byte of this player and stat
	lsr a							; divided by 4
	lsr a
	bit.b #$00
	beq .1xx
	ora.b #$00
.1xx:								; add the adjustment to the rating
	clc
	adc.b r3+2
	bpl .2x							; not negative: keep
	lda.b #$00						; negative: 0
.2x:								; upper clamp
	cmp.b #$0F						; cap at 15
	bcc .3x
	lda.b #$0F
.3x:								; back to 16-bit A
	rep #$20						; 16-bit A
	and.w #$00FF
	rtl
