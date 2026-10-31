; Pad input while shooting: aim with the pad and build shot power during the windup.
;
; Takes X = shooter, d0 = pad direction, d2 = changed buttons. Only active while X carries the puck in a shot
; animation. Calls doshot when the animation reaches frame $18; leaves sflags bit 3 when it stops.
; Called from doinput and assshoot.
ShotMode:							; shot input for the puck carrier
	cpx.w puckc						; only the puck carrier shoots
	bne .off						; someone else: end shot mode
	lda.w SPA,x						; animation
	cmp.w #SPAshotf					; before the forehand shot: end
	bcc .off
	cmp.w #$F021					; past the shot animations
	bcs .off
	lda.w SPAnum,x					; animation frame (4 per frame)
	cmp.w #$0018					; end of the animation (frame 6)
	bcs doshot						; shoot
	lda.b d0						; pad direction
	bit.w #$0008					; bit 3 = no direction
	bne .ss0						; none: keep the old one
	and.w #$0007					; direction 0-7
	sta.w passdir					; store it as the shot direction
.ss0:								; past the windup?
	lda.w SPAnum,x					; animation frame
	cmp.w #$0010					; frame 4
	bcs .rts						; yes: leave
	lda.w passspeed					; windup: shot speed grows
	clc
	adc.b d7						; by the frames elapsed
	sta.w passspeed					; grows with time
	lda.b d2						; buttons that changed
	bit.w #cbut						; shoot button changed (released)?
	beq .rts						; no: leave
	lda.w #$001C					; released: jump the animation to the end
	sec								; swing through
	sbc.w SPAnum,x					; $1C minus the frame
	sta.w SPAnum,x
	cmp.w #$0018					; past the last shot frame?
	bcc .rts						; no: leave
	lda.w #$0018					; clamp at $18
	sta.w SPAnum,x
	bra doshot						; shoot
.off:								; not shooting any more
	lda.w #$0008					; clear the shot mode flag
	trb.w sflags
.rts:								; return
	rtl
