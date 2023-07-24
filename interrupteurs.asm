
; //////////////////////////////////////////////////////////////////
; //////////////////////////////////////////////////////////////////
; ////////////////////        INTERRUPTEURS      ///////////////////
; //////////////////////////////////////////////////////////////////
; //////////////////////////////////////////////////////////////////
asic_on
	di
	ld		bc,#7F00+%10111000		; sauvegardé AVANT le out (execution)
	ld		a,c						; car en cas d'interruption les registres aurons
	ld		(valeur_asic),a			; été sauvegardé et rétablit, prêt à être "out"
	out 	(c),c
	ei
	ret
asic_off
	di
	ld 		bc,#7F00+%10100000
	ld		a,c
	ld		(valeur_asic),a
	out	 	(c),c
	ei
	ret
	
rom_on
	di
	ld	a,(mode)	
	add	a,%10000100
	ld	(change_mode_on+1),a

	; sélèction de la ROM
	ld		a,#80						; si ld c,10
	add		a,c							; on ajoute #80 au numéros de la ROM
	ld		c,a							; le reg C contient la valeur de sélection de la ROM
	ld		b,#DF
	ld		(rom_sectionnee),bc
	out		(c),c						; on execute la sélèction de la ROM
	
	change_mode_on
	ld		bc,#7F00				; ROM inf connectée, ROM sup déconnectée, MODE 0
	ld		(etat_de_la_rom),bc
	out		(c),c						; on exécute la connexion de la ROM sélectionnée.
	ei
	ret

	
rom_off	
		di
		ld		a,(mode)
		add		a,%10001100
		ld		(change_mode_off+1),a
	change_mode_off
			ld		bc,#7F00			; ROM inf déconnectée, ROM sup déconnectée, MODE 0
			ld		(etat_de_la_rom),bc
			out		(c),c						; on exécute la connexion de la ROM sélectionnée.
			ei
			ret
	
