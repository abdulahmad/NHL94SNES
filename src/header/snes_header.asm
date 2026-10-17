; SNES internal header and the interrupt vectors.

	db "NHL '94              "		; title
	db $30							; map mode: LoROM, FastROM
	db $00							; cartridge type: ROM only
	db $0A							; ROM size: 1 MB
	db $00							; SRAM size: none
	db $01							; country: USA
	db $69							; licensee: Electronic Arts
	db $00							; version
	dw $64AD						; checksum complement
	dw $9B52						; checksum
	db $FF,$FF,$FF,$FF				; native mode vectors:
	dw $0000						; COP
	dw $0000						; BRK
	dw $0000						; ABORT
	dw NMI&$FFFF					; NMI
	dw Reset&$FFFF					; (unused)
	dw IRQ&$FFFF					; IRQ
	db $FF,$FF,$FF,$FF				; emulation mode vectors:
	dw $0000						; COP
	dw $0000						; (unused)
	dw $0000						; ABORT
	dw NMI&$FFFF					; NMI
	dw Reset&$FFFF					; RESET
	dw IRQ&$FFFF					; IRQ/BRK
