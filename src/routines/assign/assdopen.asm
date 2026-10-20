; Assignment: put the player in the penalty box
; Takes: X = player object. Called through asstab (assignment $0E).
; Adds the player to PBnum (one in the byte for the visitors, $10 for the home team), clears his
; position and shows the sprite frame of a man sitting in the box.
assdopen:							; assignment: sit in the penalty box
	lda.w #$0010					; home team count unit
	sta.b d0
	lda.w pfteam,x					; visitors?
	beq .1
	lda.w #$0001					; visitors count unit
	sta.b d0
.1:									; add to the box count
	lda.w PBnum
	clc
	adc.b d0
	sta.w PBnum
	lda.w #$FFFF					; position -1: not in the game
	sta.w position,x
	lda.w sfhormode					; rink drawn vertically or horizontally
	bne .t1
	lda.w #SPFPen+8					; sitting in the box (vertical rink)
	sta.w frame,x
	bra .2

.t1:								; horizontal rink: frame 7
	lda.w #SPFPen+7					; sitting in the box (horizontal rink)
	sta.w frame,x
.2:									; done
	rtl
