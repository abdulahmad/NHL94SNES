; End of a period: the next period, overtime, or game over
;
; Takes nothing, never returns. Jumped to from puckfaceoff when the clock runs out. Fades out, picks the
; music,
; turns the teams around, counts gsp (period; tied after period 3: overtime, a playoff game plays on) and
; ends in GameOver or the next period (StartPer).
PeriodOver:							; end of a period
	jsl.l FadeOut					; fade the screen and the sound out
	jsl.l FadeOutSound
	jsl.l WaitFrame					; let two frames pass
	jsl.l WaitFrame
.loop:								; wait until the screen and the sound are faded out
	lda.w brightness
	bne .loop
	lda.w SoundFadeSpeed
	bne .loop
	jsl.l forceblack				; black screen
	lda.w shootoutmode				; shootout: keep the music as is
	bne .5
	jsl.l SPCMenuUpload				; load the menu music driver
	lda.l OptPlayMode				; play mode 0 (exhibition)?
	beq .t1
	cmp.w #$0004					; or 4 (shootout): menu song
	beq .t1
	lda.l playoffRoundIdx			; playoff round below 2: menu song
	cmp.w #$0002
	bcc .t1
	lda.w #PlayoffSong>>16			; later playoff rounds: playoff song
	sta.b p0+2
	lda.w #PlayoffSong
	sta.b p0
	jsl.l MusicStart
	jmp.w .5						; song started

.t1:								; menu song
	lda.w #MenuSong>>16
	sta.b p0+2
	lda.w #MenuSong
	sta.b p0
	jsl.l MusicStart
.5:									; music is set
	lda.w gmode						; swap the direction of play (gmdir)
	eor.w #gmdir
	sta.w gmode
	ldy.w #$0000					; Y = byte offset into tmpdst
.loopx:								; the 52 roster players
	lda.w tmpdst,y
	cmp.w #$FFFD					; out of the game (TMPDOUT)?
	bne .1
	lda.w #$FFFE					; yes: back to the bench (TMPDBENCH)
	sta.w tmpdst,y
.1:									; next player
	iny
	iny
	cpy.w #$0068					; 52 players done?
	bcc .loopx
	jsl.l SetHor					; set up the rink in the new direction
	ldx.w #$0000					; initialize the sprites
	ldy.w #$01C0
	lda.w #$6000
	jsl.l InitSprites
	jsl.l FadeIn					; fade in and show the screen
	jsl.l ScreenOn
	jsl.l SpriteFrameStart			; draw one frame
	jsl.l setvideo
	jsl.l SpriteFrameEnd
	inc.w gsp						; next period
	lda.w gsp
	cmp.w #$0003					; gsp 3: after period 3
	beq .2
	bcc .3							; gsp 1 or 2: next period
	lda.w #$0003					; after overtime: overtime again (gsp 3)
	sta.w gsp
	lda.l OptPlayMode				; playoff: tie check, else game over
	bne .2
	lda.w #$0004					; gsp 4
	sta.w gsp
.2:									; tied?
	lda.w tmscore
	cmp.w tmscore+2
	beq .3
	lda.w #$0004					; not tied: game over
	sta.w gsp
.3:									; gsp is final
	jsl.l ResetClock				; reset the clock
	jsl.l UpdateScores				; update the scores
	jsl.l Intermission				; intermission
	lda.w gsp
	cmp.w #$0004					; game over?
	bne .t1x
.4:									; game over
	jml.l GameOver

.t1x:								; next period
	lda.w gsp
	sta.w lastperiod				; remember the period just finished
	jsl.l FadeOutSound				; fade out again
	jsl.l FadeOut
.loopxx:							; wait for the sound fade
	lda.w SoundFadeSpeed
	bne .loopxx
	jsl.l SPCGameUpload				; load the game music driver
	lda.w #$FFFF					; no sketcher frame yet
	sta.w BA_Sktr_SCnum
	jmp.w StartPer					; start the next period
