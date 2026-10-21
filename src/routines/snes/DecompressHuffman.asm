; Huffman data at [p0] to WRAM at [p1]
DecompressHuffman:					; called from Decompress
	sep #$10
	lda.b p0
	clc
	adc.w #$0005
	sta.b p0
	lda.b (p0)
	sta.b HuffEscape
	inc.b p0
	lda.b (p0)
	inc.b p0
	inc.b p0
	xba
	sta.b HuffBits
	ldy.b #$08
	stz.b HuffSymCount
	stz.b HuffCode
	lda.w #$0010
	sta.b r3
	ldx.b #$FE
.2:									; loop: X + 1, X + 1, decrement r3, ...
	inx
	inx
	dec.b r3
	asl.b HuffCode
	lda.b HuffCode
	sec
	sbc.b HuffSymCount
	sta.w HuffOffset,x
	jsr.w .149
	sta.w HuffCount,x
	clc
	adc.b HuffSymCount
	sta.b HuffSymCount
	lda.b HuffNumber
	clc
	adc.b HuffCode
	sta.b HuffCode
	lda.b HuffNumber
	bne .t1
	stz.w HuffLimit,x
	bra .2

.t1:								; HuffNumber != 0: r0 = HuffCode, if zero go to .1
	lda.b HuffCode
	sta.b r0
	lda.b r3
	clc
	beq .1
.loop:								; loop: asl r0, decrement a, if a not yet 0 go to .loop
	asl.b r0
	dec a
	bne .loop
.1:									; HuffLimit,x = r0, if carry clear go to .2, ...
	lda.b r0
	sta.w HuffLimit,x
	bcc .2
	txa
	lsr a
	sta.b HuffMaxLen
	ldx.b #$3E
.loop2:								; loop: DecompTab1,x = 0, DecompTab1+$40,x = 0, DecompTab1+$80,x = 0, ...
	stz.w DecompTab1,x
	stz.w DecompTab1+$40,x
	stz.w DecompTab1+$80,x
	stz.w DecompTab1+$C0,x
	dex
	dex
	bpl .loop2
	ldx.b #$7E
	stx.w WMADDH
	lda.w #$0100
	sta.w WMADDL
	ldx.b #$FF
.loop3:								; loop: call .149, increment a
	jsr.w .149
	sep #$20
	inc a
.loop4:								; loop: X + 1, if minus go to .loop4, ...
	inx
	bit.w DecompTab1,x
	bmi .loop4
	dec a
	bne .loop4
	dec.w DecompTab1,x
	rep #$20
	stx.w WMDATA
	dec.b HuffSymCount
	bne .loop3
	tya
	asl a
	sta.b HuffStartBits
	sep #$20
	ldx.b #$00
	txy
	stz.b HuffLenIdx
.3:									; r0 = X, if zero go to .9, ...
	stx.b r0
	lda.b HuffLenIdx
	asl a
	tax
	cpx.b #$10
	beq .9
	lda.w HuffCount,x
	sta.b HuffSymCount
	ldx.b HuffLenIdx
	lda.l .4,x
	sta.b HuffSpan
	ldx.b r0
	bra .8
.4:									; lookup table entries for a code of each length, plus 1
	db $81,$41,$21,$11,$09,$05,$03,$02
.5:									; r0 = HuffLenIdx * 2, r0+1 = DecompBuf,y, Y + 1, ...
	lda.b HuffLenIdx
	asl a
	sta.b r0
	lda.w DecompBuf,y
	sta.b r0+1
	iny
	cmp.b HuffEscape
	bne .1x
	lda.b HuffLenIdx
	inc a
	sta.b HuffEscapeLen
	lda.b #$12
	sta.b r0
.1x:								; r1 = Y, go to .7
	sty.b r1
	ldy.b HuffSpan
	bra .7
.6:									; loop: Y not yet 0: DecompTab1,x = r0+1, DecompTab2,x = r0, X + 1
	lda.b r0+1
	sta.w DecompTab1,x
	lda.b r0
	sta.w DecompTab2,x
	inx
.7:									; Y - 1, if Y not yet 0 go to .6, ...
	dey
	bne .6
	ldy.b r1
.8:									; decrement HuffSymCount, if HuffSymCount still >= 0 go to .5, ...
	dec.b HuffSymCount
	bpl .5
	inc.b HuffLenIdx
	lda.b HuffMaxLen
	cmp.b HuffLenIdx
	bcs .3
	stx.b r0
.9:									; if r0 = 0 go to .1xx, ...
	ldx.b r0
	beq .1xx
	lda.b #$10
.loopx:								; loop: DecompTab2,x = A, X + 1, if not zero go to .loopx
	sta.w DecompTab2,x
	inx
	bne .loopx
.1xx:								; HuffLongVec = .10-$10,x, WMADDH = p1+2, WMADDL = p1, ...
	lda.b HuffMaxLen
	asl a
	tax
	rep #$20
	lda.l .10-$10,x					; by the longest code length, from 9 bits up
	sta.w HuffLongVec
	ldy.b p1+2
	sty.w WMADDH
	lda.b p1
	sta.w WMADDL
	lda.b HuffBits
	ldx.b HuffStartBits
	jmp (.11,x)
.10:								; dw .111,.112,.114,.115,.116,.117,.118,.119
	dw .111,.112,.114,.115,.116,.117,.118,.119
.11:								; dw $0000,.104,.92,.80,.68,.56,.44,.32,.20
	dw $0000,.104,.92,.80,.68,.56,.44,.32,.20
.12:								; asl a
	asl a
.13:								; asl a
	asl a
.14:								; asl a
	asl a
.15:								; asl a
	asl a
.16:								; asl a
	asl a
.17:								; asl a
	asl a
.18:								; asl a
	asl a
.19:								; asl a, increment p0, WMDATA = DecompTab1,y, ...
	asl a
	sep #$20
	lda.b (p0)
	rep #$20
	inc.b p0
	ldx.w DecompTab1,y
	stx.w WMDATA
	stx.b r2
.20:								; HuffBits = A, go to (.21,x)
	sta.b HuffBits
	ldy.b HuffBits+1
	ldx.w DecompTab2,y
	jmp (.21,x)
.21:								; dw .31,.42,.53,.64,.75,.86,.97,.12,.23,.22
	dw .31,.42,.53,.64,.75,.86,.97,.12,.23,.22
.22:								; go to .147
	ldx.b #$10
	jmp.w .147
.23:								; HuffBitsExt = 0, ora HuffBitsExt+1, HuffBitsExt+1 = A, ...
	ldx.b #$10
	stz.b HuffBitsExt
	lda.b (p0)
	and.w #$00FF
	ora.b HuffBitsExt+1
	sta.b HuffBitsExt+1
	lda.b HuffBits
	jmp.w (HuffLongVec)
.24:								; asl a
	asl a
.25:								; asl a
	asl a
.26:								; asl a
	asl a
.27:								; asl a
	asl a
.28:								; asl a
	asl a
.29:								; asl a
	asl a
.30:								; asl a, increment p0
	asl a
	sep #$20
	lda.b (p0)
	rep #$20
	inc.b p0
.31:								; asl a, WMDATA = DecompTab1,y, r2 = DecompTab1,y
	asl a
	ldx.w DecompTab1,y
	stx.w WMDATA
	stx.b r2
.32:								; HuffBits = A, go to (.33,x)
	sta.b HuffBits
	ldy.b HuffBits+1
	ldx.w DecompTab2,y
	jmp (.33,x)
.33:								; dw .43,.54,.65,.76,.87,.98,.13,.24,.35,.34
	dw .43,.54,.65,.76,.87,.98,.13,.24,.35,.34
.34:								; go to .147
	ldx.b #$0E
	jmp.w .147
.35:								; HuffBitsExt = 0, ora HuffBitsExt+1, HuffBitsExt+1 = A, ...
	ldx.b #$0E
	stz.b HuffBitsExt
	lda.b (p0)
	and.w #$00FF
	asl a
	ora.b HuffBitsExt+1
	sta.b HuffBitsExt+1
	lda.b HuffBits
	jmp.w (HuffLongVec)
.36:								; asl a
	asl a
.37:								; asl a
	asl a
.38:								; asl a
	asl a
.39:								; asl a
	asl a
.40:								; asl a
	asl a
.41:								; asl a, increment p0
	asl a
	sep #$20
	lda.b (p0)
	rep #$20
	inc.b p0
.42:								; asl a
	asl a
.43:								; asl a, WMDATA = DecompTab1,y, r2 = DecompTab1,y
	asl a
	ldx.w DecompTab1,y
	stx.w WMDATA
	stx.b r2
.44:								; HuffBits = A, go to (.45,x)
	sta.b HuffBits
	ldy.b HuffBits+1
	ldx.w DecompTab2,y
	jmp (.45,x)
.45:								; dw .55,.66,.77,.88,.99,.14,.25,.36,.47,.46
	dw .55,.66,.77,.88,.99,.14,.25,.36,.47,.46
.46:								; go to .147
	ldx.b #$0C
	jmp.w .147
.47:								; HuffBitsExt = 0, ora HuffBitsExt+1, HuffBitsExt+1 = A, ...
	ldx.b #$0C
	stz.b HuffBitsExt
	lda.b (p0)
	and.w #$00FF
	asl a
	asl a
	ora.b HuffBitsExt+1
	sta.b HuffBitsExt+1
	lda.b HuffBits
	jmp.w (HuffLongVec)
.48:								; asl a
	asl a
.49:								; asl a
	asl a
.50:								; asl a
	asl a
.51:								; asl a
	asl a
.52:								; asl a, increment p0
	asl a
	sep #$20
	lda.b (p0)
	rep #$20
	inc.b p0
.53:								; asl a
	asl a
.54:								; asl a
	asl a
.55:								; asl a, WMDATA = DecompTab1,y, r2 = DecompTab1,y
	asl a
	ldx.w DecompTab1,y
	stx.w WMDATA
	stx.b r2
.56:								; HuffBits = A, go to (.57,x)
	sta.b HuffBits
	ldy.b HuffBits+1
	ldx.w DecompTab2,y
	jmp (.57,x)
.57:								; dw .67,.78,.89,.100,.15,.26,.37,.48,.59,.58
	dw .67,.78,.89,.100,.15,.26,.37,.48,.59,.58
.58:								; go to .147
	ldx.b #$0A
	jmp.w .147
.59:								; HuffBitsExt = 0, ora HuffBitsExt+1, HuffBitsExt+1 = A, ...
	ldx.b #$0A
	stz.b HuffBitsExt
	lda.b (p0)
	and.w #$00FF
	asl a
	asl a
	asl a
	ora.b HuffBitsExt+1
	sta.b HuffBitsExt+1
	lda.b HuffBits
	jmp.w (HuffLongVec)
.60:								; asl a
	asl a
.61:								; asl a
	asl a
.62:								; asl a
	asl a
.63:								; asl a, increment p0
	asl a
	sep #$20
	lda.b (p0)
	rep #$20
	inc.b p0
.64:								; asl a
	asl a
.65:								; asl a
	asl a
.66:								; asl a
	asl a
.67:								; asl a, WMDATA = DecompTab1,y, r2 = DecompTab1,y
	asl a
	ldx.w DecompTab1,y
	stx.w WMDATA
	stx.b r2
.68:								; HuffBits = A, go to (.69,x)
	sta.b HuffBits
	ldy.b HuffBits+1
	ldx.w DecompTab2,y
	jmp (.69,x)
.69:								; dw .79,.90,.101,.16,.27,.38,.49,.60,.71,.70
	dw .79,.90,.101,.16,.27,.38,.49,.60,.71,.70
.70:								; go to .147
	ldx.b #$08
	jmp.w .147
.71:								; HuffBitsExt = 0, ora HuffBitsExt+1, HuffBitsExt+1 = A, ...
	ldx.b #$08
	stz.b HuffBitsExt
	lda.b (p0)
	and.w #$00FF
	asl a
	asl a
	asl a
	asl a
	ora.b HuffBitsExt+1
	sta.b HuffBitsExt+1
	lda.b HuffBits
	jmp.w (HuffLongVec)
.72:								; asl a
	asl a
.73:								; asl a
	asl a
.74:								; asl a, increment p0
	asl a
	sep #$20
	lda.b (p0)
	rep #$20
	inc.b p0
.75:								; asl a
	asl a
.76:								; asl a
	asl a
.77:								; asl a
	asl a
.78:								; asl a
	asl a
.79:								; asl a, WMDATA = DecompTab1,y, r2 = DecompTab1,y
	asl a
	ldx.w DecompTab1,y
	stx.w WMDATA
	stx.b r2
.80:								; HuffBits = A, go to (.81,x)
	sta.b HuffBits
	ldy.b HuffBits+1
	ldx.w DecompTab2,y
	jmp (.81,x)
.81:								; dw .91,.102,.17,.28,.39,.50,.61,.72,.83,.82
	dw .91,.102,.17,.28,.39,.50,.61,.72,.83,.82
.82:								; go to .147
	ldx.b #$06
	jmp.w .147
.83:								; HuffBitsExt = 0, ora HuffBitsExt+1, HuffBitsExt+1 = A, ...
	ldx.b #$06
	stz.b HuffBitsExt
	lda.b (p0)
	and.w #$00FF
	asl a
	asl a
	asl a
	asl a
	asl a
	ora.b HuffBitsExt+1
	sta.b HuffBitsExt+1
	lda.b HuffBits
	jmp.w (HuffLongVec)
.84:								; asl a
	asl a
.85:								; asl a, increment p0
	asl a
	sep #$20
	lda.b (p0)
	rep #$20
	inc.b p0
.86:								; asl a
	asl a
.87:								; asl a
	asl a
.88:								; asl a
	asl a
.89:								; asl a
	asl a
.90:								; asl a
	asl a
.91:								; asl a, WMDATA = DecompTab1,y, r2 = DecompTab1,y
	asl a
	ldx.w DecompTab1,y
	stx.w WMDATA
	stx.b r2
.92:								; HuffBits = A, go to (.93,x)
	sta.b HuffBits
	ldy.b HuffBits+1
	ldx.w DecompTab2,y
	jmp (.93,x)
.93:								; dw .103,.18,.29,.40,.51,.62,.73,.84,.95,.94
	dw .103,.18,.29,.40,.51,.62,.73,.84,.95,.94
.94:								; go to .147
	ldx.b #$04
	jmp.w .147
.95:								; HuffBitsExt = 0, ora HuffBitsExt+1, HuffBitsExt+1 = A, ...
	ldx.b #$04
	stz.b HuffBitsExt
	lda.b (p0)
	and.w #$00FF
	asl a
	asl a
	asl a
	asl a
	asl a
	asl a
	ora.b HuffBitsExt+1
	sta.b HuffBitsExt+1
	lda.b HuffBits
	jmp.w (HuffLongVec)
.96:								; asl a, increment p0
	asl a
	sep #$20
	lda.b (p0)
	rep #$20
	inc.b p0
.97:								; asl a
	asl a
.98:								; asl a
	asl a
.99:								; asl a
	asl a
.100:								; asl a
	asl a
.101:								; asl a
	asl a
.102:								; asl a
	asl a
.103:								; asl a, WMDATA = DecompTab1,y, r2 = DecompTab1,y
	asl a
	ldx.w DecompTab1,y
	stx.w WMDATA
	stx.b r2
.104:								; HuffBits = A, go to (.105,x)
	sta.b HuffBits
	ldy.b HuffBits+1
	ldx.w DecompTab2,y
	jmp (.105,x)
.105:								; dw .19,.30,.41,.52,.63,.74,.85,.96,.107,.106
	dw .19,.30,.41,.52,.63,.74,.85,.96,.107,.106
.106:								; go to .147
	ldx.b #$02
	jmp.w .147
.107:								; HuffBitsExt = 0, ora HuffBitsExt+1, HuffBitsExt+1 = A, ...
	ldx.b #$02
	stz.b HuffBitsExt
	lda.b (p0)
	and.w #$00FF
	asl a
	asl a
	asl a
	asl a
	asl a
	asl a
	asl a
	ora.b HuffBitsExt+1
	sta.b HuffBitsExt+1
	lda.b HuffBits
	jmp.w (HuffLongVec)
.108:								; lsr a, lsr a, lsr a, ...
	lsr a
	lsr a
	lsr a
	lsr a
	lsr a
	lsr a
	lsr a
	sec
	sbc.w HuffOffset+$10
	tay
	sep #$20
	lda.w DecompBuf,y
	ldy.b #$01
	cmp.b HuffEscape
	beq .110
	jmp.w .128
.109:								; lsr a, lsr a, lsr a, ...
	lsr a
	lsr a
	lsr a
	lsr a
	lsr a
	lsr a
	sec
	sbc.w HuffOffset+$12
	tay
	sep #$20
	lda.w DecompBuf,y
	ldy.b #$02
	cmp.b HuffEscape
	beq .110
	jmp.w .128
.110:								; go to .146
	jmp.w .146
.111:								; go to .108
	jmp.w .108
.112:								; if carry clear go to .108
	cmp.w HuffLimit+$10
	bcc .108
.113:								; go to .109
	jmp.w .109
.114:								; if carry clear go to .108, ...
	cmp.w HuffLimit+$10
	bcc .108
	cmp.w HuffLimit+$12
	bcc .109
	jmp.w .120
.115:								; if carry clear go to .108, ...
	cmp.w HuffLimit+$10
	bcc .108
	cmp.w HuffLimit+$12
	bcc .109
	cmp.w HuffLimit+$14
	bcc .120
	jmp.w .121
.116:								; if carry clear go to .108, ...
	cmp.w HuffLimit+$10
	bcc .108
	cmp.w HuffLimit+$12
	bcc .109
	cmp.w HuffLimit+$14
	bcc .120
	cmp.w HuffLimit+$16
org $80C001
	bcc .121
	jmp.w .124
.117:								; if carry clear go to .108, ...
	cmp.w HuffLimit+$10
	bcc .108
	cmp.w HuffLimit+$12
	bcc .109
	cmp.w HuffLimit+$14
	bcc .120
	cmp.w HuffLimit+$16
	bcc .121
	cmp.w HuffLimit+$18
	bcc .124
	jmp.w .125
.118:								; if carry clear go to .111, ...
	cmp.w HuffLimit+$10
	bcc .111
	cmp.w HuffLimit+$12
	bcc .113
	cmp.w HuffLimit+$14
	bcc .120
	cmp.w HuffLimit+$16
	bcc .121
	cmp.w HuffLimit+$18
	bcc .124
	cmp.w HuffLimit+$1A
	bcc .125
	jmp.w .126
.119:								; if carry clear go to .123, ...
	cmp.w HuffLimit+$10
	bcc .123
	cmp.w HuffLimit+$12
	bcc .113
	cmp.w HuffLimit+$14
	bcc .120
	cmp.w HuffLimit+$16
	bcc .121
	cmp.w HuffLimit+$18
	bcc .124
	cmp.w HuffLimit+$1A
	bcc .125
	cmp.w HuffLimit+puckobj
	bcc .126
	jmp.w .127
.120:								; lsr a, lsr a, lsr a, ...
	lsr a
	lsr a
	lsr a
	lsr a
	lsr a
	sec
	sbc.w HuffOffset+$14
	tay
	sep #$20
	lda.w DecompBuf,y
	ldy.b #$03
	cmp.b HuffEscape
	beq .122
	bra .128
.121:								; lsr a, lsr a, lsr a, ...
	lsr a
	lsr a
	lsr a
	lsr a
	sec
	sbc.w HuffOffset+$16
	tay
	sep #$20
	lda.w DecompBuf,y
	ldy.b #$04
	cmp.b HuffEscape
	beq .122
	bra .128
.122:								; go to .146
	jmp.w .146
.123:								; go to .108
	jmp.w .108
.124:								; lsr a, lsr a, lsr a, ...
	lsr a
	lsr a
	lsr a
	sec
	sbc.w HuffOffset+$18
	tay
	sep #$20
	lda.w DecompBuf,y
	ldy.b #$05
	cmp.b HuffEscape
	beq .122
	bra .128
.125:								; lsr a, lsr a, sbc HuffOffset+$1A, ...
	lsr a
	lsr a
	sec
	sbc.w HuffOffset+$1A
	tay
	sep #$20
	lda.w DecompBuf,y
	ldy.b #$06
	cmp.b HuffEscape
	beq .122
	bra .128
.126:								; lsr a, sbc HuffOffset+puckobj, if $07 = HuffEscape go to .122, ...
	lsr a
	sec
	sbc.w HuffOffset+puckobj
	tay
	sep #$20
	lda.w DecompBuf,y
	ldy.b #$07
	cmp.b HuffEscape
	beq .122
	bra .128
.127:								; sbc HuffOffset+$1E, if $08 = HuffEscape go to .146
	sec
	sbc.w HuffOffset+$1E
	tay
	sep #$20
	lda.w DecompBuf,y
	ldy.b #$08
	cmp.b HuffEscape
	beq .146
.128:								; WMDATA = A, r2 = A, increment p0, ...
	sta.w WMDATA
	sta.b r2
	rep #$20
	inc.b p0
	lda.b HuffBitsExt+1
	jmp (.129-2,x)
.129:								; dw .137,.136,.135,.134,.133,.132,.131,.130
	dw .137,.136,.135,.134,.133,.132,.131,.130
.130:								; asl a, Y - 1, if Y counted to 0 go to .144
	asl a
	dey
	beq .144
.131:								; asl a, Y - 1, if Y counted to 0 go to .143
	asl a
	dey
	beq .143
.132:								; asl a, Y - 1, if Y counted to 0 go to .142
	asl a
	dey
	beq .142
.133:								; asl a, Y - 1, if Y counted to 0 go to .141
	asl a
	dey
	beq .141
.134:								; asl a, Y - 1, if Y counted to 0 go to .140
	asl a
	dey
	beq .140
.135:								; asl a, Y - 1, if Y counted to 0 go to .139
	asl a
	dey
	beq .139
.136:								; asl a, Y - 1, if Y counted to 0 go to .138
	asl a
	dey
	beq .138
.137:								; asl a, increment p0, Y - 1, ...
	asl a
	sep #$20
	lda.b (p0)
	rep #$20
	inc.b p0
	dey
	beq .145
	asl a
	dey
	beq .144
	asl a
	dey
	beq .143
	asl a
	dey
	beq .142
	asl a
	dey
	beq .141
.1xxx:								; asl a, Y - 1, if Y counted to 0 go to .140, ...
	asl a
	dey
	beq .140
	asl a
	dey
	beq .139
	asl a
.138:								; go to .104
	jmp.w .104
.139:								; go to .92
	jmp.w .92
.140:								; go to .80
	jmp.w .80
.141:								; go to .68
	jmp.w .68
.142:								; go to .56
	jmp.w .56
.143:								; go to .44
	jmp.w .44
.144:								; go to .32
	jmp.w .32
.145:								; Y counted to 0: go to .20
	jmp.w .20
.146:								; increment p0, call .152, HuffBits = A, ...
	rep #$20
	inc.b p0
	lda.b HuffBitsExt+1
	jsr.w .152
	sta.b HuffBits
	jsr.w .150
	beq .148
	ldy.b r2
.loopxx:							; loop: WMDATA = Y, decrement a, if a not yet 0 go to .loopxx, ...
	sty.w WMDATA
	dec a
	bne .loopxx
	lda.b HuffBits
	jmp (.11,x)
.147:								; call .152, HuffBits = A, call .150, ...
	ldy.b HuffEscapeLen
	jsr.w .152
	sta.b HuffBits
	jsr.w .150
	beq .148
	ldy.b r2
.loopxxx:							; loop: WMDATA = Y, decrement a, if a not yet 0 go to .loopxxx, ...
	sty.w WMDATA
	dec a
	bne .loopxxx
	lda.b HuffBits
	jmp (.11,x)
.148:								; if HuffBits negative go to .t1x, ...
	lda.b HuffBits
	bmi .t1x
	ldy.b #$01
	jsr.w .152
	sta.b HuffBits
	ldy.b HuffBits+1
	sty.w WMDATA
	sty.b r2
	ldy.b #$08
	jsr.w .152
	jmp (.11,x)

.t1x:								; HuffBits negative: return
	rts
.149:								; subroutine: HuffNumber = 0, Y - 1, if Y counted to 0 go to .3x
	stz.b HuffNumber
	lda.b HuffBits
	asl a
	dey
	beq .3x
.1xxxx:								; if carry clear go to .7x, ...
	bcc .7x
	asl a
	rol.b HuffNumber
	dey
	beq .4x
.2x:								; asl a, rol HuffNumber, Y - 1, ...
	asl a
	rol.b HuffNumber
	dey
	beq .5x
	sta.b HuffBits
	lda.b HuffNumber
	rts
.3x:								; Y counted to 0: increment p0, go to .1xxxx
	sep #$20
	lda.b (p0)
	rep #$20
	inc.b p0
	ldy.b #$08
	bra .1xxxx
.4x:								; Y counted to 0: increment p0, go to .2x
	sep #$20
	lda.b (p0)
	rep #$20
	inc.b p0
	ldy.b #$08
	bra .2x
.5x:								; Y counted to 0: increment p0, HuffBits = (p0), return
	sep #$20
	lda.b (p0)
	rep #$20
	inc.b p0
	ldy.b #$08
	sta.b HuffBits
	lda.b HuffNumber
	rts
.7x:								; r0 = X
	stx.b r0
	ldx.b #$02
.1xxxxx:							; loop: asl a, Y - 1, if Y counted to 0 go to .5xx
	asl a
	dey
	beq .5xx
.2xx:								; X + 1, if carry clear go to .1xxxxx, ...
	inx
	bcc .1xxxxx
	stx.b r1
.3xx:								; loop: asl a, rol HuffNumber, Y - 1, ...
	asl a
	rol.b HuffNumber
	dey
	beq .6x
.4xx:								; X - 1, if X not yet 0 go to .3xx, ...
	dex
	bne .3xx
	sta.b HuffBits
	asl.b r1
	ldx.b r1
	lda.l .151-4,x
	ldx.b r0
	clc
	adc.b HuffNumber
	sta.b HuffNumber
	rts
.5xx:								; Y counted to 0: increment p0, go to .2xx
	sep #$20
	lda.b (p0)
	rep #$20
	inc.b p0
	ldy.b #$08
	bra .2xx
.6x:								; Y counted to 0: increment p0, go to .4xx
	sep #$20
	lda.b (p0)
	rep #$20
	inc.b p0
	ldy.b #$08
	bra .4xx
.150:								; subroutine: HuffNumber = 0, X - 1, X - 1, ...
	stz.b HuffNumber
	lda.b HuffBits
	asl a
	dex
	dex
	beq .3xxx
.1xxxxxx:							; if carry clear go to .7xx, ...
	bcc .7xx
	asl a
	rol.b HuffNumber
	dex
	dex
	beq .4xxx
.2xxx:								; asl a, rol HuffNumber, X - 1, ...
	asl a
	rol.b HuffNumber
	dex
	dex
	beq .5xxx
	sta.b HuffBits
	lda.b HuffNumber
	rts
.3xxx:								; X counted to 0: increment p0, go to .1xxxxxx
	sep #$20
	lda.b (p0)
	rep #$20
	inc.b p0
	ldx.b #$10
	bra .1xxxxxx
.4xxx:								; X counted to 0: increment p0, go to .2xxx
	sep #$20
	lda.b (p0)
	rep #$20
	inc.b p0
	ldx.b #$10
	bra .2xxx
.5xxx:								; X counted to 0: increment p0, HuffBits = (p0), return
	sep #$20
	lda.b (p0)
	rep #$20
	inc.b p0
	ldx.b #$10
	sta.b HuffBits
	lda.b HuffNumber
	rts
.7xx:								; falls through
	ldy.b #$02
.1xxxxxxx:							; loop: asl a, X - 1, X - 1, ...
	asl a
	dex
	dex
	beq .5xxxx
.2xxxx:								; Y + 1, if carry clear go to .1xxxxxxx, ...
	iny
	bcc .1xxxxxxx
	sty.b r3
.3xxxx:								; loop: asl a, rol HuffNumber, X - 1, ...
	asl a
	rol.b HuffNumber
	dex
	dex
	beq .6xx
.4xxxx:								; Y - 1, if Y not yet 0 go to .3xxxx, ...
	dey
	bne .3xxxx
	sta.b HuffBits
	txy
	lda.b r3
	and.w #$00FF
	asl a
	tax
	lda.l .151-4,x
	tyx
	clc
	adc.b HuffNumber
	sta.b HuffNumber
	rts
.5xxxx:								; X counted to 0: increment p0, go to .2xxxx
	sep #$20
	lda.b (p0)
	rep #$20
	inc.b p0
	ldx.b #$10
	bra .2xxxx
.6xx:								; X counted to 0: increment p0, go to .4xxxx
	sep #$20
	lda.b (p0)
	rep #$20
	inc.b p0
	ldx.b #$10
	bra .4xxxx
.151:								; bases of the variable-length numbers in the bit stream
	dw $0000,$0004,$000C,$001C,$003C,$007C,$00FC,$01FC,$03FC
	dw $07FC,$0FFC,$1FFC,$3FFC,$7FFC,$FFFC,$FFFC,$FFFC
.152:								; subroutine: asl a, X - 1, X - 1, ...
	asl a
	dex
	dex
	beq .t1xx
	dey
	bne .152
	rts

.t1xx:								; X counted to 0: increment p0, Y - 1, if Y not yet 0 go to .152, ...
	sep #$20
	lda.b (p0)
	rep #$20
	inc.b p0
	ldx.b #$10
	dey
	bne .152
	rts
