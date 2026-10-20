; IRQ: restore the registers and rti (where the IRQ hooks return)
IRQ_HookReturn:						; end of every IRQ hook: restore the registers and return from the
									; interrupt
	rep #$30						; 16-bit registers
	ply
	plx
	pla
	plb
	rti
