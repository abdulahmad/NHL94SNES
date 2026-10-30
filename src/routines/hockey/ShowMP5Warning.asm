; Draw the MultiPlayer 5 warning for the controller, Super Scope, or mouse.
ShowMP5Warning:						; called from SelectPauseController
	lda.w mp5warning
	beq .rtl
.loop:								; loop: call .t4, if mp5warning != 0 go to .loop, ...
	jsl.l .t4
	lda.w mp5warning
	bne .loop
	jsl.l SetupPauseScreen						; draw the pause menu: five items of the current list from item psfirst
.rtl:								; return
	rtl

.t4:								; subroutine: a1 = ShowMP5WarningPos, call print, a1 = pulled value, ...
	pha
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #ShowMP5WarningPos>>16
	sta.b a1+2
	lda.w #ShowMP5WarningPos
	sta.b a1
	jsl.l print						; print ShowMP5WarningPos
	pla
	sta.b a1
	pla
	sta.b a1+2
	lda.w #$0016
	sta.b d0
	lda.w #$0007
	sta.b d1
	jsl.l Framer					; draw a frame and fill it
	pla
	bit.w #$0001
	bne .t1
	bit.w #$0002
	bne .t2
	bit.w #$0004
	bne .t3
	jmp.w .1

.t1:								; a1 = MultiPlayer5Text, call PrintMP5Line1, a1 = MP5MustConnect, ...
	lda.w #MultiPlayer5Text>>16
	sta.b a1+2
	lda.w #MultiPlayer5Text
	sta.b a1
	jsl.l PrintMP5Line1				; print the first MultiPlayer 5 warning line, centered
	lda.w #MP5MustConnect>>16
	sta.b a1+2
	lda.w #MP5MustConnect
	sta.b a1
	jsl.l PrintMP5Line2				; print the second MultiPlayer 5 warning line, centered
	lda.w #MP5ToController>>16
	sta.b a1+2
	lda.w #MP5ToController
	sta.b a1
	jsl.l PrintMP5Line3				; print the third MultiPlayer 5 warning line, centered
	lda.w #MP5Socket2>>16
	sta.b a1+2
	lda.w #MP5Socket2
	sta.b a1
	jsl.l PrintMP5Line4				; print the fourth MultiPlayer 5 warning line, centered
	bra .1

.t2:								; a1 = MP5ScopeHead, call PrintMP5Line1, a1 = MP5ScopeNot, ...
	lda.w #MP5ScopeHead>>16
	sta.b a1+2
	lda.w #MP5ScopeHead
	sta.b a1
	jsl.l PrintMP5Line1				; print the first MultiPlayer 5 warning line, centered
	lda.w #MP5ScopeNot>>16
	sta.b a1+2
	lda.w #MP5ScopeNot
	sta.b a1
	jsl.l PrintMP5Line2				; print the second MultiPlayer 5 warning line, centered
	lda.w #MP5ScopeWith>>16
	sta.b a1+2
	lda.w #MP5ScopeWith
	sta.b a1
	jsl.l PrintMP5Line3				; print the third MultiPlayer 5 warning line, centered
	lda.w #MP5SuperScope>>16
	sta.b a1+2
	lda.w #MP5SuperScope
	sta.b a1
	jsl.l PrintMP5Line4				; print the fourth MultiPlayer 5 warning line, centered
	bra .1

.t3:								; a1 = MP5MouseHead, call PrintMP5Line1, a1 = MP5MouseNot, ...
	lda.w #MP5MouseHead>>16
	sta.b a1+2
	lda.w #MP5MouseHead
	sta.b a1
	jsl.l PrintMP5Line1				; print the first MultiPlayer 5 warning line, centered
	lda.w #MP5MouseNot>>16
	sta.b a1+2
	lda.w #MP5MouseNot
	sta.b a1
	jsl.l PrintMP5Line2				; print the second MultiPlayer 5 warning line, centered
	lda.w #MP5MouseWith>>16
	sta.b a1+2
	lda.w #MP5MouseWith
	sta.b a1
	jsl.l PrintMP5Line3				; print the third MultiPlayer 5 warning line, centered
	lda.w #MP5Mouse>>16
	sta.b a1+2
	lda.w #MP5Mouse
	sta.b a1
	jsl.l PrintMP5Line4				; print the fourth MultiPlayer 5 warning line, centered
.1:									; call SendTextMap, call WaitFrame, return
	jsl.l SendTextMap
	jsl.l WaitFrame
	rtl
