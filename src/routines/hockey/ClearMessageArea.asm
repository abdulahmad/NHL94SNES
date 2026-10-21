; Clear the message rows (ClearTextMapBottom)
ClearMessageArea:					; called from setoptions
	jsl.l ClearTextMapBottom		; fill the text map from row 12 down with the blank tile
	rtl
