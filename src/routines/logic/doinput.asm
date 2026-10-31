; Pad input for player X
;
; Takes X = player, d0 = pad direction (bit 3 = none), d1 = new presses, d3 = buttons held, d4 = pad. Buttons:
; Start $1000, Select $2000, Y $4000, B $8000, A $0080, X $0040, L $0020, R $0010. It dispatches by state:
; faceoff, line change box, puck carrier (pass / shot / burst) or not (hold, change player, defense, goalie).
doinput:							; pad input for player X
	jsl.l setpads					; pad marker follows X
	dec.b d4						; pad number
	dec.b d4
	lda.b d3						; buttons held
	bit.w #$1000					; Start?
	beq .5							; no
	lda.b d4						; pad number
	jmp.w PauseFromPad				; pause from this pad
.1:									; leave
	rtl
.5:									; not paused
	lda.w sfhormode					; horizontal screen?
	beq .1x
	lda.b d0						; pad direction
	bit.w #$0008					; none?
	bne .1x
	inc a							; horizontal: turn the direction by 2 (90 degrees)
	inc a
	and.w #$0007
	sta.b d0
.1x:								; face off in progress?
	lda.w sflags					; game flags
	bit.w #$0100					; bit $0100 (face off)?
	beq .t2
	jmp.w .7						; face off input

.t2:								; assignment running
	lda.w asscur,x
	cmp.w #$BCC7					; probably an assignment that ignores the pad
	beq .1							; leave
	phy								; keep Y
	ldy.w #$0000
	lda.w pfteam,x					; team of X
	beq .1xx						; home: team offset 0
	ldy.w #$0002					; away: team offset 2
.1xx:								; if minus go to .2, ...
	lda.w lcpad,y					; the pad that owns the line change box of the team
	ply								; restore Y
	cmp.w #$0000					; nobody owns it?
	bmi .2
	cmp.b d4						; owned by this pad?
	bne .4							; no: another pad has it
.2:									; box owner is this pad or nobody
	phy
	ldy.w #$0000
	lda.w pfteam,x
	beq .3
	ldy.w #$0002
.3:									; if not zero go to .8
	lda.w tmflags,y					; team flags
	ply
	bit.w #$0008					; line change box open (bit 3)?
	bne .8							; yes: line change input
.4:									; not in the line change box
	lda.b d1						; new presses
	bit.w #$2000					; Select?
	bne .15							; yes: open the line change box
	cpx.w puckc						; puck carrier?
	bne .t1
	jmp.w .18						; yes

.t1:								; no puck: other controls
	lda.b d1						; new presses
	bit.w #$4000					; Y?
	bne .9							; hold
	lda.w pfalock,x					; animation locked?
	bne .6							; yes
	lda.b d1
	bit.w #$0040					; X button?
	bne .17							; yes: take the goalie
	bit.w #$8000					; B?
	bne .10							; yes: change player
	lda.w position,x				; position
	beq .13							; goalie
	lda.b d1
	bit.w #$0020					; L?
	bne .11							; left defense
	bit.w #$0010					; R?
	bne .12							; right defense
	lda.w passReceiverPlayerNum		; the pass receiver is this player?
	cmp.b curobj
	beq .6							; yes
	lda.b d1
	bit.w #$0080					; A?
	bne .16							; burst
	jml.l doplayeracc				; skate
.6:									; locked: the same limited actions as the puck carrier
	jmp.w .22
.7:									; face off
	jml.l faceoffinput				; pad input for a player taking a face off
.8:									; line change box
	jml.l lineinput					; pad input for the line change box
.9:									; hold the opposing player
	jml.l Holdplayer				; hold button for player X
.10:								; change player
	jml.l findpc					; choose the player for pad d4
.11:								; take the left defense
	jml.l PadTakeLeftDefense
.12:								; take the right defense
	jml.l PadTakeRightDefense
.13:								; goalie input
	lda.w goalieflags,x
	bit.w #$0001					; goalie flag bit 0 set?
	bne .1xxx						; yes: skate
	and.w #$0002					; flag bit 1?
	bne .14							; yes: no input
.1xxx:								; go to doplayeracc
	jml.l doplayeracc				; skate
.14:								; nothing to do
	rtl
.15:								; Select, no puck
	lda.w gmclock					; clock stopped?
	bne .14							; yes: leave
	ldy.w #$0000
	lda.w pfteam,x					; team of X
	beq .1xxxx
	ldy.w #$0002
.1xxxx:								; if lcpad,y >= 0 go to .14, ...
	lda.w lcpad,y					; line change box owner
	bpl .14							; someone has it: leave
	lda.b d4						; this pad
	sta.w lcpad,y
	jmp.w SetLCmode					; open the line change box
.16:								; d1 bit $0080 set: go to burst
	jml.l burst						; speed burst
.17:								; if $0000 - $000C negative go to .1xxxxx, ...
	ldy.w #$0000					; goalie control
	cpx.w #$000C					; X is on team 0?
	bmi .1xxxxx
	ldy.w #$0002					; team 1
.1xxxxx:							; if goaliemode1,y = 0 go to .14, ...
	lda.w goaliemode1,y				; manual goalie flag of the team
	beq .14							; not set: leave
	jml.l PadTakeGoalie				; take over the goalie
.18:								; puck carrier
	lda.w pfalock,x					; animation locked?
	bne .6							; yes
	jsl.l checkob					; check the boards?
	lda.w position,x				; position
	bne .1xxxxxx					; not the goalie
	lda.w pf2aip,x					; goalie in an animation?
	bne .14							; yes: leave
.1xxxxxx:							; if sflags bit sfspdir set go to .t1x, ...
	lda.w sflags					; game flags
	bit.w #sfspdir					; pass direction set?
	bne .t1x						; yes: pass mode
	bit.w #$0008					; shot direction set (bit 3)?
	bne .t2x						; yes: shot mode
	lda.w dumpinplayer				; puck dumped in by this player?
	cmp.b curobj
	beq .23							; yes: nothing
	lda.b d1						; new presses
	bit.w #$8000					; B?
	bne .t4							; yes: pass
	bit.w #$4000					; Y?
	bne .t3							; yes: assignment $14
	lda.w position,x				; goalie?
	beq .21							; yes: goalie control
	lda.b d1
	bit.w #$0080					; A?
	bne .20							; shot
	jml.l doplayeracc				; skate

.t1x:								; sflags bit sfspdir set: go to passmode
	jml.l passmode					; pass input

.t2x:								; go to ShotMode
	jml.l ShotMode					; shot input

.t3:								; d0 = $0014, go to assinsert
	lda.w #$0014					; assignment $14
	sta.b d0
	jml.l assinsert					; give it to X

.t4:								; d1 bit $8000 set: go to setpassmode
	jml.l setpassmode				; set the pass direction
.19:								; d1 bit $8000 set: go to findpc
	jml.l findpc					; change player
.20:								; d1 bit $0080 set: go to SetShotMode
	jml.l SetShotMode				; start a shot
.21:								; position,x = 0: go to .13
	jmp.w .13						; goalie
.22:								; if zero go to .23, ...
	cpx.w puckc						; puck carrier?
	beq .23							; yes: nothing
	lda.b d1
	bit.w #$8000					; B?
	bne .19							; yes: change player
	bit.w #$0040					; X button?
	beq .t1xx						; no
	jmp.w .17						; goalie control

.t1xx:								; if zero go to .23, ...
	bit.w #$0080					; A?
	beq .23							; no
	ldy.w passReceiverPlayerNum		; pass receiver
	bmi .23							; none
	lda.w pflags,y					; his flags
	and.w #$1000					; bit $1000 and his animation lock
	ora.w pfalock,y
	bne .23							; set: leave
	lda.w playerpad,y				; his pad
	bpl .23							; he has a pad: leave
	lda.w pfteam,y					; his team
	cmp.w pfteam,x
	bne .23							; other team: leave
	sty.b d0						; d0 = receiver
	inc.w onetimerreq				; one time request
	jsl.l AssignPadPlayer			; give the pad to the receiver
	rtl
.23:								; return
	rtl								; return
