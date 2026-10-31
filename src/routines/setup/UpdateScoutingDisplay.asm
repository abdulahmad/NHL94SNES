; Every frame of the scouting report: print the next word when its timer runs out
;
; Takes nothing. Called from ScoutingReport every frame; returns rtl. ScoutingReportTimer counts the frames
; to the next word; PlayerScrollCtr is the paragraph of PregameText, a negative one means the player list
; (TestList).
;
; In the text a % followed by a letter or digit is a field (team names, hot and cold players) that the Scout
; routines print; any other character is a plain word.
UpdateScoutingDisplay:				; print the next word of the scouting report when the timer is up
	lda.w ScoutingReportTimer		; text finished ($7FFF)
	sec								; timer minus $1000
	sbc.w #$1000					; $1000 and above: text finished
	beq .2							; equal: counting
	bmi .t1							; below (signed): check overflow
	bvs .2							; overflow: counting
	bra UpdateScoutingDisplay_rtl	; timer above $1000: nothing to do yet

.t1:								; below $1000
	bvs UpdateScoutingDisplay_rtl
.2:									; timer counts down
	lda.w asv						; asv negative: text without delays
	bmi .1
	dec.w ScoutingReportTimer		; count the timer down
	bpl UpdateScoutingDisplay_rtl	; still running: nothing to print
.1:									; timer ran out: print the next word
	lda.w #PregameText>>16			; a1 = PregameText
	sta.b a1+2
	lda.w #PregameText
	sta.b a1
	lda.w PlayerScrollCtr			; d0 = PlayerScrollCtr
	sta.b d0
	bpl UpdateScoutingDisplay_para	; paragraph number: print its next word
	stz.w DispAttribCtr				; negative: the player list, column 0
	ldy.w SelectedPlayerIdx			; Y = index into TestList
	inc.w SelectedPlayerIdx			; next entry
	inc.w SelectedPlayerIdx
	lda.w #TestList>>16				; a0 = TestList
	sta.b a0+2
	lda.w #TestList
	sta.b a0
	lda.b [a0],y					; d0 = paragraph for the player
	sta.b d0
	bpl UpdateScoutingDisplay_scroll	; positive: scroll and print it
	lda.w #$7FFF					; end of list: stop the timer
	sta.w ScoutingReportTimer
	lda.w #$01E0					; show the screen for 480 frames
	sta.w screentimer
UpdateScoutingDisplay_rtl:			; shared return
	rtl
UpdateScoutingDisplay_scroll:		; start a new paragraph: scroll the text up
	lda.w VertLineScrolling			; first line (VertLineScrolling 0)?
	cmp.w #$0001					; nothing printed yet: scroll once only
	bmi .1
	jsl.l ScrollDisplayUp			; scroll up an extra line
.1:									; call ScrollDisplayUp, a2+2 = a1+2, a2 = a1, ...
	jsl.l ScrollDisplayUp			; scroll up a line
	lda.b a1+2						; a2 = a1
	sta.b a2+2
	lda.b a1
	sta.b a2
	bra UpdateScoutingDisplay_next	; find paragraph d0 in PregameText
UpdateScoutingDisplay_skip:			; skip a line: read to the next $0D
	lda.b [a2]
	inc.b a2
	and.w #$00FF
	cmp.w #$000D					; end of line?
	bne UpdateScoutingDisplay_skip
UpdateScoutingDisplay_next:			; lines left to skip
	dec.b d0
	bpl UpdateScoutingDisplay_skip
	lda.b a2						; d0 = offset of the paragraph from a1
	sec
	sbc.b a1
	sta.b d0
UpdateScoutingDisplay_para:			; print from the current position
	lda.b a1						; a2 = a1 + d0: the next character
	clc
	adc.b d0
	sta.b a2
	lda.b a1+2
	sta.b a2+2
	lda.w #$000A					; wait $0A frames for the next word
	sta.w ScoutingReportTimer
	lda.w DispAttribCtr				; d0 = DispAttribCtr: column
	sta.b d0
	lda.b [a2]						; character is % (a field)?
	and.w #$00FF
	cmp.w #$0025
	beq .t1
	jmp.w ScoutPlainWord			; no: plain word

.t1:								; a field: skip the %
	inc.b a2
	lda.b [a2]						; field code letter
	inc.w PlayerScrollCtr			; step PlayerScrollCtr on
	and.w #$00FF
	cmp.w #$0072					; 'r': home arena
	bne .t3
	jmp.w ScoutHomeArena

.t3:								; test the code for 'v'
	cmp.w #$0076					; 'v': visitor city
	bne .t1x
	jmp.w ScoutVisCity

.t1x:								; test the code for 'h'
	cmp.w #$0068					; 'h': home city
	bne .t2
	jmp.w ScoutHomeCity

.t2:								; test the code for 'V'
	cmp.w #$0056					; 'V': visitor name
	bne .t1xx
	jmp.w ScoutVisName

.t1xx:								; test the code for 'H'
	cmp.w #$0048					; 'H': home name
	bne .t5
	jmp.w ScoutHomeName

.t5:								; test the code for 'm'
	cmp.w #$006D					; 'm': visitor nickname
	bne .t1x2
	jmp.w ScoutVisNick

.t1x2:								; test the code for 'n'
	cmp.w #$006E					; 'n': home nickname
	bne .t2x
	jmp.w ScoutHomeNick

.t2x:								; test the code for 't'
	cmp.w #$0074					; 't': hot team
	bne .t1xx2
	jmp.w ScoutHotTeam

.t1xx2:								; test the code for 'e'
	cmp.w #$0065					; 'e': "extremely"
	bne .t3x
	jmp.w ScoutExtremely

.t3x:								; test the code for '0'
	cmp.w #$0030					; '0': home hot player 1
	bne .t1x2x
	jmp.w ScoutHomeHot1

.t1x2x:								; test the code for '1'
	cmp.w #$0031					; '1': home hot player 2
	bne .t2xx
	jmp.w ScoutHomeHot2

.t2xx:								; test the code for '2'
	cmp.w #$0032					; '2': home hot player 3
	bne .t1xxx
	jmp.w ScoutHomeHot3

.t1xxx:								; test the code for '3'
	cmp.w #$0033					; '3': home cold player 1
	bne .t4
	jmp.w ScoutHomeCold1

.t4:								; test the code for '4'
	cmp.w #$0034					; '4': home cold player 2
	bne .t1x3
	jmp.w ScoutHomeCold2

.t1x3:								; test the code for '5'
	cmp.w #$0035					; '5': home cold player 3
	bne .t2x2
	jmp.w ScoutHomeCold3

.t2x2:								; test the code for '6'
	cmp.w #$0036					; '6': visitor hot player 1
	bne .t1xx2x
	jmp.w ScoutVisHot1

.t1xx2x:							; test the code for '7'
	cmp.w #$0037					; '7': visitor hot player 2
	bne .t3xx
	jmp.w ScoutVisHot2

.t3xx:								; test the code for '8'
	cmp.w #$0038					; '8': visitor hot player 3
	bne .t1x2xx
	jmp.w ScoutVisHot3

.t1x2xx:							; test the code for '9'
	cmp.w #$0039					; '9': visitor cold player 1
	bne .t2xxx
	jmp.w ScoutVisCold1

.t2xxx:								; test the code for 'a'
	cmp.w #$0061					; 'a': visitor cold player 2
	bne .t1xxxx
	jmp.w ScoutVisCold2

.t1xxxx:							; test the code for 'b'
	cmp.w #$0062					; 'b': visitor cold player 3
	bne ScoutPlainWord				; other code: print it as a plain word
	jmp.w ScoutVisCold3
