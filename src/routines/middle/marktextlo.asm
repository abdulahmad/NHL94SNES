; Lower the low end of the changed text map area to A
marktextlo:							; called from puckfaceoff2
	cmp.w textdirtylo
	bcs .rtl
.1:									; textdirtylo = A
	sta.w textdirtylo
.rtl:								; return
	rtl
