; Assignment: skate to the side of the screen holding the Stanley Cup overhead
; Takes: X = player object. Called through asstab (assignment 9). Each player skates to a spot at the side
; of the screen (x +-90, y the scroll y), turns to face (vtoa) and holds the cup up (SPAstanley).
assstanley:							; assignment: Stanley Cup celebration
	lda.w pflags,x					; player flags
	bit.w #pfna						; first frame of the assignment (pfna)?
	beq .2
	and.w #$FFFD					; clear pfna
	sta.w pflags,x
	lda.w #$005A					; x target 90
	sta.w temp3,x
	lda.w Hpos						; scroll side
	bpl .1							; right half
	lda.w #$FFA6					; left side: -90
	sta.w temp3,x
.1:									; y target is the scroll y
	lda.w Vpos						; camera y
	sta.w temp4,x					; target y
	lda.w #SPAstanley				; celebration animation, locked
	sta.w pfalock,x
	jsl.l SetSPAFromA				; start the animation
.2:									; vector to the target
	lda.w temp3,x					; dx and dy to the spot
	sec
	sbc.w Xpos,x					; minus x
	sta.b d0
	lda.w temp4,x					; target y
	sec
	sbc.w Ypos,x					; minus y
	sta.b d1
	jsl.l vtoa						; vtoa: turn the vector into direction and size (probably)
	lda.b d0
	cmp.w #$0008					; d0 is 8 or more: not there yet, return
	bpl .t1
	lda.b d0						; arrived: face the direction from vtoa
	sta.b d2
	sta.w facedir,x					; facing
	lda.w #$0014					; lock 20 frames
	sta.w pfalock,x
	jmp.w playeracc					; stand still

.t1:								; return
	rtl
