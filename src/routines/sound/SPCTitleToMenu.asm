; Turn the title sample set into the menu set without a full upload: driver command 4 drops the last three
; uploaded samples, then the four samples of the menu set after its first 12 (SampleTimp, SampleDist,
; SamplePlayoffOrgan, SampleAPower) are sent and sndbank is SoundBankMenu. Called by TitleScreen
SPCTitleToMenu:						; change the title sample set into the menu set
	stz.w cursong					;no team song plays
	jsl.l SPCCmd04
	jsl.l SPCCmd04
	jsl.l SPCCmd04
	lda.w #SampleTimp>>16
	sta.b p0+2
	lda.w #SampleTimp
	sta.b p0
	jsl.l SPCUploadBlock
	lda.w #SampleDist>>16
	sta.b p0+2
	lda.w #SampleDist
	sta.b p0
	jsl.l SPCUploadBlock
	lda.w #SamplePlayoffOrgan>>16
	sta.b p0+2
	lda.w #SamplePlayoffOrgan
	sta.b p0
	jsl.l SPCUploadBlock
	lda.w #SampleAPower>>16
	sta.b p0+2
	lda.w #SampleAPower
	sta.b p0
	jsl.l SPCUploadBlock
	lda.w #SoundBankMenu
	sta.w sndbank					;the menu set is loaded
	rtl
