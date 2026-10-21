; NMI: save the registers; nothing more while $38 is set, else the frame work and the NMI hook
NMI_Fast:							; called from NMI
	rep #$30
	phb
	phk								; data bank = program bank
	plb
	pha
	cli
	lda.w #$0000
	tcd
	lda.w RDNMI
	lda.b NMISkip
	beq .t1
	pla
	plb
	rti

.t1:								; NMISkip = 0: DMABudget = $16D3, if NMIHookNext+1 = 0 go to .1, ...
	phx
	phy
	lda.w #$16D3
	sta.b DMABudget
	sep #$10
	ldx.w NMIHookNext+1
	beq .1
	lda.w NMIHookNext
	sta.w NMIHook
	stz.w NMIHookNext
	ldx.w NMIHookNext+2
	stx.w NMIHook+2
.1:									; go to [NMIHook]
	ldx.b #$80
	phx
	pea.w NMI_HookReturn-1			; rtl from the hook lands on the next line
	jml.w [NMIHook]
