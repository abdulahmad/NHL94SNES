; Work RAM of NHL '94 SNES. Equates only, no bytes; one name per address.
; Like the 94G module files, data/teamdata94s.asm holds the team record offsets and data/frames94s.asm
; the sprite frame (SPF) equates.

; Direct page ($00-$FF), then work RAM $0100-$1FFF, then banks $7E / $7F, then constants (93S order)

; Direct page the game logic uses as the 68k registers.
;
; The engine's parameter / scratch registers at the bottom of the direct page, 4 bytes each like a0-a6 / d0-d7
; (NAME+2 is the upper word or the bank). What each holds changes per routine: r0-r2 the divider and
; multiplier operands, p0 / p1 a source / destination long pointer (Decompress, MemCopy, DMA, map routines).
r0		=	$00
r1		=	$04
r2		=	$08
p0		=	$0C						; long pointer; p0+2 is the bank
p1		=	$10						; long pointer; p1+2 is the bank
r3		=	$14
r4		=	$18
r5		=	$1C
r6		=	$20
r7		=	$24
r8		=	$28
r9		=	$2C
a0		=	$89						; long pointer; a0+2 is the bank
a1		=	$8D						; long pointer; a1+2 is the bank
a2		=	$91						; team index, 0 = home
a3		=	$95						; long pointer; a3+2 is the bank
d0		=	$A5
d1		=	$A9						; d1+2 is the high word
d2		=	$AD
d7		=	$C1						; frames elapsed, added into speeds
tmp0	=	$C5						; scratch word; tmp0+1 is the next byte
tmp1	=	$C7						; scratch word
tmp2	=	$C9						; scratch byte; tmp2+1 is the next byte

; Direct page of the NMI / DMA queue, the software multiply, the sound stream and the sequencer. EventData1,
; EventData2 and EventCode are what ReadTrackEvent fills; StepTrack (the pitch bend event) and StartSoundVoice
; also use them as scratch. Names that share an address apply only in their routines.
ClipTopUnused		=	$30			;ResetPPURegs is the only access: sta.b $30 = $FFF0 (with $2C = $FFF0, $2E
									;= $0100, $32 = $00E0: ...
ClipBottomUnused	=	$32			; ResetPPURegs sta.b $32 = $00E0 (224, screen height); never read anywhere
SoundTable			=	$34			;Long pointer to the sound/instrument offset table; $36 = SoundTable+2
									;(bank, stored as a word so ...
NMISkip				=	$38			;NMI_Fast: lda.b $38 : beq -> nonzero = just pla/plb/rti (no hook, DMA,
									;OAM, sound)
DMAQueueHead		=	$3A			;Read index into the DMAQueue ring ($0100, 8-byte entries, and #$03FF):
									;NMI_HookReturn ldx $3A ...
DMAQueueTail		=	$3C			;Write index of the DMAQueue ring: QueueVRAMDMA, DMAToVRAMHigh, FillVRAM,
									;FillVRAMSplit, ...
DMABudget			=	$3E			;NMI_Fast sets $16D3 each NMI; NMI_HookReturn subtracts the CGRAM DMA
									;(len+$48) and per queue ...
StreamSrc			=	$3E			;Long pointer ($40 = StreamSrc+2, bank) to the sample bytes sent to the
									;sound CPU: ...
MulCand				=	$3E			;Multiplicand of the software multiply (taken when Mode7InUse bit 6 is
									;set): MulFrac8 $3E = A low ...
MulShift			=	$40			;MulFrac8: sta $40 = A*2, then asl $40 seven times; each carry (a bit of
									;the high byte B) adds ...
MulProd				=	$42			;MulFrac16: stz $42/$44, adds MulCand ($3E/$40) into $42/$44 (32-bit) for
									;each set multiplier ...
StreamLoop			=	$42			;UpdateStreamSfx: $42 = byte-swapped first word of the stream block
									;header, then ldy $42 -> Y = ...
MulFracResult		=	$43			;MulFrac16 returns A*Y/128 in A and $43 (soft path: lda $43 = MulProd+1;
									;hardware path: MPYM*2 -> ...
MulPlier			=	$46			;MulFrac16: sty $46 (multiplier Y), lda $46 : lsr : sta $46 each step, the
									;carry adds MulCand ...
CurTrack			=	$4A			;Track number being worked: StepTrack txa : sta $4A (restores X from it at
									;the end); ...
CurVoice			=	$4B			;Voice number being worked: FindFreeVoice returns it ($FF = none, stx $4B;
									;the steal scan keeps ...
CurTrackPtr			=	$4C			;StepTrack: lda TrackPtr,x : sta $4C; after each ReadTrackEvent copies
									;EventPtr ($56) back to ...
InstPtr				=	$4E			;Sound/instrument entry pointer (SoundTable + offset) of the sound being
									;started/stopped/updated: ...
SoundBank			=	$50			;Bank of the sound entries: SoundInit ldx $36 : stx $50 (SoundTable bank,
									;16-bit store)
VarLenAcc			=	$52			;ReadVarLen: sta $52 = value so far, then ($52 << 7) or $54 for each
									;continuation byte (top bit ...
TrackLoopEnd		=	$52			; ClearTracks: the track number to stop at (shares VarLenAcc's slot)
VarLenByte			=	$54			; ReadVarLen: the next byte and #$7F, ORed into the shifted VarLenAcc
EventPtr			=	$56			;Long read pointer into the song ($58 = EventPtr+2 = song bank: MusicStart
									;lda $0E : sta $58, 8-bit)
EventData1			=	$5A			;ReadTrackEvent: first data byte of the event (sty $5A): note velocity for
									;notes (< $D9), program ...
NotePitch			=	$5A			;Pitch word of the note: StartSoundVoice PitchTable[note] ->
									;VoiceBasePitch and $5A, bent by ...
GainWord			=	$5A			;UpdateSfxVoices: lda VoiceGain,x : sta $5A so that $5B (its high byte) is
									;the DSP GAIN ...
DSPGain				=	$5B			;GAIN byte sent by SeqCmd0C / SeqCmd0C0B (APUIO2 with command $0C, APUIO1
									;= voice): ReleaseVoice ...
StartGain			=	$5C			;StartSoundVoice: instrument word $0A -> VoiceGain,x and $5C (and
									;recsfxvol for track $10)
BendAmount			=	$5C			;StepTrack event $E5 (pitch bend): signed bend byte, sta TrackBend,x and
									;$5C; its sign selects ...
EventData2			=	$5E			;ReadTrackEvent: second data item: note length (ReadVarLen) for notes,
									;controller value ($DF: ...
EventCode			=	$60			;ReadTrackEvent sty $60 = event status byte; StepTrack dispatches on it
									;($D9/$DA stop, $DB loop, ...
SendPitch			=	$60			;UpdateSfxVoices: VoicePitch,x (+ VoiceVibOfs while the vibrato runs) ->
									;$60; SeqCmd0B sends $60 ...
EventEAUnused		=	$62			;StepTrack event $EA: EventData1 and #$FF -> $62 (word store); never read
									;anywhere
SfxVelocity			=	$64			;Velocity of the next sound effect, in the high byte ($65 =
									;SfxVelocity+1): PlaySound lda $65 : ...
VoiceRotor			=	$66			;FindFreeVoice: lda $66 : inc : and #$07 : sta $66, the search starts at
									;that voice (round ...
StealCount			=	$68			;FindFreeVoice steal scan (no free voice): lda #$08 : sta $68 ... dec $68
									;: bne, the voices left ...

; Direct page used by one routine each (several share an address: the name is applied only in its routine):
; the decompressors (Huff* / LZ*), the intro, burst, checkwallcoll, SuperMult (93S mulres) and updateplayers
HuffBitsExt		=	$6A				; Low word of the 32-bit bit window $6A-$6D under HuffBits
LZCopySrc		=	$6B				;Long pointer of a back-reference copy: $6B/$6C = LZOutAddr - LZDistance -
									;1 (lda $6F / clc / sbc ...
HuffBits		=	$6C				;16-bit bit buffer, MSB first: header loads it with the 2 bytes at
									;header+6 (xba / sta $6C, Y = 8 ...
HuffNumber		=	$6F				;Result of the variable-length number readers .149/.150 (stz $6F, then rol
									;$6F per bit, plus the ...
LZOutAddr		=	$6F				;Output address: starts as the destination word $10 (lda $10 / sta $6F)
									;and every literal and ...
HuffStartBits	=	$71				;Bits left in the buffer after the header, times 2 (tya / asl a / sta
									;$71); the decode loop ...
LZCmd			=	$71				;Command byte of each LZ token (lda [$0C],y / sta $71): bit 7 / bit 6 /
									;bit 5 choose the 2-, 3-, ...
HuffEscape		=	$73				;Escape symbol from header byte 5 (lda ($0C) / sta $73 after adding 5);
									;table build gives its ...
LZCmdByte2		=	$73				;Second byte of a 2- or 3-byte LZ token: offset low byte of the short form
									;(offset = (cmd and ...
HuffEscapeLen	=	$74				;Code length of the escape symbol: set while building the tables when the
									;symbol equals ...
HuffCode		=	$75				;Canonical code accumulator in the header loop: per length asl $75,
									;HuffOffset,x = $75 - symbols ...
LZCmdByte3		=	$75				;Third byte of the 3-byte LZ token (lda [$0C],y / sta $75): offset low
									;byte, offset = (($73 and ...
HuffSymCount	=	$77				;Symbol count: header loop sums the codes of each length into it (adc $77
									;/ sta $77), the symbol ...
LZLenLo			=	$77				;Fourth byte of the 4-byte LZ token (lda [$0C],y / sta $77): low byte of
									;the copy length, length ...
HuffMaxLen		=	$79				;Longest code length index: x/2 at the end of the header loop (txa / lsr a
									;/ sta $79); bounds the ...
LZSrcIdx		=	$79				;Source index Y saved over each back-reference copy (sty $79 / ldy #0 /
									;copy [$6B],y / ldy $79)
HuffLenIdx		=	$7B				;Code length - 1 during the table fill (stz $7B, inc $7B): indexes
									;HuffCount (asl / tax) and the ...
LZDistance		=	$7B				;Back-reference distance: (cmd and $60)*8 + byte 2, or ((byte 2 and $3F)
									;<< 8) + byte 3, or the ...
HuffSpan		=	$7D				;Table entries per code of the current length, plus 1 (lda .4,x / sta $7D;
									;ldy $7D / dey / bne ...
introHookFlags	=	$C3				;Jobs pending for the intro frame hook (.framehook), set with tsb and
									;cleared there with trb: ...
introPal2Src	=	$D1				;Long pointer ($D1 address word, $D3 bank) of the second palette the intro
									;frame hook sends when ...
introBG1H		=	$D5				;BG1 horizontal scroll of the intro: .3 sets $0180 (also into BG1HScroll)
									;and tsb $0010; the ...
introBG1V		=	$D7				;BG1 vertical scroll of the intro: .3 sets $0190 (also into BG1VScroll);
									;the frame hook writes ...
burstspeed		=	$D7				;Speed of the burst: energy*$233 >> 16 (Mul16U high word $0A / sta $D7),
									;multiplied by the dirtab ...
cornerdy		=	$D7				;checkwallcoll corner circle: |d3 - d5|, the y distance from the corner
									;center (93S mulb at .dy); ...
introM7A		=	$D9				;Mode 7 matrix A (x scale) of the intro: .23 sets $0100, .24 sets $0001,
									;the zoom step .6 adds ...
introM7D		=	$DB				;Mode 7 matrix D (y scale) of the intro, always stored with the same value
									;as introM7A (sta $D9 / ...
mulres			=	$DD				;SuperMult (passbits *= d0): passbits is copied here and cleared (sta
									;$DD,x for x = $0E..0), then ...
PlayersUnused	=	$E6				;never read: updateplayers sets $FFFF for every object at the top of the
									;per-object loop (lda #$FFFF / sta ...
curobjteam		=	$EA				;never read. Team of the object being updated, 0 = home, 2 = away:
									;updateplayers sets 0 before the loop and 2 ...
curobjopp		=	$EC				;never read. The other team of the object being updated (2 for the home
									;objects, 0 from X = $0C on), set ...

xsave		=	$87					; X saved around the push/pop loops
a4			=	$99					; long pointer; a4+2 is the bank
d3			=	$B1
d4			=	$B5
d5			=	$B9
d6			=	$BD
a5			=	$9D					; long pointer (the next of the 4-byte a registers); a5+2 is the bank
vcount		=	$83					; 32-bit frame counter, +1 per NMI (NMI_Tick; 93S vcount)
crowdhold	=	$81					;frames the crowd level holds before it fades (Goal 120, puckglue 20;
									;updatecrowdf counts it down)
tmp3		=	$CB					; scratch word (after tmp0-tmp2)
tmp4		=	$CD					; scratch word
tmp5		=	$CF					; scratch word
curobj		=	$E4					;object index of the object being updated (updateplayers,
									;CalcPuckDistances store X; the assignments reload it)

; $0100-$09FF: the DMA queue, the decompressor tables, the NMI / IRQ hooks and PPU copies, the sprite tile
; cache, and the sound sequencer (Track* arrays: 17 tracks, track 16 = sound effects; Voice* arrays: 8 voices)
DecompBuf			=	$0100		;DecompressPairs / DecompressHuffman scratch (pair flags, the Huffman
									;symbol list): the DMAQueue RAM
DMAQueue			=	$0100		; Ring of 128 8-byte VRAM transfer entries: ...
DecompTab1			=	$0500		;DecompressPairs: first byte of each pair code (sta DecompTab1,x, read in
									;the expand loop); DecompressHuffman: ...
DecompTab2			=	$0600		;DecompressPairs: second byte of each pair code (sta DecompTab2,x);
									;DecompressHuffman: code-length jump index of ...
HuffCount			=	$0700		;DecompressHuffman header loop: sta HuffCount,x = number of codes of each
									;length (x = 2*length, 16 words), ...
HuffOffset			=	$0720		;DecompressHuffman: sta HuffOffset,x = first code minus symbols so far,
									;per length; long-code decode does sbc ...
HuffLimit			=	$0740		;DecompressHuffman: sta HuffLimit,x = left-justified code limit per
									;length; long-code decode compares against ...
HuffLongVec			=	$0760		;DecompressHuffman: sta HuffLongVec = compare-chain entry chosen by the
									;longest code length; jmp (HuffLongVec) for ...
FrameCount			=	$0764		;NMI_SendOAM inc FrameCount each NMI (unless FrameCountHold); WaitFrame
									;waits for it to change; Reset_Fast clears it; ...
CGDMALen			=	$0768		;DMAToCGRAM (screen on) stores colours*2 at CGDMALen; NMI_HookReturn DMAs
									;that many bytes to CGRAM when ...
CGDMAColour			=	$076A		; DMAToCGRAM sty CGDMAColour (first colour); NMI_HookReturn ldx
									;CGDMAColour -> CGADD
CGDMASrc			=	$076C		; DMAToCGRAM sta CGDMASrc ($0C); NMI_HookReturn -> A1T0L
CGDMABank			=	$076E		; DMAToCGRAM sta CGDMABank ($0E); NMI_HookReturn ldx CGDMABank -> A1B0
FrameHookNext		=	$0770		;SetFrameHook sta FrameHookNext / stx $0772 (bank); NMI_SendOAM: when
									;$0771 (address high byte) is nonzero copies ...
NMIHookNext			=	$0773		;ClearNMIHook sta NMIHookNext / stx $0775 (bank); NMI_Fast: when $0774 is
									;nonzero copies it to NMIHook ...
Multi5Sig			=	$0781		;Multi5ConnectCheck rol.w JOYSER0/1 bit 1 into $0782/Multi5Sig (port 1)
									;and $0784/$0783 (port 2); $FF then ...
FrameCountHold		=	$0787		;NMI_SendOAM: lda FrameCountHold bne skips inc FrameCount; no writer in
									;routines apart from the Reset_Fast clear
FrameHook			=	$0789		;NMI_SendOAM jml [FrameHook] (returns to NMI_FrameHookReturn); loaded from
									;FrameHookNext; Reset_Fast copies ...
NMIHook				=	$078C		;NMI_Fast jml [NMIHook] (returns to NMI_HookReturn); loaded from
									;NMIHookNext
IRQHook				=	$078F		;IRQ_Fast jml [IRQHook]; SetIRQ sta IRQHook / stx $0791 (bank =
									;IRQHook+2); IRQOff sets IRQHook_Off; the IRQ_* ...
seed				=	$0792		;RandomWord's two 16-bit generators (seed, $0794);
									;FallDown/chk4shot/asspuckc/chk4lc read seed where 93S ...
RAMTag				=	$0796		;Reset_Fast copies InitTag 'EACDSI' here (and to RAMTag2 and
									;ReplayBufferEnd); no reader found - a RAM marker
MapVRAM				=	$079C		;VRAM word address of the screen map:
									;MapToVRAM/MapPartToVRAM/MapPartToVRAMOffset/Mode7MapToVRAM add row*32 ...
MapScreenStep		=	$079E		;MapToVRAM/MapPartToVRAM add MapScreenStep to the VRAM address after row
									;31 (to the next 32-row screen); no writer ...
SpriteBlockTiles	=	$07B8		;InitSprites: (Y+$1F)&~$1F (at least $1A0) = tiles of the 16x16 block area
									;of sprite VRAM; LoadFrameTiles ...
FrameCacheCount		=	$07BA		;Tile cache entries in use: InitSprites stz, LoadFrameTiles inc (max $80),
									;FreeCacheEntry dec; ...
FrameTilesFail		=	$07C0		;GetFrameTiles stores $FFFF here when LoadFrameTiles finds no room; never
									;read
CacheUseMark		=	$07C2		;InitSprites sets 2; GetFrameTiles stores it in the entry's FrameCacheUse
									;word, which SpriteFrameStart shifts ...
DrawFrameNum		=	$07C4		;DrawSprite/FreeFrameTiles/GetFrameTiles store the frame number here; with
									;FrameByNumber set the cache ...
FrameByNumber		=	$07C6		;Nonzero ($FFFF from StartGame/ReloadRink):
									;GetFrameTiles/FreeFrameTiles/DrawSpritePieces find the entry by ...
PieceX				=	$07C8		;DrawSprite/DrawSpritePieces: x offset of the current frame piece (with
									;$1C); ...
PieceY				=	$07CA		;DrawSprite/DrawSpritePieces: y offset of the piece (from $1E);
									;LoadFrameTiles reuses it for the 8x8 tile ...
PieceTile			=	$07CC		;DrawSpritePieces: piece tile/attribute word, + first tile $16, eor $14 ->
									;OAM +2
PieceSize			=	$07CE		;DrawSpritePieces: piece size byte (0 = 8x8, else 16x16: centre 15 not 7,
									;size bit in the OAM high table)
PieceNext			=	$07D0		;DrawSprite/DrawSpritePieces sty PieceNext: offset of the next piece
									;record of the frame
IRQVTime			=	$07D2		;SetIRQ sty IRQVTime (IRQ line); NMI_HookReturn
									;writes it to VTIMEL every frame
IRQHTime			=	$07D4		;NMI_HookReturn writes it to HTIMEL every frame; set by
									;SetupBandIRQ/SetupScrollIRQ/TitleScreen
BG1HScroll			=	$07D6		;NMI_HookReturn writes the 6 words BG1HScroll..$07E1 to BG1HOFS..BG3VOFS
									;(x = 0..$0B, $07D7 = BG1HScroll+1); ...
BG1VScroll			=	$07D8		;2nd word of the NMI_HookReturn scroll list
									;(BG1VOFS); ResetPPURegs sets $FFFF
BG2HScroll			=	$07DA		;ShowRinkRows stores Hscroll+$C0 here, as 93S writes BG2HOFS = Hscroll+$C0
BG2VScroll			=	$07DC		; ShowRinkRows stores vramrow*8 + (Vscroll&7), the 93S BG2VOFS value
BG3HScroll			=	$07DE		;5th word of the NMI_HookReturn scroll list (BG3HOFS);
									;ResetPPURegs/PlayoffScreen/TitleScreen
BG3VScroll			=	$07E0		;6th word (BG3VOFS); IRQ_BG1Scroll also writes BG3VScroll/$07E1 to BG1VOFS
									;for the lower band
Mode7InUse			=	$07E2		;TitleScreen/IntroSequence set $FF, ResetPPURegs clears; MulFrac8 bit
									;Mode7InUse / MulFrac16 bit $07E1 (16-bit: ...
SoundMono			=	$07E3		;StepTrack (event $DE, program change) and PlaySound: nonzero -> both side
									;volumes from instrument byte $17 ...
EchoVoices			=	$07E7		;Controller $32 (StepTrack); SeqCmd08 sends it with command $82, which the
									;driver ($0631) writes to DSP EON ...
NoiseVoices			=	$07E8		;Controller $39; SeqCmd08 command $82 APUIO1 ->
									;driver writes DSP NON ($3D)
PitchModVoices		=	$07E9		;SeqCmd08 command $08 APUIO3 -> driver writes DSP PMON ($2D) (and ORs it
									;into FLG); only ever cleared ...
EchoDelay			=	$07EA		;Controller $33; SeqCmd08 command $83 APUIO2 -> driver writes DSP EDL
									;($7D) (ESA = $E0)
EchoVolume			=	$07EB		; Controller $34; SeqCmd08 command $09 APUIO1/2 -> DSP EVOL L/R ($2C/$3C)
EchoFeedback		=	$07EC		; Controller $35; SeqCmd08 command $09 APUIO3 -> DSP EFB ($0D)
SongPtr				=	$07ED		;MusicStart sta SongPtr (song address $0C); Opening/PlayoffScreen compare
									;it with the menu/playoff song ...
SongUnused			=	$07EF		;MusicStart stz SongUnused; first byte of the sound RAM SoundInit clears
									;(SongUnused..$0A09); never read
MusicPause			=	$07F1		;SequencerTick: nonzero -> UpdateVoices but no StepTrack; SoundUpdate
									;tests it around a no-op save/restore ...
TempoAcc			=	$07F5		;SequencerTick adds $40 each frame and runs a tick (subtracting TempoTick)
									;while it reaches TempoTick
TempoTick			=	$07F6		;SequencerTick tick threshold; MusicStart sets it from the song header
									;(DivX8U), StepTrack event $DD sets ...
InstVolL			=	$07FB		;StepTrack event $DE: instrument byte $12 (left, or $17), scaled by the
									;event value into TrackVolL; ...
VoiceVolL			=	$07FC		;Left volume sent to the driver: SeqCmd07 APUIO2 (DSP VOL L), StepTrack
									;command $0E; StartSoundVoice = ...
InstVolR			=	$07FD		; StepTrack event $DE: instrument byte $13 (right, or $17)
VoiceVolR			=	$07FE		;Right volume: SeqCmd07 APUIO3 (DSP VOL R), StepTrack command $0E;
									;FindFreeVoice reuses it for the new ...
CurTrackOfs			=	$07FF		;StepTrack stx CurTrackOfs (track*2) and reloads X from it;
									;PlaySound/QueueSound set $20 (track 16, sound effects)
VoiceOfs			=	$0800		;Voice*2 of the voice being worked: StartSoundVoice asl/sta VoiceOfs, ldx
									;$0800; UpdateVoices/UpdateSfxVoices ...
TrackCount			=	$0801		;MusicStart: song header byte 6; SequencerTick steps tracks TrackCount-1
									;down to 0; MusicStop clears it
MusicDuck			=	$0802		;StartSoundVoice: nonzero halves (negative: quarters) the volumes of music
									;voices (track != $10); no writer ...
TrackPtr			=	$0804		;17 words (tracks 0-15 music, 16 = sound effects): MusicStart stores each
									;track start; StepTrack reads ...
TrackLoop			=	$0826		;MusicStart = track start; StepTrack event $E2 copies TrackPtr here, event
									;$DB copies it back
TrackWait			=	$0848		;StepTrack: ticks to the track's next event (ReadVarLen delta, dec each
									;tick); ClearTracks zeroes it
TrackInst			=	$086A		;Instrument/sound entry pointer of the track: event $DC (program change)
									;from the [$34] table, ...
TrackBend			=	$088C		;StepTrack event $E5 (pitch bend) stores the bend;
									;StartSoundVoice/StepTrack bend the voice pitch by it
TrackBendRange		=	$089D		;Instrument byte $2F (StepTrack program change, PlaySound); notes the full
									;bend spans (StartSoundVoice adds ...
TrackVolL			=	$08AE		;Track left volume: controller $0B, event $DE, instrument byte $12;
									;StartSoundVoice scales it by velocity ...
TrackVolR			=	$08BF		;Track right volume: controller $0C, event $DE, instrument byte $13 ($08CF
									;= TrackVolR+$10 in PlaySound)
TrackSustain		=	$08D0		;Controller $40 (sustain pedal) value; StepTrack releases the track's
									;voices when it becomes 0, UpdateVoice ...
TrackUnused			=	$08E1		; MusicStart sets all 17 bytes to $1F; never read
VoiceState			=	$08F2		;0 free (FindFreeVoice), 1 gain / 2 ADSR (StartSoundVoice by instrument
									;ADSR1 bit 7), 3 set by ...
VoiceTrack			=	$08FA		;Track that owns the voice (StartSoundVoice sta $4A; $10+ = sound effect,
									;$FF after StopVoice); ...
VoiceVelocity		=	$0902		;StartSoundVoice: VolumeCurve[velocity]*2; StepTrack event $DE rescales
									;TrackVolL/R by it for the playing ...
VoiceNote			=	$090A		;StartSoundVoice: note + instrument transpose (byte $04); StepTrack pitch
									;bend reads PitchTable at it
VoicePriority		=	$0912		;Instrument byte $2A (StartSoundVoice); FindFreeVoice only steals a voice
									;whose priority is not above the ...
VoiceLength			=	$091A		;StartSoundVoice: note length - 1; UpdateVoice counts it down and releases
									;the voice at 0
VoiceInst			=	$092A		;Sound entry pointer the voice plays (StartSoundVoice $4E);
									;QueueSound/StopSound/PlaySound .stop find a ...
VoiceGain			=	$093A		;Gain word whose high byte SeqCmd0C0B sends as DSP GAIN (UpdateSfxVoices
									;$5A); instrument byte $0A at ...
VoicePitch			=	$094A		;Pitch (instrument tuning + bent PitchTable value); UpdateSfxVoices adds
									;VoiceVibOfs and sends it ...
VoiceBasePitch		=	$095A		;StartSoundVoice: PitchTable[note] before the bend; StepTrack event $E5
									;rebends from it
VoiceAge			=	$096A		;Zeroed at start, inc every frame (UpdateSfxVoices); vibrato runs while it
									;is between instrument $18 and ...
VoiceVibCount		=	$097A		;UpdateSfxVoices dec; when negative steps the vibrato and reloads it from
									;VoiceVibRate
VoiceVibOfs			=	$098A		;Vibrato pitch offset: +/- VoiceVibSpeed per step up to VoiceVibDepth,
									;added to VoicePitch
VoiceVibRate		=	$099A		;Frames between vibrato steps: instrument $1C, ramped by instrument
									;$2A/$2C (fraction in VoiceVibRateFrac)
VoiceVibRateFrac	=	$09AA		;Fraction of VoiceVibRate (UpdateSfxVoices clc adc instrument $2A, carry
									;into VoiceVibRate)
VoiceVibDepth		=	$09BA		;Vibrato limit: instrument $20, ramped by $26/$28; at |VoiceVibOfs| >= it
									;the vibrato turns or resets
VoiceVibDepthFrac	=	$09CA		; Fraction of VoiceVibDepth
VoiceVibSpeed		=	$09DA		;Vibrato step: instrument $1E, ramped by $22/$24; added to / subtracted
									;from VoiceVibOfs
VoiceVibSpeedFrac	=	$09EA		; Fraction of VoiceVibSpeed
VoiceVibDir			=	$09FA		;0 = vibrato offset rising, $FFFF = falling (bit VoiceVibDir,x; dec/inc to
									;flip at the limit by instrument $2D ...
JoyPad				=	$0776		; buttons held, a word per pad (5 pads)
HeapStart7E			=	$07A0		; first block header of the bank $7E heap
HeapStart7F			=	$07A2		; first block header of the bank $7F heap
NewHandleSlot		=	$07A4		; NewHandle: the free handle being filled
NewHandleSkipBank	=	$07A6		; NewHandle: the bank it must not use
SoundLock			=	$07E5		; nonzero: SoundUpdate does nothing (decremented around sound work)
MusicOn				=	$07F3		; nonzero while a song plays
SoundVolume			=	$07F7		; master volume; its high byte goes to the sound driver
SoundFadeSpeed		=	$07F9		; subtracted from SoundVolume each frame; at 0 the sound is reset
OAMReady			=	$0766		; nonzero: the NMI copies the OAM buffer at OAMShowBuf to OAM
OAMLastEnd			=	$07A8		; OAMNext of the frame last finished
OAMDrawBuf			=	$07AA		; OAM buffer (bank $7E) the sprites are drawn into
OAMShowBuf			=	$07AC		; OAM buffer (bank $7E) the NMI copies
SpritesLeft			=	$07AE		; OAM entries still free this frame
OAMHiPtr			=	$07B0		;byte of the OAM high table that takes the next
									;entry's size and X high bits
OAMHiShift			=	$07B2		; position of the next entry in that byte, 3 down to 0
SpriteVRAM			=	$07B4		; VRAM word address of sprite tile 0
SpritesReserved		=	$07B6		; OAM entries at the start that the sprite drawing leaves alone
OAMNext				=	$07BC		; next OAM entry to fill in OAMDrawBuf
OAMHideEnd			=	$07BE		; SpriteFrameEnd moves the entries from OAMNext up to here off screen
mesarea				=	$0A2A		; string being built: a length word, then the bytes
mesareaEnd			=	$0A48		; one past the last digit PushNumber and PushTime may write
puckc				=	$0AD9		; object index of the puck carrier, negative = loose
RemapOut		=	$0A0A			; sixteen words: the tile RemapTiles is building
IniDispShadow		=	$0762		; INIDISP value the NMI writes (forced blank, brightness)
fadestep			=	$0AD1		; fade: a delay counting down to a fade in, or $FFFF to fade out (NMI)
brightness			=	$0AD3		;screen brightness 0-15 the fade sets; BrightnessHook writes it to INIDISP
pausepad			=	$0AC6		; the controller that owns the pause menu
padlast				=	$0A9A		; 5 words: each pad's buttons at the last ReadPads
paddir				=	$0AA4		; 5 words: each pad's direction (PadDirection of the dpad bits)
padchange			=	$0AAE		; 5 words: each pad's buttons that changed at the last ReadPads
padnew				=	$0AB8		; 5 words: each pad's buttons newly pressed at the last ReadPads
puckdist			=	$0B1D		; per object: distance to the puck (ApproxLength)
puckdist2			=	$0B3D		; per object: about (dx^2 + dy^2) / 4 to the puck
puckdir				=	$0B5D		; per object: direction to the puck (vtoa)
dumpinplayer		=	$0BA3		; the player dumping the puck in (assdumpin), -1 none
dumpintarget		=	$0BA5		;assdumpin: the target index (DumpInTarget), a word offset into its x / y
									;tables

; $0A4A-$0CD3: print buffers, pads, pass and goalie state, the title screen and credits (they reuse
; $0BCB-$0BFF: their names are used only in those routines), the crowd sprites, the replay sound record and
; the addframe parameters (93S names)
PWCharStr		=	$0A4A			;PasswordScreen: a one-character print string (length word 3, then the
									;PasstoText character) printed ...
PushWidthBuf	=	$0A8E			;PushNumberWrap/PushNumberWidth: length word (digits + 2), then 8
									;characters ($0A90-$0A97) set to spaces ...
gamefps			=	$0A98			;Gameloop: gameframes (game frames since the faceoff) * 60 / FrameCount
									;(NMI frames since the faceoff) = game frames ...
padchangeany	=	$0AC2			;ReadPads: OR of the five padchange words; ReadAnyPad returns it in d1;
									;SaveRegsStartHL2 clears it.
repeatdelay		=	$0AC4			;ProcessInputWithRepeat: frames to the next key repeat (dec, reload 6 / 20
									;on a change), as the 93S ...
pausepadidle	=	$0AC8			;SelectPauseController: 60 when the pause pad holds a button, -3 per idle
									;frame; at 0 pausepad goes back to ...
mp5padsig		=	$0ACA			;Multi5Bios: 5 bytes, one per pad: the low nibble of JOYxL (controller
									;signature) shifted left with one ...
bosgames		=	$0ACF			;ReadPassBits/WritePassBits read and write it at the 93S bosgames slot
									;(range 8); 0-6 = game of the best of ...
WinBits			=	$0AD5			;ReadPassBits/WritePassBits at the 93S WinBits slot (range $4000);
									;ResolveGames sets the bits of the teams ...
mp5readall		=	$0AD7			;PlayerSelect sets $FFFF while it runs and clears it at the end; when
									;nonzero Multi5Bios reads the multitap ...
timestep		=	$0ADB			;Gameloop/SaveRegsStartHL2/ReplayMode/PauseReplay store d7 (frames
									;elapsed) here (PauseMenu sets 2); ...
padinputdone	=	$0ADD			;updateplayers: 5 words (pad*2) cleared each frame, set to 1 when the
									;pad's doinput has run; ...
PadControlObj	=	$0AE7			;setpads stores SCnum of the player each marker slot follows (slot 0 puck
									;carrier, 1-5 pads, 6 replay ...
fopadfirst		=	$0AF5			;FaceoffPads: per team (home here, away +2) the first pad given a player
									;(findpc) at the last faceoff; the ...
padsitnext		=	$0AF9			;asspenalty/assepen/FaceoffPads, indexed by team (a2): round-robin pad
									;index for sitting a pad out (padside ...
puckpadnext		=	$0AFD			;PuckCarrierPad/puckfaceoff2, indexed by team: the pad that last got the
									;puck carrier, the round-robin ...
passpad			=	$0B01			;dopass stores the passer's pad (playerpad,x) per team (a2); puckglue
									;gives that pad to the pass receiver ...
goalieflags		=	$0B05			;Per player (12): assgoalie/assgoalietopuck set bits 1,2 and clear bit 2
									;inside the crease, bit 1 near the ...
asscur			=	$0B7D			;Per object: the assignment number being run (the asslist entry at
									;assnum), set by ...
topgoalie		=	$0B9D			;updateplayers: each frame the goalie (position 0) with Ypos >= 0 (top
									;goal end), $FFFF none; avdgoal uses ...
botgoalie		=	$0B9F			;updateplayers: the goalie with Ypos < 0 (bottom goal end); avdgoal for
									;the net at y -$108; topgoalie+2 in ...
goaliestopped	=	$0BA1			;assgoalie: set after the CPU goalie is stopped dead once while an
									;opposing carrier is in a shot animation ...
passtargetx		=	$0BA7			;dopass: puckx + the pass vector x (where the receiver meets the puck);
									;asspassrec aims the one-timer from ...
passtargety		=	$0BA9			;dopass: pucky + the pass vector y; asspassrec: goal line y (+-$108) minus
									;it for the one-timer direction.
onetimerreq		=	$0BAB			;Set when the pass receiver's pad presses shoot (asspassrec, doinput) or
									;the CPU decides; asspassrec then ...
passwait		=	$0BAD			;Per player: dopass sets the receiver's frames until the puck arrives
									;(d6+6); asspassrec counts it down by ...
lastshotspeed	=	$0BC5			;doshot stores passspeed (the shot speed after the backhand cut) here;
									;nothing reads it.
goalieturnwait	=	$0BCB			;Per player: AdjustFacingDirection/goalieacc set 6 after turning a
									;goalie's facedir one step and count it ...
TitleWH1		=	$0BCB			;Title: the WH1 window edge the frame hook writes; TitleWindowWipe moves
									;it, TitleScreen clears it.
TitleWH3		=	$0BCD			;Title: the WH3 window edge for the top band (frame hook); TitleScreen
									;steps it $42, $7D, $FF as the title ...
TitleWH3Low		=	$0BCF			;Title: the WH3 edge .irq1 writes for the band below line $46;
									;TitleWindowWipe moves it.
TitleBGMode		=	$0BD1			; Title: the BGMODE the frame hook writes for the top band (9, then 1).
TitleM7TM		=	$0BD3			; Title: the TM value .irq2 writes for the mode 7 band ($11 / $10).
TitleTeamIdx	=	$0BD5			;ShuffleTitleTeams fills the 26 team list at titleteams (it is the byte
									;count while filling); NextTitleTeam ...
CreditStep		=	$0BD9			;StartCredits/RollCredits: credits state (0 scroll title and name, 1
									;scroll name, 2 hold, 3 done).
CreditTime		=	$0BDB			; RollCredits: the FrameCount frame count at which the next credits step
									;runs.
CreditTitleIdx	=	$0BDD			; RollCredits: index into CreditTitles.
CreditTitleY	=	$0BDF			;RollCredits: screen y of the credit title
									;(PrintStringSprites), scrolls up from $E0.
CreditNameIdx	=	$0BE1			; RollCredits: index into CreditNames.
CreditNameY		=	$0BE3			; RollCredits: screen y of the credit name, scrolls up from $F0.
LogoSrcOfs		=	$0BE5			;LoadTitleLogo: source offset of the logo row being unpacked (+$20 a row).
LogoDstOfs		=	$0BE7			;LoadTitleLogo: offset into the titlelogobuf mode 7 buffer of that row
									;(+$40 a row).
goaliedivewait	=	$0BEB			;Per player: assgoalie sets $168 after a dive and $F0 after a poke check;
									;updateplayers counts it down by ...
TitleSkipMask	=	$0BEB			;Title: the frame hook ends the title (titleskip) when JoyPad has a bit of
									;it; 0 at first, $F0C0 once the ...
LogoPalBits		=	$0BED			;LoadTitleLogo: the palette bits ($60 or $70) ORed into every unpacked
									;logo pixel.
TitlePathPos	=	$0BEF			;TitleScreen .6: integer part of the logo path position (TitlePathFrac
									;carries into it); with TitlePathFrac+1 it ...
TitlePathFrac	=	$0BF1			; TitleScreen .6: fraction of the path position (+$0C00 a frame).
TitleM7X		=	$0BF3			; Title .irq2 writes it to M7X (low, then $0BF4 high).
TitleM7Y		=	$0BF5			; Title .irq2 writes it to M7Y.
TitleM7HOfs		=	$0BF7			;Title .irq2 writes it to BG1HOFS;
									;TitleZoomOutLeft/Right and the path move it.
TitleM7VOfs		=	$0BF9			;Title .irq2 writes it to BG1VOFS;
									;TitleZoomOutLeft/Right and the path move it.
TitleM7Scale	=	$0BFB			;Title .irq2 writes it to M7A and M7D (the zoom);
									;TitleZoomIn/OutLeft/OutRight step it between $100 and $200.
TitlePathFlip	=	$0BFD			;TitleScreen .6: toggled at each path end; nonzero negates the path's
									;horizontal offset.
TitleLogoFlags	=	$0BFF			;TitleScreen: bit 1 = the logo path runs, bit 0 = path ended: load the
									;next team logo (NextTitleTeam, ...
benchrounds		=	$0C25			;StartBenchCheer clears it, UpdateBenchCheer counts the cheer rounds (ends
									;after 4), FallDown sets 2 ...
benchtimer		=	$0C27			;StartBenchCheer sets 11; UpdateBenchCheer counts it down by timestep and
									;steps benchframe when it runs out.
crowdanim		=	$0C2B			;showcrowd: per crowd sprite slot (21 words, x = 0-$28): the
									;CrowdAnimTable sequence playing (0 idle, $A, ...
crowdanimstep	=	$0C55			;showcrowd: per slot the byte offset of the current frame in the sequence
									;(+2 each step).
crowdanimtime	=	$0C7F			;showcrowd: per slot frames left on the current frame (count down by
									;timestep).
replaydelay		=	$0CA9			;Goal / Stop4Pen set 30: updatereplay keeps recording until it counts down
									;to 1, then stops; puckfaceoff2 / ...
replaylock		=	$0CAB			;ReplayMode: object the replay camera / cursor locks onto; $FFFF = none
									;(follows PadControlObj slot 0 or ...
recsfx			=	$0CAD			;QueueSound: the sound queued this frame ($FFFF none) for the replay
									;record; updatereplay records it ...
recsfxpitch		=	$0CAF			;StartSoundVoice / PuckSfx / updatepwrplay store the voice pitch
									;(VoicePitch) of the recorded sound; ReplayMode ...
recsfxvol		=	$0CB1			;StartSoundVoice stores the sound's volume (VoiceGain); ReplayMode puts it
									;in $64 (the volume in the high byte) ...
recsfx2			=	$0CB3			;QueueSound moves recsfx here when a second sound comes in the same frame;
									;recorded and replayed like recsfx.
recsfxpitch2	=	$0CB5			;QueueSound copies recsfxpitch here with recsfx2; ReplayMode restores
									;VoicePitch from it.
recsfxvol2		=	$0CB7			; QueueSound copies recsfxvol here; ReplayMode loads $64 from it.
replaynewframe	=	$0CB9			;RestoreReplayFrame increments it, ReplayMode clears it after drawing;
									;showcrowd animates during a replay ...
replaymusic		=	$0CBB			;PauseReplay saves MusicOn here; at the end of ReplayMode a nonzero value
									;restarts the menu / playoff song.
replayHpos		=	$0CBD			;ReplayMode: the replay camera x, eased toward the locked object / cursor
									;(4 or 2 a frame, clamped) and ...
replayVpos		=	$0CBF			; ReplayMode: the replay camera y, eased the same way and written to Vpos.
camobj			=	$0020			; ReplayMode: object slot used as the replay camera (Xpos / Ypos and the
									; wall check, as 93G CameraPosStruct)
percue			=	$0CC1			;StartPer sets $FFFF (cleared in some modes); puckfaceoff2 then plays team
									;song slot 0 (the period start ...
cursong			=	$0CC3			;PlayTeamSong stores the TeamSongs slot + 1 of the song started; the SPC
									;uploads and UpdateStreamSfx (no ...
sprhflip		=	$0CC5			;addframe parameter: nonzero = x flip (attribute $4000);
									;setsortcords/checkfo set attribute & $0800 as 93S ...
reloadtime		=	$0CC7			;StartPer clears it, ReloadRink adds 60 each time it reloads the rink;
									;never read.
sprattr			=	$0CC9			;addframe parameter: the OAM attribute word for DrawSprite (priority,
									;palette $0200; addframe ORs in the ...
sprpriority		=	$0CCB			;checkfo sets $3000 for the faceoff sprites and $2000 after, ORed into
									;sprattr; setoptions sets 0: as 93S ...
sprframe		=	$0CCD			;addframe parameter: sprite frame number (1-based, at most $3D0), as 93S
									;sprframe; set by setsortcords, ...
sprx			=	$0CCF			; addframe parameter: screen x of the frame (93S sprx).
spry			=	$0CD1			; addframe parameter: screen y of the frame (93S spry).
sprvflip		=	$0CD3			;addframe parameter: nonzero = y flip (attribute $8000); setsortcords sets
									;attribute & $1000 as 93S sprvflip.
titleskip			=	$0BE9		; set when a pad press ends the title sequence

; Cleared but never set or read (no job in the ROM)
GoalieUnused	=	$0BC9			; assgoalietopuck clears it when the assignment starts
FaceoffUnused	=	$0C0B			;per player (12 words): FaceoffPads clears it with goalieflags,
									;goalieturnwait, goaliedivewait
PauseUnused		=	$1D60			; Pausemode clears it when the pause menu is left (with pregamepause)
Hscroll				=	$0CED		; horizontal scroll
iflags				=	$0CF1		; icing flags (if* masks)
passdir				=	$0D03		; direction for pass/shot 0-7 (8 = none)
passspeed			=	$0D05		; speed of pass/shot
printx				=	$0D0F		; x cordinate for printing (text map column)
printy				=	$0D11		; y cordinate for printing
Hpos			=	$0CEB			; ice rink horizontal position
printm			=	$0CD9			; offset of the print map in the text map
textdirtylo		=	$0CD5			; lowest changed word of the text map
textdirtyhi		=	$0CD7			; highest changed word of the text map
benchcheer			=	$0C23		; the bench that is cheering (StartBenchCheer), 0 none
benchframe			=	$0C29		;bench cheer frame: set * 8 + step, drawn by setsortcords; negative = none
									;(kept in the replay)

; Game variables from $0CD5 to $0D55, in the order 93S has them (names from the 93S routines that use them the
; same way)
collflag			=	$0CDB		;a player collision happened: checkcoll restores the old position (set by
									;Bcheck, checkgoal)
impactstep			=	$0CDD		; d7*2: impact decay this game frame (Gameloop)
velstep				=	$0CDF		; d7*16: velocity to position scale this game frame
gravstep			=	$0CE1		; d7*96: gravity this game frame
pausetimer			=	$0CE3		; pause menu: frames left before a demo pause ends by itself
ThirdPBonus			=	$0CE5		; setplayer: +2 when tied or trailing late in the 3rd period
cheercnt			=	$0CE7		; crowd cheers still to play after a goal (one every 150 frames, Gameloop)
cheervc				=	$0CE9		; vcount of the last crowd cheer
lastplayer			=	$0CF3		; the last player who touched the puck (doshot, puckstick)
lldisp				=	$0CF7		; count down for the once-a-second screen / game updates (periodicevents)
nibblebuffer		=	$0CF9		; 4 words: the weights SetScore picks from
oldvcount			=	$0D01		; vcount at the last game frame (d7 = vcount - oldvcount)
passReceiverPlayerNum	=	$0D07	; the player the last pass was aimed at (negative = none)
printa				=	$0D0D		; attribute (palette / priority bits) for print characters
psfirst				=	$0D13		; pause menu: first item shown (Pmenu shows five from here)
psitem				=	$0D15		; pause menu item
puckcross			=	$0D17		;2 entries of (x, frames): where / when the puck crosses the top / bottom
									;goal line
shotplayer			=	$0D29		; the player who shot last (doshot)
sfxmutetime			=	$0D2B		; vcount of the last goal: Stop4Pen waits 60 frames after it
threat				=	$0D2D		; direction of threat on puck handler (nonzero = threat)
demoflag			=	$0D2F		; nonzero in demo mode
TickerNum			=	$0D31		; playoff game the score ticker shows next
tickervc			=	$0D33		; vcount when the ticker box was last shown
lastframevc			=	$0D35		; vcount of the last game frame (Gameloop)
wcradiusx			=	$0D3B		; wall collision radius x
wcradiusy			=	$0D3D		; wall collision radius y
screentimer			=	$0D41		; frames left on the scouting report screen
DispAttribCtr		=	$0D47		; text column (scouting report, line and shooter lists)
yleader				=	$0D4F		; lead distance on scrolling
vcountmark			=	$0D51		; 32-bit vcount snapshot: elapsed time base
ReplayBufferPtr		=	$0D1F		; long pointer to the next replay frame record
Vscroll				=	$0D39		; vertical scroll (low 3 bits = BG2 fine scroll)
Xpos				=	$0D55		; x position (integer part) of each object
Ypos				=	$0DB7		; y position (integer part) of each object
pucky				=	$0DD3		; puck y position
puckvx				=	$0EDF		; puck x speed
Vpos			=	$0D37			; ice rink vertical position
xc1				=	$0D4B			; scroll lock x
yc1				=	$0D4D			; scroll lock y
Oldrow				=	$0D23		; last rink map row
vramrow				=	$0D25		; BG2 tile map row at the top of the ring buffer
VertLineScrolling	=	$0D49		; scouting report vertical scroll
PlayerScrollCtr		=	$0D3F		; scouting report player scroll
SelectedPlayerIdx	=	$0D43		; scouting report selected player
ScoutingReportTimer	=	$0D45		; scouting report timer

; Sort objects: a word per object in each array, 16 objects ($20 bytes; Xpos and Ypos have a 17th, the replay
; cursor point), indexed by object * 2. The 93S struct order: 94S keeps height only for the puck (puckz ...)
; and drops Zvel, limpact and pf2fight.
Xfrac		=	$0D77				; fraction of Xpos
Yfrac		=	$0DD9				; fraction of Ypos
puckz		=	$0DF9				; puck height (93S Zpos+puckobj)
shadowz		=	$0DFB				; height of object 15, the puck shadow (setsortcords)
puckzfrac	=	$0DFD				; fraction of puckz
puckoldz	=	$0DFF				; puckz before this frame's move (93S OldZpos+puckobj)
puckvz		=	$0E01				; puck height speed (93S Zvel+puckobj)
oldframe	=	$0E23				; frame last drawn (setsortcords)
OldXpos		=	$0E43				; Xpos before this frame's move
rosxoff		=	OldXpos				; roster screen: sprite x offset from Xpos (slides -40..+40)
OldXfrac	=	$0E63
OldYpos		=	$0E83
OldYfrac	=	$0EA3
Xvel		=	$0EC3				; x speed (puckvx is Xvel+puckobj)
Yvel		=	$0EE3				; y speed
impactp		=	$0F03				; the other object (index) of the last collision or hold
impact		=	$0F23				; impact value, added to by collisions
temp1		=	$1003				; assignment scratch, per object
temp2		=	$1023
temp3		=	$1043
temp4		=	$1063
temp5		=	$1083
temp2b		=	$10A3
radiusx		=	$10C3				; collision width (InitSortObjects)
radiusy		=	$10E3				; collision height
SCnum		=	$1143				; object number (index / 2)
facefrac	=	$1183				; turn fraction of facedir (doplayeracc)
nopuck		=	$1203				; no puck collision until zero
nopuckb		=	$1223				; second count down
puckvy				=	$0EFF		; puck y speed
pfalock				=	$14E3		; nonzero: locked until the animation is done
Wallcos				=	$1103		; per object: cos of the angle of the last wall collision
Wallsin				=	$1123		; per object: sin of that angle

; player attributes, stored by setplayer in the 93S order
weight		=	$12C3
legstr		=	$12E3
legspd		=	$1303
aioff		=	$1323
aidef		=	$1343
shotspd		=	$1363
shotacc		=	$1383
passacc		=	$13A3				; passacc (goalies: glove save right)
rostnum		=	$13C3
spodds		=	$13E3				; shot / pass odds
stickhand	=	$1403
endurance	=	$1423				; endurance (goalies: stick save right)
aggress		=	$1443				; aggression: penalty odds (goalies: glove save left)
GGSleft		=	aggress				; goalie glove save left (92 name), puckgoalie
fighting	=	$1463				; fighting rating (stored; 94S has no fights; 93 $74)
checking	=	$1483				; checking rating (check odds; 93 $75)
handed		=	$14A3				; nonzero: right handed
pfrev		=	$1523				; nonzero: skating backwards. pflags bit pfrev
pf2aip		=	$1543				; nonzero: animation in progress. pflags2 bit pf2aip
pfnc		=	$1563				; nonzero: no collision mode. pflags bit pfnc
position	=	$0F43				;player's position
									;(0=goalie,1=l.def,2=r.def,3=l.wing,4=center,5=r.wing; negative = none)
SPA			=	$11A3				; current animation (offset into the animation data)
SPAnum		=	$11C3				; index into animation (4 per frame)
SPAcnt		=	$11E3				; count down to the next animation frame (-1 = restart)
frame		=	$0D97				;sprite frame number of each object (SPF groups); object 14 ($1C) is the
									;puck, 15 ($1E) its shadow
facedir		=	$1163				; direction of facing, 0-7
assnum		=	$0F63				; index of the current assignment (0-7)
asslist		=	$0F83				; assignments, 8 bytes per object
newpos		=	$1243				; requested next position (negative = none)
newpnum		=	$1263				; requested next roster player (negative = none)
pflags		=	$1283				;pflags (bits 0-7) and pflags2 (bit n at bit n+10); some flags have their
									;own arrays below
pnum		=	$12A3				; player's team location number (low byte)
pfgoal		=	$14C3				; nonzero: shoots at the top goal. pflags bit pfgoal
pfteam		=	$1503				; 0 = home, nonzero = visitors. pflags bit pfteam
gmode		=	$15D4				; game mode flags (gm* masks)
sflags		=	$15D8				; sflags (low byte) and sflags2 (high byte) as one word (sf*/sf2* masks)
sfhormode	=	$15DA				; nonzero: screen in horizontal mode. sflags bit sfhor
sflags3		=	$15DC				; sflags3 (sf3* masks)
Pencntdwn	=	$1620				; penalty/fight count down (negative = fight over)
pentimer	=	$1622				; frames to the next penalty clock second (updatepentime)
PBnum		=	$1624				; players in the penalty boxes: home*16 + visitors
InjCntDown	=	$1626				; frames until the injury box is shown
penmsgtimer	=	$1628				; count down to reprinting the horizontal penalty message line
RefCnt		=	$162A				; ref graphics control (negative = idle)
RefStep		=	$162C				; step in the ref animation (negative = done)
gsp			=	$1630				; game period
tmsort		=	$1766				; first object index of the team
tmline		=	$1796				; current line
tmtouch1	=	$179A				; pnum of the last touch
tmtouch2	=	$179E				; second last touch
tmtouch3	=	$17A2				; third last touch
tmap		=	$17A6				; active players on ice
tmgoalie	=	$17AA				; home and away goalie (words): low byte = goalie 0/1, $FFxx = pulled
tmflags		=	$17DE				; team flags
tmpde		=	$17EA				; energy of each roster player (word per player)
tmpdst		=	$1852				; bench/ice/box state of each roster player
tmboxlist	=	$18BA				; penalty box list of roster players (bytes, negative ends)
maxros		=	26					; roster slots per team (the visiting list starts maxros bytes on)
HomeTeam	=	$1C98				; home team number (TeamList index)
VisTeam		=	$1C9A				; visiting team number
tmdata		=	$1CDC				; team data address
OptPerlen	=	$7E34C2				; the period length option (index into GetPeriodTime_timetab)
HmAwBonus	=	$0CEF				; setplayer: home bonus / visitor penalty
PKBonus		=	$0D09				; setplayer: penalty kill bonus (negative)
PPBonus		=	$0D0B				; setplayer: power play bonus
attribute	=	$0E03				; frame attribute bits (attrxflip, attryflip)
Ylist		=	$1583				; y of each sort object
OOlistpos	=	$15A3				; position of each object in OOlist
OOlist		=	$15C3				; 16 bytes: object order list, bottom of the screen last
gameclock	=	$1632				; game clock seconds; gameclock+2 = jiffies
gmclock				=	$15D6		; nonzero: game clock is stopped
PenBuf				=	$15DE		; up to 32 penalties: (penalty number, object) word pairs, 0 = free
RefPen				=	$162E		; penalty number of the ref animation
TempPlOffset		=	$1636		; pnum of the penalized player, high bit set for the visitors

; Penalty shot and breakaway
IsBreakaway		=	$1638			; 1 while the puck carrier has a breakaway (CheckBreakaway)
PenShotActive	=	$163A			; 1 during a penalty shot (SetupPenaltyShot .. puckfaceoff2)
PenSumLength	=	$163C			; penalty log entries (94G PenSumLength; 94S counts entries, not bytes)
PenSum			=	$163E			;penalty log: $41 entries of (time word, player | $80 away, penalty)
									;(InProgress, FillPenaltyPage)
tmPwrGoals			=	$1742		;power play goals (team word pair); the first word clearTeamStats clears
									;(through $18ED)

; Team struct: word pairs (home, away) indexed by a2. TeamStatSources lists the stats screen rows they feed.
tmPwrPlays			=	$1746		; power plays
tmPenalties			=	$174A		; penalties
tmPenmin			=	$174E		; penalty minutes
tmATOP				=	$1752		; attack zone time (chkatop)
tmPwrPlayTime		=	$1756		; power play time (CountPowerPlayTime)
tmPPShots			=	$175A		; power play shots (ChkShotStat)
tmSHShots			=	$175E		; shorthanded shots (ChkShotStat; not on the stats screen)
tmSHGoals			=	$1762		; shorthanded goals
tmPerShots			=	$176A		; shots by period: + period*4 + team*2
tmshots				=	$177A		; shots
tmPerGoals			=	$177E		; goals by period: + period*4 + team*2
tmscore				=	$178E		; score
tmfowon				=	$1792		; faceoffs won
tmnear				=	$17AE		;nearest distance to the puck this frame (updateplayers; 93S tmnear, one
									;word here)
tmnearpl			=	$17B2		; the team's player nearest the puck (updateplayers, assnearest)
tmchecks			=	$17B6		; body checks (FallDown)
tmpasscomp			=	$17BA		; completed passes (puckglue)
tmpassatt			=	$17BE		; pass attempts (dopass)
tmBreakaways		=	$17C2		; breakaways (StartBreakaway)
tmBreakawayGoals	=	$17C6		; breakaway goals
tmPenShots			=	$17CA		; penalty shots (StartPenaltyShot)
tmPenShotGoals		=	$17CE		; penalty shot goals
tmOneTimerSwings	=	$17D2		; one-timer swings started (asspassrec; not on the stats screen)
tmOneTimers			=	$17D6		; one-timers (asspassrec)
tmOneTimerGoals		=	$17DA		; one-timer goals
tmtimeouts			=	$17E2		; timeouts left (StartGame sets 1; PauseTimeout)
tmlcchoice			=	$17E6		; the chosen line change row (lcfound, SetLCmode2)

; Per roster player bytes, $1A players per team (away at +$1A)
tmgoals		=	$18EE				; goals (goalies: goals against)
tmassists	=	$1922				; assists
tmpshots		=	$1956			; shots (goalies: shots against)
ppenmin		=	$198A				; penalty minutes
CwdExciteLvl		=	$19BE		;crowd excitement: raised by hits and goals, set per playoff stage at a
									;period start
CurCrowdMeter		=	$19C2		; the crowd meter in dB: sroot(CwdExciteLvl * 4) + 65, at most 128
CrowdPeak			=	$19C4		; the highest CurCrowdMeter of the game

; Crowd meter
CrowdLoud		=	$19C0			; 1 at 110 dB or more; cleared under 105 dB (CheckCrowdMeter)
CrowdAvg		=	$19C6			; the game's average meter (CrowdMeterSum / CrowdMeterCount)
CrowdMeterCount	=	$19C8			; meter samples taken
CrowdMeterSum	=	$19CA			; 32-bit sum of the meter samples
HotColdRaised	=	$19CE			;nonzero while the hot / cold table is raised by 2 (LowerHotColdTable
									;undoes it)

; Pads (5 with the multitap)
teampads		=	$19D0			; pads on the home / away team
playerpad		=	$19D4			; per player object: the controlling pad * 2, negative = none
c1playernum		=	$19EC			;per pad (5 words): the player object it controls (93S c1playernum,
									;c2playernum ...)
padside			=	$19F6			;per pad: 0 home / 2 away; high byte $80 = moved for a penalty shot or
									;shootout
mp5connect		=	$1A00			; Multi5ConnectCheck: bit 7 multitap on port 1, bit 6 on port 2
mp5readdelay	=	$1A02			; frames to the next multitap read while pads 4 and 5 are unused
mp5checktimer	=	$1A04			; frames left calling Multi5ConnectCheck after a port line change
mp5port1last	=	$1A06			; last JOYSER0 bit 1
mp5port2last	=	$1A08			; last JOYSER1 bit 1
mp5portchg		=	$1A0A			; the port 1 change bit
mp5present		=	$1A0C			; bit 0: multitap on port 2 (pads 3-5 are read)
mp5warning		=	$1A0E			;bit 0 multitap in port 1, bit 1 Super Scope, bit 2 mouse:
									;ShowMP5Warning shows its text
InIntermission	=	$1A10			; 1 during the intermission
HotColdTable	=	$1A12			;52 players x 12 attribute bytes added to the
									;ratings (Create_HotCold_Table)
homeshooters		=	$1D71		;home shootout list: the goalie, then the shooters (bytes, player number +
									;1)
awayshooters		=	$1D79		; away shootout list, as homeshooters
shootoutround		=	$1D85		; shootout round, from 1
PerTimeTotal		=	$1C82		; length of this period (seconds)
tmteam				=	$1CE0		; team number of each team struct
jmlvector			=	$1D59		; RAM jml trampoline: $5C (jml opcode), target at +1..+3
homelines			=	$1CE4		;the home team lines (7 lines of 8 slot bytes), loaded by LoadTeamLines,
									;changed by the line editor
awaylines			=	$1D1C		; the visitors lines, as homelines

; $1C84-$1EC2: pad teams (94G cont1team-cont4team, a word per pad), pause options, the line editor, the stats
; and card screens (curitem, listtop, listend, listcount, curplayer are shared by them), ShowThreeStars, the
; scouting report, the penalty shot and shootout (94G BA_ and sopath names), the pause menu lists
cont1team			=	$1C84		;Team on pad 1 (0 none, 1 home, 2 away); StartGame turns cont1team,x into
									;padside,x = (team-1)*2, ...
cont2team			=	$1C86		; Pad 2 team word of the cont1team array (93S/94G cont2team)
cont3team			=	$1C88		; Pad 3 team word of the cont1team array (94G cont3team)
cont4team			=	$1C8A		; Pad 4 team word of the cont1team array (94G cont4team)
cont5team			=	$1C8C		;Pad 5 (multitap) team word, the last of the five the loops over
									;cont1team,x stop at ($0A); name extends ...
goaliemode1			=	$1C90		;Home manual goalie flag, word per team indexed goaliemode1,y: StartGame
									;copies the goalie option (OptGoalie) ...
goaliemode2			=	$1C92		;Visitors manual goalie flag (goaliemode1+2), set with goaliemode1 by
									;StartGame (94G goaliemode2)
defcontrol			=	$1C94		;Defense control on/off per team (word, indexed by team 0/2):
									;PauseDefControl toggles it, Pmenu prints ...
lcpad				=	$1D55		;Per team (y = 0/2) the pad (d4) that opened the line change box, negative
									;= none: doinput sets it and ...
asv					=	$1D5E		;Scouting text without delays: ScoutingReport sets $FFFF while down is
									;held and clears it at the end of the ...
sndbank				=	$1D68		;Sample set loaded in the SPC: SPCGameUpload/SPCIntroUpload/SPCTitleUpload
									;skip the upload when it is 1 and ...
SoundBankGame		=	$0001		;sndbank: the in-game set (SPCIntroUpload and SPCTitleUpload set it too)
SoundBankMenu		=	$0002		;sndbank: the menu set (SPCMenuUpload, SPCTitleToMenu); 0 = none
gameframes			=	$1D6D		;Gameloop frames since the last faceoff: Gameloop increments it and
									;computes gameframes*60/FrameCount (NMI frames) ...
shootoutmode		=	$1D81		;Nonzero during the shootout: PlayShootout sets 1 and clears it at the
									;end, Opening clears it; ...
shootoutstop		=	$1D83		;Shootout turn whistle: PlayShootout .t1 clears it, SetPA sets 1 in
									;shootoutmode when the ref animation is ...
shootoutturnover	=	$1D87		;Shootout turn finished: cleared at each PlayShootout turn, incremented by
									;puckfaceoff after shootoutstop; ...
shootoutdecider		=	$1D89		;PlayShootout sets 0 before each round and 1 before the home team's turn
									;from round 5 on; ShootoutWonBy ...
linecursor			=	$1D8B		;Line editor slot cursor row: EditLinesScreen starts it at 4 and moves it
									;within 0..lineslots-1, ...
lineplayer			=	$1D8F		;SetLineSlot: the player being put in the cursor slot (A on entry),
									;compared with the slots for the swap ...
lineswap			=	$1D93		;Temporary slot byte while SetLineSlot (.5) and
									;SwapLineSlots swap two line slots
linemenuitem		=	$1D97		;EditLinesMenu item: 0 Return to Game, 1 Restore default lines (down/up
									;set it, the button acts on it, ...
curplayer			=	$1D9B		;Roster index of the player being worked on:
									;DrawPlayerCard/NextPlayerCard/PrevPlayerCard/DrawPlayerPicture ...
lineslots			=	$1D9F		;Rows (slots) of the line being edited: EditLinesScreen sets 5, drops it
									;to 4 for lines 6-7 and back; ...
listcount			=	$1DA3		;Size of the current list: the defense/forward (SelectLinePlayer) or
									;skater (ShooterSelectList) count of ...
picktop				=	$1DA7		;Pick list (line editor, shootout shooters): roster index of the first
									;player shown; ...
pickfirst			=	$1DAB		;Pick list: roster index of the first player of the listed category
									;(goalie count, + forwards for defense), ...
pickrows			=	$1DAF		;Line editor pick list rows shown = min(9, listcount) (SelectLinePlayer),
									;bound of the cursor, used by ...
curitem				=	$1DB9		;Current item of the screen up: exit prompt choice (AskExitGame,
									;DrawExitPrompt), card (ShowPlayerCards, ...
listtop				=	$1DBD		;First row shown of a scrolled stats list (game stats, penalty/scoring
									;summaries, other scores: ...
listend				=	$1DC1		;End of the current list: penalty count (PenSumLength), goal count, other
									;games + 1, last player card (players+6), ...
listrows			=	$1DC5		;Rows of a scrolled stats list in the window / sent to VRAM (5 summaries,
									;6 game stats, 7 player stats; one ...
statstemp			=	$1DC9		;Player stats scratch: ComparePlayerStats returns nonzero to swap and uses
									;it as a temp, SortPlayerStats ...
scrollirqdone		=	$1DCD		;IRQ_StatsScroll1 sets $FFFF each frame; the unused waits in
									;ScrollGameStatsDown (.t1) and OtherScoresRtl ...
crowdmeterlit		=	$1DD1		;ShowCrowdMeter: lit columns of the crowd meter (level/4), the width the
									;CrowdMeterLitMap paste loop uses
otherskip			=	$1DE9		;Other scores: 1 when FillOtherScores skipped the user's game (gamenum),
									;added into the row math of ...
irqline1			=	$1DED		;Line of the first split IRQ: SetupScrollIRQ/SetupBandIRQ store A here and
									;SetIRQ at it, IRQ_BandEnd ...
irqline2			=	$1DEF		;Line of the second split IRQ: SetupScrollIRQ/SetupBandIRQ store X,
									;IRQ_StatsScroll1/IRQ_BandStart load ...
irqline3			=	$1DF1		;Line of the third split IRQ: SetupScrollIRQ stores Y, IRQ_StatsScroll2
									;loads VTIME from it
irqvscroll1			=	$1DF3		;BG1VOFS written by IRQ_StatsScroll1 (low byte, then $1DF4): the scroll
									;routines step it by 2 per frame for ...
irqvscroll2			=	$1DF5		;BG1VOFS of the second split, written by IRQ_StatsScroll2;
									;ShowGameStats/ShowPlayerStats and the summary ...
irqvscroll3			=	$1DF7		;BG1VOFS of the third split, written by IRQ_StatsScroll3; SetupScrollIRQ
									;sets $FFFF
statcolumn			=	$1DF9		;Player stats page column: 0 = goalies, 1-5 = skater sort column;
									;left/right in ShowPlayerStats, ...
statsorder			=	$1DFB		;Player stats row order, a byte per roster player (InitStatsOrder fills
									;0,1,2..; ...
statpenrows			=	$1E15		;Game stats: $10 when penalties are on, 0 when off (ShowGameStats);
									;PrintTeamStatRows ORs it with each ...
letterx				=	$1E17		;X of the next sprite letter: PrintLetterSprites, PrintSmallLetterSprites,
									;PrintStringSprites, ...
lettery				=	$1E1B		;Y of the sprite letters (Y on entry), passed to DrawSprite by the same
									;routines
otgoalscorer		=	$1E1F		;ShowThreeStars: player (+$1A for visitors, $FFFF none) taken from a goal
									;entry whose period field is 3 ...
starplayerend		=	$1E21		;ShowThreeStars: end of the team's player indexes in the scan
									;(GetPlayerCount, +$1A for visitors)
stargoalieend		=	$1E23		;ShowThreeStars: end of the team's goalie indexes (GoalieCount, +$1A for
									;visitors); below it the goalie scoring ...
starswapplayer		=	$1E25		;ShowThreeStars: player pushed down a place while
									;inserting into the three stars
starswapscore		=	$1E27		;ShowThreeStars: 32-bit star score (low word, high word at +2) of the
									;player pushed down while inserting
star1				=	$1E2B		; ShowThreeStars: first star (player index, +$1A for visitors until
									;printing)
star2				=	$1E2D		; ShowThreeStars: second star
star3				=	$1E2F		; ShowThreeStars: third star
star1score			=	$1E31		;ShowThreeStars: 32-bit score of star1 (low word compared with d0, high at
									;+2 with $A7)
star2score			=	$1E35		; ShowThreeStars: 32-bit score of star2
star3score			=	$1E39		; ShowThreeStars: 32-bit score of star3
matchuptimer		=	$1E3D		;ScoutingReport: frames on the current matchup, the next matchup comes at
									;300 and paging resets it (94G ...
matchuphold			=	$1E3F		;ScoutingReport: $FFFF once a pad paged the matchups (A/C/Y), stops the
									;automatic paging and the screentimer
hotterteam			=	$1E41		;ScoutingReport: team number with the higher hot/cold total, $FFFF when
									;they differ by less than 4; ...
hotextreme			=	$1E43		;ScoutingReport: 1 when the hot/cold totals differ by 8 or more;
									;ScoutExtremely prints 'extremely '
hotcoldsum			=	$1E45		;ScoutingReport: per team (y 0/2) sum of rating minus base rating over the
									;roster
hotplayer1			=	$1E49		;ScoutingReport: hottest player per team (home, visitors at +2, $FFFF
									;none); ScoutHomeHot1 prints it (94G ...
hotplayer2			=	$1E4D		; Second hottest player per team (ScoutHomeHot2)
hotplayer3			=	$1E51		; Third hottest player per team (ScoutHomeHot3)
coldplayer1			=	$1E55		; Coldest player per team (ScoutHomeCold1)
coldplayer2			=	$1E59		; Second coldest per team (ScoutHomeCold2)
coldplayer3			=	$1E5D		; Third coldest per team (ScoutHomeCold3)
hotvalue1			=	$1E61		;ScoutingReport: hot value (rating - base rating) of hotplayer1 per team,
									;init $FF06, compared in .t1xx
hotvalue2			=	$1E65		; Hot value of hotplayer2 per team
hotvalue3			=	$1E69		; Hot value of hotplayer3 per team
coldvalue1			=	$1E6D		; Cold value of coldplayer1 per team, init $00FA
coldvalue2			=	$1E71		; Cold value of coldplayer2 per team
coldvalue3			=	$1E75		; Cold value of coldplayer3 per team
strengths			=	$1E79		;Player card best three ratings as (column, rating) word pairs:
									;FindSkaterStrengths/FindGoalieStrengths ...
cardframechars		=	$1E85		;LoadPlayerCardScreen: first VRAM tile after the card back tiles (where
									;CardFrameTiles go), added to every ...
picattr				=	$1E87		;DrawPlayerPicture: map attribute (palette) of the picture, $3400 home /
									;$2400 visitors, added to the ...
onetimer			=	$1E89		;A one-timer shot is under way: asspassrec sets 1 when the receiver shoots
									;the pass directly (counts ...
breakaway			=	$1E8B		;Breakaway in progress (CheckBreakaway result IsBreakaway):
									;StartBreakaway, PenShotChk, doshot set it; Goal ...
BA_Sktr_SCnum		=	$1E8D		;Penalty shot / shootout shooter object (SCnum*2, $FFFF none): Bcheck sets
									;it on a penalty-shot foul, ...
BA_Skater_Offset	=	$1E8F		;Roster index of the penalty shot shooter: StartPenaltyShot = pnum of
									;BA_Sktr_SCnum, PlayShootout = shooter ...
BA_Team				=	$1E91		;Shooting team of the penalty shot / shootout turn (0 home, 2 visitors):
									;StartPenaltyShot, PlayShootout; ...
pspad				=	$1E93		;Pad index (into padside) controlling the penalty shooter, $FFFF none:
									;Bcheck copies playerpad,y, PlayShootout ...
psfoxsave			=	$1E97		;StartPenaltyShot saves the faceoff spot x (fox) here and zeroes it;
									;EndPenaltyShot puts it back into ...
psfoysave			=	$1E99		;StartPenaltyShot saves the faceoff spot y (foy); EndPenaltyShot puts
									;it into lty (last touch y)
penshot				=	$1E9B		;Penalty shot pending / under way: StartPenaltyShot sets 1, EndPenaltyShot
									;and StartGame clear; Goal, ...
penshotlive			=	$1E9D		;Set 1 by SetupPenaltyShot when the shot starts, cleared by puckfaceoff
									;(.9) and StartGame; ...
pstimer				=	$1E9F		;Penalty shot time limit: SetupPenaltyShot sets 1000, Gameloop subtracts
									;d7 outside the shootout and calls ...
sopathx				=	$1EA1		;assbreakaway: x of the current point of the CPU breakaway skater's path
									;to the net (from the .10 point ...
sopathy				=	$1EA3		;assbreakaway: y of the current path point, negated for the bottom goal,
									;skateto target (94G sopathy)
sopathnext			=	$1EA5		;assbreakaway: distance toward the goal at which the next path point is
									;taken (.9); negative = last point, ...
sopathpoint			=	$1EA7		;assbreakaway: index of the path point in the .10 table, cleared at the
									;start, incremented by .9 (94G ...
sopathside			=	$1EA9		;assbreakaway: x side of the path (first point x, signed by pfgoal);
									;sopathx is negated by it and a ...
sopathface			=	$1EAB		;assbreakaway: facedir when the last path point was taken; the shot comes
									;when facedir moves away from it
lastperiod			=	$1EAD		;Period just finished: PeriodOver copies gsp, StartGame clears it,
									;DrawPeriodStats shows the periods up to it
teamtaken			=	$1EAF		;InitializeGameStructures: nonzero when the random team's bit was already
									;set (pick again)
teambit				=	$1EB3		;InitializeGameStructures: 1 << (team & $F), tested and ORed into the
									;used-team bit sets $B3 / d3
pmenulist			=	$1EB7		;Pause menu list shown (0-5): PauseMenu/ChoosePauseMenu pick it, Pmenu
									;prints items and values by it, ...
pmenucount			=	$1EB9		;Items in that pause menu list (PauseMenu/ChoosePauseMenu set it with
									;pmenulist); bounds psitem and psfirst
pregamepause		=	$1EBB		;StartGame sets 1 when any pad has a team; StartPer then opens the pause
									;menu at the start (startpause), ...
RAMTag2				=	$1EBD		;Reset_Fast copies the 6 byte InitTag 'EACDSI' here (and to RAMTag and
									;ReplayBufferEnd) after clearing RAM; ...

; The sprite tile cache (bank $7E; the sprite routines run with the data bank at $7E and use 16-bit
; addresses). An entry per cached frame, 128 entries, a word each, indexed by entry * 2:
FrameCacheAddr	=	$7E2540			; address of the frame (LoadFrameTiles; FindCachedFrame compares it)
FrameCacheBank	=	$7E2640			; bank of the frame
FrameCacheOf	=	$7E2740			;a byte per frame number ($2741 + DrawFrameNum): its cache entry, $FF none
									;(InitSprites fills $FF)
FrameCacheNum	=	$7E2B40			; frame number of the entry
FrameCacheAlloc	=	$7E2C40			;the entry's allocation: block run index | $8000 (16x16 blocks), else the
									;single tile run index
FrameCacheUse	=	$7E2D40			;use bits: GetFrameTiles sets CacheUseMark when drawn, SpriteFrameStart
									;shifts them each frame
									; and frees the entry when they run out
FrameCacheTile	=	$7E2E40			; first VRAM tile of the entry's tiles (the DMA destination)
HandleTable			=	$7E2000		; handles of 4 bytes: address word, bank word (0,0 = free)

; The two tile allocators: runs of free / used space, a byte each (run length, | $80 = used), with back links
BlockRuns		=	$7E2F40			;16x16 block area of sprite VRAM (InitSprites: one free run of
									;SpriteBlockTiles / 4)
BlockRunPrev	=	$7E2FB9			; previous run of each block run ($FF = none)
TileRuns		=	$7E3032			; single 8x8 tile area (from SpriteBlockTiles to $200)
TileRunPrev		=	$7E3093			; previous run of each tile run ($FF = none)
OptPen				=	$7E34C4		; penalties (0 = off)
PlList				=	$7E3114		; players wanted on the ice
TestList			=	$7E347C		; scouting report text list

; Bank $7E / $7F: last touch, faceoff and goal log (93S), hat trick hats, setup screen and options (93S / 94G
; Opt*), playoffs (93S gst*), the screen tile bases (93S charofs, BigFontChars, refchars ...), screen buffers
; and the title tables
Ram7E			=	$7E0000			;Bank $7E base indexed by an address in X: HeapInit writes the heap block
									;header (+0 size, +2 flags, +4 ...
Ram7F			=	$7F0000			;Bank $7F base indexed by an address in X: HeapInit writes the bank $7F
									;heap block header (+0..+6 as ...
carriedy		=	$7E30F4			;updateplayers stores pucky here while puckc >= 0, as 93S updateplayers
									;.cy stores carriedy.
ltplayer		=	$7E30F6			;a2touchpuck stores the touching player (index / 2) here like 93S
									;a2touchpuck sta ltplayer.
ltx				=	$7E30F8			;a2touchpuck stores Xpos,y (93S ltx); Stop4Pen loads it as the OOP faceoff
									;x like 93S; EndPenaltyShot ...
lty				=	$7E30FA			; a2touchpuck stores Ypos,y (93S lty); Stop4Pen loads it into d1 like 93S.
fobox			=	$7E3120			;puckfaceoff2 sets it (FaceOffMap+6) when the faceoff box is drawn,
									;Endfaceoff clears it, SetLCmode2 / ...
fodir1			=	$7E3122			;Endfaceoff loads it into d3 (home pull direction) as 93S lda fodir1;
									;puckfaceoff2 sets $FFFF.
fodir2			=	$7E3124			;Endfaceoff loads it into d3 when the winner faces down, as 93S fodir2;
									;puckfaceoff2 sets $FFFF.
fodropx			=	$7E3126			;puckfaceoff2 sets the faceoff box x; updatefaceoff ((x-$2E)/8 to printx)
									;and checkfo read it as 93S fodropx.
fodropy			=	$7E3128			;puckfaceoff2 sets $5C; updatefaceoff ((y-$44)/8 to printy) and checkfo
									;read it as 93S fodropy.
fofdata2		=	$7E312A			;Faceoff pull frame / attribute pairs of the home (fofdata2 / +2) and
									;visiting (+4 / +6) centre: ...
fofdata			=	$7E3132			;Frame / attribute of the faceoff ref: updatefaceoff stores the drop frame
									;here (93S sta fofdata); ...
fox				=	$7E3136			;Faceoff spot x: limitfo clamps it, puckfaceoff2 puts it in puckx,
									;StartPer clears it, StartPenaltyShot ...
foy				=	$7E3138			;Faceoff spot y: limitfo compares / sets it against the blue line (93S
									;foy), puckfaceoff2 puts it in pucky, ...
ScoreSumbytes	=	$7E313A			;Goal adds 6 per goal (capped at $258) and writes the goal at ScoreSum+it;
									;ShowScoringSummary loops on it; ...
ScoreSum		=	$7E313C			;Extra, not in the list (only as an immediate): the goal log Goal writes
									;6 bytes per goal into (93S ...
hatx			=	$7E3394			;UpdateHatTrick: x (12.4 fixed) of each of the ten hats, plus hatvx each
									;step, >>4 for the DrawSprite x.
haty			=	$7E33A8			;UpdateHatTrick: y of each hat (12.4), plus hatvy each step, used for the
									;hat and its shadow.
hatz			=	$7E33BC			;UpdateHatTrick: height of each hat, lowered by hatvz until 0 (landed);
									;subtracted from y for the hat sprite.
hatvx			=	$7E33D0			;UpdateHatTrick: x speed of each hat (DivX8S at
									;launch), damped on landing.
hatvy			=	$7E33E4			; UpdateHatTrick: y speed of each hat, damped on landing.
hatvz			=	$7E33F8			;UpdateHatTrick: fall speed of each hat: +6 each step, >>2 taken from hatz
									;(the launch clears only slot 0: ...
hatstep			=	$7E340C			;UpdateHatTrick: animation step 1-3 of each hat, 0 = not launched yet;
									;StartHatTrick clears the ten slots.
hattimer		=	$7E3420			;UpdateHatTrick: frames to the hat's next animation step (reloaded from
									;its .9 table, $3E8 once landed).
hatkind			=	$7E3434			;UpdateHatTrick: kind of hat * 3 (0, 3, 6), added to the step for the
									;SPFhat frame.
hattrick		=	$7E3448			;StartHatTrick sets 1, UpdateHatTrick runs only while it is set,
									;puckfaceoff2 and SaveRegsStartHL2 clear it.
refwindow		=	$7E344A			;PushRef sets 1 when it draws a ref frame other than the little offsides
									;ref (6) and clears it when it ...
penmsgbox		=	$7E344C			;prefmes sets 1 after framing the vertical penalty message and erases that
									;box and clears it the next time; ...
newperiod		=	$7E344E			;StartGame and SetupTeamForIntermission set 1 at a period start;
									;puckfaceoff skips the teampads line change ...
pspuckback		=	$7E3450			;pucknorm: during a penalty shot (PenShotActive) counts the frames the
									;loose puck moves back from the goal; ...
setuphome		=	$7E3452			;setoptions sets HomeTeam ($1D logo, $FFFF while a player picture shows)
									;like 94G GameSetUp setuphome; ...
setupvis		=	$7E3454			;As setuphome for the visitors (left) box: VisTeam (+$21 asks SetupScreen
									;for SetupBack), $1C logo, $FFFF ...
teamschanged	=	$7E3456			;setoptions: set at entry and when a mode / team row changes; .10 then
									;copies OptTeam1 / OptTeam2 to ...
cardtimer		=	$7E3458			;setoptions .11: counts down by 2 each pass; below 0 it is reset to $78
									;and the next matchup picture is ...
matchuphome		=	$7E345A			;Player (or matchup slot in matchup photo mode) whose picture
									;DrawMatchupPictures draws in the home box, ...
matchupvis		=	$7E345C			;As matchuphome for the visitors box (94G matchupvis); set by setoptions
									;and ShowMatchups.
setupmatchup	=	$7E345E			;setoptions: matchup shown on the game setup screen, 0-5 (GetMatchupPlayer
									;slot) cycling to 6 = team logos; ...
redrawblocks	=	$7E3460			;Nonzero: DrawTeamBlocks / DrawSelectTeam also write the block palette and
									;map (setoptions, SetHor, ...
horblocks		=	$7E3462			;Set while DrawHorTeams draws the blocks: DrawTeamBlocks skips the map
									;when redrawblocks is 0, ...
cardblock		=	$7E3464			;Set while DrawPlayerCard draws its team block: DrawTeamBlocks moves the
									;name sprites (x -8, +4 / +4).
bigtextchar		=	$7E3466			;RenderBigText: next letter tile (+2 per letter), used by the BigLetter
									;hooks and by SendBigText / ...
drawlinesback	=	$7E3468			;EditLinesScreen sets 1; DrawEditLinesTitle then draws DrawEditLinesBack
									;first and clears it.
pausesubmenu	=	$7E346A			;PauseEditLines / PauseShootoutSetup set it around EditLinesScreen /
									;ShootoutShooters run from the pause ...
phototeams		=	$7E346C			;LoadMatchupPhotos: team (home +0, visitors +2) whose matchup photos are
									;unpacked in the $7F photo buffer, ...
homepicaddr		=	$7E3470			;DrawPlayerPicture: bank $7F address of the home picture tiles ($6F00 or
									;$5100+MatchupPhotoOffsets); ...
vispicaddr		=	$7E3472			;As homepicaddr for the visitors picture ($6900 or
									;$2D00+MatchupPhotoOffsets).
matchupphotos	=	$7E3474			;ScoutingReport / setoptions set 1: DrawPlayerPicture takes the preloaded
									;matchup photos ...
pausemenuon		=	$7E3476			;PauseMenu sets $FFFF, Pausemode / Intermission clear it after;
									;DrawHorTeams leaves the pulsing side ...
playerstatson	=	$7E3478			;ShowPlayerStats sets 1 while it runs; DrawMatchupPictures then skips the
									;picture DMA.
gamesstarted	=	$7E347A			;StartGame increments it right after clearing carriedy to playerstatson
									;(count of games started; no reader found).
OptPlayMode		=	$7E34BC			;Setup menu row 0 'Play Mode' (base of the 7-word option block setoptions
									;edits; choices Regular Season .. ...
OptTeam1		=	$7E34BE			;Setup row 1 'Home': setoptions copies it to HomeTeam; NewPO takes it as
									;the user's team (93S OptTeam1).
OptTeam2		=	$7E34C0			;Setup row 2 'Visitor', copied to VisTeam; FigureJoy stores the opponent
									;here like 93S FigureJoy sta OptTeam2.
OptLine			=	$7E34C6			;setup row 5 Line Changes: 0 off, 1 on, 2 automatic (93S / 94G use 0 =
									;on); readers test 0 or 2
OptGoalie		=	$7E34C8			;Setup row 6 'Goalie' (Automatic / Manual); StartGame copies it to
									;goaliemode1 / goaliemode2 as 94G ...
OptPlayers		=	$7E34CA			;FigureJoy regular season: index * 4 into the controller team list, as 93S
									;FigureJoy .fjnpo lda OptPlayers; ...
notdemo			=	$7E34CC			;DefaultMenus sets $FFFF, setoptions clears it for the attract demo;
									;FigureJoy / PlayerSelect / ...
pojoy			=	$7E34CE			;ReadPassBits stores the range-4 field here like 93S sta pojoy; FigureJoy
									;adds it to the pad list index; ...
postarts		=	$7E34D0			;ReadPassBits stores the range-32 field ($FFFF on a bad checksum) like 93S
									;postarts; maketree, ...
potree			=	$7E34D2			;FigureJoy reads byte [#$34D2 + potreeteam] as 93S potree,potreeteam;
									;PlayoffScreen compares potree,x.
potreeteam		=	$7E34F2			;ReadPassBits range-16 field (93S potreeteam); NewPO, FigureJoy, EncodePW,
									;PlayoffScreen.
tpassbits		=	$7E3518			;ResolveGames copies passbits here and EncodePW copies it back, as 93S
									;tpassbits.
gst1			=	$7E3528			;Playoff game team 1 (8 words): FigureJoy / SetScore compare and load it
									;like 93S gst1,y.
gst2			=	$7E3538			; Playoff game team 2 (93S gst2): FigureJoy, SetScore, PrintOtherScore.
gspotwins		=	$7E3548			; ReadPassBits second range-5 series field per game, as 93S gspotwins.
gspobwins		=	$7E3558			; ReadPassBits first range-5 series field per game, as 93S gspobwins.
gsper			=	$7E3568			;InitScores clears it per game (93S sta gsper,y); SetScore,
									;SaveRegsStartHL2.
gss1			=	$7E3578			; SetScore: team 1 score (93S gss1,y).
gss2			=	$7E3588			; SetScore: team 2 score (93S gss2,y).
gsflags			=	$7E3598			;ReadPassBits / InitScores test and set bit 2
									;(series over) as 93S gsflags,y.
charofs			=	$7E35AA			;Tile offset added to text map words: setupice / ReloadRink set $FF00,
									;PlayoffScreen 0; PushRef, EASNLogo, ...
charofs2		=	$7E35AC			;Second tile offset, cleared with charofs by the screen setups
									;(SetupScreen, LoadScoutingScreen, setupice) ...
BigFontChars	=	$7E35AE			;setupice sets it to Framercset+4 ahead of the BigFontTiles; printbig adds
									;it, as 93S BigFontChars.
EASNcset		=	$7E35B0			;setupice: first tile of RinkLogoTiles after the faceoff tiles; EASNLogo
									;pastes EASNLogoMap with it (93S ...
cardbackchars	=	$7E35B2			;LoadPlayerCardScreen: first tile of CardBackTiles (set 0) and the map
									;base of the card back.
backchars		=	$7E35B4			;SetupScreen / LoadScoutingScreen: first BG2 tile after MenuBackTiles,
									;where the screen background ...
centericechars	=	$7E35B8			;setupice: tile count of IceRinkTiles = first tile of the centre ice logo;
									;LoadCenterIce DMAs the logo ...
faceoffvrcset	=	$7E35BA			;LoadCenterIce sets it after the logo tiles; setupice loads FaceOffTiles
									;there and puckfaceoff2 adds it to ...
ninetilechars	=	$7E35BE			;SetupScreen: first tile of FramerNineTileTiles (then +$1400 palette);
									;FramerNineTile builds its box from it.
outlinechars	=	$7E35C0			;SetupScreen / LoadScoutingScreen: first tile of FramerOutlineTiles (then
									;+$1000); FramerOutline builds its ...
ExtraChars		=	$7E35C2			;setupice: first tile after TeamBlocksTiles (the last set), as 93S
									;setupice sta ExtraChars; no reader found.
nextfreechar	=	$7E35C4			;SetupScreen: running next free tile while it loads each set;
									;ShowCrowdMeter puts CrowdMeterTiles there and ...
cupchars		=	$7E35C6			;PlayoffScreen: scorechars+$70, the StanleyCupTiles after the bracket
									;tiles; StanleyCupMap is pasted with it.
refcharshor		=	$7E35C8			;setupice: first tile of RefTilesHor; PushRef uses it on the horizontal
									;rink, as 93S refcharshor.
refchars		=	$7E35CA			;setupice: first tile of RefTiles; PushRef uses it on the vertical rink,
									;as 93S refchars.
picchars		=	$7E35D2			;SetupScreen / LoadPlayerCardScreen: tile base of the two picture boxes;
									;DrawPlayerPicture adds it to the ...
gamenum			=	$7E35D6			;FigureJoy stores -1 or the user's game index and InitScores skips that
									;game, as 93S gamenum.
vcountfrac		=	$7E35D8			; NMI_Tick: fraction accumulator; its carry adds an extra vcount tick.
vcountstep		=	$7E35DA			;CheckPAL: 0 on NTSC, $3333 on PAL; NMI_Tick adds it to vcountfrac each
									;frame (60 / 50 time step).
tickerstart		=	$7E35DC			;Intermission saves TickerNum here; IntermissionTick plays DoHiLights when
									;the ticker comes round to it, as ...
replaypanel		=	$7E35F0			;ReplayMode sets $FFFF when it draws the control panel (map in
									;rinkmapbuf); the first B press blanks it and ...
usehotcold		=	$7E35F2			;GetPlayerRating / GetNameandAttrib set 1, GetPlayerBaseRating 0;
									;CalcAttrib adds the hot / cold table only ...
hlsavebuf		=	$7E47F4			;SaveRegsStartHL2 copies gmode-1 ($15D3) .. +$780 and then ScoreSumbytes
									;here and back, as 93S StartHL2 ...
bigtextbuf		=	$7E4EF4			;RenderBigText ORs the letter pixels in here, PlayerSelect clears $290
									;bytes, SendBigText / PlayoffScreen ...
screenmap		=	$7EA670			;PlayoffScreen map buffer (+0 width $80, +2 height $20, words from +6:
									;bracket, team blocks, Stanley Cup); ...
screenmap2		=	$7EC676			;Second PlayoffScreen map ($80 x $20: +0 / +2 header, words from +6) for
									;the BigLetterPlayoff letters, sent ...
OAMHiMasks		=	$7EE67C			;Reset_Fast copies OAMHighMasks (16 bytes) here; DrawSprite /
									;DrawSpritePieces AND with it (x indexed).
titleteams		=	$7EF000			;ShuffleTitleTeams fills it with the 26 team numbers in random order;
									;TitleScreen / NextTitleTeam read word ...
introbuf		=	$7F4000			;IntroSequence work buffer (it clears $4000 bytes from here): EALogoMap
									;unpacked here (map words at +6, ...
introchars		=	$7F8010			;IntroSequence unpacks EALogoTiles here and sends them as the mode 7
									;character bytes (VMDATAH); the same ...
brackettiles	=	$7F6700			;PlayoffScreen draws the $70 bracket tiles (bytes $FF / $80 / $7F / $00)
									;here and DMAs $E00 bytes to VRAM.
colourbuf		=	$7F7500			;The colour buffer SetColours fills and SendColours sends (256 colours) on
									;the menu screens; PlayoffScreen ...
logoboxmap		=	$7F7700			;SetupScreen pastes the 7 x 7 part of MenuBackMap here (header 7, 7 at +0
									;/ +2, words from +6); ...
picboxmap		=	$7F7780			;LoadPictureMap / LoadPlayerCardScreen unpack the 7 x 7 PictureMap here
									;(+0 width, +2 height, words from ...
titlescale		=	$7F8000			;BuildTitlePath: mode 7 scale of each of the $500 title logo path steps;
									;TitleScreen reads it.
titlexofs		=	$7F8A00			; BuildTitlePath: x offset of each title path step; TitleScreen adds $190.
titleyscroll	=	$7F9400			; BuildTitlePath: y scroll of each title path step, read by TitleScreen.
titlelogobuf	=	$7FA000			;LoadTitleLogo: mode 7 buffer of the title team logo (header +0 / +2 / +4,
									;then the map; pixel pairs at +0 ...
unpackbuf		=	$7F0000			;Decompress output buffer (bank $7F, as 93S unpackbuf): tiles, maps and
									;palettes are unpacked here and sent to VRAM / CGRAM from here
statspage		=	$7F2780			;stats page buffer (32 wide) that PrintToStatsPage and the Fill*Page
									;routines print into
titlesprbuf		=	$7F5000			;TitleSprites unpacked here; DrawTitleSprite draws sprite A of the set
logosprbuf		=	$7F7800			;team logo sprites, unpacked by LoadScoutingScreen, LoadPlayerCardScreen,
									;SetupScreen and DrawMatchupPictures; DrawLogoSprite draws from here
rinkmapbuf		=	$7FC800			;BuildRinkMap unpacks IceRinkMap here and pastes the centre ice logo at
									;+$10B6; ReplayMode and StatsReport send parts of it to VRAM
SPCStreamLeft		=	$7E35E2		; bytes of the sound stream still to send
SPCStreamPtr		=	$7E35EC		; long pointer to the next stream byte (address word, bank word)
playoffRoundIdx		=	$7E35D4		; playoff round for other scores and password bits
textmap			=	$7E37F4			; the text map
printfontset	=	$7E35A8			; tile base of the selected print font
PassWord			=	$7E34F4		; password characters
passbits			=	$7E3508		; password bits, low word first
pausesavebuf		=	$7E4F7E		; Pausemode saves textmap here ($800 bytes, up to ReplayBufferStart)
ReplayBufferStart	=	$7E577E		; first replay frame record
ReplayBufferEnd		=	$7EE676		; replay buffer end
Crowdlevel			=	$7E35E0		; crowd noise level: raised by the play, fades every frame
palbuffer			=	$7E35F4		; the palette buffer (256 colours) sent to CGRAM
textmap2			=	$7E3FF4		; the second text map (ClearTextMap2, SendTextMap2)
blankchar			=	$7E35D0		; vram tile of the blank character (eraser fills with it)
streamsfx			=	$7E35E6		; the streamed sound effect asked for (1-6, StreamSfx), 0 none
streamstate			=	$7E35E8		; UpdateStreamSfx: 0 start, 1 streaming, 2 playing, 3 done
streamloaded		=	$7E35EA		; the streamed sound whose sample is in sound RAM
smallfontchars		=	$7E35B6		; vram tiles for the small font (print)
Framercset			=	$7E35BC		; vram tiles for the Framer box
scorechars			=	$7E35CE		; vram tiles for the scoreboard / team block maps

; --- constants (values, not addresses) ---

puckobj		=	$1C					; object index of the puck
netobj1		=	$18					; object index*2 of goal net 1 (y +268)
netobj2		=	$1A					; object index*2 of goal net 2 (y -268)

gmoffs		=	$0020				; offsides on
gmhl		=	$0010				; highlight mode
gmdir		=	$0002				; 0 = home team goes up
pfna		=	$0002				; new assignment
tmfoside	=	$0010				; team flagged offsides
cbut		=	$0080				; shoot / check button in d2
blueline	=	$58					; puck y past which a team can be offside
sideline	=	$88					; distance from center to side boards

; Penalty numbers (word offsets into Penaltylist) for AddPenalty
PenEOP			=	$02
PenEOG			=	$04
PenOOP			=	$06
PenGhold		=	$08
PenWhistle		=	$0A
PenIcing		=	$0C
PenGoal			=	$0E
PenNoText		=	$10
PenOffsides		=	$12
PenRoughing2	=	$14
PenNoText2		=	$16
PenCharging		=	$18
PenSlashing		=	$1A
PenRoughing		=	$1C
PenCrossChk		=	$1E
PenHooking		=	$20
PenTripping		=	$22
PenShot			=	$24
PenInterference	=	$26
PenHolding		=	$28
PenFighting		=	$2A
PenFighting2	=	$2C
PenInst			=	$2E
PenDelay		=	$30
PenNoText3		=	$32

gmpen		=	$0004				; penalty called, ref in progress
sfpz		=	$0001				; pause mode
sfspdir		=	$0004				; a pass direction is set (passdir)
sfwrap		=	$0010				; replay has wrapped around
sf2drec		=	$0400				; disable replay record
sf2pwrplay	=	$2000				; power play in progress
sf2pwrtm	=	$4000				; 0 for team 1 in power play
sf2replay	=	$0800				; replay in progress
sf2refref	=	$0200				; ref needs refresh
sfslock		=	$0040				; scroll lock to xc1/yc1
sf3llcs		=	$0001				; lower line change box on screen
pf2inj		=	$0004				; injured
TMPDBENCH	=	$FFFE				; on the bench
TMPDOUT		=	$FFFD				; out of the game
rosterNone	=	$FFFC				; no roster slot (beside TMPDOUT in bench checks)
TMPDINJ		=	$1000				; injured: box time with this bit has no penalty
TMPDICE		=	$FFFF				; on the ice
PWrange		=	30					; characters in PasstoText
pwlength	=	16					; password characters
replaysize	=	$7A					; bytes per replay frame record

; Record fields (names shared with 93G, 93S and 94G)
cmpformat			=	0			;Decompress header: word format ($FB10 LZ, $FB46, $FB30, $FB7A)
cmpsizelow			=	3			;low word of the unpacked size (24-bit, high byte first, at bytes 2-4)
sstime				=	0			;ScoreSum entry (6 bytes per goal): word period / time
ssflags				=	2			;byte 2 + skater difference (goal type); bit 7 = away team scored
ssscorer			=	3			;byte scorer
ssassist1			=	4			;byte first assist (negative none)
ssassist2			=	5			;byte second assist (negative none)
sssize				=	6
pstime				=	0			;PenSum entry: word period / time
pcx					=	0			;puckcross entry (4 bytes; entry 0 top, 1 bottom): word x
pcframes			=	2			;word frames
pcsize				=	4
pldnum				=	0			;.pld player ratings, 8 bytes after the name (92 setplayer field names):
									;jersey number -> rostnum
pldweight			=	1			;high nibble weight, low nibble leg power legstr
pldlegspd			=	2			;high nibble speed legspd, low nibble offense aioff
pldaidef			=	3			;high nibble defense aidef, low nibble shot power shotspd
pldcheck			=	4			;high nibble checking, bit 0 handed, bits 1-3 fighting
pldstick			=	5			;high nibble stickhandling stickhand, low nibble shot accuracy
pldendur			=	6			;high nibble endurance, low nibble shoot / pass odds spodds
pldpass				=	7			;high nibble passing passacc, low nibble aggression aggress
pldsize				=	8
foframe				=	0			;fofdata2, fofdata: 4 bytes per big faceoff sprite (centers, ref): frame
foattr				=	2			;word attribute (bit 11 x flip)
fosize				=	4

; puck fields (need puckobj above)
puckx		=	Xpos+puckobj		; puck x position
