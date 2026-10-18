; Empty the penalty boxes and put every player on his own bench
ResetBench:
	stz.w PBnum
	lda.w #$0010
	sta.b d1
	stz.b a0
	jsl.l .rb
	lda.w #$0001
	sta.b d1
	lda.w #$0002
	sta.b a0
.rb:
	lda.w #$0032
	sta.b d0
.rb1:
	lda.w PBnum
	clc
	adc.b d1
	sta.w PBnum
	lda.b a0
	beq .idx
	lda.w #$0034
.idx:
	adc.b d0
	tay
	lda.w tmpdst,y
	bmi .nopen
	beq .nopen
	bit.w #TMPDINJ
	beq .next
	and.w #$07FF
	sta.b d2
	bne .next
	lda.w PBnum
	sec
	sbc.b d1
	sta.w PBnum
	bra .next
.nopen:
	lda.w PBnum
	sec
	sbc.b d1
	sta.w PBnum
	lda.w tmpdst,y
	cmp.w #TMPDOUT
	beq .next
	cmp.w #rosterNone
	beq .next
	lda.w #TMPDBENCH
	sta.w tmpdst,y
.next:
	dec.b d0
	dec.b d0
	bpl .rb1
	rtl
