; Store which player a pad marker belongs to
;
; Takes X = object offset of the player, d4 = pad marker slot offset. Called from doinput, asspenalty
; and updateplayers.
setpads:							; pad marker d4 follows player X
	txa								; A = X / 2: the player number
	lsr a
	ldy.b d4						; Y = marker slot
	sta.w PadControlObj,y			; store it
	rtl
