; Set the energy of player d1 of team a2 to d0
;
; Takes d1 = player number, d0 = energy (a negative value is stored as 0), a2 = team (0 home).
; Called from playeracc and burst. Returns nothing.
setpde:								; set the energy of player d1 of team a2 to d0
	lda.b a2						; team
	beq .home						; home
	lda.w #$0034					; away team offset $34
.home:								; index the energy table
	clc
	adc.b d1						; plus the player
	tay
	lda.b d0						; energy
	bpl .store						; negative: 0
	lda.w #$0000
	sta.b d0
.store:								; store the energy
	sta.w tmpde,y					; store it
	rtl
