; Wait until the DMA queue is empty ($3A = $3C)
; Takes nothing. Spins until the DMA queue head (DMAQueueHead) equals its tail (DMAQueueTail).
; The code after the rtl (.t1 to .t1xxxx) are waits for a button with a frame timeout; nothing calls them.
;
; Called from DrawPeriodStats and Decompress.
WaitDMAQueue:						; wait until the DMA queue is empty
	pha
.loop:								; queue head equals tail?
	lda.b DMAQueueHead
	cmp.b DMAQueueTail
	bne .loop
	pla
	rtl

.t1:								; unused: wait X frames (Y rounds) for any button on pad 1
	iny
.1:									; wait a frame
	jsl.l WaitFrame
	dex
	bne .t1x
	dey
	bne .t1x
	lda.w #$0000
	rtl

.t1x:								; button on pad 1?
	lda.w JoyPad
	beq .1
	rtl

.t2:								; unused: the same for pad 2
	iny
.2:									; wait a frame
	jsl.l WaitFrame
	dex
	bne .t1xx
	dey
	bne .t1xx
	lda.w #$0000
	rtl

.t1xx:								; button on pad 2?
	lda.w JoyPad+2
	beq .2
	rtl

.t2x:								; unused: wait for a button of mask A on pad 1
	sta.b r3
	iny
.3:									; wait a frame
	jsl.l WaitFrame
	dex
	bne .t1xxx
	dey
	bne .t1xxx
	lda.w #$0000
	rtl

.t1xxx:								; masked buttons of pad 1?
	lda.w JoyPad
	and.b r3
	beq .3
	rtl

.t2xx:								; unused: wait for a button of mask A on pad 2
	sta.b r3
	iny
.4:									; wait a frame
	jsl.l WaitFrame
	dex
	bne .t1xxxx
	dey
	bne .t1xxxx
	lda.w #$0000
	rtl

.t1xxxx:							; masked buttons of pad 2?
	lda.w JoyPad+2
	and.b r3
	beq .4
	rtl
