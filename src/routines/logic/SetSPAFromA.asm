; Start sprite animation A on object X
SetSPAFromA:						; called from FallDown, GlideBack, Goal, Sweepcheck, assbench and 17 more
	cmp.w SPA,x
	beq .rtl
	sta.w SPA,x
	stz.w SPAnum,x
	lda.w #$FFFF
	sta.w SPAcnt,x
.rtl:								; return
	rtl
