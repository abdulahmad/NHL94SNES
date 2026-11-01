; Pad d4 takes control of player d0: its old player is released (pflags, playerpad = -1), the new one marked
; (pflags bit 3, playerpad = pad, c1playernum = player)
AssignPadPlayer:					; called from AssignPadIfFree, PadTakePosition, PuckCarrierPad, doinput...
	lda.w #$FFFF
	sta.w dumpinplayer
	ldy.b d4
	lda.w c1playernum,y
	cmp.b d0
	beq .rtl
	tay
	cpy.w #$0018
	bcs .1
	lda.w pflags,y
	and.w #(~pfjoycon&$FFFF)
	ora.w #$0002
	sta.w pflags,y
	lda.w #$FFFF
	sta.w playerpad,y
	lda.w position,y
	bne .1
	lda.w #$0000
	sta.w goalieflags,y
.1:									; if d0 >= $0018 go to .rtl, ...
	ldy.b d0
	cpy.w #$0018
	bcs .rtl
	lda.w pflags,y
	ora.w #pfjoycon
	sta.w pflags,y
	lda.b d4
	sta.w playerpad,y
	tay
	lda.b d0
	sta.w c1playernum,y
.rtl:								; return
	rtl
