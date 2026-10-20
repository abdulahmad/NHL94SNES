; Text palette $2000 for the sorted stat column (A = $1DF9), else $2400
SetStatColumnPal:					; A = column number; sets printa; called from FillPlayerStatsPage
	cmp.w statcolumn				; the sorted column?
	beq .t1							; yes
	lda.w #$2400					; normal text palette
	sta.w printa					; print attribute
	bra .1							; done

.t1:								; the sorted column
	lda.w #$2000					; highlighted palette
	sta.w printa
.1:									; done
	rtl
