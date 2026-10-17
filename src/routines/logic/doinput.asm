; Pad input for player X
doinput:
	jsl.l setpads
	dec.b d4
	dec.b d4
	lda.b d3
	bit.w #$1000
	beq .5
	lda.b d4
	jmp.w PauseFromPad
.1:
	rtl
.5:
	lda.w sfhormode
	beq .1x
	lda.b d0
	bit.w #$0008
	bne .1x
	inc a
	inc a
	and.w #$0007
	sta.b d0
.1x:
	lda.w sflags
	bit.w #$0100
	beq .t2
	jmp.w .7

.t2:
	lda.w asscur,x
	cmp.w #$BCC7
	beq .1
	phy
	ldy.w #$0000
	lda.w pfteam,x
	beq .1xx
	ldy.w #$0002
.1xx:
	lda.w lcpad,y
	ply
	cmp.w #$0000
	bmi .2
	cmp.b d4
	bne .4
.2:
	phy
	ldy.w #$0000
	lda.w pfteam,x
	beq .3
	ldy.w #$0002
.3:
	lda.w tmflags,y
	ply
	bit.w #$0008
	bne .8
.4:
	lda.b d1
	bit.w #$2000
	bne .15
	cpx.w puckc
	bne .t1
	jmp.w .18

.t1:
	lda.b d1
	bit.w #$4000
	bne .9
	lda.w pfalock,x
	bne .6
	lda.b d1
	bit.w #$0040
	bne .17
	bit.w #$8000
	bne .10
	lda.w position,x
	beq .13
	lda.b d1
	bit.w #$0020
	bne .11
	bit.w #$0010
	bne .12
	lda.w passReceiverPlayerNum
	cmp.b curobj
	beq .6
	lda.b d1
	bit.w #$0080
	bne .16
	jml.l doplayeracc
.6:
	jmp.w .22
.7:
	jml.l faceoffinput
.8:
	jml.l lineinput
.9:
	jml.l holdplayer
.10:
	jml.l findpc
.11:
	jml.l PadTakeLeftDefense
.12:
	jml.l PadTakeRightDefense
.13:
	lda.w goalieflags,x
	bit.w #$0001
	bne .1xxx
	and.w #$0002
	bne .14
.1xxx:
	jml.l doplayeracc
.14:
	rtl
.15:
	lda.w gmclock
	bne .14
	ldy.w #$0000
	lda.w pfteam,x
	beq .1xxxx
	ldy.w #$0002
.1xxxx:
	lda.w lcpad,y
	bpl .14
	lda.b d4
	sta.w lcpad,y
	jmp.w SetLCmode
.16:
	jml.l burst
.17:
	ldy.w #$0000
	cpx.w #$000C
	bmi .1xxxxx
	ldy.w #$0002
.1xxxxx:
	lda.w goaliemode1,y
	beq .14
	jml.l PadTakeGoalie
.18:
	lda.w pfalock,x
	bne .6
	jsl.l checkob
	lda.w position,x
	bne .1xxxxxx
	lda.w pf2aip,x
	bne .14
.1xxxxxx:
	lda.w sflags
	bit.w #sfspdir
	bne .t1x
	bit.w #$0008
	bne .t2x
	lda.w dumpinplayer
	cmp.b curobj
	beq .23
	lda.b d1
	bit.w #$8000
	bne .t4
	bit.w #$4000
	bne .t3
	lda.w position,x
	beq .21
	lda.b d1
	bit.w #$0080
	bne .20
	jml.l doplayeracc

.t1x:
	jml.l passmode

.t2x:
	jml.l ShotMode

.t3:
	lda.w #$0014
	sta.b d0
	jml.l assinsert

.t4:
	jml.l setpassmode
.19:
	jml.l findpc
.20:
	jml.l SetShotMode
.21:
	jmp.w .13
.22:
	cpx.w puckc
	beq .23
	lda.b d1
	bit.w #$8000
	bne .19
	bit.w #$0040
	beq .t1xx
	jmp.w .17

.t1xx:
	bit.w #$0080
	beq .23
	ldy.w passReceiverPlayerNum
	bmi .23
	lda.w pflags,y
	and.w #$1000
	ora.w pfalock,y
	bne .23
	lda.w playerpad,y
	bpl .23
	lda.w pfteam,y
	cmp.w pfteam,x
	bne .23
	sty.b d0
	inc.w onetimerreq
	jsl.l AssignPadPlayer
	rtl
.23:
	rtl
