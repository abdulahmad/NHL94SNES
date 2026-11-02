; A busy-wait of X loops, skipped once a pad press has ended the title (titleskip)
TitleDelay:							; x = loop count; called from the title zoom and wipe routines
	phx								; keep x
	ldx.w titleskip					; title ended by a pad press?
	bne .1							; yes, skip the delay
	plx								; x = count again
.loop:								; busy loop
	dex								; count down
	bne .loop						; until 0
	phx								; (x = 0 pushed, popped below)
.1:									; done
	plx								; restore x
	rts
