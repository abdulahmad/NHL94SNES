; Clear the track pointers and waits of tracks Y up to X
ClearTracks:						; called from MusicStop, SoundInit
	php
	sep #$30
	stx.b TrackLoopEnd
	tya
	tax
	asl a
	tay
	rep #$20
	lda.w #$0000
.loop:								; loop: TrackInst,y = A, TrackWait,y = A, Y + 1, ...
	sta.w TrackInst,y
	sta.w TrackWait,y
	iny
	iny
	inx
	cpx.b TrackLoopEnd
	bne .loop
	plp
	rts
