; A = a random number from 0 to A-1, for A below 256
; A = limit. Returns A = random number from 0 to A-1 (random word times A, high byte), carry clear.
;
; Called from Create_HotCold_Table, Endfaceoff, chk4pass, setoptions and others.
randoma8:							; random number below A
	phx
	pha
randoma8_go:						; entry with the limit already pushed
	jsl.l RandomWord				; get a random word
	and.w #$00FF					; low byte only
	tax								; times the limit
	pla
	jsl.l Mul8U						; 8x8 multiply
	plx
	xba								; result is in the high byte
	and.w #$00FF
	clc
	rtl
