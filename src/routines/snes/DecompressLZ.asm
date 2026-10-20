; LZ data at [p0] (after its header) to WRAM
DecompressLZ:						; called from Decompress
	lda.b p1
	sta.b LZOutAddr
	lda.b p1+2
	sta.b LZCopySrc+2
	stz.b LZCmd
	stz.b LZCmdByte2
	stz.b LZCmdByte3
	stz.b LZLenLo
	sep #$20
	ldy.w #$0005
.2:									; Y + 1, LZCmd = [p0],y, if zero go to .t1, ...
	lda.b [p0],y
	iny
	sta.b LZCmd
	and.b #$80
	beq .t1
	jmp.w .t3

.t1:								; Y + 1, LZCmdByte2 = [p0],y, if zero go to .1, ...
	lda.b [p0],y
	iny
	sta.b LZCmdByte2
	lda.b LZCmd
	rep #$20
	and.w #$0003
	beq .1
	tax
	clc
	adc.b LZOutAddr
	sta.b LZOutAddr
	sep #$20
.loop:								; loop: Y + 1, WMDATA = [p0],y, X - 1, ...
	lda.b [p0],y
	iny
	sta.w WMDATA
	dex
	bne .loop
.1:									; LZDistance = LZCmd & $0060 * 2 * 2 * 2 + LZCmdByte2, LZCopySrc = LZOu...
	rep #$20
	lda.b LZCmd
	and.w #$0060
	asl a
	asl a
	asl a
	clc
	adc.b LZCmdByte2
	sta.b LZDistance
	lda.b LZOutAddr
	clc
	sbc.b LZDistance
	sta.b LZCopySrc
	lda.b LZCmd
	and.w #$001C
	lsr a
	lsr a
	clc
	adc.w #$0003
	tax
	clc
	adc.b LZOutAddr
	sta.b LZOutAddr
	sty.b LZSrcIdx
	ldy.w #$0000
	sep #$20
.loop2:								; loop: Y + 1, WMDATA = [LZCopySrc],y, X - 1, ...
	lda.b [LZCopySrc],y
	iny
	sta.w WMDATA
	dex
	bne .loop2
	ldy.b LZSrcIdx
	jmp.w .2

.t3:								; if LZCmd & $40 = 0 go to .t1x, ...
	lda.b LZCmd
	and.b #$40
	beq .t1x
	jmp.w .t2

.t1x:								; LZCmd & $40 = 0: Y + 1, LZCmdByte2 = [p0],y, Y + 1, ...
	lda.b [p0],y
	iny
	sta.b LZCmdByte2
	lda.b [p0],y
	iny
	sta.b LZCmdByte3
	rep #$20
	lda.b LZCmdByte2
	asl a
	asl a
	xba
	and.w #$0003
	beq .1x
	tax
	clc
	adc.b LZOutAddr
	sta.b LZOutAddr
	sep #$20
.loopx:								; loop: Y + 1, WMDATA = [p0],y, X - 1, ...
	lda.b [p0],y
	iny
	sta.w WMDATA
	dex
	bne .loopx
.1x:								; xba, adc LZCmdByte3, LZDistance = A, ...
	rep #$20
	lda.b LZCmdByte2
	and.w #$003F
	xba
	clc
	adc.b LZCmdByte3
	sta.b LZDistance
	lda.b LZOutAddr
	clc
	sbc.b LZDistance
	sta.b LZCopySrc
	lda.b LZCmd
	and.w #$003F
	clc
	adc.w #$0004
	tax
	clc
	adc.b LZOutAddr
	sta.b LZOutAddr
	sep #$20
	sty.b LZSrcIdx
	ldy.w #$0000
.loop2x:							; loop: Y + 1, WMDATA = [LZCopySrc],y, X - 1, ...
	lda.b [LZCopySrc],y
	iny
	sta.w WMDATA
	dex
	bne .loop2x
	ldy.b LZSrcIdx
	jmp.w .2

.t2:								; if LZCmd & $20 = 0 go to .t1xx, ...
	lda.b LZCmd
	and.b #$20
	beq .t1xx
	jmp.w .4

.t1xx:								; LZCmd & $20 = 0: LZOutAddr = LZCmd & $0003 + LZOutAddr, xba, LZDistan...
	lda.b LZCmd
	rep #$20
	and.w #$0003
	tax
	clc
	adc.b LZOutAddr
	sta.b LZOutAddr
	lda.b [p0],y
	xba
	sta.b LZDistance
	iny
	iny
	sep #$20
	lda.b [p0],y
	iny
	sta.b LZLenLo
	txa
	beq .1xx
.loopxx:							; loop: Y + 1, WMDATA = [p0],y, X - 1, ...
	lda.b [p0],y
	iny
	sta.w WMDATA
	dex
	bne .loopxx
.1xx:								; LZCopySrc = LZOutAddr - LZDistance, xba, adc LZLenLo, ...
	rep #$20
	clc
	lda.b LZOutAddr
	sbc.b LZDistance
	sta.b LZCopySrc
	lda.b LZCmd
	and.w #$000C
	lsr a
	lsr a
	xba
	clc
	adc.b LZLenLo
	adc.w #$0005
	tax
	clc
	adc.b LZOutAddr
	sta.b LZOutAddr
	sep #$20
	sty.b LZSrcIdx
	ldy.w #$0000
.3:									; loop: Y + 1, WMDATA = [LZCopySrc],y, X - 1, ...
	lda.b [LZCopySrc],y
	iny
	sta.w WMDATA
	dex
	bne .3
	ldy.b LZSrcIdx
	jmp.w .2
.4:									; if carry set go to .t1xxx, ...
	lda.b LZCmd
	and.b #$1F
	asl a
	asl a
	adc.b #$04
	cmp.b #$71
	bcs .t1xxx
	rep #$20
	and.w #$00FF
	tax
	clc
	adc.b LZOutAddr
	sta.b LZOutAddr
	sep #$20
.loopxxx:							; loop: Y + 1, WMDATA = [p0],y, X - 1, ...
	lda.b [p0],y
	iny
	sta.w WMDATA
	dex
	bne .loopxxx
	jmp.w .2

.t1xxx:								; if zero go to .1xxx, ...
	lda.b LZCmd
	rep #$20
	and.w #$0003
	beq .1xxx
	tax
	clc
	adc.b LZOutAddr
	sta.b LZOutAddr
	sep #$20
.loopxxxx:							; loop: Y + 1, WMDATA = [p0],y, X - 1, ...
	lda.b [p0],y
	iny
	sta.w WMDATA
	dex
	bne .loopxxxx
.1xxx:								; return
	rep #$20
	rts
