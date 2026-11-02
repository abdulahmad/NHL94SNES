; LZ data at [p0] (after its header) to WRAM
DecompressLZ:						;EA RefPack-style LZ from [p0] to WMDATA (WRAM port set to p1 by the
									;caller); called from Decompress
	lda.b p1						;output address
	sta.b LZOutAddr					;tracks the WRAM write position
	lda.b p1+2						;output bank
	sta.b LZCopySrc+2				;copies read back from it
	stz.b LZCmd
	stz.b LZCmdByte2
	stz.b LZCmdByte3
	stz.b LZLenLo
	sep #$20
	ldy.w #$0005					;skip the 5-byte header
.2:									;next command byte
	lda.b [p0],y					;command
	iny
	sta.b LZCmd
	and.b #$80						;bit 7?
	beq .t1							;clear: 2-byte command
	jmp.w .t3						;set: longer forms

.t1:								;2-byte command 0DDLLLPP: P literals, then copy L+3 from distance DD:byte2
									;+ 1
	lda.b [p0],y					;byte 2
	iny
	sta.b LZCmdByte2				;distance low
	lda.b LZCmd
	rep #$20						;command
	and.w #$0003					;literal count 0-3
	beq .1							;none
	tax								;count
	clc
	adc.b LZOutAddr					;advanced past them
	sta.b LZOutAddr
	sep #$20
.loop:								;copy the literals
	lda.b [p0],y
	iny
	sta.w WMDATA					;to WRAM
	dex
	bne .loop
.1:									;the back-reference
	rep #$20
	lda.b LZCmd
	and.w #$0060					;distance high bits 5-6
	asl a							;to bits 8-9
	asl a
	asl a
	clc
	adc.b LZCmdByte2				;plus the low byte
	sta.b LZDistance				;distance
	lda.b LZOutAddr
	clc
	sbc.b LZDistance				;minus distance + 1
	sta.b LZCopySrc					;copy source
	lda.b LZCmd
	and.w #$001C					;length bits 2-4
	lsr a							;length
	lsr a
	clc
	adc.w #$0003					;plus 3
	tax								;count
	clc
	adc.b LZOutAddr					;advanced past it
	sta.b LZOutAddr
	sty.b LZSrcIdx					;save the input index
	ldy.w #$0000					;from the copy source
	sep #$20
.loop2:								;copy from earlier output
	lda.b [LZCopySrc],y
	iny
	sta.w WMDATA					;to WRAM
	dex
	bne .loop2
	ldy.b LZSrcIdx					;input index
	jmp.w .2						;next command

.t3:								;10xxxxxx or 11xxxxxx?
	lda.b LZCmd
	and.b #$40						;bit 6?
	beq .t1x						;clear: 3-byte command
	jmp.w .t2						;set: 4-byte or literal

.t1x:								;3-byte command 10LLLLLL PPDDDDDD DDDDDDDD: P literals, copy L+4
	lda.b [p0],y					;byte 2
	iny
	sta.b LZCmdByte2				;literals and distance high
	lda.b [p0],y					;byte 3
	iny
	sta.b LZCmdByte3				;distance low
	rep #$20
	lda.b LZCmdByte2				;byte 2
	asl a							;top 2 bits
	asl a
	xba								;to the low byte
	and.w #$0003					;literal count
	beq .1x							;none
	tax								;count
	clc
	adc.b LZOutAddr					;advanced
	sta.b LZOutAddr
	sep #$20
.loopx:								;copy the literals
	lda.b [p0],y
	iny
	sta.w WMDATA					;to WRAM
	dex
	bne .loopx
.1x:								;distance
	rep #$20
	lda.b LZCmdByte2
	and.w #$003F					;14 bits
	xba								;high byte
	clc
	adc.b LZCmdByte3				;plus the low byte
	sta.b LZDistance				;distance
	lda.b LZOutAddr					;output position
	clc
	sbc.b LZDistance				;minus distance + 1
	sta.b LZCopySrc					;copy source
	lda.b LZCmd						;command
	and.w #$003F					;length bits 0-5
	clc
	adc.w #$0004					;plus 4
	tax								;count
	clc
	adc.b LZOutAddr					;advanced
	sta.b LZOutAddr
	sep #$20
	sty.b LZSrcIdx					;save the input index
	ldy.w #$0000					;from the copy source
.loop2x:							; loop: Y + 1, WMDATA = [LZCopySrc],y, X - 1, ...
	lda.b [LZCopySrc],y				;copy from earlier output
	iny
	sta.w WMDATA					;to WRAM
	dex
	bne .loop2x
	ldy.b LZSrcIdx					;input index
	jmp.w .2						;next command

.t2:								;110xxxxx or 111xxxxx?
	lda.b LZCmd
	and.b #$20						;bit 5?
	beq .t1xx						;clear: 4-byte command
	jmp.w .4						;set: literal run

.t1xx:								;4-byte command 110xLLPP: P literals, distance from bytes 2-3, copy
									;LL:byte4 + 5
	lda.b LZCmd
	rep #$20
	and.w #$0003					;literal count
	tax
	clc
	adc.b LZOutAddr					;advanced
	sta.b LZOutAddr
	lda.b [p0],y					;bytes 2 and 3
	xba								;byte 2 high
	sta.b LZDistance				;distance
	iny
	iny
	sep #$20
	lda.b [p0],y					;byte 4
	iny
	sta.b LZLenLo					;length low
	txa								;literals?
	beq .1xx						;none
.loopxx:							;copy the literals
	lda.b [p0],y
	iny
	sta.w WMDATA					;to WRAM
	dex
	bne .loopxx
.1xx:								; LZCopySrc = LZOutAddr - LZDistance, xba, adc LZLenLo, ...
	rep #$20
	clc
	lda.b LZOutAddr
	sbc.b LZDistance				;minus distance + 1
	sta.b LZCopySrc					;copy source
	lda.b LZCmd
	and.w #$000C					;length bits 2-3
	lsr a
	lsr a
	xba								;to bits 8-9
	clc
	adc.b LZLenLo					;plus the low byte
	adc.w #$0005					;plus 5
	tax								;count
	clc
	adc.b LZOutAddr					;advanced
	sta.b LZOutAddr
	sep #$20
	sty.b LZSrcIdx					;save the input index
	ldy.w #$0000					;from the copy source
.3:									; loop: Y + 1, WMDATA = [LZCopySrc],y, X - 1, ...
	lda.b [LZCopySrc],y				;copy from earlier output
	iny
	sta.w WMDATA					;to WRAM
	dex
	bne .3
	ldy.b LZSrcIdx					;input index
	jmp.w .2						;next command
.4:									;111LLLLL: (L+1)*4 literals, or the end
	lda.b LZCmd
	and.b #$1F						;count bits
	asl a
	asl a							;x4
	adc.b #$04						;plus 4
	cmp.b #$71						;more than $70: end code
	bcs .t1xxx
	rep #$20						;count
	and.w #$00FF
	tax
	clc
	adc.b LZOutAddr					;advanced
	sta.b LZOutAddr
	sep #$20
.loopxxx:							;copy the literals
	lda.b [p0],y
	iny
	sta.w WMDATA					;to WRAM
	dex
	bne .loopxxx
	jmp.w .2						;next command

.t1xxx:								;end code 111111PP: P final literals
	lda.b LZCmd
	rep #$20
	and.w #$0003					;literal count
	beq .1xxx						;none
	tax
	clc
	adc.b LZOutAddr					;advanced
	sta.b LZOutAddr
	sep #$20
.loopxxxx:							;copy the literals
	lda.b [p0],y
	iny
	sta.w WMDATA					;to WRAM
	dex
	bne .loopxxxx
.1xxx:								; return
	rep #$20
	rts
