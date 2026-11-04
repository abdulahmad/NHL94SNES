; Raise the high end of the changed text map area to A
marktexthi:							; called from puckfaceoff2
	cmp.w textdirtyhi
	bcc .rtl
.1:									; textdirtyhi = A
	sta.w textdirtyhi
.rtl:								; return
	rtl
