; Draw sprite frame $0CCD at $0CCF / $0CD1
addframe:							; draw SpriteFrames frame $0CCD (at most $3D0) at $0CCF, $0CD1
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
.1:
	lda.w sprvflip
	beq .2
	lda.w #$8000
	tsb.w sprattr
.2:
	lda.w sprframe
	dec a
	bpl .3
	lda.w #$0000
.3:
	cmp.w #$03D0
	bcc .4
	lda.w #$03D0
.4:
	sta.b r0
	lda.w sprattr
	ldx.w sprx
	ldy.w spry
	jsl.l DrawSprite
org $9BC001
.rtl:
	rtl
