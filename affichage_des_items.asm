afficher_les_items
		ld		a,(flag_lumiere)			
		or		a
		ret		z	
		ld		a,(init_afficher_item)
		or		a
		RET		NZ
		call	calcule_piece_items				; on va lire la ligne de la piece en cours
		ld		a,(init_afficher_item)
		or		a
		JP		NZ,aucun_item_2
		ld		(pointeur_tableau_item),hl		; le resltat est en reg HL
		inc hl : inc hl : inc hl
		ld		a,(hl)
		push	af
		call	asic_on
		pop		af
		or		a
		ret		z
		dec	hl :dec	hl :dec	hl
		ld		de,Tableau_item_en_cours		; on va écrire dans le Tableau de l'item en cours
		inc	hl : inc hl							; on zappe les octets du numeros de la pièce
		call	asic_off	
		LDI		; adresse du sprite hard
		LDI		
		LDI		; adresse du sprite du HUD
		LDI
		LDI		; identifiant d'item
		inc		hl	
		LDI		; pos X
		LDI
		LDI		; pos Y
		LDI
		call	asic_on
		ld		hl,(adr_item_sprh)
		call	affichage_objet			; on positionne l'item dans la map
		ld		a,1
		ld		(init_afficher_item),a
		aucun_item_2
		call	asic_on
		ret
		
affichage_objet
		ld		a,(id_item)
		cp		a,17
		jp		z,Init_automodif_bank_item
		cp		a,23
		jp		z,Init_automodif_bank_item
		cp		a,22
		jp		z,Init_automodif_bank_item
		cp		a,21
		jp		z,Init_automodif_bank_item
		cp		a,20
		jp		z,Init_automodif_bank_item
		cp		a,19
		jp		z,Init_automodif_bank_item
		jp		retablir_automodif_bank_item
		retour_Init_automodif_bank_item
		ld		a,(id_item)
		cp		a,8						; fiole
		jp		z,petit_item_vertical
		cp		a,18						; fiole
		jp		z,petit_item_vertical
		cp		a,9						; globe oeil
		jp		z,petit_item_vertical
		cp		a,14					; extincteur
		jp		z,petit_item_vertical
		cp		a,13					; bonbon
		jp		z,petit_item_horizontal
		cp		a,19					; cle
		jp		z,petit_item_horizontal
		cp		a,22					; DILDO
		jp		z,petit_item_horizontal
grand_item
		ld		hl,(pos_X_item)
		ld		(SPRH12_X),hl
		ld		(SPRH14_X),hl
		ld		de,32
		add		hl,de
		ld		(SPRH13_X),hl
		ld		(SPRH15_X),hl
		ld		hl,(pos_Y_item)
		ld		(SPRH12_Y),hl
		ld		(SPRH13_Y),hl
		ld		de,16
		add		hl,de
		ld		(SPRH14_Y),hl
		ld		(SPRH15_Y),hl
		ld		a,ZOOM_mode_1
		ld		(SPRH12_ZOOM),a
		ld		(SPRH13_ZOOM),a
		ld		(SPRH14_ZOOM),a
		ld		(SPRH15_ZOOM),a
	automodif_bank_item
		ld		c,bank_sprh_items
		call	rom_on
		ld		hl,(adr_item_sprh)
		ld		de,SPRH12_ADR
		ld		bc,#400
		LDIR
		call	rom_off
		ret
petit_item_vertical
		ld		hl,(pos_X_item)
		ld		(SPRH12_X),hl
		ld		(SPRH13_X),hl
		ld		hl,(pos_Y_item)
		ld		(SPRH13_Y),hl
		ld		de,16
		add		hl,de
		ld		(SPRH12_Y),hl
		ld		a,ZOOM_mode_1
		ld		(SPRH12_ZOOM),a
		ld		(SPRH13_ZOOM),a
		xor		a
		ld		(SPRH14_ZOOM),a
		ld		(SPRH15_ZOOM),a
		ld		c,bank_sprh_items
		call	rom_on
		ld		hl,(adr_item_sprh)
		ld		de,SPRH12_ADR
		ld		bc,#200
		LDIR
		call	rom_off
		ret
petit_item_horizontal
		ld		hl,(pos_X_item)
		ld		(SPRH12_X),hl
		ld		de,32
		add		hl,de
		ld		(SPRH13_X),hl
		ld		hl,(pos_Y_item)
		ld		de,16				; on le decalge de 16px vers le bas pour qu'il touche le sol
		add		hl,de
		ld		(SPRH13_Y),hl
		ld		(SPRH12_Y),hl
		ld		a,ZOOM_mode_1
		ld		(SPRH12_ZOOM),a
		ld		(SPRH13_ZOOM),a
		xor		a
		ld		(SPRH14_ZOOM),a
		ld		(SPRH15_ZOOM),a
	automodif_bank_item2
		ld		c,bank_sprh_items
		call	rom_on
		ld		hl,(adr_item_sprh)
		ld		de,SPRH12_ADR
		ld		bc,#200
		LDIR
		call	rom_off
		ret
calcule_piece_items
		call	asic_off
		ld		a,(no_de_la_salle)			; on lit le numero de la salle actuelle
		ld		c,a							; on stock la salle actuelle dans reg C
		ld		hl,Tableau_items_piece		; on lit l'adr du Tableau_items_piece
		ld		b,60						; nombre de piece total
	boucle_calcule_piece_items
			ld		a,(no_de_la_salle)			; on lit le numero de la salle actuelle
			ld		c,a							; on stock la salle actuelle dans reg C
			ld		a,(hl)					; on lit l'octet contenu dans le tableau
			ld		e,a						; on le stock dans reg E
			ld		a,c						; on remet la salle dans reg A
			ld		c,e						; et l'octet du tableau dans reg C
			sub		a,c						; A - C (salle - octet)
			ret		z						; si on trouve une égalité c'est OK
			jp		c,aucun_item						; si on trouve un résultat négatif c'est que l'on a dépassé la ligne
			ld		de,12					
			add		hl,de
			push	af
			push	bc
			call	asic_off
			pop		bc
			pop		af	; sinon on va lire la ligne du dessous
			djnz	boucle_calcule_piece_items
			ret
		aucun_item
		ld		a,1
		ld		(init_afficher_item),a
		ret
Init_automodif_bank_item
	ld	a,bank_sprh_items2
	ld	(automodif_bank_item+1),a
	ld	(automodif_bank_item2+1),a
	jp	retour_Init_automodif_bank_item
retablir_automodif_bank_item
	ld	a,bank_sprh_items
	ld	(automodif_bank_item+1),a
	ld	(automodif_bank_item2+1),a
	jp	retour_Init_automodif_bank_item	


	