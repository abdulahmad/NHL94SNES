; Clear the sorted objects and set up the objects from their start tables
defaultsprites_0:					; called from setoptions, setupice_reset
	phb
	phk								; data bank = program bank
	plb
	ldx.w #$0000					; SortCords (all fields of the 16 objects)
.loop:								; loop: Xpos,x = 0, X + 1, X + 1, ...
	stz.w Xpos,x					; clear one word at a time
	inx
	inx
	cpx.w #$076E
	bne .loop
	stz.b d6						; object number
	stz.b a1						; OOlist index
	stz.b a2						; byte offset into SortObjInitTable
	stz.b a3						; byte offset into the sort tables
	stz.b a4
	stz.w puckz
.loop2:								; loop: SCnum,y = d6, oldframe,y = $FFFF, pnum,y = $FFFF, ...
	ldx.b a2
	ldy.b a3
	lda.b d6
	sta.w SCnum,y					; SCnum = object number
	lda.w #$FFFF
	sta.w oldframe,y				; oldframe and pnum = -1
	sta.w pnum,y
	lda.w .3,x
	sta.w Xpos,y
	lda.w .3+2,x
	sta.w Ypos,y
	lda.w .3+6,x
	sta.w frame,y
	lda.w .3+8,x
	sta.w attribute,y
	lda.w .3+10,x
	sta.w radiusx,y
	lda.w .3+12,x
	sta.w radiusy,y
	lda.b d6
	asl a
	asl a
	asl a
	tay
	lda.w .3+14,x
	sta.w asslist,y
	ldy.b a3
	sta.w asscur,y
	lda.w .3+16,x
	sta.w pflags,y					; object flags
	lda.w #$0000
	sta.w pfnc,y					; default function 0
	cpy.w #$001E					; object $1E (puck shadow): pfnc
	bne .1
	lda.w #$0001
	sta.w pfnc,y
.1:									; rol a, increment a, and #$0001, ...
	cpx.w #$006C					; pfgoal for objects 6-11 and 12-15, pfteam $34 for 6-11
	rol a
	inc a
	and.w #$0001
	sta.w pfgoal,y
	cpx.w #$006C
	bcc .2
	cpx.w #$00D8
	bcs .2
	lda.w #$0034
	sta.w pfteam,y					; pfteam = $34
.2:									; increment a3, increment a3, OOlist,y = d6 * 2, ...
	inc.b a3						; next sort table slot
	inc.b a3
	sep #$20						; 8-bit A
	lda.b d6
	asl a							; build the OOlist entry
	ldy.b a1
	sta.w OOlist,y
	inc.b a1						; OOlist index
	rep #$30						; 16-bit registers
	ldy.b a4
	lda.b d6
	sta.w OOlistpos,y				; OOlistpos[object] = object
	inc.b a4
	inc.b a4
	inc.b d6
	lda.b a2
	clc
	adc.w #$0012					; next init table entry
	sta.b a2
	lda.b d6
	cmp.w #$0010					; all 16 objects done?
	beq .t1
	jmp.w .loop2

.t1:								; d6 = $0010: position+$18 = $FFFF, position+$1A = $FFFF, go to SprSort
	lda.w #$FFFF
	sta.w position+netobj1
	sta.w position+netobj2
	plb
	jmp.w SprSort					; sort the objects by screen position
.3:									; a record of 9 words per object, read by the .loop2 loop above
	; x, y, height, frame, attribute (bit 0 = visiting palette), collision width, collision height,
	; assignment, flags (as 93S SortObjInitTable)
	dw $0160,$00C0,$0000,SPFskatewp,$0000,$0008,$0004,$0000,$0000
	dw $FF38,$FF9C,$0000,SPFskatewp,$0000,$0008,$0004,$0000,$0000
	dw $FF38,$FFB0,$0000,SPFskatewp,$0000,$0008,$0004,$0000,$0000
	dw $FF38,$FFC4,$0000,SPFskatewp,$0000,$0008,$0004,$0000,$0000
	dw $FF38,$FFD8,$0000,SPFskatewp,$0000,$0008,$0004,$0000,$0000
	dw $FF38,$FFEC,$0000,SPFskatewp,$0000,$0008,$0004,$0000,$0000
	dw $00C0,$00C0,$0000,SPFskatewp,$0001,$0008,$0004,$0000,$0000
	dw $FF38,$0028,$0000,SPFskatewp,$0001,$0008,$0004,$0000,$0000
	dw $FF38,$003C,$0000,SPFskatewp,$0001,$0008,$0004,$0000,$0000
	dw $FF38,$0050,$0000,SPFskatewp,$0001,$0008,$0004,$0000,$0000
	dw $FF38,$0064,$0000,SPFskatewp,$0001,$0008,$0004,$0000,$0000
	dw $FF38,$0078,$0000,SPFskatewp,$0001,$0008,$0004,$0000,$0000
	dw $0000,$010C,$0000,SPFgoal,$0000,$0014,$0006,$0000,$0000	; goal net
	dw $0000,$FEF4,$0000,SPFgoal+1,$0000,$0014,$0006,$0000,$0000	; other goal net
	dw $0000,$0000,$0000,SPFpuck+1,$0000,$0005,$0005,$0018,$0001	; puck
	dw $0000,$0000,$0000,SPFpuck,$0000,$0003,$0003,$0019,$0000	; puck shadow
