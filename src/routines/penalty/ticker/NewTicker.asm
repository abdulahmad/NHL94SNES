; Show the next ticker score once the clock is at 8:00 or less
NewTicker:							; starts the ticker when the clock is low
	lda.w gameclock					; game clock
	cmp.w #$01E1
	bcc NewTicker2					; below $1E1: show the next ticker score
	rtl								; else leave
