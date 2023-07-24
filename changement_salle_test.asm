agauche
	ld		hl,-16
	ld		(decalage_octets_salle_suivante),hl
	call	calcule_salle_suivante
jp NOUVELLE_PIECE

adroite
	ld		hl,-12
	ld		(decalage_octets_salle_suivante),hl
	call	calcule_salle_suivante
	jp NOUVELLE_PIECE
enhaut
jp NOUVELLE_PIECE
enbas
jp NOUVELLE_PIECE






calcule_salle_suivante
	ld		c,bank_maptile_decors
	call	rom_on
	ld		hl,(adresse_du_decors_en_rom)				; car avant on a les infos des salles adjacentes
	ld		de,(decalage_octets_salle_suivante)										; -12 octet en arrièce on tombe sur l'adresse de la piece de droite
	add		hl,de										
	ld		a,(hl)										; on lit le poid faible
	ld		e,a											; on charge dans e
	inc 	l											; octet suivant
	ld		a,(hl)										; on lit le poid fort
	ld		d,a											; on charge dans d	
	ex		hl,de										; on met le resultat dans hl. On a l'adresse de la prochaine piece
	ld		a,(hl)										; on lit le tout premier octet
	ld		(no_de_la_salle),a							; qui contient le numero de la salle
	ld		de,18										; et 18 octets plus loin on a la première tile
	add		hl,de										
	ld		(adresse_du_decors_en_rom),hl				; on la sauvegarde
	call	rom_off
	; on efface les evenements des animations de l'ecran precedant
	xor		a
	ld		b,15
	ld		hl,event_animations
		efface_anim
			ld	(hl),a
			inc	l
			dec	 b
			jr	nz,efface_anim
			ret
	
	