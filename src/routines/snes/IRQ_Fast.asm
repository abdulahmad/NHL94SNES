; IRQ: save the registers, acknowledge TIMEUP and run the IRQ hook at [$078F]; the hook returns through
; IRQ_HookReturn
IRQ_Fast:
	rep #$30
	sei
	phb
	phk
	plb
	pha
	phx
	phy
	sep #$10
	ldx.w TIMEUP
	ldx.b #$80
	phx
	pea.w IRQ_HookReturn-1			; rtl from the hook lands on the next line
	jml [$078F]
