; The roster column handlers, as offsets from the table
attribjmp:							; table of handler offsets, one word per attribute
	dw AttribStatus-attribjmp,AttribEnergy-attribjmp,AttribHanded-attribjmp,AttribWeight-attribjmp,AttribFighting-attribjmp,AttribRating-attribjmp
