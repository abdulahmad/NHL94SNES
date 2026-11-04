; x offset and height of each shot direction (doshot, by passdir)
;
; Nine pairs of words (x offset, height), one per passdir; doshot reads them at passdir*4.
doshot_shotsets:					; table: x offset and height for each passdir
	dw 0,12,15,12,15,6,15,0,0
	dw 0,-15,0,-15,6,-15,12,0,6
