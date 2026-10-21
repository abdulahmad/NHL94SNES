; Pause mode: save the screen, stop the sound, show the pause menu, then restore
Pausemode:							; called from Gameloop, PlayShootout
	phx
	lda.w #textmap>>16
	sta.b p0+2
	lda.w #textmap
	sta.b p0
	lda.w #Ram7E>>16
	sta.b p1+2
	lda.w #$4F7E
	sta.b p1
	ldx.w #$0800
	jsl.l MemCopy
	plx
	jsl.l FadeOutSound
	lda.w sfhormode
	pha
	lda.w sflags
	pha
	jsl.l FadeOut
	jsl.l WaitFadeOut
	jsl.l forceblack
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
	stz.w psfirst
	stz.w psitem
.loop:								; loop: a1 = PausemodePos, call print, a1 = pulled value, ...
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #PausemodePos>>16
	sta.b a1+2
	lda.w #PausemodePos
	sta.b a1
	jsl.l print
	pla
	sta.b a1
	pla
	sta.b a1+2
	lda.w #$0016
	sta.b d0
	lda.w #$0007
	sta.b d1
	jsl.l Framer
	jsl.l printscores1
	jsl.l PauseMenu
	bne .loop
	lda.w #$0000
	sta.l pausemenuon
	stz.w pregamepause
	stz.w PauseUnused
	jsl.l FadeOut
	jsl.l WaitFadeOut
	jsl.l forceblack
	jsl.l SoundInit
	phx
	lda.w #Ram7E>>16
	sta.b p0+2
	lda.w #$4F7E
	sta.b p0
	lda.w #textmap>>16
	sta.b p1+2
	lda.w #textmap
	sta.b p1
	ldx.w #$0800
	jsl.l MemCopy
	plx
	stz.w textdirtylo
	lda.w #$03FF
	sta.w textdirtyhi
	pla
	sta.w sflags
	pla
	sta.w sfhormode
	bne .1
	jsl.l ClrHor
.1:									; trb sflags, call printscores1, call InitSprites, ...
	lda.w #$0001
	trb.w sflags
	jsl.l printscores1
	ldx.w #$0000
	ldy.w #$01C0
	lda.w #$6000
	jsl.l InitSprites
	jsl.l FadeIn
	jsl.l ScreenOn
	jsl.l SpriteFrameStart
	jsl.l setvideo
	jsl.l SpriteFrameEnd
	lda.w #$7000
	sta.b SfxVelocity
	lda.w #$0012
	jsl.l QueueSound
	lda.w #$0013
	jsl.l QueueSound
	lda.w #$FFFF
	sta.w recsfx
	sta.w recsfx2
	lda.b vcount
	sta.w lastframevc
	sta.w oldvcount
	rtl
