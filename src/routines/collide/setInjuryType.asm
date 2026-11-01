; Player a2 is injured: the crowd reacts and the injury box gets his name
;
; Takes a2 = the player's pflags index. Returns nothing; sets the injury state for the period.
; Called from FallDown when a player is hurt by a fall.
setInjuryType:						; player a2 is injured
	ldy.b a2
	lda.w pflags,y
	ora.w #pf2unav					; unavailable, as 94G setInjuryType sets pf2unav
	sta.w pflags,y
	lda.l Crowdlevel
	clc
	adc.w #$012C
	sta.l Crowdlevel				; the crowd gets louder
	lda.w #$003C
	sta.b crowdhold					; hold the crowd level for 60 frames
	lda.w #$0004
	jsl.l StreamSfx					; play streamed sound 4 (the groan)
	ldy.b a2
	lda.w Xpos,y
	sta.w xc1						; scroll lock target x = the player's x
	lda.w Ypos,y
	sta.w yc1						; scroll lock target y = the player's y
	lda.w #$0040
	tsb.w sflags					; sfslock: lock the screen on xc1/yc1
	stz.b d1						; d1 = team flag, home 0
	stz.b a0						; a0 = team offset, home 0
	lda.w pfteam,y
	beq .1							; home team: skip
	lda.w #$8000
	sta.b d1						; away team flag $8000
	lda.w #$0002					; away team offset 2
	sta.b a0						; away team offset 2
.1:									; player number plus the team flag
	lda.w pnum,y					; player number
	and.w #$00FF
	ora.b d1						; plus the team flag
	sta.w TempPlOffset				; remember who it is
	and.w #$00FF
	bit.w #$0080
	beq .2							; number below $80: no sign extension
	ora.w #$FF00					; sign extend the player number
.2:									; times 2 (word entries)
	asl a							; times 2
	sta.b d1
	lda.b a0
	beq .3							; home team: no extra offset
	lda.w #$0034					; away team offset $34
.3:									; index into the tmpdst table
	adc.b d1
	tay								; Y = index
	lda.w #$FFFD
	sta.w tmpdst,y					; mark this entry $FFFD
	lda.w #$0007
	jsl.l randoma8					; roll 0-7
	cmp.w #$0000
	bne .rtl						; usually done
	lda.w #$FFFC					; one time in eight the entry is $FFFC instead
	sta.w tmpdst,y
	lda.w TempPlOffset				; and TempPlOffset gets bit $4000 (probably marks the longer injury)
	ora.w #$4000
	sta.w TempPlOffset
.rtl:								; return
	rtl
