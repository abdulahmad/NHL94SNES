; Assignment: the players taking the face off
; Takes: X = player object. Called through asstab (assignment $17).
; Sets the face off pull frame in fofdata2 (4 bytes further for the visitors) from the player's animation
; and handedness; a computer player starts the face off swing animation (sometimes the reverse pull).
assfaceoffpl:						; assignment: the two players taking the face off
	lda.w pfalock,x					; animation locked?
	beq .t1							; no
.1x:								; unreferenced label
	jmp.w .t2						; locked: return

.t1:								; not locked: is the face off still on?
	lda.w sflags					; bit $0100 of sflags: face off in progress
	bit.w #sf2faceoff
	beq .t3							; over: leave
	lda.w pflags,x					; player flags
	bit.w #pfna
	beq .1xx						; new assignment?
	and.w #$FFFD					; clear pfna
	sta.w pflags,x
	stz.w temp1,x					; clear temp1
.1xx:								; a0 = fofdata2 (home) or fofdata2+fosize (visitors)
	lda.w #fofdata2>>16
	sta.b a0+2
	lda.w #fofdata2
	sta.b a0
	lda.w pfteam,x					; visitors?
	beq .2
	lda.w #$312E					; visitors entry
	sta.b a0
.2:									; frame = SPAnum/4 + 1
	lda.w SPAnum,x					; frame = SPAnum/4 + 1, +3 for a righty
	lsr a
	lsr a
	inc a
	sta.b d0						; frame
	lda.w handed,x					; right handed: +3 (handed set = left handed)
	bne .3							; left
	inc.b d0
	inc.b d0
	inc.b d0
.3:									; store the frame in the face off data
	lda.b d0						; frame
	sta.b [a0]						; store it
	lda.w playerpad,x				; human pad: the player pulls, return
	bpl .t2
	lda.w pf2aip,x					; set pf2aip, keep the old value
	pha
	lda.w #$0001					; new value
	sta.w pf2aip,x
	pla
	cmp.w #$0000					; already swinging: return
	bne .t2							; already pulling: leave
	lda.w #SPAfaceoff				; face off animation
	sta.b d1
	lda.w temp1+puckscnum			; puck temp1 above $10: sometimes the reverse pull
	cmp.w #$0011
	bcc .4
	jsl.l RandomWord
	and.w #$0007					; 1 in 8 gets the reverse animation
	sta.b d0
	beq .4							; 0: normal swing
	lda.w #SPAfaceoffr				; reverse swing
	sta.b d1
.4:									; swing started: mark it
	lda.w #$0001					; flag
	sta.w pf2aip,x
	jml.l SetSPA					; start the animation

.t2:								; return
	rtl								; return

.t3:								; face off over: no puck collision for 20 frames
	lda.w #$0014					; nopuck = 20
	sta.w nopuck,x					; no puck for 20 frames
	jml.l assexit					; assignment over
