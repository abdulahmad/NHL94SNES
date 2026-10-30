; Pause mode: save the screen, stop the sound, show the pause menu, then restore
Pausemode:							; called from Gameloop, PlayShootout
	phx
	lda.w #textmap>>16
	sta.b p0+2
	lda.w #textmap
	sta.b p0
	lda.w #pausesavebuf>>16
	sta.b p1+2
	lda.w #pausesavebuf
	sta.b p1
	ldx.w #$0800
	jsl.l MemCopy					; copy X bytes from [p0] to [p1]
	plx
	jsl.l FadeOutSound				; start the sound fade out
	lda.w sfhormode
	pha
	lda.w sflags
	pha
	jsl.l FadeOut					; fade out: install BrightnessHook as the frame hook
	jsl.l WaitFadeOut				; wait until the screen is black
	jsl.l forceblack				; turn the screen black: default interrupt handlers, forced blank
	jsl.l SetHor					; switches to the horizontal rink
	ldx.w #$0000
	ldy.w #$01C0
	lda.w #$6000
	jsl.l InitSprites
	jsl.l FadeIn					; fade in: install BrightnessHook as the frame hook
	jsl.l ScreenOn
	jsl.l SpriteFrameStart
	jsl.l setvideo					; once per game frame: build the sprite table for the next vblank
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
	jsl.l print						; print PausemodePos
	pla
	sta.b a1
	pla
	sta.b a1+2
	lda.w #$0016
	sta.b d0
	lda.w #$0007
	sta.b d1
	jsl.l Framer					; draw a frame and fill it
	jsl.l printscores1				; draw the scoreboard: the period and score boxes on the vertical rink
	jsl.l Pausemode_menu					; pick which pause menu is up
	bne .loop
	lda.w #$0000
	sta.l pausemenuon
	stz.w pregamepause
	stz.w PauseUnused
	jsl.l FadeOut					; fade out: install BrightnessHook as the frame hook
	jsl.l WaitFadeOut				; wait until the screen is black
	jsl.l forceblack				; turn the screen black: default interrupt handlers, forced blank
	jsl.l SoundInit					; reset the sound player
	phx
	lda.w #pausesavebuf>>16
	sta.b p0+2
	lda.w #pausesavebuf
	sta.b p0
	lda.w #textmap>>16
	sta.b p1+2
	lda.w #textmap
	sta.b p1
	ldx.w #$0800
	jsl.l MemCopy					; copy X bytes from [p0] to [p1]
	plx
	stz.w textdirtylo
	lda.w #$03FF
	sta.w textdirtyhi
	pla
	sta.w sflags
	pla
	sta.w sfhormode
	bne .1
	jsl.l ClrHor					; switch back from the horizontal rink to the vertical ice rink
.1:									; trb sflags, call printscores1, call InitSprites, ...
	lda.w #$0001
	trb.w sflags
	jsl.l printscores1				; draw the scoreboard: the period and score boxes on the vertical rink
	ldx.w #$0000
	ldy.w #$01C0
	lda.w #$6000
	jsl.l InitSprites
	jsl.l FadeIn					; fade in: install BrightnessHook as the frame hook
	jsl.l ScreenOn
	jsl.l SpriteFrameStart
	jsl.l setvideo					; once per game frame: build the sprite table for the next vblank
	jsl.l SpriteFrameEnd
	lda.w #$7000
	sta.b SfxVelocity
	lda.w #$0012
	jsl.l QueueSound				; queue sound A
	lda.w #$0013
	jsl.l QueueSound				; queue sound A
	lda.w #$FFFF
	sta.w recsfx
	sta.w recsfx2
	lda.b Vcount
	sta.w lastframevc
	sta.w OldVcount
	rtl
