; Start sprite animation A on object X (as SetSPAFromA) and update it at once (updateanim)
SetSPAUpdate:						; A = animation, x = object; called from asseben, updateanim, FallDown
	cmp.w SPA,x						; already running?
	beq .rtl						; yes, leave it
	sta.w SPA,x						; new animation
	stz.w SPAnum,x					; from its first frame
	lda.w #$FFFF					; frame counter $FFFF
	sta.w SPAcnt,x					; forces the next frame at once
	jsl.l updateanim				; update now
.rtl:								; done
	rtl
