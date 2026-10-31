; Draw sprite frame sprframe at sprx / spry
addframe:							; draw SpriteFrames frame sprframe (at most $3D0) at sprx, spry
	lda.w sprframe
	cmp.w #$03D1
	bcs .rtl
	lda.w #SpriteFrames>>16
	sta.b p1+2
	lda.w #SpriteFrames
	sta.b p1
	lda.w sprhflip
	beq .1
	lda.w #$4000
	tsb.w sprattr
.1:									; if sprvflip = 0 go to .2, ...
	lda.w sprvflip
	beq .2
	lda.w #$8000
	tsb.w sprattr
.2:									; if a still >= 0 go to .3, ...
	lda.w sprframe
	dec a
	bpl .3
	lda.w #$0000
.3:									; if carry clear go to .4, ...
	cmp.w #$03D0
	bcc .4
	lda.w #$03D0
.4:									; r0 = A, call DrawSprite
	sta.b r0
	lda.w sprattr
	ldx.w sprx
	ldy.w spry
	jsl.l DrawSprite
org $9BC001
.rtl:								; return
	rtl
