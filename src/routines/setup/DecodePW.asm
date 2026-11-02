; Turn the password into the playoff state
DecodePW:							; called from BadPasswordPrompt, GameOver
	jsl.l PWtoBits					; turn the password characters into the password bits
	jml.l ReadPassBits				; password bits back into the playoff state
