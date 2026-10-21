; Shootout shooters: the player list rows
PrintShooterList:					;draw the ShooterSelectList list: the title of rating column
									;DispAttribCtr, the scroll marks, the rows
	lda.b a1+2						;save a1
	pha
	lda.b a1
	pha
	lda.w #PrintShooterListPos>>16	;header position
	sta.b a1+2
	lda.w #PrintShooterListPos
	sta.b a1
	jsl.l print						;print the header position
	pla								;restore a1
	sta.b a1
	pla
	sta.b a1+2
	lda.w #$0020
	sta.b d0						;$20 columns
	lda.w #$000D
	sta.b d1						;$D rows
	lda.l blankchar
	sta.b d2						;blank tile
	jsl.l eraser					;clear the list area
	lda.w #$0011
	sta.w printx					;column $11
	lda.w #$0002
	sta.w printy					;row 2
.1:									;find page DispAttribCtr
	lda.w #ShooterAttribColumns>>16	;rating columns
	sta.b a1+2
	lda.w #ShooterAttribColumns		;rating columns
	sta.b a1
	lda.w DispAttribCtr				;page number
	sta.b d0						;page number
	bra .3							;find it
.2:									;skip one entry
	lda.b a1						;skip one entry
	clc
	adc.b [a1]						;plus the title length
	adc.w #$0004					;plus the weights
	sta.b a1						;next entry
.3:									;is this the page?
	lda.b [a1]						;entry length
	bmi .1x							;end of the list
	dec.b d0						;count down the pages
	bpl .2							;not there yet
.1x:								;end of the list or the page
	lda.b [a1]						;end marker?
	bpl .t1							;a page?
	dec.w DispAttribCtr				;past the last page: back one
	bra .1							;try again

.t1:								;page found
	lda.w #$3800					;palette $3800
	sta.w printa					;normal palette
	jsl.l print						;print the column title
	lda.b [a1]						;rating weights
	sta.b d4+2						;high word of the weights
	ldy.w #$0002
	lda.b [a1],y					;second word
	sta.b d4						;low word of the weights
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #PlayerTxt2>>16			;"Player" header
	sta.b a1+2
	lda.w #PlayerTxt2
	sta.b a1
	jsl.l print						;print the "Player" header
	pla
	sta.b a1
	pla
	sta.b a1+2
	lda.w picktop					;page shown
	cmp.w pickfirst					;first page?
	beq .1xx						;on the first page: no left arrow
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #LeftArrowTxt3>>16		;left arrow
	sta.b a1+2
	lda.w #LeftArrowTxt3
	sta.b a1
	jsl.l print						;print the left arrow
	pla
	sta.b a1
	pla
	sta.b a1+2
.1xx:								;right arrow if more pages follow
	lda.w picktop					;first page shown
	sec
	sbc.w pickfirst					;minus the first page
	clc
	adc.w #$0009					;plus 9 columns shown
	cmp.w listcount					;past the list?
	bpl .2x							;no more to the right
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #RightArrowTxt3>>16		;right arrow
	sta.b a1+2
	lda.w #RightArrowTxt3
	sta.b a1
	jsl.l print						;print the right arrow
	pla
	sta.b a1
	pla
	sta.b a1+2
.2x:								;print the rows
	jsl.l PrintShooterRows			;the rows
	rtl
