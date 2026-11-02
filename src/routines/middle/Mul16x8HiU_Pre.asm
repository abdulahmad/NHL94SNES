; Multiplies. X is the 16-bit operand of the 16 x 8 forms.
; A * Y (low byte) / 256 into A and $09, unsigned, no zero test
Mul16x8HiU_Pre:						; called from Mul16x8HiXS_Neg
	phy
	bra Mul16x8HiU_Go
