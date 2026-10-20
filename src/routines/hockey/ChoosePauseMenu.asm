; Use the longer pause menu when this side still has a timeout, otherwise the standard menu.
ChoosePauseMenu:					; called from PauseMenu, PauseTimeout, SelectPauseController
	ldx.w pausepad
	bmi .t1
	lda.w gmclock
	beq .t1
	lda.w InIntermission
	bne .t1
	lda.w cont1team,x
	and.w #$0002
	tay
	lda.w tmtimeouts,y
	beq .t1
	lda.w #$0011
	sta.w pmenucount
	lda.w #$0005
	sta.w pmenulist
	bra .1

.t1:								; pmenucount = $0010, pmenulist = $0000
	lda.w #$0010
	sta.w pmenucount
	lda.w #$0000
	sta.w pmenulist
.1:									; if carry clear go to .rtl, ...
	lda.w psfirst
	clc
	adc.w #$0005
	cmp.w pmenucount
	bcc .rtl
	dec.w psfirst
.rtl:								; return
	rtl
