; After a game: the password and the playoff screen, then the next game or the start
GameOver:
	stz.w FrameByNumber
	jsl.l EncodePW
	jsl.l PlayoffScreen
	lda.l OptPlayMode
	cmp.w #$0001
	beq .t1
	jml.l Restart

.t1:
	lda.l gamenum
	bpl .t2
	jml.l Restart

.t2:
	lda.l PassWord
	and.w #$7F7F
	sta.l PassWord
	jsl.l DecodePW
	jsl.l maketree
	lda.w #$0004
	trb.w sflags3
	beq .t1x
	jmp.w StartGame

.t1x:
	jml.l StartGame_scout
