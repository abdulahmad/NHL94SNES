; IRQ: save the registers, acknowledge TIMEUP and run the IRQ hook at [$078F]; the hook returns through
; IRQ_HookReturn
;
; Takes nothing; entered from the IRQ vector. Calls the hook in IRQHook and returns through IRQ_HookReturn.
IRQ_Fast:							; IRQ handler: save the registers, run the hook
	rep #$30						; 16-bit registers, interrupts off
	sei
	phb								; data bank = program bank
	phk
	plb
	pha								; save A, X and Y
	phx
	phy
	sep #$10						; 8-bit index
	ldx.w TIMEUP					; read TIMEUP: acknowledges the IRQ
	ldx.b #$80						; bank $80 for the return address
	phx
	pea.w IRQ_HookReturn-1			; rtl from the hook lands on the next line
	jml [$078F]						; jump to the hook
