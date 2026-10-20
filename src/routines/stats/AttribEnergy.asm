; Roster column: the player's energy as a percentage
; Takes d0 = player index, a2 = team offset. Looks up the player's energy word in tmpde (second table for the
; other team), divides it by $28 (or uses $1000 when OptLine is 2), limits the result to 100 and prints it
; through AttribRating.
;
; Called through attribjmp.
AttribEnergy:						; print the energy column
	asl.b d0						; word index of the player
	lda.b a2						; team offset
	beq .5							; first team: use the first table
	lda.w #$0034					; other team: skip $34 bytes
.5:									; index into tmpde
	adc.b d0
	tay
	lda.w tmpde,y					; energy word
	sta.b r2
	lda.l OptLine					; option line
	cmp.w #$0002
	bne .2							; not 2: use the energy
.1:									; option line 2: energy is a fixed $1000
	lda.w #$1000
	sta.b r2
.2:									; divide by $28
	lda.w #$0028
	sta.b r1
	phx
	jsl.l Div16x8U
	plx
	lda.b r0
	cmp.w #$0065
	bcc .3
	lda.w #$0064
.3:									; result 0-100
	sta.b d0
	bra AttribRating
