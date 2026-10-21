; The cold start after Reset_Fast: password and default options, the title screen, then a fresh start
; (Restart)
;
; Takes nothing, never returns. Jumped to from Reset_Fast. Falls into Restart.
Opening:							; called from Reset_Fast
	rep #$30						; 16 bit registers
	jsl.l Multi5Init				; init the multitap
	jsl.l IntroSequence				; power-on animation, returns when it ends or a button is pressed
	jsl.l forceblack				; turn the screen black: default interrupt handlers, forced blank
	lda.w #$0000					; A = 0, X = 0
	tax
.loop:								; clear all of bank 7F, a word at a time (X wraps around through $0000)
	sta.l Ram7F,x
	dex
	dex
	bne .loop
	lda.w #$005C					; $5C: the jml opcode of the RAM trampoline
	sta.w jmlvector
	jsl.l CheckPAL					; detect NTSC / PAL
	jsl.l ResetPassWord				; reset the password
	jsl.l DefaultMenus				; default menu options
	jsl.l ReadAnyPad				; d1 = the buttons that changed on any pad
	lda.w #$0000
	sta.w brightness
	jsl.l ReadAnyPad				; d1 = the buttons that changed on any pad
	stz.w sndbank					;no sample set loaded: the title upload runs
	jsl.l TitleScreen				; title screen
	jsl.l FadeOutSound				; fade the music out
.loop2:								; wait for the fade-out to end
	lda.w brightness
	bne .loop2
	lda.w MusicOn
	bne .loop2
; Back to the menu song and the option screens, then the game. Takes nothing, never returns. Jumped to from
; demoread, BadPasswordPrompt, PauseExitGame and GameOver.
Restart:							; start over at the option screens
	lda.w #$0000					; playoff round 0
	sta.l playoffRoundIdx
	rep #$30
	lda.w #$1FFF					; stack back to $1FFF
	tcs
	phk								; data bank = program bank
	plb
	jsl.l SPCMenuUpload				; upload the menu music driver
	lda.w MusicOn
	beq .1							; no music playing: start the menu song
	lda.w SongPtr
	cmp.w #$C20C					; menu song already playing?
	beq .2
	jsl.l FadeOutSound				; other music: fade it out
.loop:								; and wait for it to stop
	lda.w MusicOn
	bne .loop
.1:									; start the menu song
	lda.w #MenuSong>>16
	sta.b p0+2
	lda.w #MenuSong
	sta.b p0
	jsl.l MusicStart				; start the song at [p0]: tempo from its second byte
.2:									; menu song running
	stz.w sfhormode					; vertical mode
	lda.w #$005C
	sta.w jmlvector
	jsl.l CheckPAL					; set the frame time step for a 50 Hz console
	jsl.l setoptions				; option screens
	stz.w shootoutmode				; no shootout yet
	lda.l OptPlayMode
	cmp.w #$0004					; play mode 4 = shootout?
	bne StartGame					; no: start the game
	jsl.l PlayShootout				; shootout
	stz.w FrameByNumber				; clear the frame cache flag
	jmp.w Restart					; back to the start
