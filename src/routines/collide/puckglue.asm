; Player a2 takes the puck
puckglue:							; called from puckgoalie, puckstick
	ldy.b a2
	cpy.w puckc
	beq .1
	lda.w #$0003
	jsl.l PuckSfx					; play sound A with half the puck velocity
	jsl.l EndPenaltyShot			; end the penalty shot or shootout attempt in progress: clear it
	stz.w breakaway
	stz.w onetimer
.1:									; puckc = a2, d0 = a2, a0 = 0, ...
	ldy.b a2
	sty.w puckc
	sty.b d0
	stz.b a0						; a0 = 0
	lda.w #$0002					; a1 = 2
	sta.b a1
	lda.w pfteam,y					; team
	bne .2							; team 1
	stz.b a1						; a1 = 0
	lda.w #$0002
	sta.b a0						; a0 = 2
.2:									; tmtouch2,y = $FFFF, tmtouch3,y = $FFFF, tmflags,y = tmflags,y | $0004...
	ldy.b a0						; other team
	lda.w #$FFFF					; no touches
	sta.w tmtouch2,y				; other team loses its touches
	sta.w tmtouch3,y				; touches
	lda.w tmflags,y					; flags
	ora.w #$0004
	sta.w tmflags,y
	lda.w #$0010
	trb.w sflags3					; sf3fo: this pickup wins the faceoff
	beq .3							; no faceoff win
	ldy.b a1						; faceoff team
	lda.w tmfowon,y					; faceoff wins
	inc a
	sta.w tmfowon,y
	lda.l Crowdlevel
	clc
	adc.w #$00C8
	sta.l Crowdlevel
	lda.w #$0014
	sta.b crowdhold
.3:									; if gmclock != 0 go to .4, ...
	lda.w gmclock
	bne .4
	lda.b a2
	cmp.w passReceiverPlayerNum		; pass reached its receiver
	bne .4
	ldy.b a1						; team
	lda.w tmpasscomp,y				; passes completed
	inc a							; one more
	sta.w tmpasscomp,y
.4:									; trb sflags, if position,y != 0 go to .6, ...
	lda.w #$000C
	trb.w sflags
	ldy.b a2						; player
	lda.w position,y				; position
	bne .6
	jsl.l ChkShotStat				; ChkShotStat (goalie made a save)
	ldy.b a2						; player
	lda.w #$008C					; temp5 = 140, count down for the faceoff
	sta.w temp5,y					; store
	lda.w SPA,y						; animation
	cmp.w #SPAgdive
	bne .6
.5:									; temp5,y = $0005
	lda.w #$0005
	sta.w temp5,y
.6:									; if a2 != passReceiverPlayerNum go to .t1, ...
	lda.b a2
	cmp.w passReceiverPlayerNum
	bne .t1
	ldy.b a1
	lda.w passpad,y
	sta.b d4
	bmi .t1
	jsl.l AssignPadIfFree			; AssignPadPlayer when player d0 has no pad yet
	bra .7

.t1:								; call PuckCarrierPad
	jsl.l PuckCarrierPad			; when player d0 has the puck and no pad
.7:									; passReceiverPlayerNum = $FFFF, return
	lda.w #$FFFF
	sta.w passReceiverPlayerNum
	rtl
