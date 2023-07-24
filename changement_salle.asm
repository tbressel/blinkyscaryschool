on_change_de_piece
	
	ld		a,(etat_blinky_en_cours)
	cp		a,va_a_droite
	
	jp		z,vers_la_piece_droite
	cp		a,va_a_gauche
	jp		z,vers_la_piece_gauche

vers_la_piece_droite
	ld		a,(no_bank_maptile_deco)
	ld		c,a
	call	rom_on
	ld		hl,(adr_piece_actuelle)				; l'adresse cible de la 1ere tile
	ld		de,-10								; 10 octet en arrière on a le n° de la bank
	add		hl,de
	ld		a,(hl)								; on lit l'octet contenu à l'adresse HL
	ld		(no_bank_maptile_deco),a				; on sauvegarde la nouvelle bank à lire
	dec		hl									; on recule sur le poid fort
	ld		a,(hl)
	ld		d,a									; on le met dans D
	dec		hl									; on recule sur le poid faible
	ld		a,(hl)		
	ld		e,a									; on le met dans E
	ex		de,hl								; le resultat est dans DE donc on inverse pour le mettre dans HL
	
	push	hl
	ld		a,(no_bank_maptile_deco)
	ld		c,a
	call	rom_on
	pop		hl
		
	ld		a,(hl)
	ld		(no_de_la_salle),a
	
	
	ld		de,18								; on avance de 18 octet pour être sur la première tile. 
	add		hl,de
	ld		(adr_piece_actuelle),hl				; hl contient la nouvelle adresse de la pièce a afficher
	ld		(adresse_du_decors_en_rom),hl
	
	
	ld		hl,#0000
	ld		(pos_X_blinky),hl
	ld		(pos_X_blinky_debut_tableau),hl
	
	ld		hl,(pos_Y_blinky)
	ld		(pos_Y_blinky_debut_tableau),hl
	
	call	update_position_X_de_blinky
	
	ld		hl,(animation_blinky_en_cours)
	ld		(animation_blinky_en_cours),hl
	ld		(animation_blinky_saute),hl
	ld		a,3
	ld		(vitesse_animation_blinky),a
	call	on_efface_les_events
	jp			NOUVELLE_PIECE



vers_la_piece_gauche
	ld		a,(no_bank_maptile_deco)
	ld		c,a				; on se connect à la maptile actuelle
	call	rom_on
	ld		hl,(adr_piece_actuelle)				; l'adresse cible de la 1ere tile
	ld		de,-14								; 10 octet en arrière on a le n° de la bank
	add		hl,de
	ld		a,(hl)								; on lit l'octet contenu à l'adresse HL
	ld		(no_bank_maptile_deco),a				; on sauvegarde la nouvelle bank à lire
	dec		hl									; on recule sur le poid fort
	ld		a,(hl)
	ld		d,a									; on le met dans D
	dec		hl									; on recule sur le poid faible
	ld		a,(hl)		
	ld		e,a									; on le met dans E
	ex		de,hl								; le resultat est dans DE donc on inverse pour le mettre dans HL
	
	push	hl
	ld		a,(no_bank_maptile_deco)
	ld		c,a
	call	rom_on
	pop		hl
	
	ld		a,(hl)
	ld		(no_de_la_salle),a
	
	
	ld		de,18								; on avance de 18 octet pour être sur la première tile. 
	add		hl,de
	ld		(adr_piece_actuelle),hl				; hl contient la nouvelle adresse de la pièce a afficher
	ld		(adresse_du_decors_en_rom),hl
	
	
	
	ld		a,(no_de_la_salle)
	cp		a,86
	jp		z,xy_blinky_salle_86
	
	ld		hl,#023C
	ld		(pos_X_blinky),hl
	ld		(pos_X_blinky_debut_tableau),hl
	ld		hl,(pos_Y_blinky)
	ld		(pos_Y_blinky_debut_tableau),hl
retour_xy_blinky_salle_86
	call	update_position_X_de_blinky

	
	
	ld		hl,(animation_blinky_en_cours)
	ld		(animation_blinky_en_cours),hl
	ld		(animation_blinky_saute),hl
	ld		a,3
	ld		(vitesse_animation_blinky),a
	
	call	on_efface_les_events
	jp			NOUVELLE_PIECE
xy_blinky_salle_86
	ld		hl,#0144
	ld		(pos_X_blinky),hl
	ld		(pos_X_blinky_debut_tableau),hl
	ld		hl,#60
	ld		(pos_Y_blinky_debut_tableau),hl
	jp		retour_xy_blinky_salle_86





vers_la_piece_haut
ld		a,(no_bank_maptile_deco)
	ld		c,a				; on se connect à la maptile actuelle
	call	rom_on
	ld		hl,(adr_piece_actuelle)				; l'adresse cible de la 1ere tile de la salle en cours
	ld		de,-6								; 7 octet en arrière on a le n° de la bank
	add		hl,de
	ld		a,(hl)								; on lit l'octet contenu à l'adresse HL
	ld		(no_bank_maptile_deco),a				; on sauvegarde la nouvelle bank à lire
	dec		hl									; on recule sur le poid fort
	ld		a,(hl)
	ld		d,a									; on le met dans D
	dec		hl									; on recule sur le poid faible
	ld		a,(hl)		
	ld		e,a									; on le met dans E
	ex		de,hl								; le resultat est dans DE donc on inverse pour le mettre dans HL
	push	hl
	push	de
	
	ld		a,(no_bank_maptile_deco)
	ld		c,a									; on se connect à la maptile actuelle
	call	rom_on

	pop		de
	pop		hl
	
	
	push	hl
	ld		a,(no_bank_maptile_deco)
	ld		c,a
	call	rom_on
	pop		hl
	ld		a,(hl)
	ld		(no_de_la_salle),a
	
	ld		de,18								; on avance de 18 octet pour être sur la première tile. 
	add		hl,de
	ld		(adr_piece_actuelle),hl				; hl contient la nouvelle adresse de la pièce a afficher
	ld		(adresse_du_decors_en_rom),hl
	
	
	ld		hl,(posY_blinky_bas)
	ld		(pos_Y_blinky),hl
	ld		(pos_Y_blinky_debut_tableau),hl
	ld		hl,(pos_X_blinky)
	ld		(pos_X_blinky_debut_tableau),hl
	
	call	update_position_Y_de_blinky
	
	
	
	ld		hl,(animation_blinky_en_cours)
	ld		(animation_blinky_en_cours),hl
	ld		(animation_blinky_saute),hl
	ld		a,3
	ld		(vitesse_animation_blinky),a
	
	call	on_efface_les_events
	jp			NOUVELLE_PIECE
	
vers_la_piece_bas
	ld		a,(no_bank_maptile_deco)
	ld		c,a				; on se connect à la maptile actuelle
	call	rom_on
	ld		hl,(adr_piece_actuelle)				; l'adresse cible de la 1ere tile de la salle en cours
	ld		de,-2								; 7 octet en arrière on a le n° de la bank
	add		hl,de
	ld		a,(hl)								; on lit l'octet contenu à l'adresse HL
	ld		(no_bank_maptile_deco),a				; on sauvegarde la nouvelle bank à lire
	dec		hl									; on recule sur le poid fort
	ld		a,(hl)
	ld		d,a									; on le met dans D
	dec		hl									; on recule sur le poid faible
	ld		a,(hl)		
	ld		e,a									; on le met dans E
	ex		de,hl								; le resultat est dans DE donc on inverse pour le mettre dans HL
	push	hl
	push	de
	
	ld		a,(no_bank_maptile_deco)
	ld		c,a									; on se connect à la maptile actuelle
	call	rom_on

	pop		de
	pop		hl
	
	push	hl
	ld		a,(no_bank_maptile_deco)
	ld		c,a
	call	rom_on
	pop		hl
	
	ld		a,(hl)
	ld		(no_de_la_salle),a
	
	
	ld		de,18								; on avance de 18 octet pour être sur la première tile. 
	add		hl,de
	ld		(adr_piece_actuelle),hl				; hl contient la nouvelle adresse de la pièce a afficher
	ld		(adresse_du_decors_en_rom),hl
	
	
	ld		hl,(posY_blinky_haut)
	ld		(pos_Y_blinky),hl
	ld		(pos_Y_blinky_debut_tableau),hl
	ld		hl,(pos_X_blinky)
	ld		(pos_X_blinky_debut_tableau),hl
	call	update_position_Y_de_blinky
	
	
	ld		hl,(animation_blinky_en_cours)
	ld		(animation_blinky_en_cours),hl
	ld		(animation_blinky_saute),hl
	ld		a,3
	ld		(vitesse_animation_blinky),a
	
	call	on_efface_les_events
	jp			NOUVELLE_PIECE
	
on_efface_les_events
	ld		c,bank_programme_rom
	call	rom_on
	call	on_efface_les_events_ROM_bank3
	call	rom_off
	ret
	
	
test_lumiere
	ld		hl,tbl_salle_eteind
	ld		a,(no_de_la_salle)
	ld		b,a
	boucle_test_eteind
	ld		a,(hl)
	cp		a,b
	jp		z,on_eteind
	cp		a,#FF
	jp		z,test_lumiere_allume
	inc		hl
	jp		boucle_test_eteind
	test_lumiere_allume
	ld		hl,tbl_salle_allume
	ld		a,(no_de_la_salle)
	ld		b,a
	boucle_test_allume
	ld		a,(hl)
	cp		a,b
	jp		z,on_allume
	cp		a,#FF
	jp		z,fin_test_salle
	inc		hl
	jp		boucle_test_allume
	
tbl_salle_eteind
DB	25,26,27,28,70,71,76,77,78,79,94,95,96,97,103,104,105,108,109,111,112,113,114,115,#FF
tbl_salle_allume
DB	1,5,74,75,82,10,15,30,93,99,101,106,#FF	
	
	
fin_test_salle


	ld		hl,pallette_decors_ram
	ld		(pallette_en_cours_decors),hl
	ld		hl,pallette_hud_ram
	ld		(pallette_en_cours_hud),hl
	ld		a,ZOOM_mode_1
	ld		(SPRH0_ZOOM),a
	ld		(SPRH1_ZOOM),a
	ld		(SPRH2_ZOOM),a
	ld		(SPRH3_ZOOM),a
ret




on_allume
; on désactive Fire B
	ld		a,#ca					; JP  z
	ld		(fire2_jpz),a			; on rétablie la possibilité de faire fire B quand on intègre une pièce allumé
	ld		hl,inventaire			; sinon à la prise d'un parchemein la palette change et la pièce reste allumé
	ld		(fire2_jpz+1),hl
	
	ld		a,(flag_blinky_est_dans_leau)
	cp		a,1
	call 	z,automodif_bank_sprite_eau
	ld		a,(flag_blinky_est_dans_leau)
	cp		a,0
	call	z,automodif_retablir_bank_sprite_eau

	ld	a,(etat_blinky_en_cours)
	cp	a,va_a_droite
	jp	z,on_allume_droite
	cp	a,va_a_gauche
	jp	z,on_allume_gauche
	

on_allume_droite
	ld		hl,blinky_sprh_1_droite_ROM
	ld		(blinky_droite_adr),hl
	jp		on_allume_droite_ou_gauche
on_allume_gauche
	ld		hl,blinky_sprh_1_gauche_ROM
	ld		(blinky_gauche_adr),hl		; endroit où sont les sprh de blinky
	jp		on_allume_droite_ou_gauche
	
on_allume_droite_ou_gauche
	ld		(animation_blinky_en_cours),hl
	ld		(animation_blinky_saute),hl
	ld		a,ZOOM_mode_1
	ld		(SPRH0_ZOOM),a
	ld		(SPRH1_ZOOM),a
	ld		(SPRH2_ZOOM),a
	ld		(SPRH3_ZOOM),a
	ld		a,1
	ld		(flag_lumiere),a
	ld		hl,pallette_decors_ram
	ld		(pallette_en_cours_decors),hl
	ld		hl,pallette_hud_ram
	ld		(pallette_en_cours_hud),hl
	
	ld		hl,#400
	ld		(longueur_du_sprh),hl
automodif_bank	
	ld		a,bank_sprh_blinky
	ld		(no_bank_sprh_blinky),a
	
	ld		a,(no_bank_sprh_blinky)
	ld		c,a
	
	call	rom_on
	ld		hl,(animation_blinky_en_cours)
	ld		de,SPRH0_ADR
	ld		BC,(longueur_du_sprh)
	LDIR
	call	rom_off
	ret
automodif_bank_sprite_eau
ld	a,bank_sprh_blinky2
ld	(automodif_bank+1),a
ret
automodif_retablir_bank_sprite_eau
ld	a,bank_sprh_blinky
ld	(automodif_bank+1),a
ret

	
	
on_meurt
ld		a,(flag_lumiere)
cp		a,0
jp		z,blinky_perd_une_vie_piege



	
on_eteind
; on ré-active Fire B
	xor		a						; on empeche l'utilisateur de faire fire B
	ld		(fire2_jpz),a			; afin d'éviter qu'il ramasse quand meme les objets dans une pièce éteinte
	ld		(fire2_jpz+1),a
	ld		(fire2_jpz+2),a

ld		a,(item_ID_1)
cp		a,3
jp		z,on_allume
ld		a,(item_ID_2)
cp		a,3
jp		z,on_allume
ld		a,(item_ID_3)
cp		a,3
jp		z,on_allume

		ld		a,ZOOM_mode_1
		ld		(SPRH0_ZOOM),a
		
		xor		a
		ld		(flag_lumiere),a
		ld		(SPRH1_ZOOM),a
		ld		(SPRH2_ZOOM),a
		ld		(SPRH3_ZOOM),a
		ld		(SPRH4_ZOOM),a
		ld		(SPRH5_ZOOM),a
		ld		(SPRH6_ZOOM),a
		ld		(SPRH7_ZOOM),a
		ld		(SPRH8_ZOOM),a
		ld		(SPRH9_ZOOM),a
		ld		(SPRH10_ZOOM),a
		ld		(SPRH11_ZOOM),a
		ld		(SPRH12_ZOOM),a
		ld		(SPRH13_ZOOM),a
		ld		(SPRH14_ZOOM),a
		ld		(SPRH15_ZOOM),a
		
		ld		hl,pallette_noire
		ld		(pallette_en_cours_decors),hl
	
		ld		a,(etat_blinky_en_cours)
		cp		a,va_a_droite
		jp		z,affiche_yeux_droite
		cp		a,va_a_gauche
		jp		z,affiche_yeux_gauche
	affiche_yeux_droite
			ld		a,bank_sprh_blinky2
			ld		(no_bank_sprh_blinky),a
			ld		hl,#F000					; sprite des yeux à gauche
			ld		(blinky_droite_adr),hl
			ld		(animation_blinky_en_cours),hl
			ld		hl,#100
			ld		(longueur_du_sprh),hl
			
			
			ld		c,a
			call	rom_on
			ld		hl,(animation_blinky_en_cours)
			ld		de,SPRH0_ADR
			ld		bc,(longueur_du_sprh)
			LDIR
			call	rom_off
			ret
	affiche_yeux_gauche
			ld		a,bank_sprh_blinky2
			ld		(no_bank_sprh_blinky),a
			ld		hl,#F300					; sprite des yeux à gauche
			ld		(blinky_gauche_adr),hl
			ld		(animation_blinky_en_cours),hl
			ld		hl,#100
			ld		(longueur_du_sprh),hl
			ld		c,bank_sprh_blinky2
			call	rom_on
			ld		hl,(animation_blinky_en_cours)
			ld		de,SPRH0_ADR
			ld		bc,(longueur_du_sprh)
			ldir
			call	rom_off
			ret


