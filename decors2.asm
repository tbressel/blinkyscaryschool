on_affiche_le_decors
		ld		hl,(adresse_du_decors_en_rom)		; adrr de la salle de la maptile à afficher
		ld		de,depart_decors_ecran
		ld		c,bank_tilset_decors
		call 	rom_on								; je n'utilise pas HL ni DE dans rom_on
		ld		b,nombre_de_ligne_de_tile			; 20 ligne de 20 tiles de long
	on_affiche_20_lignes_de_tile_decors	
			push	bc		
			ld		b,nombre_de_tile_sur_une_ligne		; on répète 20 fois pour faire une ligne
		on_affiche_une_ligne_de_tile_decors
			push	bc
			push 	hl					; on sauvegarde le dernier endroit pointé dans la table
			push	de					; on sauvegarde le dernier endroit ecrit à l'écran
			call	calcule_tile_decors
			call	affiche_une_tile_decors
			pop		de					; on recupère le pointeur ecran
			pop		hl					; on recupère le pointeur de table
			inc		hl					; on pointe la tile suivante dans la table
			inc		hl
			inc		de
			inc		de
			inc		de
			inc		de					; les tiles font 4 octets de large, donc je vais pointer 2 octets plus loin
			pop		bc
			djnz	on_affiche_une_ligne_de_tile_decors
			pop		bc
			djnz	on_affiche_20_lignes_de_tile_decors	
			ret
		
		
		
	
			
calcule_tile_decors
	ld		a,(no_bank_maptile_deco)
	ld		c,a
	call	rom_on
							; les tiles font 2 octets de large sur 8 lignes de haut
							; donc elles font 16 octets de longueur
	push	de
	ld		a,(hl)			; je lit l'octet de poid faible dans la table de tiles du hud, dans A.
	ld		e,a				; je sauvegarde dans e
	inc		hl				; je passe à l'octet de poid fort
	ld		a,(hl)			; je le lit.
	ld		d,a				; je le met dans d.
	EX		hl,de			; on echange 
	
							; exemple :  si c'est une tiles no 27, sera 16*27 dans la mémoire.
							; donc 432. 27+27, 54+54, 108+108, 216+216
							
	
	call	test_no_du_tilset
							
	pop		de				; je récupère DE						
	add		hl,hl
	add		hl,hl
	add		hl,hl
	add		hl,hl
	add		hl,hl
	ld		bc,adresse_maptile_en_rom
	add		hl,bc			; l'adresse de la tile est dans HL
	ret
affiche_une_tile_decors
		ld		a,(no_de_bank_du_tileset)
		ld		c,a
		call 	rom_on
		ld		b,hauteur_dune_tile
		boucle_afficher_une_tile_decors
			push	bc
			push	de
			ldi							
			ldi
			ldi							
			ldi
			pop		de
			call	LIGNE_INFERIEUR
			pop		bc
			djnz	boucle_afficher_une_tile_decors
			ret




test_no_du_tilset
 ex		hl,de		; le numero de la tile est dans DE				
 ld		hl,499
 sbc	hl,de		; dès que çà dépasse 499 le flag C est mis à 1
 JP		nc,tileset_no1
 or		a
 jp		tileset_no2

tileset_no1
 ld	a,bank_tilset_decors
 ld	(no_de_bank_du_tileset),a
 ex	hl,de
 ret
tileset_no2
 ld		a,bank_tilset_decors2
 ld		(no_de_bank_du_tileset),a
 ex	 	hl,de
 ld		de,500
 sbc	hl,de
 ret


