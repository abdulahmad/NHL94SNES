; Watch for icing: the loose puck crossing the far goal line
;
; Takes iflags and the puck y. When icing is armed and nobody has the puck, sets the icing
; called flag (bit 0 of iflags) once the loose puck is past the far goal line.
;
; Called from pucknorm.
PuckIChk:							; icing check
	lda.w iflags					; icing flags
	bit.w #ifok						; bit $0004: icing armed
	beq .1							; not armed: .1
	bit.w #ifcgl					; bit $0001: icing already called
	bne .1							; called: .1
	lda.w puckc						; puck carrier
	bpl .1							; somebody has it: .1
	lda.w #$0108					; d0 = $0108, the far goal line y
	sta.b d0
	lda.w iflags
	bit.w #ifdir					; bit $0002: direction of the play
	bne .2							; .2: goal line at the other end
	lda.w #$FEF8					; $FEF8 = -$0108
	sec
	sbc.w pucky						; minus the puck y
	bpl .3							; past the line: call icing
.1:									; return
	rtl
.2:									; compare against the end at +$0108
	lda.w #$0108
	sec
	sbc.w pucky
	bpl .1							; not past it: return
.3:									; call icing
	lda.w #$0001					; bit $0001: icing called
	tsb.w iflags					; set it in iflags
	rtl
