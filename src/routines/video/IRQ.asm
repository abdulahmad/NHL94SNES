; IRQ vector: jml IRQ_Fast
IRQ:								; IRQ vector target
	jml.l IRQ_Fast					; go to the real handler
