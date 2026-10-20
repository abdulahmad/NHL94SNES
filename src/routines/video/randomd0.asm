; d0 = a random number from 0 to d0-1
randomd0:							; called from InitializeGameStructures, WeightedRandomSelect, assneares...
	lda.b d0
	jsl.l randoma					; random number 0 to A-1
	sta.b d0
	rtl
