; start the song at [p0]: tempo from its second byte, tracks from its offset list
MusicStart:							; called from PeriodOver, PlayTeamSong, PlayoffScreen, ReplayMode, Rest...
	php
	sep #$30
	jsl.l MusicStop
	dec.w SoundLock
	lda.b #$1F
	ldy.b #$10
.loop:								; loop: TrackUnused,y = A, Y - 1, if Y still >= 0 go to .loop, ...
	sta.w TrackUnused,y
	dey
	bpl .loop
	rep #$10
	ldy.w #$0001
	ldx.w #$2760
	lda.w STAT78
	bit.b #$10
	beq .1
	ldx.w #$1FE0
.1:									; call DivX8U, TempoTick = A, EventPtr+2 = p0+2, ...
	lda.b [p0],y
	jsl.l DivX8U
	sta.w TempoTick
	sep #$10
	lda.b p0+2
	sta.b EventPtr+2
	rep #$20
	lda.b p0
	sta.w SongPtr
	ldx.b #$00
	ldy.b #$08
.loop2:								; loop: if [p0],y = 0 go to .t1, ...
	lda.b [p0],y
	beq .t1
	clc
	adc.b p0
	sta.w TrackPtr,x
	sta.w TrackLoop,x
	iny
	iny
	inx
	inx
	bra .loop2

.t1:								; [p0],y = 0: SongUnused = 0, TrackCount = [p0],y, MusicOn = $01, ...
	stz.w SongUnused
	sep #$20
	ldy.b #$06
	lda.b [p0],y
	sta.w TrackCount
	lda.b #$01
	sta.w MusicOn
	inc.w SoundLock
	plp
	rtl
