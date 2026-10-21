; Every game loop: let the crowd level fade
;
; Takes d7 = frames elapsed. While crowdhold is nonzero it counts down (at most 60 at once); then
; Crowdlevel (capped at $480) falls by impactstep each frame down to 0. Called from periodicevents.
updatecrowdf:						; crowd level fade, every game loop
	lda.b crowdhold					; hold time left?
	beq .t1							; none: let the level fall
	cmp.w #$003C					; limit the hold to 60 frames
	bcc .1
	lda.w #$003C
.1:									; hold count
	sec
	sbc.b d7						; minus frames elapsed
	bpl .2							; still positive
	lda.w #$0000					; clamp at 0
.2:									; hold count ready
	sta.b crowdhold					; store the hold
	rtl

.t1:								; not held: fade the crowd level
	lda.l Crowdlevel
	cmp.w #$0480					; cap the level at $480
	bcc .1x
	lda.w #$0480
.1x:								; level capped
	sec								; minus the impact decay of this frame
	sbc.w impactstep
	sta.l Crowdlevel				; store the level
	bpl .rtl						; still positive: done
	lda.w #$0000					; clamp at 0
	sta.l Crowdlevel
.rtl:								; return
	rtl
