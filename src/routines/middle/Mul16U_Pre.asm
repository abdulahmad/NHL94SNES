; A * Y into $08-$0B, unsigned, Y also in $00, no zero test
Mul16U_Pre:							; called from Mul16XS_Neg
	phy
	bra Mul16U_Go
