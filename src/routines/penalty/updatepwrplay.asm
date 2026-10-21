; Show the power play box: the time left and the team on the power play
updatepwrplay:						; called from periodicevents, printscores1
	lda.l OptPlayMode
	cmp.w #$0004
	beq .off
	stz.b a2						; a2 = home, a3 = away
	lda.w #$0002
	sta.b a3
	lda.w tmap						; difference of the power play times
	sec
	sbc.w tmap+2
	sta.b d0						; d0 = home - away
	bne .ne
	jmp.w updatepwrplay_clr			; power play over: put the EASN logo back
.ne:								; if plus go to .t0, ...
	bpl .t0
	lda.w sflags					; negative: away team on the power play
	bit.w #sf2pwrtm
	bne .upp
	jsl.l updatepwrplay_clr			; clear the box when the team changes
	lda.w #sf2pwrtm					; team flag
	tsb.w sflags
	bra .upp
.off:								; OptPlayMode = $0004: return
	rtl
.t0:								; a2 = a3, a3 = a2, if sflags bits sf2pwrtm clear go to .upp, ...
	ldx.b a2
	ldy.b a3
	sty.b a2
	stx.b a3
	lda.w sflags					; flags
	bit.w #sf2pwrtm
	beq .upp
	jsl.l updatepwrplay_clr			; clear the box when the team changes
	lda.w #sf2pwrtm
	trb.w sflags					; clear the team flag
.upp:								; tsb sflags, if not zero go to .uppt, ...
	lda.w #sf2pwrplay				; sf2pwrplay; new: tmPwrPlays + 1
	tsb.w sflags
	bne .uppt
	ldx.b a3						; first time: count the power play
	inc.w tmPwrPlays,x				; new power play for the team
.uppt:								; a1 = updatepwrplayPos, call print, a1 = pulled value, ...
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #updatepwrplayPos>>16
	sta.b a1+2
	lda.w #updatepwrplayPos
	sta.b a1
	jsl.l print						; print updatepwrplayPos
	pla
	sta.b a1
	pla
	sta.b a1+2
	jsl.l GetLowestPen				; time left of the power play -> d0
	lda.w gmclock
	bne .time
	lda.b d0
	cmp.w #$0005
	bcs .time
	cmp.w #$0001
	beq .one
	lda.w #$7000
	sta.b SfxVelocity
	lda.w #$0005
	jsl.l QueueSound				; queue sound A
	bra .time
.one:								; SfxVelocity = $7000, call QueueSound, if VoiceState,y != $02 go to .w...
	lda.w #$7000
	sta.b SfxVelocity
	lda.w #$0005
	jsl.l QueueSound				; queue sound A
	phx
	tay
	sep #$20
	lda.w VoiceState,y
	cmp.b #$02
	bne .wide
	lda.b #$03
	sta.w VoiceState,y
	rep #$20
	tya
	asl a
	tay
	lda.w #$0659
	sta.w VoicePitch,y
	sta.w recsfxpitch
.wide:								; falls through
	rep #$20
	plx
.time:								; call PushTime, call print, a0 = tmdata,x, ...
	jsl.l PushTime					; time as text
	jsl.l print						; print it
	ldx.b a3						; team of the power play
	lda.w tmdata,x					; team name (bank $83)
	sta.b a0
	lda.w #TeamList>>16
	sta.b a0+2
	lda.w #$0000
	sta.b a3+2
	lda.w #mesarea
	sta.b a3
	lda.w #$0002
	sta.b [a3]
	lda.w #updatepwrplayPos2>>16
	sta.b a1+2
	lda.w #updatepwrplayPos2
	sta.b a1
	jsl.l appstring					; append string [a1] to string [a3]
	lda.b a0						; team name offset
	ldy.w #$0004					; short name offset
	clc
	adc.b [a0],y
	sta.b a0						; add the entry offset
	adc.b [a0]
	sta.b a0
	sta.b a1						; string pointer
	lda.b a0+2
	sta.b a1+2
	jsl.l appstring					; append the string
	lda.b a3+2
	sta.b a1+2
	lda.b a3
	sta.b a1
	jsl.l print
	rtl
