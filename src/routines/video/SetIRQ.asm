; Turn on an IRQ at line Y with the routine at X:A
; A = low 16 bits of the hook routine, X = its bank, Y = V-counter line. The H-counter comes from IRQHTime.
; Interrupts are switched off while the vectors are patched, then NMI plus H/V IRQ are turned on.
;
; Called from TitleScreen, SetupBandIRQ and SetupScrollIRQ.
SetIRQ:								; turn on an IRQ at line Y with the routine at X:A
	php								; save flags
	sei								; no interrupts while the hook is changed
	sep #$20						; 8-bit A
	pha								; keep the hook address
	lda.b #$81						; NMI + auto joypad read, IRQ disabled
	sta.w NMITIMEN					; set NMITIMEN
	pla								; restore the hook address
	rep #$20						; 16-bit A
	sty.w IRQVTime					; remember the V line
	sty.w VTIMEL					; V-counter compare = line Y
	ldy.w IRQHTime					; H-counter compare from IRQHTime
	sty.w HTIMEL					; set the H-counter compare
	sep #$10						; X = hook bank only
	stx.w IRQHook+2					; hook bank into the jump at IRQHook
	sta.w IRQHook					; hook address into the jump at IRQHook
	jsl.l WaitFrame					; wait one frame
	sep #$20						; 8-bit A
	lda.b #$B1						; NMI + auto joypad + H/V IRQ enabled
	sta.w NMITIMEN					; set NMITIMEN
	plp								; restore flags
	cli								; interrupts on again
IRQHook_Off:						; IRQ hook that does nothing; IRQOff points IRQHook here
	rtl
