; NMI after the frame hook: Multi5Bios, SoundUpdate and the sound stream (UpdateStreamSfx), then restore and
; rti
NMI_FrameHookReturn:				; called from NMI_Tick
	sep #$30
	jsl.l Multi5Bios				; read the five pads: pads 1 and 2 from the auto read
	rep #$20
	jsr.w SoundUpdate				; per frame: fade, envelopes, and the song ticks that are due
	jsl.l UpdateStreamSfx
	rep #$30
	stz.b NMISkip
	ply
	plx
	pla
	plb
	rti
