; Wait X frames (WaitFrames_Inc) unless a pad press has ended the title (titleskip)
TitleWait:							; x = frames to wait; called from TitleScreen and TitleBlankSprites
	ldy.w titleskip					; title ended by a pad press?
	bne .rtl						; yes, no wait
	ldy.w #$0000					; y = 0
	jsl.l WaitFrames_Inc			; wait x frames
.rtl:								; done
	rtl
