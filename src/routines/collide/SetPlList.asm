; Make the list of the players team a2 wants on the ice now
SetPlList:							; called from setpersonel
	lda.w #PlList>>16
	sta.b a4+2
	lda.w #PlList
	sta.b a4
	lda.w #$0000					; clear the list
	sta.b [a4]						; three words
	ldy.w #$0002					; second word
	sta.b [a4],y
	ldy.w #$0004					; third word
	sta.b [a4],y
	lda.w #priolist>>16
	sta.b a0+2
	lda.w #priolist
	sta.b a0
	lda.w penshot
	beq .t1
	lda.w #priolist>>16
	sta.b a0+2
	lda.w #priolist+7
	sta.b a0
	lda.b a2
	cmp.w BA_Team
	bne .1
	inc.b a0
	bra .1

.t1:								; penshot = 0: if tmgoalie,y >= 0 go to .1, ...
	ldy.b a2
	lda.w tmgoalie,y
	bpl .1
	inc.b a0
.1:									; call GetTeamLines, a1+2 = a3+2, a1 = a3, ...
	lda.b a3+2
	pha
	lda.b a3
	pha
	jsl.l GetTeamLines
	lda.b a3+2
	sta.b a1+2
	lda.b a3
	sta.b a1
	pla
	sta.b a3
	pla
	sta.b a3+2
	ldy.b a2
	lda.w tmline,y					; current line
	asl a							; times 8
	asl a
	asl a
	sta.b d0
	adc.b a1						; plus the line offset
	sta.b a1
	lda.w tmap,y					; tmap: players on ice
	sta.b d4						; slots to fill
	bra .7
.3:									; loop: d4 still >= 0: d5 = [a0],y & $00FF, [a4],y = [a1],y, if d5 = 0...
	ldy.b d4
	lda.b [a0],y					; priority entry
	and.w #$00FF
	sta.b d5						; keep the slot index
	tay
	sep #$20						; 8-bit A
	lda.b [a1],y					; roster number from the line
	ldy.b d4
	sta.b [a4],y					; store it in the list
	lda.b d5
	beq .1x
	lda.w penshot
	beq .1x
	lda.w BA_Skater_Offset
	inc a
	sta.b [a4],y					; store it in the list
.1x:								; Y + 1, Y + 1, Y + 1, ...
	iny
	iny
	iny
	iny
	iny
	iny
	lda.b d5
	sta.b [a4],y					; and the slot index
	rep #$20						; 16-bit A
	lda.b d5
	bne .7
	ldy.b a2						; goalie: 1 + tmgoalie
	lda.w tmgoalie,y				; team goalie
	inc a
	sta.b d3
	bne .2
	lda.w penshot
	beq .2
	inc.b d3
.2:									; [a4],y = d3
	ldy.b d4						; slot
	sep #$20						; 8-bit A
	lda.b d3
	sta.b [a4],y					; store it
	rep #$20						; 16-bit A
.7:									; decrement d4, if d4 still >= 0 go to .3, ...
	dec.b d4						; next slot
	bpl .3
	lda.w #$0005					; 6 slots
	sta.b d4
.4:									; d3 = [a4],y & $00FF, if not zero go to .t1x, ...
	ldy.b d4
	lda.b [a4],y					; list entry
	and.w #$00FF
	sta.b d3						; player number
	bne .t1x
	jmp.w .5

.t1x:								; and #$00FF, if zero go to .1xx, ...
	and.w #$00FF
	bit.w #$0080
	beq .1xx
	ora.w #$FF00
.1xx:								; decrement a, asl a, d3 = A, ...
	dec a							; player index
	asl a
	sta.b d3
	lda.b a2
	beq .2x
	lda.w #$0034					; second team offset
.2x:								; adc d3, if tmpdst,y = $FFFD go to .3x, ...
	clc
	adc.b d3						; plus the player index
	tay
	lda.w tmpdst,y					; player state
	cmp.w #$FFFD
	beq .3x
	cmp.w #$FFFC
	beq .3x
	lda.w tmpdst,y
	bmi .5
	beq .5
.3x:								; call GetTeamLines, a1+2 = a3+2, a1 = a3, ...
	lda.b a3+2
	pha
	lda.b a3
	pha
	jsl.l GetTeamLines
	lda.b a3+2
	sta.b a1+2
	lda.b a3
	sta.b a1
	pla
	sta.b a3
	pla
	sta.b a3+2
	lda.b d4						; slot
	clc
	adc.w #$0006					; entry offset
	tay
	lda.b [a4],y					; wanted position
	and.w #$00FF
	asl a
	sta.b d0
	lda.w #sublist>>16
	sta.b a0+2
	lda.w #sublist
	sta.b a0
	ldy.b d0
	lda.b [a0],y					; offset of the list
	clc
	adc.b a0
	sta.b a0
.loop:								; next substitute position from sublist
	lda.b [a0]						; next candidate position
	inc.b a0
	and.w #$00FF
	sta.b d0
	bit.w #$0080					; $80: try everyone
	bne .6
	ldy.b d0						; roster index
	lda.b [a1],y					; player from the line sets
	and.w #$00FF
	sta.b d0
	jsl.l TryAddPlayerToList		; try to add him
	beq .loop
.5:									; decrement d4, if d4 counted below 0 go to .t1xx, ...
	dec.b d4
	bmi .t1xx
	jmp.w .4

.t1xx:								; d4 counted below 0: return
	rtl
.6:									; call GetPlayerCount, d3 = d0
	jsl.l GetPlayerCount			; GetPlayerCount
	lda.b d0						; player count
	sta.b d3
.loopx:								; try the previous slot
	lda.b d3
	sta.b d0
	dec.b d3
	bmi .5
	jsl.l TryAddPlayerToList
	beq .loopx
	bra .5
