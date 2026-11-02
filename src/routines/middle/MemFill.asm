; Fill X bytes at [p1] with the word A
MemFill:							; called from ClearBigText, ClearPictureBox, ClearTextMap, ClearTextMap...
	txy
	dey
	dey
.loop:								; loop: [p1],y = A, Y - 1, Y - 1, ...
	sta.b [p1],y
	dey
	dey
	bne .loop
	sta.b [p1]
	rtl

.t1:								; r3 = A, txy, Y - 1, ...
	sta.b r3
	txy
	dey
	dey
.loopx:								; loop: [p1],y = [p1],y + r3, Y - 1, Y - 1, ...
	lda.b [p1],y
	clc
	adc.b r3
	sta.b [p1],y
	dey
	dey
	bne .loopx
	lda.b [p1]
	clc
	adc.b r3
	sta.b [p1]
	rtl
