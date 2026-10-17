; End of a period: the next period, overtime, or game over
PeriodOver:
	jsl.l FadeOut
	jsl.l FadeOutSound
	jsl.l WaitFrame
	jsl.l WaitFrame
.loop:
	lda.w brightness
	bne .loop
	lda.w SoundFadeSpeed
	bne .loop
	jsl.l forceblack
	lda.w shootoutmode
	bne .5
	jsl.l SPCMenuUpload
	lda.l OptPlayMode
	beq .t1
	cmp.w #$0004
	beq .t1
	lda.l playoffRoundIdx
	cmp.w #$0002
	bcc .t1
	lda.w #PlayoffSong>>16
	sta.b p0+2
	lda.w #PlayoffSong
	sta.b p0
	jsl.l MusicStart
	jmp.w .5

.t1:
	lda.w #MenuSong>>16
	sta.b p0+2
	lda.w #MenuSong
	sta.b p0
	jsl.l MusicStart
.5:
	lda.w gmode
	eor.w #gmdir
	sta.w gmode
	ldy.w #$0000
.loopx:
	lda.w tmpdst,y
	cmp.w #$FFFD
	bne .1
	lda.w #$FFFE
	sta.w tmpdst,y
.1:
	iny
	iny
	cpy.w #$0068
	bcc .loopx
	jsl.l SetHor
	ldx.w #$0000
	ldy.w #$01C0
	lda.w #$6000
	jsl.l InitSprites
	jsl.l FadeIn
	jsl.l ScreenOn
	jsl.l SpriteFrameStart
	jsl.l setvideo
	jsl.l SpriteFrameEnd
	inc.w gsp
	lda.w gsp
	cmp.w #$0003
	beq .2
	bcc .3
	lda.w #$0003
	sta.w gsp
	lda.l OptPlayMode
	bne .2
	lda.w #$0004
	sta.w gsp
.2:
	lda.w tmscore
	cmp.w tmscore+2
	beq .3
	lda.w #$0004
	sta.w gsp
.3:
	jsl.l ResetClock
	jsl.l UpdateScores
	jsl.l Intermission
	lda.w gsp
	cmp.w #$0004
	bne .t1x
.4:
	jml.l GameOver

.t1x:
	lda.w gsp
	sta.w lastperiod
	jsl.l FadeOutSound
	jsl.l FadeOut
.loopxx:
	lda.w SoundFadeSpeed
	bne .loopxx
	jsl.l SPCGameUpload
	lda.w #$FFFF
	sta.w BA_Sktr_SCnum
	jmp.w StartPer
