; Run the penalty work once a frame: times, new calls, the referee
;
; Called from periodicevents each frame.
PenaltyManager:						; penalty work for this frame
	jsl.l updatepentime				; update the penalty times
	jsl.l checkfornewpen			; look for a new penalty
	jsl.l chkprogress				; move the referee through a penalty
	jml.l UpdatePA					; update the penalty display and return
