; Swing type of player X for direction d0: forehand or backhand
;
; Takes X = player, d0 = direction. Returns A = 0 forehand, 1 backhand (d0 is changed to the direction
; relative to his facing). Called from doshot, dopass, asspassrec and assbreakaway.
Findhittype:						; swing type of player X for direction d0
	lda.b d0						; direction
	eor.w #$FFFF					; negate it
	inc a
	clc
	adc.w facedir,x					; plus the player's facing
	and.w #$0007					; 0-7
	sta.b d0						; relative direction
	lda.w attribute,x				; player attributes
	bit.w #$0800					; x flip attribute (bit $0800)?
	beq .t1							; no: use the table at .1+3
	phx								; keep X
	ldx.b d0						; X = relative direction
	lda.l .1,x						; x flip table
	plx								; restore X
	and.w #$00FF					; byte
	rtl								; return

.t1:								; not flipped
	phx								; keep X
	ldx.b d0						; direction as index
	lda.l .1+3,x					; unflipped table (starts 3 bytes in)
	plx								; restore X
	and.w #$00FF					; byte
	rtl
.1:									; 1 = backhand; the x flip table starts here, the unflipped one at .1+3
	db $00,$00,$00,$00,$01,$01,$01,$01,$00,$00,$00
