; Turn the password into the playoff state
DecodePW:							; called from BadPasswordPrompt, GameOver
	jsl.l PWtoBits
	jml.l ReadPassBits
