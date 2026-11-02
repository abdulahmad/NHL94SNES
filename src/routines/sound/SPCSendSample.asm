; Sound driver command $03: send a sample of X bytes from [p0] to the sound CPU, with loop point Y (the next
; sample slot). Each byte goes through APUIO2 and is acknowledged on APUIO1
; Takes X = number of bytes, Y = loop point, p0 = long pointer to the sample. Returns with 16-bit A.
;
; Called from SPCUploadBlock.
SPCSendSample:						; send one sample to the sound CPU
	sep #$20
.wait:								;wait for the driver to be idle
	lda.w APUIO0
	bne .wait
	sty.w APUIO2					;the loop point
	lda.b #$03
	sta.w APUIO0					;command 3
	stz.w APUIO1
.ack:								;wait for the command to be acknowledged
	cmp.w APUIO0
	bne .ack
	ldy.w #$0000					;byte counter
.loop:								;send the sample bytes
	lda.b [p0],y
	sta.w APUIO2					;the byte
	iny
	tya
	sta.w APUIO1					;the count of bytes sent, low byte
.ackbyte:							;wait until the driver echoes the count
	cmp.w APUIO1
	bne .ackbyte
	nop
	nop
	nop
	dex								;X bytes left
	bne .loop
	stz.w APUIO0					;the command is finished
	rep #$20
	rtl
