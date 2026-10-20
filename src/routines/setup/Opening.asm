; The cold start after Reset_Fast: password and default options, the title screen, then a fresh start
; (Restart)
Opening:
	rep #$30
	jsl.l Multi5Init
	jsl.l IntroSequence
	jsl.l forceblack
	lda.w #$0000
	tax
.loop:
	sta.l Ram7F,x
	dex
	dex
	bne .loop
	lda.w #$005C
	sta.w jmlvector
	jsl.l CheckPAL
	jsl.l ResetPassWord
	jsl.l DefaultMenus
	jsl.l ReadAnyPad
	lda.w #$0000
	sta.w brightness
	jsl.l ReadAnyPad
	stz.w sndbank					;no sample set loaded: the title upload runs
	jsl.l TitleScreen
	jsl.l FadeOutSound
.loop2:
	lda.w brightness
	bne .loop2
	lda.w MusicOn
	bne .loop2
Restart:
	lda.w #$0000
	sta.l playoffRoundIdx
	rep #$30
	lda.w #$1FFF
	tcs
	phk
	plb
	jsl.l SPCMenuUpload
	lda.w MusicOn
	beq .1
	lda.w SongPtr
	cmp.w #$C20C
	beq .2
	jsl.l FadeOutSound
.loop:
	lda.w MusicOn
	bne .loop
.1:
	lda.w #MenuSong>>16
	sta.b p0+2
	lda.w #MenuSong
	sta.b p0
	jsl.l MusicStart
.2:
	stz.w sfhormode
	lda.w #$005C
	sta.w jmlvector
	jsl.l CheckPAL
	jsl.l setoptions
	stz.w shootoutmode
	lda.l OptPlayMode
	cmp.w #$0004
	bne StartGame
	jsl.l PlayShootout
	stz.w FrameByNumber
	jmp.w Restart
