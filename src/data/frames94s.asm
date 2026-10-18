; Sprite frame (SPF) groups: the first SpriteFrames frame of each group, named as the 93S / 94G groups
; (SPFskatewp to SPFhold match 93S frame for frame, then the 93S fight frames are gone). Frame numbers count
; from 1; the frame label is SpriteFrame_<group>_<n> and DrawSprite takes the frame number - 1.
SPFskatewp		=	1				; 40 frames: skating with the puck, 5 per direction
SPFskate		=	41				; 40 frames: skating, 5 per direction
SPFturnl		=	81				; 8 frames: turning left
SPFturnr		=	89				; 8 frames: turning right
SPFswing		=	97				; 48 frames: shot and pass swings, 6 per direction
SPFstop			=	145				; 16 frames: stopping
SPFskateb		=	161				; 24 frames: skating backwards
SPFcelebrate	=	185				; 16 frames: celebrating a goal
SPFpump			=	201				; 16 frames: fist pump
SPFcup			=	217				; 8 frames: holding the cup
SPFcupover		=	225				;8 frames: the cup alone: setsortcords draws SPFcupover+n in palette 0
									;over SPFcup+n (new in 94S)
SPFhipl			=	233				; 8 frames: hip check left
SPFhipr			=	241				; 8 frames: hip check right
SPFshoulderl	=	249				; 8 frames: shoulder check left
SPFshoulderr	=	257				; 8 frames: shoulder check right
SPFsweep		=	265				; 16 frames: sweep check
SPFfallback		=	281				; 32 frames: falling back
SPFfallfwd		=	313				; 32 frames: falling forward
SPFduck			=	345				; 8 frames: ducking
SPFhold			=	353				; 8 frames: holding
SPFPen			=	361				;9 frames: over the boards (+0-+3 vertical, +4-+7 horizontal), then
									;sitting: +7 horizontal and +8 vertical (assdopen)
SPFgwall		=	370				;4 frames: the goalie over the boards (SPAgwallright, SPAgwallleft; new in
									;94S)
SPFarrow		=	374				; 15 frames: off-screen arrows, 3 per controller (setvideo)
SPFpad			=	389				;6 frames: stars: +0 the puck carrier, +1-+5 the controllers (setffo,
									;PlayerSelect)
SPFreplay		=	395				;1 frame: the replay cursor: four corner marks round the player or point
									;ReplayMode follows (setffo slot 6; confirmed in game)
SPFpuck			=	396				; 11 frames: +0 the puck shadow, +1 the puck, then the flipping puck
SPFgoal			=	407				; 2 frames: the two nets
SPFSiren		=	409				; 14 frames: the goal light
SPFfaceoff		=	423				; 10 frames: the big faceoff sprites (checkfo)
SPFsmallfont	=	433				; 15 frames: 0-9, C, D, L, R, X (setffo, PlayerSelect)
SPFzamboni		=	448				; 1 frame: the Zamboni (showzam)
SPFflip			=	449				; 8 frames: flipping over
SPFstumble		=	457				; 24 frames: stumbling
SPFhook			=	481				; 16 frames: hooking
SPFcatch		=	497				; 16 frames: catching a pass
SPFbglass		=	513				; 5 frames: the glass breaking
SPFcrosscheck	=	518				; 16 frames: cross check (SPAcrosscheck; new in 94S)
SPFGoalie		=	534				; 112 frames: the goalie
SPFgready		=	646				; 16 frames: the goalie ready, 2 per direction
SPFgdive		=	662				; 16 frames: the goalie diving
SPFgpoke		=	678				; 16 frames: the goalie poke check (new in 94S)
SPFgcover		=	694				; 24 frames: the goalie covering the puck (new in 94S)
SPFgbutterfly	=	718				; 24 frames: the goalie butterfly save (new in 94S)
SPFgsprawll		=	742				; 24 frames: the goalie sprawling left (new in 94S)
SPFgsprawlr		=	766				; 24 frames: the goalie sprawling right (new in 94S)
SPFpump2		=	790				; 31 frames: the second fist pump (SPApump2; new in 94S)
SPFunused		=	821				; 11 frames: used only by SPAunused1 and SPAunused2, which nothing sets
SPFboardfront	=	832				; 16 frames: checked into the boards, from the front (new in 94S)
SPFboardright	=	848				; 16 frames: checked into the boards, from the right (new in 94S)
SPFboardback	=	864				; 16 frames: checked into the boards, from behind (new in 94S)
SPFboardleft	=	880				; 16 frames: checked into the boards, from the left (new in 94S)
SPFbenchcheck	=	896				;21 frames: checked into the bench (SPAbenchcheckr, SPAbenchcheckl; new in
									;94S)
SPFbench		=	917				; 12 frames: the players on the bench cheering, 6 per bench (setsortcords)
SPFbigfont		=	929				; 38 frames: A-Z, ., (c), 0-9 (PrintTeamSprites)
SPFhat			=	967				; 9 frames: hat trick hats, 3 kinds of 3 frames (UpdateHatTrick)
SPFhatshadow	=	976				; 1 frame: the hat shadow (UpdateHatTrick)

; The sprite animations. SPA holds the address of one. Each animation: eight words (the frame list for each
; direction; a direction may point at the next animation instead), a word of attributes (bit 0 = loops),
; then the frame lists: pairs of (SPF frame, time in decimal frames); a negative time ends one.
;
; Then $FF fill to the end of the bank.
SPAlist:							; the animations (SPA): SPA 0 is no animation
	dw 0
SPAgready:
	dw .d0,.d1,.d2,.d3,.d4,.d5,.d6,.d7
	dw 1
.d0:	dw SPFGoalie,180,SPFgready,20,SPFGoalie,10,SPFgready+1,20,SPFGoalie,-10
.d1:	dw SPFGoalie+3,130,SPFgready+2,10,SPFgready+3,20,SPFGoalie+3,1,SPFGoalie+3,-9
.d2:	dw SPFGoalie+6,210,SPFgready+4,10,SPFgready+5,20,SPFGoalie+6,1,SPFGoalie+6,-9
.d3:	dw SPFGoalie+9,100,SPFgready+6,20,SPFgready+7,10,SPFGoalie+9,1,SPFGoalie+9,-9
.d4:	dw SPFGoalie+12,240,SPFgready+8,10,SPFgready+9,30,SPFgready+8,10,SPFGoalie+12,-10
.d5:	dw SPFGoalie+15,180,SPFgready+10,20,SPFgready+11,20,SPFGoalie+15,1,SPFGoalie+15,-9
.d6:	dw SPFGoalie+18,120,SPFgready+12,20,SPFgready+13,20,SPFgready+12,10,SPFGoalie+18,-10
.d7:	dw SPFGoalie+21,180,SPFgready+14,20,SPFgready+15,20,SPFGoalie+21,1,SPFGoalie+21,-9
SPAgready2:
	dw .d0,.d1,.d2,.d3,.d4,.d5,.d6,.d7
	dw 0
.d0:	dw SPFGoalie,-30
.d1:	dw SPFGoalie+3,-30
.d2:	dw SPFGoalie+6,-30
.d3:	dw SPFGoalie+9,-30
.d4:	dw SPFGoalie+12,-30
.d5:	dw SPFGoalie+15,-30
.d6:	dw SPFGoalie+18,-30
.d7:	dw SPFGoalie+21,-30
SPAgglover:
	dw .d0,.d1,.d2,.d3,.d4,.d5,.d6,.d7
	dw 0
.d0:	dw SPFGoalie+1,-32
.d1:	dw SPFGoalie+4,-32
.d2:	dw SPFGoalie+7,-32
.d3:	dw SPFGoalie+10,-32
.d4:	dw SPFGoalie+13,-32
.d5:	dw SPFGoalie+16,-32
.d6:	dw SPFGoalie+19,-32
.d7:	dw SPFGoalie+22,-32
SPAgglovel:
	dw .d0,.d1,.d2,.d3,.d4,.d5,.d6,.d7
	dw 0
.d0:	dw SPFGoalie+2,-32
.d1:	dw SPFGoalie+5,-32
.d2:	dw SPFGoalie+8,-32
.d3:	dw SPFGoalie+11,-32
.d4:	dw SPFGoalie+14,-32
.d5:	dw SPFGoalie+17,-32
.d6:	dw SPFGoalie+20,-32
.d7:	dw SPFGoalie+23,-32
SPAgstickr:
	dw .d0,.d1,.d2,.d3,.d4,.d5,.d6,.d7
	dw 0
.d0:	dw SPFGoalie+64,-32
.d1:	dw SPFGoalie+66,-32
.d2:	dw SPFGoalie+68,-32
.d3:	dw SPFGoalie+70,-32
.d4:	dw SPFGoalie+72,-32
.d5:	dw SPFGoalie+74,-32
.d6:	dw SPFGoalie+76,-32
.d7:	dw SPFGoalie+78,-32
SPAgstickl:
	dw .d0,.d1,.d2,.d3,.d4,.d5,.d6,.d7
	dw 0
.d0:	dw SPFGoalie+65,-32
.d1:	dw SPFGoalie+67,-32
.d2:	dw SPFGoalie+69,-32
.d3:	dw SPFGoalie+71,-32
.d4:	dw SPFGoalie+73,-32
.d5:	dw SPFGoalie+75,-32
.d6:	dw SPFGoalie+77,-32
.d7:	dw SPFGoalie+79,-32
SPAgstackr:
	dw .d0,.d1,.d2,.d3,.d4,.d5,.d6,.d7
	dw 0
.d0:	dw SPFGoalie+40,8,SPFGoalie+41,-20
.d1:	dw SPFGoalie+42,8,SPFGoalie+43,-20
.d2:	dw SPFGoalie+42,8,SPFGoalie+43,-20
.d3:	dw SPFGoalie+44,8,SPFGoalie+45,-20
.d4:	dw SPFGoalie+46,8,SPFGoalie+47,-20
.d5:	dw SPFGoalie+48,8,SPFGoalie+49,-20
.d6:	dw SPFGoalie+48,8,SPFGoalie+49,-20
.d7:	dw SPFGoalie+50,8,SPFGoalie+51,-20
SPAgstackl:
	dw .d0,.d1,.d2,.d3,.d4,.d5,.d6,.d7
	dw 0
.d0:	dw SPFGoalie+52,8,SPFGoalie+53,-20
.d1:	dw SPFGoalie+54,8,SPFGoalie+55,-20
.d2:	dw SPFGoalie+54,8,SPFGoalie+55,-20
.d3:	dw SPFGoalie+56,8,SPFGoalie+57,-20
.d4:	dw SPFGoalie+58,8,SPFGoalie+59,-20
.d5:	dw SPFGoalie+60,8,SPFGoalie+61,-20
.d6:	dw SPFGoalie+60,8,SPFGoalie+61,-20
.d7:	dw SPFGoalie+62,8,SPFGoalie+63,-20
SPAgswing:
	dw .d0,.d1,.d2,.d3,.d4,.d5,.d6,.d7
	dw 0
.d0:	dw SPFGoalie+24,5,SPFGoalie+25,8,SPFGoalie+24,-16
.d1:	dw SPFGoalie+26,5,SPFGoalie+27,8,SPFGoalie+26,-16
.d2:	dw SPFGoalie+28,5,SPFGoalie+29,8,SPFGoalie+28,-16
.d3:	dw SPFGoalie+30,5,SPFGoalie+31,8,SPFGoalie+30,-16
.d4:	dw SPFGoalie+32,5,SPFGoalie+33,8,SPFGoalie+32,-16
.d5:	dw SPFGoalie+34,5,SPFGoalie+35,8,SPFGoalie+34,-16
.d6:	dw SPFGoalie+36,5,SPFGoalie+37,8,SPFGoalie+36,-16
.d7:	dw SPFGoalie+38,5,SPFGoalie+39,8,SPFGoalie+38,-16
SPAgskate:
	dw .d0,.d1,.d2,.d3,.d4,.d5,.d6,.d7
	dw 1
.d0:	dw SPFGoalie+80,10,SPFGoalie+81,10,SPFGoalie+82,10,SPFGoalie+83,-15
.d1:	dw SPFGoalie+84,10,SPFGoalie+85,10,SPFGoalie+86,10,SPFGoalie+87,-15
.d2:	dw SPFGoalie+88,10,SPFGoalie+89,10,SPFGoalie+90,10,SPFGoalie+91,-15
.d3:	dw SPFGoalie+92,10,SPFGoalie+93,10,SPFGoalie+94,10,SPFGoalie+95,-15
.d4:	dw SPFGoalie+96,10,SPFGoalie+97,10,SPFGoalie+98,10,SPFGoalie+99,-15
.d5:	dw SPFGoalie+100,10,SPFGoalie+101,10,SPFGoalie+102,10,SPFGoalie+103,-15
.d6:	dw SPFGoalie+104,10,SPFGoalie+105,10,SPFGoalie+106,10,SPFGoalie+107,-15
.d7:	dw SPFGoalie+108,10,SPFGoalie+109,10,SPFGoalie+110,10,SPFGoalie+111,-15
SPAgwallright:						;the goalie's SPAwallright: asseben gives it to a goalie leaving the bench
	dw .d0,.d0,.d0,.d3,.d3,.d3,.d3,SPAgwallleft
	dw 0
.d0:	dw SPFgwall,8,SPFgwall+1,8,SPFgwall+2,8,SPFgwall+3,-8
.d3:	dw SPFgwall+3,8,SPFgwall+2,8,SPFgwall+1,8,SPFgwall,-8
SPAgwallleft:						;the goalie's SPAwallleft: assbench gives it to a goalie going to the
									;bench
	dw .d0,.d0,.d0,.d3,.d3,.d3,.d3,SPAgdive
	dw 0
.d0:	dw SPFgwall+3,8,SPFgwall+2,8,SPFgwall+1,8,SPFgwall,-8
.d3:	dw SPFgwall,8,SPFgwall+1,8,SPFgwall+2,8,SPFgwall+3,-8
SPAgdive:
	dw .d0,.d1,.d2,.d3,.d4,.d5,.d6,.d7
	dw 0
.d0:	dw SPFgdive,8,SPFgdive+1,48,SPFgdive,-8
.d1:	dw SPFgdive+2,8,SPFgdive+3,48,SPFgdive+2,-8
.d2:	dw SPFgdive+4,8,SPFgdive+5,48,SPFgdive+4,-8
.d3:	dw SPFgdive+6,8,SPFgdive+7,48,SPFgdive+6,-8
.d4:	dw SPFgdive+8,8,SPFgdive+9,48,SPFgdive+8,-8
.d5:	dw SPFgdive+10,8,SPFgdive+11,48,SPFgdive+10,-8
.d6:	dw SPFgdive+12,8,SPFgdive+13,48,SPFgdive+12,-8
.d7:	dw SPFgdive+14,8,SPFgdive+15,48,SPFgdive+14,-8
SPAgpoke:							;assgoalie: the controlled goalie's X button, the CPU goalie at random
									;when an opponent has the puck near
	dw .d0,.d1,.d2,.d3,.d4,.d5,.d6,.d7
	dw 0
.d0:	dw SPFgpoke,4,SPFgpoke+1,15,SPFgpoke,-6
.d1:	dw SPFgpoke+2,4,SPFgpoke+3,15,SPFgpoke+2,-6
.d2:	dw SPFgpoke+4,4,SPFgpoke+5,15,SPFgpoke+4,-6
.d3:	dw SPFgpoke+6,4,SPFgpoke+7,15,SPFgpoke+6,-6
.d4:	dw SPFgpoke+8,4,SPFgpoke+9,15,SPFgpoke+8,-6
.d5:	dw SPFgpoke+10,4,SPFgpoke+11,15,SPFgpoke+10,-6
.d6:	dw SPFgpoke+12,4,SPFgpoke+13,15,SPFgpoke+12,-6
.d7:	dw SPFgpoke+14,4,SPFgpoke+15,15,SPFgpoke+14,-6
SPAgcover2:							; SPAgcover's frames held 20, not 90; nothing sets it
	dw .d0,.d1,.d2,.d3,.d4,.d5,.d6,.d7
	dw 0
.d0:	dw SPFgcover,6,SPFgcover+1,6,SPFgcover+2,20,SPFgcover+1,6,SPFgcover,6,SPFgready,-8
.d1:	dw SPFgcover+3,6,SPFgcover+4,6,SPFgcover+5,20,SPFgcover+4,6,SPFgcover+3,6,SPFgready+2,-8
.d2:	dw SPFgcover+6,6,SPFgcover+7,6,SPFgcover+8,20,SPFgcover+7,6,SPFgcover+6,6,SPFgready+4,-8
.d3:	dw SPFgcover+9,6,SPFgcover+10,6,SPFgcover+11,20,SPFgcover+10,6,SPFgcover+9,6,SPFgready+6,-8
.d4:	dw SPFgcover+12,6,SPFgcover+13,6,SPFgcover+14,20,SPFgcover+13,6,SPFgcover+12,6,SPFgready+8,-8
.d5:	dw SPFgcover+15,6,SPFgcover+16,6,SPFgcover+17,20,SPFgcover+16,6,SPFgcover+15,6,SPFgready+10,-8
.d6:	dw SPFgcover+18,6,SPFgcover+19,6,SPFgcover+20,20,SPFgcover+19,6,SPFgcover+18,6,SPFgready+12,-8
.d7:	dw SPFgcover+21,6,SPFgcover+22,6,SPFgcover+23,20,SPFgcover+22,6,SPFgcover+21,6,SPFgready+14,-8
SPAgcover:							;assgoalie: the goalie drops on the puck for 90 frames when an opponent is
									;near it
	dw .d0,.d1,.d2,.d3,.d4,.d5,.d6,.d7
	dw 0
.d0:	dw SPFgcover,6,SPFgcover+1,6,SPFgcover+2,90,SPFgcover+1,6,SPFgcover,6,SPFgready,-4
.d1:	dw SPFgcover+3,6,SPFgcover+4,6,SPFgcover+5,90,SPFgcover+4,6,SPFgcover+3,6,SPFgready+2,-4
.d2:	dw SPFgcover+6,6,SPFgcover+7,6,SPFgcover+8,90,SPFgcover+7,6,SPFgcover+6,6,SPFgready+4,-4
.d3:	dw SPFgcover+9,6,SPFgcover+10,6,SPFgcover+11,90,SPFgcover+10,6,SPFgcover+9,6,SPFgready+6,-4
.d4:	dw SPFgcover+12,6,SPFgcover+13,6,SPFgcover+14,90,SPFgcover+13,6,SPFgcover+12,6,SPFgready+8,-4
.d5:	dw SPFgcover+15,6,SPFgcover+16,6,SPFgcover+17,90,SPFgcover+16,6,SPFgcover+15,6,SPFgready+10,-4
.d6:	dw SPFgcover+18,6,SPFgcover+19,6,SPFgcover+20,90,SPFgcover+19,6,SPFgcover+18,6,SPFgready+12,-4
.d7:	dw SPFgcover+21,6,SPFgcover+22,6,SPFgcover+23,90,SPFgcover+22,6,SPFgcover+21,6,SPFgready+14,-4
SPAgbutterfly:						; GoalieSaveList 8: a slow shot straight at the goalie
	dw .d0,.d1,.d2,.d3,.d4,.d5,.d6,.d7
	dw 0
.d0:	dw SPFgbutterfly,6,SPFgbutterfly+1,6,SPFgbutterfly+2,20,SPFgready,-4
.d1:	dw SPFgbutterfly+3,6,SPFgbutterfly+4,6,SPFgbutterfly+5,20,SPFgready+2,-4
.d2:	dw SPFgbutterfly+6,6,SPFgbutterfly+7,6,SPFgbutterfly+8,20,SPFgready+4,-4
.d3:	dw SPFgbutterfly+9,6,SPFgbutterfly+10,6,SPFgbutterfly+11,20,SPFgready+6,-4
.d4:	dw SPFgbutterfly+12,6,SPFgbutterfly+13,6,SPFgbutterfly+14,20,SPFgready+8,-4
.d5:	dw SPFgbutterfly+15,6,SPFgbutterfly+16,6,SPFgbutterfly+17,20,SPFgready+10,-4
.d6:	dw SPFgbutterfly+18,6,SPFgbutterfly+19,6,SPFgbutterfly+20,20,SPFgready+12,-4
.d7:	dw SPFgbutterfly+21,6,SPFgbutterfly+22,6,SPFgbutterfly+23,20,SPFgready+14,-4
SPAgsprawll:						; GoalieSaveList 7: a shot from a wide angle, to the left
	dw .d0,.d1,.d2,.d3,.d4,.d5,.d6,.d7
	dw 0
.d0:	dw SPFgsprawll,4,SPFgsprawll+1,4,SPFgsprawll+2,20,SPFgready,-4
.d1:	dw SPFgsprawll+3,4,SPFgsprawll+4,4,SPFgsprawll+5,20,SPFgready+2,-4
.d2:	dw SPFgsprawll+6,4,SPFgsprawll+7,4,SPFgsprawll+8,20,SPFgready+4,-4
.d3:	dw SPFgsprawll+9,4,SPFgsprawll+10,4,SPFgsprawll+11,20,SPFgready+6,-4
.d4:	dw SPFgsprawll+12,4,SPFgsprawll+13,4,SPFgsprawll+14,20,SPFgready+8,-4
.d5:	dw SPFgsprawll+15,4,SPFgsprawll+16,4,SPFgsprawll+17,20,SPFgready+10,-4
.d6:	dw SPFgsprawll+18,4,SPFgsprawll+19,4,SPFgsprawll+20,20,SPFgready+12,-4
.d7:	dw SPFgsprawll+21,4,SPFgsprawll+22,4,SPFgsprawll+23,20,SPFgready+14,-4
SPAgsprawlr:						; GoalieSaveList 6: a shot from a wide angle, to the right
	dw .d0,.d1,.d2,.d3,.d4,.d5,.d6,.d7
	dw 0
.d0:	dw SPFgsprawlr,4,SPFgsprawlr+1,4,SPFgsprawlr+2,20,SPFgready,-4
.d1:	dw SPFgsprawlr+3,4,SPFgsprawlr+4,4,SPFgsprawlr+5,20,SPFgready+2,-4
.d2:	dw SPFgsprawlr+6,4,SPFgsprawlr+7,4,SPFgsprawlr+8,20,SPFgready+4,-4
.d3:	dw SPFgsprawlr+9,4,SPFgsprawlr+10,4,SPFgsprawlr+11,20,SPFgready+6,-4
.d4:	dw SPFgsprawlr+12,4,SPFgsprawlr+13,4,SPFgsprawlr+14,20,SPFgready+8,-4
.d5:	dw SPFgsprawlr+15,4,SPFgsprawlr+16,4,SPFgsprawlr+17,20,SPFgready+10,-4
.d6:	dw SPFgsprawlr+18,4,SPFgsprawlr+19,4,SPFgsprawlr+20,20,SPFgready+12,-4
.d7:	dw SPFgsprawlr+21,4,SPFgsprawlr+22,4,SPFgsprawlr+23,20,SPFgready+14,-4
SPAwallright:
	dw .d0,.d1,.d1,.d3,.d3,.d3,.d3,SPAwallleft
	dw 0
.d0:	dw SPFPen+4,8,SPFPen+5,8,SPFPen+6,8,SPFPen+7,-15
.d1:	dw SPFPen,8,SPFPen+1,8,SPFPen+2,8,SPFPen+3,-8
.d3:	dw SPFPen+3,8,SPFPen+2,8,SPFPen+1,8,SPFPen,-8
SPAwallleft:
	dw .d0,.d1,.d1,.d3,.d3,.d3,.d3,SPApflip
	dw 0
.d0:	dw SPFPen+6,8,SPFPen+5,8,SPFPen+4,8,SPFPen+7,-15
.d1:	dw SPFPen+3,8,SPFPen+2,8,SPFPen+1,8,SPFPen,-8
.d3:	dw SPFPen,8,SPFPen+1,8,SPFPen+2,8,SPFPen+3,-8
SPApflip:
	dw .d0,.d1,.d2,.d3,.d4,.d5,.d6,.d7
	dw 1
.d0:	dw SPFpuck+2,4,SPFpuck+3,4,SPFpuck+4,4,SPFpuck+5,4,SPFpuck+6,4,SPFpuck+3,4,SPFpuck+7,4,SPFpuck+1,-4
.d1:	dw SPFpuck+9,2,SPFpuck+1,2,SPFpuck+8,2,SPFpuck+5,2,SPFpuck+10,2,SPFpuck+5,2,SPFpuck+8,2,SPFpuck+1,-2
.d2:	dw SPFpuck+4,2,SPFpuck+3,2,SPFpuck+2,2,SPFpuck+1,2,SPFpuck+7,2,SPFpuck+3,2,SPFpuck+6,2,SPFpuck+5,-2
.d3:	dw SPFpuck+8,4,SPFpuck+1,4,SPFpuck+9,4,SPFpuck+1,4,SPFpuck+8,4,SPFpuck+5,4,SPFpuck+10,4,SPFpuck+5,-4
.d4:	dw SPFpuck+1,-4096
.d5:	dw SPFpuck+1,-4096
.d6:	dw SPFpuck+5,-4096
.d7:	dw SPFpuck+5,-4096
SPAglide:
	dw .d0,.d1,.d2,.d3,.d4,.d5,.d6,.d7
	dw 0
.d0:	dw SPFskatewp,-8
.d1:	dw SPFskatewp+5,-8
.d2:	dw SPFskatewp+10,-8
.d3:	dw SPFskatewp+15,-8
.d4:	dw SPFskatewp+20,-8
.d5:	dw SPFskatewp+25,-8
.d6:	dw SPFskatewp+30,-8
.d7:	dw SPFskatewp+35,-8
SPAskatewp:
	dw .d0,.d1,.d2,.d3,.d4,.d5,.d6,.d7
	dw 0
.d0:	dw SPFskatewp+1,10,SPFskatewp+2,10,SPFskatewp+3,10,SPFskatewp+4,10,SPFskatewp,-15
.d1:	dw SPFskatewp+6,10,SPFskatewp+7,10,SPFskatewp+8,10,SPFskatewp+9,10,SPFskatewp+5,-15
.d2:	dw SPFskatewp+11,10,SPFskatewp+12,10,SPFskatewp+13,10,SPFskatewp+14,10,SPFskatewp+10,-15
.d3:	dw SPFskatewp+16,10,SPFskatewp+17,10,SPFskatewp+18,10,SPFskatewp+19,10,SPFskatewp+15,-15
.d4:	dw SPFskatewp+21,10,SPFskatewp+22,10,SPFskatewp+23,10,SPFskatewp+24,10,SPFskatewp+20,-15
.d5:	dw SPFskatewp+26,10,SPFskatewp+27,10,SPFskatewp+28,10,SPFskatewp+29,10,SPFskatewp+25,-15
.d6:	dw SPFskatewp+31,10,SPFskatewp+32,10,SPFskatewp+33,10,SPFskatewp+34,10,SPFskatewp+30,-15
.d7:	dw SPFskatewp+36,10,SPFskatewp+37,10,SPFskatewp+38,10,SPFskatewp+39,10,SPFskatewp+35,-15
SPAskate:
	dw .d0,.d1,.d2,.d3,.d4,.d5,.d6,.d7
	dw 0
.d0:	dw SPFskate+1,10,SPFskate+2,10,SPFskate+3,10,SPFskate+4,10,SPFskate,-15
.d1:	dw SPFskate+6,10,SPFskate+7,10,SPFskate+8,10,SPFskate+9,10,SPFskate+5,-15
.d2:	dw SPFskate+11,10,SPFskate+12,10,SPFskate+13,10,SPFskate+14,10,SPFskate+10,-15
.d3:	dw SPFskate+16,10,SPFskate+17,10,SPFskate+18,10,SPFskate+19,10,SPFskate+15,-15
.d4:	dw SPFskate+21,10,SPFskate+22,10,SPFskate+23,10,SPFskate+24,10,SPFskate+20,-15
.d5:	dw SPFskate+26,10,SPFskate+27,10,SPFskate+28,10,SPFskate+29,10,SPFskate+25,-15
.d6:	dw SPFskate+31,10,SPFskate+32,10,SPFskate+33,10,SPFskate+34,10,SPFskate+30,-15
.d7:	dw SPFskate+36,10,SPFskate+37,10,SPFskate+38,10,SPFskate+39,10,SPFskate+35,-15
SPAturnl:
	dw .d0,.d1,.d2,.d3,.d4,.d5,.d6,.d7
	dw 0
.d0:	dw SPFturnl,-12
.d1:	dw SPFturnl+1,-12
.d2:	dw SPFturnl+2,-12
.d3:	dw SPFturnl+3,-12
.d4:	dw SPFturnl+4,-12
.d5:	dw SPFturnl+5,-12
.d6:	dw SPFturnl+6,-12
.d7:	dw SPFturnl+7,-12
SPAturnr:
	dw .d0,.d1,.d2,.d3,.d4,.d5,.d6,.d7
	dw 0
.d0:	dw SPFturnr,-12
.d1:	dw SPFturnr+1,-12
.d2:	dw SPFturnr+2,-12
.d3:	dw SPFturnr+3,-12
.d4:	dw SPFturnr+4,-12
.d5:	dw SPFturnr+5,-12
.d6:	dw SPFturnr+6,-12
.d7:	dw SPFturnr+7,-12
SPAstop:
	dw .d0,.d1,.d2,.d3,.d4,.d5,.d6,.d7
	dw 1
.d0:	dw SPFstop,4,SPFstop+1,-4
.d1:	dw SPFstop+2,4,SPFstop+3,-4
.d2:	dw SPFstop+4,4,SPFstop+5,-4
.d3:	dw SPFstop+6,4,SPFstop+7,-4
.d4:	dw SPFstop+8,4,SPFstop+9,-4
.d5:	dw SPFstop+10,4,SPFstop+11,-4
.d6:	dw SPFstop+12,4,SPFstop+13,-4
.d7:	dw SPFstop+14,4,SPFstop+15,-4
SPApassf:
	dw .d0,.d1,.d2,.d3,.d4,.d5,.d6,.d7
	dw 0
.d0:	dw SPFswing+3,4,SPFswing+4,4,SPFswing+5,-20
.d1:	dw SPFswing+9,4,SPFswing+10,4,SPFswing+11,-20
.d2:	dw SPFswing+15,4,SPFswing+16,4,SPFswing+17,-20
.d3:	dw SPFswing+21,4,SPFswing+22,4,SPFswing+23,-20
.d4:	dw SPFswing+27,4,SPFswing+28,4,SPFswing+29,-20
.d5:	dw SPFswing+33,4,SPFswing+34,4,SPFswing+35,-20
.d6:	dw SPFswing+39,4,SPFswing+40,4,SPFswing+41,-20
.d7:	dw SPFswing+45,4,SPFswing+46,4,SPFswing+47,-20
SPApassb:
	dw .d0,.d1,.d2,.d3,.d4,.d5,.d6,.d7
	dw 0
.d0:	dw SPFswing+3,4,SPFswing+2,4,SPFswing+1,-20
.d1:	dw SPFswing+9,4,SPFswing+8,4,SPFswing+7,-20
.d2:	dw SPFswing+15,4,SPFswing+14,4,SPFswing+13,-20
.d3:	dw SPFswing+21,4,SPFswing+20,4,SPFswing+19,-20
.d4:	dw SPFswing+27,4,SPFswing+26,4,SPFswing+25,-20
.d5:	dw SPFswing+33,4,SPFswing+32,4,SPFswing+31,-20
.d6:	dw SPFswing+39,4,SPFswing+38,4,SPFswing+37,-20
.d7:	dw SPFswing+45,4,SPFswing+44,4,SPFswing+43,-20
SPAshotf:
	dw .d0,.d1,.d2,.d3,.d4,.d5,.d6,.d7
	dw 0
.d0:	dw SPFswing+3,4,SPFswing+2,4,SPFswing+1,4,SPFswing,4,SPFswing+2,0,SPFswing+3,0,SPFswing+4,0,SPFswing+5,-20
.d1:	dw SPFswing+9,4,SPFswing+8,4,SPFswing+7,4,SPFswing+6,4,SPFswing+8,0,SPFswing+9,0,SPFswing+10,0,SPFswing+11,-20
.d2:	dw SPFswing+15,4,SPFswing+14,4,SPFswing+13,4,SPFswing+12,4,SPFswing+14,0,SPFswing+15,0,SPFswing+16,0,SPFswing+17,-20
.d3:	dw SPFswing+21,4,SPFswing+20,4,SPFswing+19,4,SPFswing+18,4,SPFswing+20,0,SPFswing+21,0,SPFswing+22,0,SPFswing+23,-20
.d4:	dw SPFswing+27,4,SPFswing+26,4,SPFswing+25,4,SPFswing+24,4,SPFswing+26,0,SPFswing+27,0,SPFswing+28,0,SPFswing+29,-20
.d5:	dw SPFswing+33,4,SPFswing+32,4,SPFswing+31,4,SPFswing+30,4,SPFswing+32,0,SPFswing+33,0,SPFswing+34,0,SPFswing+35,-20
.d6:	dw SPFswing+39,4,SPFswing+38,4,SPFswing+37,4,SPFswing+36,4,SPFswing+38,0,SPFswing+39,0,SPFswing+40,0,SPFswing+41,-20
.d7:	dw SPFswing+45,4,SPFswing+44,4,SPFswing+43,4,SPFswing+42,4,SPFswing+44,0,SPFswing+45,0,SPFswing+46,0,SPFswing+47,-20
SPAshotb:
	dw .d0,.d1,.d2,.d3,.d4,.d5,.d6,.d7
	dw 0
.d0:	dw SPFswing+3,4,SPFswing+4,4,SPFswing+5,4,SPFswing+5,4,SPFswing+4,0,SPFswing+3,0,SPFswing+2,0,SPFswing+1,-20
.d1:	dw SPFswing+9,4,SPFswing+10,4,SPFswing+11,4,SPFswing+11,4,SPFswing+10,0,SPFswing+9,0,SPFswing+8,0,SPFswing+7,-20
.d2:	dw SPFswing+15,4,SPFswing+16,4,SPFswing+17,4,SPFswing+17,4,SPFswing+16,0,SPFswing+15,0,SPFswing+14,0,SPFswing+13,-20
.d3:	dw SPFswing+21,4,SPFswing+22,4,SPFswing+23,4,SPFswing+23,4,SPFswing+22,0,SPFswing+21,0,SPFswing+20,0,SPFswing+19,-20
.d4:	dw SPFswing+27,4,SPFswing+28,4,SPFswing+29,4,SPFswing+29,4,SPFswing+28,0,SPFswing+27,0,SPFswing+26,0,SPFswing+25,-20
.d5:	dw SPFswing+33,4,SPFswing+34,4,SPFswing+35,4,SPFswing+35,4,SPFswing+34,0,SPFswing+33,0,SPFswing+32,0,SPFswing+31,-20
.d6:	dw SPFswing+39,4,SPFswing+40,4,SPFswing+41,4,SPFswing+41,4,SPFswing+40,0,SPFswing+39,0,SPFswing+38,0,SPFswing+37,-20
.d7:	dw SPFswing+45,4,SPFswing+46,4,SPFswing+47,4,SPFswing+47,4,SPFswing+46,0,SPFswing+45,0,SPFswing+44,0,SPFswing+43,-20
SPAonetimerf:
	dw .d0,.d1,.d2,.d3,.d4,.d5,.d6,.d7
	dw 0
.d0:	dw SPFswing+1,55,SPFswing+2,2,SPFswing+3,2,SPFswing+4,2,SPFswing+5,-20
.d1:	dw SPFswing+7,55,SPFswing+8,2,SPFswing+9,2,SPFswing+10,2,SPFswing+11,-20
.d2:	dw SPFswing+13,55,SPFswing+14,2,SPFswing+15,2,SPFswing+16,2,SPFswing+17,-20
.d3:	dw SPFswing+19,55,SPFswing+20,2,SPFswing+21,2,SPFswing+22,2,SPFswing+23,-20
.d4:	dw SPFswing+25,55,SPFswing+26,2,SPFswing+27,2,SPFswing+28,2,SPFswing+29,-20
.d5:	dw SPFswing+31,55,SPFswing+32,2,SPFswing+33,2,SPFswing+34,2,SPFswing+35,-20
.d6:	dw SPFswing+37,55,SPFswing+38,2,SPFswing+39,2,SPFswing+40,2,SPFswing+41,-20
.d7:	dw SPFswing+43,55,SPFswing+44,2,SPFswing+45,2,SPFswing+46,2,SPFswing+47,-20
SPAonetimerb:
	dw .d0,.d1,.d2,.d3,.d4,.d5,.d6,.d7
	dw 0
.d0:	dw SPFswing+5,55,SPFswing+4,2,SPFswing+3,2,SPFswing+2,2,SPFswing+1,-20
.d1:	dw SPFswing+11,55,SPFswing+10,2,SPFswing+9,2,SPFswing+8,2,SPFswing+7,-20
.d2:	dw SPFswing+17,55,SPFswing+16,2,SPFswing+15,2,SPFswing+14,2,SPFswing+13,-20
.d3:	dw SPFswing+23,55,SPFswing+22,2,SPFswing+21,2,SPFswing+20,2,SPFswing+19,-20
.d4:	dw SPFswing+29,55,SPFswing+28,2,SPFswing+27,2,SPFswing+26,2,SPFswing+25,-20
.d5:	dw SPFswing+35,55,SPFswing+34,2,SPFswing+33,2,SPFswing+32,2,SPFswing+31,-20
.d6:	dw SPFswing+41,55,SPFswing+40,2,SPFswing+39,2,SPFswing+38,2,SPFswing+37,-20
.d7:	dw SPFswing+47,55,SPFswing+46,2,SPFswing+45,2,SPFswing+44,2,SPFswing+43,-20
SPAglideback:
	dw .d0,.d1,.d2,.d3,.d4,.d5,.d6,.d7
	dw 0
.d0:	dw SPFskateb,-8
.d1:	dw SPFskateb+3,-8
.d2:	dw SPFskateb+6,-8
.d3:	dw SPFskateb+9,-8
.d4:	dw SPFskateb+12,-8
.d5:	dw SPFskateb+15,-8
.d6:	dw SPFskateb+18,-8
.d7:	dw SPFskateb+21,-8
SPAskateback:
	dw .d0,.d1,.d2,.d3,.d4,.d5,.d6,.d7
	dw 0
.d0:	dw SPFskateb,8,SPFskateb+1,8,SPFskateb,8,SPFskateb+2,-8
.d1:	dw SPFskateb+3,8,SPFskateb+4,8,SPFskateb+3,8,SPFskateb+5,-8
.d2:	dw SPFskateb+6,8,SPFskateb+7,8,SPFskateb+6,8,SPFskateb+8,-8
.d3:	dw SPFskateb+9,8,SPFskateb+10,8,SPFskateb+9,8,SPFskateb+11,-8
.d4:	dw SPFskateb+12,8,SPFskateb+13,8,SPFskateb+12,8,SPFskateb+14,-8
.d5:	dw SPFskateb+15,8,SPFskateb+16,8,SPFskateb+15,8,SPFskateb+17,-8
.d6:	dw SPFskateb+18,8,SPFskateb+19,8,SPFskateb+18,8,SPFskateb+20,-8
.d7:	dw SPFskateb+21,8,SPFskateb+22,8,SPFskateb+21,8,SPFskateb+23,-8
SPAcrosscheck:						;checkcheck: the check straight ahead, away from the crease (94G
									;SPAcrosscheck)
	dw .d0,.d1,.d2,.d3,.d4,.d5,.d6,.d7
	dw 0
.d0:	dw SPFcrosscheck,1,SPFcrosscheck+1,10,SPFcrosscheck,-8
.d1:	dw SPFcrosscheck+2,1,SPFcrosscheck+3,10,SPFcrosscheck+2,-8
.d2:	dw SPFcrosscheck+4,1,SPFcrosscheck+5,10,SPFcrosscheck+4,-8
.d3:	dw SPFcrosscheck+6,1,SPFcrosscheck+7,10,SPFcrosscheck+6,-8
.d4:	dw SPFcrosscheck+8,1,SPFcrosscheck+9,10,SPFcrosscheck+8,-8
.d5:	dw SPFcrosscheck+10,1,SPFcrosscheck+11,10,SPFcrosscheck+10,-8
.d6:	dw SPFcrosscheck+12,1,SPFcrosscheck+13,10,SPFcrosscheck+12,-8
.d7:	dw SPFcrosscheck+14,1,SPFcrosscheck+15,10,SPFcrosscheck+14,-8
SPAsweepchk:
	dw .d0,.d1,.d2,.d3,.d4,.d5,.d6,.d7
	dw 0
.d0:	dw SPFsweep,4,SPFsweep+1,8,SPFsweep,-4
.d1:	dw SPFsweep+2,4,SPFsweep+3,8,SPFsweep+2,-4
.d2:	dw SPFsweep+4,4,SPFsweep+5,8,SPFsweep+4,-4
.d3:	dw SPFsweep+6,4,SPFsweep+7,8,SPFsweep+6,-4
.d4:	dw SPFsweep+8,4,SPFsweep+9,8,SPFsweep+8,-4
.d5:	dw SPFsweep+10,4,SPFsweep+11,8,SPFsweep+10,-4
.d6:	dw SPFsweep+12,4,SPFsweep+13,8,SPFsweep+12,-4
.d7:	dw SPFsweep+14,4,SPFsweep+15,8,SPFsweep+14,-4
SPAshoulderchkl:
	dw .d0,.d1,.d2,.d3,.d4,.d5,.d6,.d7
	dw 0
.d0:	dw SPFshoulderl,-24
.d1:	dw SPFshoulderl+1,-24
.d2:	dw SPFshoulderl+2,-24
.d3:	dw SPFshoulderl+3,-24
.d4:	dw SPFshoulderl+4,-24
.d5:	dw SPFshoulderl+5,-24
.d6:	dw SPFshoulderl+6,-24
.d7:	dw SPFshoulderl+7,-24
SPAshoulderchkr:
	dw .d0,.d1,.d2,.d3,.d4,.d5,.d6,.d7
	dw 0
.d0:	dw SPFshoulderr,-24
.d1:	dw SPFshoulderr+1,-24
.d2:	dw SPFshoulderr+2,-24
.d3:	dw SPFshoulderr+3,-24
.d4:	dw SPFshoulderr+4,-24
.d5:	dw SPFshoulderr+5,-24
.d6:	dw SPFshoulderr+6,-24
.d7:	dw SPFshoulderr+7,-24
SPAhipchkl:
	dw .d0,.d1,.d2,.d3,.d4,.d5,.d6,.d7
	dw 0
.d0:	dw SPFhipl,-24
.d1:	dw SPFhipl+1,-24
.d2:	dw SPFhipl+2,-24
.d3:	dw SPFhipl+3,-24
.d4:	dw SPFhipl+4,-24
.d5:	dw SPFhipl+5,-24
.d6:	dw SPFhipl+6,-24
.d7:	dw SPFhipl+7,-24
SPAhipchkr:
	dw .d0,.d1,.d2,.d3,.d4,.d5,.d6,.d7
	dw 0
.d0:	dw SPFhipr,-24
.d1:	dw SPFhipr+1,-24
.d2:	dw SPFhipr+2,-24
.d3:	dw SPFhipr+3,-24
.d4:	dw SPFhipr+4,-24
.d5:	dw SPFhipr+5,-24
.d6:	dw SPFhipr+6,-24
.d7:	dw SPFhipr+7,-24
SPAburst:
	dw .d0,.d1,.d2,.d3,.d4,.d5,.d6,.d7
	dw 0
.d0:	dw SPFskate,-24
.d1:	dw SPFskate+5,-24
.d2:	dw SPFskate+10,-24
.d3:	dw SPFskate+15,-24
.d4:	dw SPFskate+20,-24
.d5:	dw SPFskate+25,-24
.d6:	dw SPFskate+30,-24
.d7:	dw SPFskate+35,-24
SPAHold:
	dw .d0,.d1,.d2,.d3,.d4,.d5,.d6,.d7
	dw 0
.d0:	dw SPFhold,-30
.d1:	dw SPFhold+1,-30
.d2:	dw SPFhold+2,-30
.d3:	dw SPFhold+3,-30
.d4:	dw SPFhold+4,-30
.d5:	dw SPFhold+5,-30
.d6:	dw SPFhold+6,-30
.d7:	dw SPFhold+7,-30
SPAHold2:
	dw .d0,.d1,.d2,.d3,.d4,.d5,.d6,.d7
	dw 0
.d0:	dw SPFhold,-72
.d1:	dw SPFhold+1,-72
.d2:	dw SPFhold+2,-72
.d3:	dw SPFhold+3,-72
.d4:	dw SPFhold+4,-72
.d5:	dw SPFhold+5,-72
.d6:	dw SPFhold+6,-72
.d7:	dw SPFhold+7,-72
SPAhook2:
	dw .d0,.d1,.d2,.d3,.d4,.d5,.d6,.d7
	dw 0
.d0:	dw SPFhook,18,SPFhook+1,18,SPFhook,18,SPFhook+1,-18
.d1:	dw SPFhook+2,18,SPFhook+3,18,SPFhook+2,18,SPFhook+3,-18
.d2:	dw SPFhook+4,18,SPFhook+5,18,SPFhook+4,18,SPFhook+5,-18
.d3:	dw SPFhook+6,18,SPFhook+7,18,SPFhook+6,18,SPFhook+7,-18
.d4:	dw SPFhook+8,18,SPFhook+9,18,SPFhook+8,18,SPFhook+9,-18
.d5:	dw SPFhook+10,18,SPFhook+11,18,SPFhook+10,18,SPFhook+11,-18
.d6:	dw SPFhook+12,18,SPFhook+13,18,SPFhook+12,18,SPFhook+13,-18
.d7:	dw SPFhook+14,18,SPFhook+15,18,SPFhook+14,18,SPFhook+15,-18
SPAflail:
	dw .d0,.d1,.d2,.d3,.d4,.d5,.d6,.d7
	dw 0
.d0:	dw SPFskate,-90
.d1:	dw SPFskate+5,-90
.d2:	dw SPFskate+10,-90
.d3:	dw SPFskate+15,-90
.d4:	dw SPFskate+20,-90
.d5:	dw SPFskate+25,-90
.d6:	dw SPFskate+30,-90
.d7:	dw SPFskate+35,-90
SPAfallfwd:
	dw .d0,.d1,.d2,.d3,.d4,.d5,.d6,.d7
	dw 0
.d0:	dw SPFfallfwd,6,SPFfallfwd+1,6,SPFfallfwd+2,100,SPFfallfwd+3,8,SPFduck,-8
.d1:	dw SPFfallfwd+4,6,SPFfallfwd+5,6,SPFfallfwd+6,100,SPFfallfwd+7,8,SPFduck+1,-8
.d2:	dw SPFfallfwd+8,6,SPFfallfwd+9,6,SPFfallfwd+10,100,SPFfallfwd+11,8,SPFduck+2,-8
.d3:	dw SPFfallfwd+12,6,SPFfallfwd+13,6,SPFfallfwd+14,100,SPFfallfwd+15,8,SPFduck+3,-8
.d4:	dw SPFfallfwd+16,6,SPFfallfwd+17,6,SPFfallfwd+18,100,SPFfallfwd+19,8,SPFduck+4,-8
.d5:	dw SPFfallfwd+20,6,SPFfallfwd+21,6,SPFfallfwd+22,100,SPFfallfwd+23,8,SPFduck+5,-8
.d6:	dw SPFfallfwd+24,6,SPFfallfwd+25,6,SPFfallfwd+26,100,SPFfallfwd+27,8,SPFduck+6,-8
.d7:	dw SPFfallfwd+28,6,SPFfallfwd+29,6,SPFfallfwd+30,100,SPFfallfwd+31,8,SPFduck+7,-8
SPAfallback:
	dw .d0,.d1,.d2,.d3,.d4,.d5,.d6,.d7
	dw 0
.d0:	dw SPFfallback,6,SPFfallback+1,6,SPFfallback+2,100,SPFfallback+3,8,SPFduck,-8
.d1:	dw SPFfallback+4,6,SPFfallback+5,6,SPFfallback+6,100,SPFfallback+7,8,SPFduck+1,-8
.d2:	dw SPFfallback+8,6,SPFfallback+9,6,SPFfallback+10,100,SPFfallback+11,8,SPFduck+2,-8
.d3:	dw SPFfallback+12,6,SPFfallback+13,6,SPFfallback+14,100,SPFfallback+15,8,SPFduck+3,-8
.d4:	dw SPFfallback+16,6,SPFfallback+17,6,SPFfallback+18,100,SPFfallback+19,8,SPFduck+4,-8
.d5:	dw SPFfallback+20,6,SPFfallback+21,6,SPFfallback+22,100,SPFfallback+23,8,SPFduck+5,-8
.d6:	dw SPFfallback+24,6,SPFfallback+25,6,SPFfallback+26,100,SPFfallback+27,8,SPFduck+6,-8
.d7:	dw SPFfallback+28,6,SPFfallback+29,6,SPFfallback+30,100,SPFfallback+31,8,SPFduck+7,-8
SPAfaceoff:
	dw .d0,.d1,.d1,.d1,.d1,.d1,.d1,.d1
	dw 0
.d0:	dw SPFskatewp,2,SPFsweep+1,10,SPFsweep,-6
.d1:	dw SPFskatewp+20,2,SPFsweep+9,10,SPFsweep+8,-6
SPAfaceoffr:
	dw .d0,.d1,.d1,.d1,.d1,.d1,.d1,.d1
	dw 0
.d0:	dw SPFskatewp,-5
.d1:	dw SPFskatewp+20,-5
SPAsiren:
	dw .d0,.d0,.d0,.d0,.d0,.d0,.d0,.d0
	dw 1
.d0:	dw SPFSiren,3,SPFSiren+1,3,SPFSiren+2,3,SPFSiren+3,3,SPFSiren+4,3,SPFSiren+5,3,SPFSiren+6,3,SPFSiren+7,3
	dw SPFSiren+8,3,SPFSiren+9,3,SPFSiren+10,3,SPFSiren+11,3,SPFSiren+12,3,SPFSiren+13,-3
SPAstanley:
	dw .d0,.d1,.d2,.d3,.d4,.d5,.d6,.d7
	dw 1
.d0:	dw SPFcup,-30
.d1:	dw SPFcup+1,-30
.d2:	dw SPFcup+2,-30
.d3:	dw SPFcup+3,-30
.d4:	dw SPFcup+4,-30
.d5:	dw SPFcup+5,-30
.d6:	dw SPFcup+6,-30
.d7:	dw SPFcup+7,-30
SPAflip:
	dw .d0,.d1,.d2,.d3,.d4,.d5,.d6,.d7
	dw 0
.d0:	dw SPFflip,6,SPFflip+1,6,SPFflip+2,6,SPFflip+3,6,SPFfallback+2,100,SPFfallback+3,8,SPFduck,-8
.d1:	dw SPFflip,6,SPFflip+1,6,SPFflip+2,6,SPFflip+3,6,SPFfallback+6,100,SPFfallback+7,8,SPFduck+1,-8
.d2:	dw SPFflip,6,SPFflip+1,6,SPFflip+2,6,SPFflip+3,6,SPFfallback+10,100,SPFfallback+11,8,SPFduck+2,-8
.d3:	dw SPFflip+4,6,SPFflip+5,6,SPFflip+6,6,SPFflip+7,6,SPFfallback+14,100,SPFfallback+15,8,SPFduck+3,-8
.d4:	dw SPFflip+4,6,SPFflip+5,6,SPFflip+6,6,SPFflip+7,6,SPFfallback+18,100,SPFfallback+19,8,SPFduck+4,-8
.d5:	dw SPFflip+4,6,SPFflip+5,6,SPFflip+6,6,SPFflip+7,6,SPFfallback+22,100,SPFfallback+23,8,SPFduck+5,-8
.d6:	dw SPFflip+4,6,SPFflip+5,6,SPFflip+6,6,SPFflip+7,6,SPFfallback+26,100,SPFfallback+27,8,SPFduck+6,-8
.d7:	dw SPFflip,6,SPFflip+1,6,SPFflip+2,6,SPFflip+3,6,SPFfallback+30,100,SPFfallback+31,8,SPFduck+7,-8
SPAstumble:
	dw .d0,.d1,.d2,.d3,.d4,.d5,.d6,.d7
	dw 0
.d0:	dw SPFstumble,6,SPFstumble+1,6,SPFstumble+2,8,SPFstumble+1,6,SPFstumble,-6
.d1:	dw SPFstumble+3,6,SPFstumble+4,6,SPFstumble+5,8,SPFstumble+4,6,SPFstumble+3,-6
.d2:	dw SPFstumble+6,6,SPFstumble+7,6,SPFstumble+8,8,SPFstumble+7,6,SPFstumble+6,-6
.d3:	dw SPFstumble+9,6,SPFstumble+10,6,SPFstumble+11,8,SPFstumble+10,6,SPFstumble+9,-6
.d4:	dw SPFstumble+12,6,SPFstumble+13,6,SPFstumble+14,8,SPFstumble+13,6,SPFstumble+12,-6
.d5:	dw SPFstumble+15,6,SPFstumble+16,6,SPFstumble+17,8,SPFstumble+16,6,SPFstumble+15,-6
.d6:	dw SPFstumble+18,6,SPFstumble+19,6,SPFstumble+20,8,SPFstumble+19,6,SPFstumble+18,-6
.d7:	dw SPFstumble+21,6,SPFstumble+22,6,SPFstumble+23,8,SPFstumble+22,6,SPFstumble+21,-6
SPAhook:
	dw .d0,.d1,.d2,.d3,.d4,.d5,.d6,.d7
	dw 0
.d0:	dw SPFhook,-30
.d1:	dw SPFhook+2,-30
.d2:	dw SPFhook+4,-30
.d3:	dw SPFhook+6,-30
.d4:	dw SPFhook+8,-30
.d5:	dw SPFhook+10,-30
.d6:	dw SPFhook+12,-30
.d7:	dw SPFhook+14,-30
SPAcatch:
	dw .d0,.d1,.d2,.d3,.d4,.d5,.d6,.d7
	dw 0
.d0:	dw SPFcatch,6,SPFcatch+1,-6
.d1:	dw SPFcatch+2,6,SPFcatch+3,-6
.d2:	dw SPFcatch+4,6,SPFcatch+5,-6
.d3:	dw SPFcatch+6,6,SPFcatch+7,-6
.d4:	dw SPFcatch+8,6,SPFcatch+9,-6
.d5:	dw SPFcatch+10,6,SPFcatch+11,-6
.d6:	dw SPFcatch+12,6,SPFcatch+13,-6
.d7:	dw SPFcatch+14,6,SPFcatch+15,-6
SPAbglass:
	dw .d0,.d0,.d0,.d0,.d0,.d0,.d0,.d0
	dw 0
.d0:	dw SPFbglass,8,SPFbglass+1,8,SPFbglass+2,8,SPFbglass+3,8,SPFbglass+4,-1000
SPAinjury1:
	dw .d0,.d0,.d0,.d3,.d3,.d3,.d3,.d0
	dw 0
.d0:	dw SPFfallback,20,SPFfallback+1,20,SPFfallback+2,1000,SPFfallback+2,-1000
.d3:	dw SPFfallback+16,20,SPFfallback+17,20,SPFfallback+18,1000,SPFfallback+18,-1000
SPAcelebrate:
	dw .d0,.d1,.d2,.d3,.d4,.d5,.d6,.d7
	dw 0
.d0:	dw SPFpump,5,SPFcelebrate,6,SPFcelebrate+1,6,SPFcelebrate,12,SPFcelebrate+1,40,SPFcelebrate,-5
.d1:	dw SPFpump+2,5,SPFcelebrate+2,6,SPFcelebrate+3,6,SPFcelebrate+2,12,SPFcelebrate+3,40,SPFcelebrate+2,-5
.d2:	dw SPFpump+4,5,SPFcelebrate+4,6,SPFcelebrate+5,6,SPFcelebrate+4,12,SPFcelebrate+5,40,SPFcelebrate+4,-5
.d3:	dw SPFpump+6,5,SPFcelebrate+6,6,SPFcelebrate+7,6,SPFcelebrate+6,12,SPFcelebrate+7,40,SPFcelebrate+6,-5
.d4:	dw SPFpump+8,5,SPFcelebrate+8,6,SPFcelebrate+9,6,SPFcelebrate+8,12,SPFcelebrate+9,40,SPFcelebrate+8,-5
.d5:	dw SPFpump+10,5,SPFcelebrate+10,6,SPFcelebrate+11,6,SPFcelebrate+10,12,SPFcelebrate+11,40,SPFcelebrate+10,-5
.d6:	dw SPFpump+12,5,SPFcelebrate+12,6,SPFcelebrate+13,6,SPFcelebrate+12,12,SPFcelebrate+13,40,SPFcelebrate+12,-5
.d7:	dw SPFpump+14,5,SPFcelebrate+14,6,SPFcelebrate+15,6,SPFcelebrate+14,12,SPFcelebrate+15,40,SPFcelebrate+14,-5
SPApump:
	dw .d0,.d1,.d2,.d3,.d4,.d5,.d6,.d7
	dw 0
.d0:	dw SPFpump,8,SPFpump+1,8,SPFpump,-8
.d1:	dw SPFpump+2,8,SPFpump+3,8,SPFpump+2,-8
.d2:	dw SPFpump+4,8,SPFpump+5,8,SPFpump+4,-8
.d3:	dw SPFpump+6,8,SPFpump+7,8,SPFpump+6,-8
.d4:	dw SPFpump+8,8,SPFpump+9,8,SPFpump+8,-8
.d5:	dw SPFpump+10,8,SPFpump+11,8,SPFpump+10,-8
.d6:	dw SPFpump+12,8,SPFpump+13,8,SPFpump+12,-8
.d7:	dw SPFpump+14,8,SPFpump+15,8,SPFpump+14,-8
SPApump2:
	dw .d0,.d1,.d2,.d3,.d4,.d5,.d6,.d7
	dw 0
.d0:	dw SPFcelebrate,5,SPFcelebrate+1,15,SPFpump2,10,SPFpump2+1,5,SPFpump2+2,5,SPFpump2+3,5,SPFpump2,5,SPFpump2+1,5
	dw SPFpump2+2,5,SPFpump2+3,5,SPFcelebrate+1,5,SPFcelebrate,5,SPFskatewp,1,SPFskatewp,1,SPFskatewp,-3
.d1:	dw SPFcelebrate+2,5,SPFcelebrate+3,20,SPFpump2+4,5,SPFpump2+5,15,SPFpump2+6,10,SPFpump2+5,10,SPFpump2+6,10,SPFpump2+5,10
	dw SPFpump2+6,5,SPFpump2+7,20,SPFskatewp+5,1,SPFskatewp+5,1,SPFskatewp+5,1,SPFskatewp+5,1,SPFskatewp+5,-1
.d2:	dw SPFcelebrate+4,5,SPFcelebrate+5,20,SPFpump2+8,5,SPFpump2+9,5,SPFpump2+10,5,SPFpump2+11,10,SPFpump2+10,5,SPFpump2+11,10
	dw SPFpump2+10,10,SPFskatewp+10,1,SPFskatewp+10,1,SPFskatewp+10,1,SPFskatewp+10,1,SPFskatewp+10,1,SPFskatewp+10,-1
.d3:	dw SPFcelebrate+6,5,SPFcelebrate+7,20,SPFpump2+12,5,SPFpump2+13,5,SPFpump2+14,5,SPFpump2+15,10,SPFpump2+14,5,SPFpump2+15,10
	dw SPFpump2+14,10,SPFskatewp+15,1,SPFskatewp+15,1,SPFskatewp+15,1,SPFskatewp+15,1,SPFskatewp+15,1,SPFskatewp+15,-1
.d4:	dw SPFcelebrate+8,5,SPFcelebrate+9,15,SPFpump2+16,10,SPFpump2+17,5,SPFpump2+18,5,SPFpump2+19,5,SPFpump2+16,5,SPFpump2+17,5
	dw SPFpump2+18,5,SPFpump2+19,5,SPFcelebrate+9,5,SPFcelebrate+8,5,SPFskatewp+20,1,SPFskatewp+20,1,SPFskatewp+20,-3
.d5:	dw SPFcelebrate+10,5,SPFcelebrate+11,20,SPFpump2+20,5,SPFpump2+21,10,SPFpump2+22,10,SPFpump2+21,10,SPFpump2+20,5,SPFcelebrate+10,5
	dw SPFskatewp+25,1,SPFskatewp+25,1,SPFskatewp+25,1,SPFskatewp+25,1,SPFskatewp+25,1,SPFskatewp+25,1,SPFskatewp+25,-1
.d6:	dw SPFcelebrate+12,5,SPFcelebrate+13,20,SPFcelebrate+12,5,SPFpump2+23,5,SPFpump2+24,10,SPFpump2+25,5,SPFpump2+26,5,SPFpump2+24,5
	dw SPFpump2+25,5,SPFpump2+26,5,SPFpump2+24,5,SPFpump2+25,5,SPFpump2+26,5,SPFpump2+23,5,SPFskatewp+30,-5
.d7:	dw SPFpump+14,5,SPFcelebrate+14,5,SPFcelebrate+15,15,SPFcelebrate+14,5,SPFpump2+27,5,SPFpump2+28,15,SPFpump2+29,5,SPFpump2+30,5
	dw SPFpump2+28,10,SPFpump2+27,5,SPFpump+14,5,SPFskatewp+35,1,SPFskatewp+35,1,SPFskatewp+35,1,SPFskatewp+35,-2
SPAboardfront:
	dw .d0,.d0,.d2,.d2,.d4,.d4,.d6,.d6
	dw 0
.d0:	dw SPFboardfront,6,SPFboardfront+1,6,SPFboardfront+2,6,SPFboardfront+3,75,SPFfallfwd+19,-6
.d2:	dw SPFboardfront+4,6,SPFboardfront+5,6,SPFboardfront+6,6,SPFboardfront+7,75,SPFfallfwd+11,-6
.d4:	dw SPFboardfront+8,6,SPFboardfront+9,6,SPFboardfront+10,6,SPFboardfront+11,75,SPFfallfwd+19,-6
.d6:	dw SPFboardfront+12,6,SPFboardfront+13,6,SPFboardfront+14,6,SPFboardfront+15,75,SPFfallfwd+27,-6
SPAboardback:
	dw .d0,.d0,.d2,.d2,.d4,.d4,.d6,.d6
	dw 0
.d0:	dw SPFboardback,6,SPFboardback+1,6,SPFboardback+2,6,SPFboardback+3,75,SPFfallfwd+3,-6
.d2:	dw SPFboardback+4,6,SPFboardback+5,6,SPFboardback+6,6,SPFboardback+7,75,SPFfallback+11,-6
.d4:	dw SPFboardback+8,6,SPFboardback+9,6,SPFboardback+10,6,SPFboardback+11,75,SPFfallfwd+19,-6
.d6:	dw SPFboardback+12,6,SPFboardback+13,6,SPFboardback+14,6,SPFboardback+15,75,SPFfallback+27,-6
SPAboardright:
	dw .d0,.d0,.d2,.d2,.d4,.d4,.d6,.d6
	dw 0
.d0:	dw SPFboardright,6,SPFboardright+1,6,SPFboardright+2,6,SPFboardright+3,75,SPFfallback+3,-6
.d2:	dw SPFboardright+4,6,SPFboardright+5,6,SPFboardright+6,6,SPFboardright+7,75,SPFfallback+7,-6
.d4:	dw SPFboardright+8,6,SPFboardright+9,6,SPFboardright+10,6,SPFboardright+11,75,SPFfallback+19,-6
.d6:	dw SPFboardright+12,6,SPFboardright+13,6,SPFboardright+14,6,SPFboardright+15,75,SPFfallback+31,-6
SPAboardleft:
	dw .d0,.d0,.d2,.d2,.d4,.d4,.d6,.d6
	dw 0
.d0:	dw SPFboardleft,6,SPFboardleft+1,6,SPFboardleft+2,6,SPFboardleft+3,75,SPFfallfwd+3,-6
.d2:	dw SPFboardleft+4,6,SPFboardleft+5,6,SPFboardleft+6,6,SPFboardleft+7,75,SPFfallback+7,-6
.d4:	dw SPFboardleft+8,6,SPFboardleft+9,6,SPFboardleft+10,6,SPFboardleft+11,75,SPFfallfwd+19,-6
.d6:	dw SPFboardleft+12,6,SPFboardleft+13,6,SPFboardleft+14,6,SPFboardleft+15,75,SPFfallfwd+23,-6
SPAbenchcheckr:
	dw .d0,.d0,.d2,.d2,.d4,.d4,.d6,.d6
	dw 0
.d0:	dw SPFbenchcheck,10,SPFbenchcheck+1,10,SPFbenchcheck+4,10,SPFbenchcheck+4,90,SPFbenchcheck+20,-20
.d2:	dw SPFbenchcheck+5,10,SPFbenchcheck+6,10,SPFbenchcheck+9,10,SPFbenchcheck+9,90,SPFbenchcheck+20,-20
.d4:	dw SPFbenchcheck+10,10,SPFbenchcheck+11,10,SPFbenchcheck+14,10,SPFbenchcheck+14,90,SPFbenchcheck+20,-20
.d6:	dw SPFbenchcheck+15,10,SPFbenchcheck+16,10,SPFbenchcheck+19,10,SPFbenchcheck+19,90,SPFbenchcheck+20,-20
SPAbenchcheckl:
	dw .d0,.d0,.d2,.d2,.d4,.d4,.d6,.d6
	dw 0
.d0:	dw SPFbenchcheck+2,10,SPFbenchcheck+3,10,SPFbenchcheck+4,10,SPFbenchcheck+4,90,SPFbenchcheck+20,-20
.d2:	dw SPFbenchcheck+7,10,SPFbenchcheck+8,10,SPFbenchcheck+9,10,SPFbenchcheck+9,90,SPFbenchcheck+20,-20
.d4:	dw SPFbenchcheck+12,10,SPFbenchcheck+13,10,SPFbenchcheck+14,10,SPFbenchcheck+14,90,SPFbenchcheck+20,-20
.d6:	dw SPFbenchcheck+17,10,SPFbenchcheck+18,10,SPFbenchcheck+19,10,SPFbenchcheck+19,90,SPFbenchcheck+20,-20
SPAunused1:							; nothing sets it (updateanim only compares SPA with its address)
	dw .d0,.d0,.d0,.d0,.d0,.d0,.d6,.d6
	dw 0
.d0:	dw SPFskateb+6,6,SPFunused,6,SPFunused+1,15,SPFunused+2,6,SPFunused,6,SPFskatewp+10,-6
.d6:	dw SPFskateb+18,6,SPFunused+3,6,SPFunused+4,15,SPFunused+5,6,SPFunused+3,6,SPFskatewp+30,-6
SPAunused2:							; nothing sets it
	dw .d0,.d0,.d0,.d0,.d0,.d0,.d6,.d6
	dw 0
.d0:	dw SPFskateb+6,6,SPFunused,15,SPFunused+6,15,SPFunused+7,15,SPFunused+8,15,SPFunused+7,15,SPFunused+8,15,SPFunused,10
	dw SPFskateb+9,-6
.d6:	dw SPFskateb+18,6,SPFunused+3,15,SPFunused+9,15,SPFunused+10,15,SPFunused+9,15,SPFunused+10,15,SPFunused+3,10,SPFskateb+18,-6
SPAunused3:							; nothing sets it
	dw .d0,.d0,.d0,.d0,.d0,.d0,.d0,.d0
	dw 0
.d0:	dw SPFskateb+12,-52
	padbyte $FF
	pad $9E8000
