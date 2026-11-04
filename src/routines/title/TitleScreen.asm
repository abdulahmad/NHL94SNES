; The title screen with its music; a button leaves
TitleScreen:						; no input; runs until the title is over (a pad press or the credits end);
									; called from Opening
	jsl.l forceblack				; screen off
	jsl.l SPCTitleUpload			; load the title sound set into the sound CPU
	lda.w #$6000
	ldx.w #$0000
	ldy.w #$01A0
	jsl.l InitSprites				; sprite setup for the title
	sep #$20						; 8-bit A: PPU setup
	lda.b #$58
	sta.w BG2SC						; BG2 and BG3 map addresses
	lda.b #$5C
	sta.w BG3SC
	lda.b #$05
	sta.w BG34NBA					; BG3/4 tile base
	lda.b #$FF
	sta.w Mode7InUse				; mode 7 is in use ($FF)
	stz.w W34SEL					; no windows on BG3/4 or OBJ
	stz.w WOBJSEL
	stz.w WH0
	stz.w WH2
	lda.b #$03
	sta.w TMW						; windows mask on BG1 and BG2
	lda.b #$80
	sta.w M7SEL						; mode 7 screen over/flip settings ($80)
	stz.w M7B						; matrix B and C are 0 (no rotation)
	stz.w M7B
	stz.w M7C
	stz.w M7C
	rep #$20						; 16-bit A
	stz.w BG1HScroll				; scroll values
	lda.w #$FFFF
	sta.w BG1VScroll				; $FFFF
	stz.w BG2HScroll
	stz.w BG2VScroll
	stz.w BG3HScroll
	stz.w BG3VScroll
	lda.w #$0050					; BG3 vertical scroll $50
	sta.w BG3VScroll
	lda.w #$0100					; BG1 horizontal scroll $100: the wipe counter used by TitleWindowWipe
	sta.w BG1HScroll
	stz.w TitleWH1					; window edges 0
	stz.w TitleWH3
	stz.w TitleWH3Low
	lda.w #$0009					; BG mode 9 (mode 1 with the BG3 priority bit) for the top band
	sta.w TitleBGMode
	lda.w #$0200					; mode 7 centre
	sta.w TitleM7X
	sta.w TitleM7Y
	lda.w #$0200
	sta.w TitleM7Y
	sta.w TitleM7HOfs
	lda.w #$0190					; mode 7 horizontal offset $190
	sta.w TitleM7HOfs
	sta.w TitleM7VOfs
	lda.w #$0180					; mode 7 vertical offset $180
	sta.w TitleM7VOfs
	sta.w TitleM7Scale				; scale $1800: far away
	lda.w #$1800
	sta.w TitleM7Scale
	sta.w TitlePathFlip
	lda.w #$0011					; mode 7 band shows BG1 and OBJ
	sta.w TitleM7TM
	stz.w TitleLogoFlags			; no logo path yet
	jsr.w .7						; load the title graphics
	jsr.w BuildTitlePath			; build the logo path tables
	stz.w TitleSkipMask				; no skip yet
	stz.w titleskip
	jsl.l FadeIn					; fade in
.loop:								; wait for full brightness
	lda.w brightness
	cmp.w #$000F					; fully bright?
	bcc .loop						; no
	lda.w #.irq1					; IRQ hook for the first band
	ldx.w #.irq1>>16
	ldy.w #$0000
	sty.w IRQHTime					; H time 0
	ldy.w #$0046					; V line $46
	jsl.l SetIRQ					; start the IRQ
	lda.w #.framehook				; frame hook
	ldx.w #.framehook>>16
	jsl.l SetFrameHook				; install it
	jsl.l WaitFrame					; two frames
	jsl.l WaitFrame
	lda.w #$000F
	sta.w brightness
	sta.w IniDispShadow				; full brightness
	jsr.w TitleZoomIn				; zoom the logo in
	lda.w #$7000					; sound velocity
	sta.b SfxVelocity
	lda.w #$0037					; title sound
	jsl.l PlaySound					; play it
	ldx.w #$001E					; 30 frames
	jsl.l TitleWait					; wait
	lda.w #$0000					; title sprite 0
	jsr.w .9						; show it for 4 frames
	lda.w #$0001
	jsr.w .9
	lda.w #$0002
	jsr.w .9
	lda.w #$0034					; sound
	jsl.l PlaySound					; play it
	lda.w #$0042					; window 3 edge
	sta.w TitleWH3					; open part of the screen
	jsr.w TitleBlankSprites			; clear sprites, wait
	lda.w #$0003					; title sprite 3
	jsr.w .9
	lda.w #$0004
	jsr.w .9
	lda.w #$0005
	jsr.w .9
	lda.w #$0034					; sound
	jsl.l PlaySound					; play sound A at once
	lda.w #$007D					; window 3 edge
	sta.w TitleWH3					; open more of the screen
	jsr.w TitleBlankSprites			; clear sprites, wait
	lda.w #$0006					; title sprite 6
	jsr.w .9
	lda.w #$0007
	jsr.w .9
	lda.w #$0008
	jsr.w .9
	lda.w #$0034					; sound
	jsl.l PlaySound					; play sound A at once
	lda.w #$00FF					; window 3 edge
	sta.w TitleWH3					; fully open
	jsr.w TitleBlankSprites			; clear sprites, wait
	jsr.w TitleStub					; (does nothing)
	lda.w #$0001					; BG mode 1
	sta.w TitleBGMode				; for the top band
	lda.w #$0036					; sound
	jsl.l PlaySound					; play it
	ldx.w #$0007					; 7 frames
	jsl.l TitleWait					; wait
	jsr.w TitleWindowWipe			; wipe the windows
	jsl.l SPCTitleToMenu			; switch the sound CPU to the menu set
	lda.w #TitleSong>>16			; p0 = the title song
	sta.b p0+2
	lda.w #TitleSong
	sta.b p0
	jsl.l MusicStart				; start it
	jsl.l SpriteFrameStart			; a sprite frame ...
	jsr.w PrintCopyright			; ... with the copyright text
	jsl.l SpriteFrameEnd			; close it
	jsl.l WaitFrame					; two frames
	jsl.l WaitFrame
	jsr.w TitleZoomOutRight			; zoom out to the right
	jsl.l SpriteFrameStart			; next sprite frame
	jsr.w PrintCopyright			; copyright text
	lda.w #titlesprbuf>>16			; p1 = sprite buffer
	sta.b p1+2
	lda.w #titlesprbuf
	sta.b p1
	lda.w #$0009					; title sprite 9
	jsr.w DrawTitleSprite			; draw it
	lda.w #$0010					; mode 7 band shows OBJ only
	sta.w TitleM7TM
	lda.w #$1800					; far scale again
	sta.w TitleM7Scale
	lda.w #$0190
	sta.w TitleM7HOfs
	lda.w #$0180
	sta.w TitleM7VOfs
	jsl.l SpriteFrameEnd			; close the frame
	jsl.l WaitFrame					; show
	lda.w #unpackbuf>>16			; p0 = the licence mode 7 map
	sta.b p0+2
	lda.w #unpackbuf
	sta.b p0
	lda.w #$0000
	sta.w MapVRAM					; map to VRAM address 0
	ldx.w #$003C					; map size 60 x 60
	ldy.w #$003C
	jsl.l Mode7MapToVRAM			; load the map
	jsl.l WaitFrame					; frame
	lda.w #$0011					; mode 7 band shows BG1 and OBJ
	sta.w TitleM7TM
	jsl.l WaitFrame					; frame
	jsr.w TitleZoomIn				; zoom in again
	ldx.w #$002D					; 45 frames
	jsl.l TitleWait					; wait
	jsr.w TitleZoomOutLeft			; zoom out to the left
	jsl.l SpriteFrameStart			; next sprite frame
	jsr.w PrintCopyright			; copyright text
	lda.w #titlesprbuf>>16
	sta.b p1+2
	lda.w #titlesprbuf
	sta.b p1
	lda.w #$0009					; title sprite 9 ...
	jsr.w DrawTitleSprite
	lda.w #$000A					; ... and 10
	jsr.w DrawTitleSprite
	jsl.l SpriteFrameEnd			; close the frame
	jsl.l WaitFrame					; two frames
	jsl.l WaitFrame
	lda.w #$0010					; mode 7 band shows OBJ only
	sta.w TitleM7TM
	lda.w #$0F00					; scale
	sta.w TitleM7Scale
	lda.w #$0190
	sta.w TitleM7HOfs
	lda.w #$01B0					; vertical offset
	sta.w TitleM7VOfs
	lda.w #$0210					; centre x
	sta.w TitleM7X
	lda.w #$F0C0					; a press of these buttons now ends the title
	sta.w TitleSkipMask
	lda.w #TitlePuckTiles>>16		; p0 = puck tiles
	sta.b p0+2
	lda.w #TitlePuckTiles
	sta.b p0
	lda.w #unpackbuf>>16
	sta.b p1+2
	lda.w #unpackbuf
	sta.b p1
	jsl.l Decompress				; unpack them
	lda.w #unpackbuf>>16
	sta.b p0+2
	lda.w #unpackbuf
	sta.b p0
	ldy.w #$2000					; 8 KB
	jsl.l DMAToVRAMHigh				; to VRAM
	jsr.w ShuffleTitleTeams			; random order of the teams
	stz.w TitlePathFlip				; path not flipped
	lda.w TitleTeamIdx				; team index
	asl a
	tax
	lda.l titleteams,x				; first team number
	jsr.w LoadTitleLogo				; load its logo
	lda.w #$0011					; mode 7 band shows BG1 and OBJ
	sta.w TitleM7TM
	jsl.l WaitFrame					; two frames
	jsl.l WaitFrame
	stz.w FrameCount				; count frames
	stz.w TitlePathPos				; start the logo path
	stz.w TitlePathFrac
	lda.w #$0002					; logo path runs
	sta.w TitleLogoFlags
.1:									; licence screens, 240 frames
	lda.w FrameCount
	cmp.w #$00F0					; 240 frames?
	bcs .3							; yes: credits
	lda.w FrameCount
	cmp.w #$0078					; 120 frames?
	bcs .t1							; yes: second licence
	jsr.w DrawLicenceNHL			; first licence text
	bra .2							; then logo

.t1:								; second half
	jsr.w DrawLicenceNHLPA			; NHLPA licence text
.2:									; next logo
	jsr.w .5						; load the next logo when a path ended
	bra .1							; loop
.3:									; credits
	stz.w FrameCount				; count frames again
	jsr.w StartCredits				; start the credits
	jsl.l WaitFrame					; frame
.loopx:								; credits until the time is up or a press
	lda.w FrameCount
	cmp.w #$1284					; credits time ($1284 frames) over?
	bcs .4							; yes
	lda.w titleskip					; pad press?
	bne .4							; yes
	jsr.w RollCredits				; scroll the credits
	jsr.w .5						; next logo when needed
	bra .loopx						; again
.4:									; fade out
	lda.w brightness				; brightness
	beq .t1x						; dark: done
	dec.w brightness				; darker
	jsl.l WaitFrame					; frame
	bra .4							; again

.t1x:								; dark
	jsr.w .8						; clear the title variables
	rtl								; end of the title
.5:									; when the logo path ended (bit 0), start the next logo
	lda.w TitleLogoFlags
	bit.w #$0001					; path ended?
	beq .rts						; no
	stz.w TitlePathPos
	stz.w TitlePathFrac				; restart the path
	jsr.w NextTitleTeam				; next team
	jsr.w LoadTitleLogo				; load its logo
	lda.w #$0001
	trb.w TitleLogoFlags			; clear the flag
.rts:								; done
	rts
.6:									; advance the logo along its path (called from the frame hook)
	php								; keep flags
	rep #$30
	lda.w TitleLogoFlags
	bit.w #$0002					; logo path runs?
	beq .4x							; no
	bit.w #$0001					; path ended?
	bne .1x							; yes, wait for the next logo
	lda.w TitlePathFrac
	clc
	adc.w #$0C00					; path position fraction += $0C00
	sta.w TitlePathFrac
	bcc .1x
	inc.w TitlePathPos				; carry: next step
.1x:								; path position as 8.8
	sep #$20
	lda.w TitlePathPos
	xba
	lda.w TitlePathFrac+1			; high byte of the fraction
	rep #$20
	cmp.w #$0500					; end of the path ($500 steps)?
	bcc .2x							; no
	lda.w #$0001
	tsb.w TitleLogoFlags			; path ended
	lda.w TitlePathFlip
	eor.w #$0001					; flip the logo side
	sta.w TitlePathFlip
	lda.w #$0000					; back to step 0
.2x:								; A = step
	asl a
	tax
	lda.l titlescale,x				; scale of the step
	sta.w TitleM7Scale
	lda.l titlexofs,x				; x offset of the step
	ldy.w TitlePathFlip
	beq .3x							; not flipped
	eor.w #$FFFF					; flipped: negate it
	inc a
.3x:								; offset
	clc
	adc.w #$0190					; plus the centre
	sta.w TitleM7HOfs
	lda.l titleyscroll,x			; y scroll of the step
	sta.w TitleM7VOfs
.4x:								; done
	plp								; restore flags
	rts
.framehook:							;frame hook: a press ends the title (titleskip), then the display
									;registers and .irq1
	lda.w PadRaw1
	bit.w TitleSkipMask				; pad press that ends the title?
	beq .5x							; no
	lda.w #$0001
	sta.w titleskip					; flag the skip
.5x:								; set the display registers for the top band
	sep #$20
	lda.w brightness				; screen brightness
	sta.w INIDISP					; to the display
	lda.b #$17
	sta.w TM						; BG1, BG2, BG3 and OBJ on the main screen
	lda.b #$54
	sta.w BG1SC						; BG1 map address
	lda.b #$44
	sta.w BG12NBA					; BG1/2 tile base
	lda.b #$C3
	sta.w W12SEL					; windows on BG1 and BG2
	lda.w TitleBGMode				; BG mode of the top band
	sta.w BGMODE
	lda.w TitleWH1					; window 1 right edge
	sta.w WH1
	lda.w TitleWH3					; window 2 right edge
	sta.w WH3
	rep #$20
	lda.w #.irq1>>16				; next IRQ hook is .irq1
	sta.w IRQHook+2
	lda.w #.irq1
	sta.w IRQHook
	lda.w #$0046					; IRQ at line $46
	sta.w VTIMEL
	lda.w #$0000
	sta.w HTIMEL					; horizontal time 0
	jsr.w .6						; move the logo along its path
	rtl
.irq1:								; IRQ hook: the WH3 window edge, then .irq2
	sep #$20
	lda.w TitleWH3Low
	sta.w WH3
	rep #$20
	lda.w #.irq2>>16
	sta.w IRQHook+2
	lda.w #.irq2
	sta.w IRQHook
	lda.w #$0050
	sta.w VTIMEL
	lda.w #$00A0
	sta.w HTIMEL
	rtl
.irq2:								; IRQ hook: the mode 7 matrix and scroll for the lower band, then .irq3
	sep #$20
	lda.b #$07
	sta.w BGMODE
	lda.b #$00
	sta.w BG1SC
	lda.b #$00
	sta.w BG12NBA
	stz.w W12SEL
	lda.w TitleM7TM
	sta.w TM
	lda.w TitleM7X
	sta.w M7X
	lda.w TitleM7X+1
	sta.w M7X
	lda.w TitleM7Y
	sta.w M7Y
	lda.w TitleM7Y+1
	sta.w M7Y
	lda.w TitleM7HOfs
	sta.w BG1HOFS
	lda.w TitleM7HOfs+1
	sta.w BG1HOFS
	lda.w TitleM7VOfs
	sta.w BG1VOFS
	lda.w TitleM7VOfs+1
	sta.w BG1VOFS
	lda.w TitleM7Scale
	sta.w M7A
	lda.w TitleM7Scale+1
	sta.w M7A
	lda.w TitleM7Scale
	sta.w M7D
	lda.w TitleM7Scale+1
	sta.w M7D
	rep #$20
	lda.w #.irq3>>16
	sta.w IRQHook+2
	lda.w #.irq3
	sta.w IRQHook
	lda.w #$00B0
	sta.w VTIMEL
	lda.w #$0000
	sta.w HTIMEL
	rtl
.irq3:								; IRQ hook: BG1 on the main screen (TM)
	sep #$20
	lda.b #$11
	sta.w TM
	rep #$20
	rtl
.7:									; load the title graphics: palettes, licence and logo tiles, the maps and
									; the sprites
	lda.w #TitlePalette>>16
	sta.b p0+2
	lda.w #TitlePalette
	sta.b p0
	lda.w #unpackbuf>>16
	sta.b p1+2
	lda.w #unpackbuf
	sta.b p1
	jsl.l Decompress				; unpack TitlePalette
	lda.w #TitleSpritePalette>>16
	sta.b p0+2
	lda.w #TitleSpritePalette
	sta.b p0
	lda.w #(unpackbuf+$100)>>16
	sta.b p1+2
	lda.w #unpackbuf+$100
	sta.b p1
	jsl.l Decompress				; unpack TitleSpritePalette
	lda.w #unpackbuf>>16
	sta.b p0+2
	lda.w #unpackbuf
	sta.b p0
	ldy.w #$0000
	ldx.w #$0100
	jsl.l DMAToCGRAM				; send the palette to CGRAM
	lda.w #$0000
	ldx.w #$4000
	ldy.w #$0000
	jsl.l FillVRAMSplit				; clear VRAM
	lda.w #LicenceTiles>>16
	sta.b p0+2
	lda.w #LicenceTiles
	sta.b p0
	lda.w #unpackbuf>>16
	sta.b p1+2
	lda.w #unpackbuf
	sta.b p1
	jsl.l Decompress				; unpack LicenceTiles
	lda.w #unpackbuf>>16
	sta.b p0+2
	lda.w #unpackbuf
	sta.b p0
	ldy.w #$0000
	jsl.l DMAToVRAMHigh				; DMA X bytes from [p0] to the high bytes of video memory at Y
	lda.w #LicenceNHLMap>>16
	sta.b p0+2
	lda.w #LicenceNHLMap
	sta.b p0
	lda.w #$0000
	sta.w MapVRAM
	ldx.w #$003C
	ldy.w #$003C
	jsl.l Mode7MapToVRAM			; copy byte map [p0] into the mode 7 map at column X, row Y
	lda.w #TitleLogoTiles>>16
	sta.b p0+2
	lda.w #TitleLogoTiles
	sta.b p0
	lda.w #unpackbuf>>16
	sta.b p1+2
	lda.w #unpackbuf
	sta.b p1
	jsl.l Decompress				; unpack TitleLogoTiles
	lda.w #unpackbuf>>16
	sta.b p0+2
	lda.w #unpackbuf
	sta.b p0
	ldy.w #$4000
	jsl.l DMAToVRAM					; DMA X bytes from [p0] to video memory at Y
	lda.w #Title94Map>>16
	sta.b p0+2
	lda.w #Title94Map
	sta.b p0
	lda.w #unpackbuf>>16
	sta.b p1+2
	lda.w #unpackbuf
	sta.b p1
	jsl.l Decompress				; unpack Title94Map
	lda.w #unpackbuf>>16
	sta.b p0+2
	lda.w #unpackbuf
	sta.b p0
	lda.w #$5400
	sta.w MapVRAM
	ldx.w #$0000
	ldy.w #$0000
	jsl.l MapToVRAM					; copy map [p0] into the screen map in video memory at column X, row Y
	lda.w #TitleNHLMap>>16
	sta.b p0+2
	lda.w #TitleNHLMap
	sta.b p0
	lda.w #unpackbuf>>16
	sta.b p1+2
	lda.w #unpackbuf
	sta.b p1
	jsl.l Decompress				; unpack TitleNHLMap
	lda.w #unpackbuf>>16
	sta.b p0+2
	lda.w #unpackbuf
	sta.b p0
	lda.w #$5800
	sta.w MapVRAM
	ldx.w #$0000
	ldy.w #$0000
	jsl.l MapToVRAM					; copy map [p0] into the screen map in video memory at column X, row Y
	lda.w #LicenceNHLPAMap>>16
	sta.b p0+2
	lda.w #LicenceNHLPAMap
	sta.b p0
	lda.w #unpackbuf>>16
	sta.b p1+2
	lda.w #unpackbuf
	sta.b p1
	jsl.l Decompress				; unpack LicenceNHLPAMap
	lda.w #TitlePuckMap>>16
	sta.b p0+2
	lda.w #TitlePuckMap
	sta.b p0
	lda.w #introbuf>>16
	sta.b p1+2
	lda.w #introbuf
	sta.b p1
	jsl.l Decompress				; unpack TitlePuckMap
	lda.b p1
	clc
	adc.w #$0006
	sta.b p1
	lda.w #$8080
	jsl.l MemOr						; OR the word A into X bytes at [p1]
	lda.w #TitleSprites>>16
	sta.b p0+2
	lda.w #TitleSprites
	sta.b p0
	lda.w #titlesprbuf>>16
	sta.b p1+2
	lda.w #titlesprbuf
	sta.b p1
	jsl.l Decompress				; unpack TitleSprites
	rts
.8:									; clear the title variables TitleWH1-$0C00
	ldx.w #$0BCB
	lda.w #$0000
.loopxx:							; word by word
	sta.b r0,x
	inx
	inx
	cpx.w #$0C01
	bcc .loopxx
	rts
.9:									; A = title sprite: show it alone for 4 frames
	pha
	jsl.l SpriteFrameStart
	pla
	jsr.w DrawTitleSprite
	jsl.l SpriteFrameEnd
	ldx.w #$0004
	jsl.l TitleWait					; wait X frames unless a pad press has ended the title
	rts
