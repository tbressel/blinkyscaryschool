inventaire
	call	collision_avec_les_items
	ld		a,(flag_on_touche_un_item)
	or		a
	jp		z,retour_avant_test_fire
; on test si c'est un parchemin
	ld		a,(id_item)
	or		a
	jp		z,on_affiche_le_parchemin
; on test si l'inventaire à une case de libre
	ld		a,(flag_item_case_3)
	or		a
	jp		nz,inventaire_est_plein
	ld		a,(flag_item_case_2)
	or		a
	jp		nz,destination_items_case_3	
	ld		a,(flag_item_case_1)
	or		a
	jp		nz,destination_items_case_2
	jp		destination_items_case_1	
inventaire_est_plein
	ld 		a,(timing_fire_2)
	inc		a
	ld		(timing_fire_2),a
	cp		#10
	jp		nz,retour_avant_test_fire
; test pour empecher l'objet partit d'arriver dans le hud et en variable
	call	calcule_piece_items				; on va lire la ligne de la piece en cours
	ld		(pointeur_tableau_item),hl		; le resltat est en reg HL
	inc hl : inc hl : inc hl
	ld		a,(hl)
	push	af
	call	asic_on
	pop		af
	or		a								
	jp		z,retour_avant_test_fire
	dec	hl :dec	hl :dec	hl
	ld		c,bank_programme_rom
	call	rom_on
	call	inventaire_est_plein_ROM_bank3
	call	rom_off
	call	affichage_objet					; on positionne l'item dans la map
		
			; on va décaler les objets dans	le tableau de l'inventaire
			ld		hl,Objet2
			ld		de,Objet1
			LDI : LDI : LDI : LDI : LDI
			ld		hl,Objet3
			ld		de,Objet2
			LDI : LDI : LDI : LDI : LDI
			ld		hl,Objet_en_plus
			ld		de,Objet3
			LDI : LDI : LDI : LDI : LDI
			
		
			
			; on va décaler les objets dans	le hud
			ld		c,bank_gfx_hud : call	rom_on					; connexion à la bank des sprites items
			ld		a,6 : ld  	(largeur_animation),a	; ocets de large du sprite
			ld		hl,(item_hud_3)					; adresse du sprites en ROM	
			ld		de,Emplacement3_adr					; adresse du sprites à l'écran
			ld		b,24								; hauteur du sprite
			call	affichage_de_l_animation			; on l'affiche
			
			ld		hl,(item_hud_2)					; adresse du sprites en ROM	
			ld		de,Emplacement2_adr					; adresse du sprites à l'écran
			ld		b,24								; hauteur du sprite
			call	affichage_de_l_animation			; on l'affiche
			
			ld		hl,(item_hud_1)					; adresse du sprites en ROM	
			ld		de,Emplacement1_adr					; adresse du sprites à l'écran
			ld		b,24								; hauteur du sprite
			call	affichage_de_l_animation			; on l'affiche
			call	rom_off
			xor		a
			ld		(timing_fire_2),a

			ld		a,(item_ID_3)						; il est en notre possession
			ld		hl,Flag_des_items
			ld		e,a
			ld		d,0
			add		hl,de
			ld		a,1
			ld		(hl),a
			
			ld		a,(item_ID_1)
			ld		(Item_ID_pour_chaudron),a
			ld		a,(item_ID_2)
			ld		(Item_ID_pour_chaudron+1),a
			ld		a,(item_ID_3)
			ld		(Item_ID_pour_chaudron+2),a
			
			
			ld		hl,DMA_LIST_2
			ld		(#6C00),hl
			ld		a,1
			ld		(#6C0F),a
			jp		retour_avant_test_fire

		destination_items_case_3
			; test pour empecher l'objet partit d'arriver dans le hud et en variable
			call	calcule_piece_items				; on va lire la ligne de la piece en cours
			ld		(pointeur_tableau_item),hl		; le resltat est en reg HL
			inc hl : inc hl : inc hl
			ld		a,(hl)
			push	af
			call	asic_on
			pop		af
			or		a							
			jp		z,retour_avant_test_fire
			dec	hl :dec	hl :dec	hl
		
			
			ld		c,bank_gfx_hud : call	rom_on					; connexion à la bank des sprites items
			ld		a,6 : ld  	(largeur_animation),a	; ocets de large du sprite
			ld		hl,(adr_item_hud)					; adresse du sprites en ROM	
			ld		de,Emplacement3_adr					; adresse du sprites à l'écran
			ld		b,24								; hauteur du sprite
			call	affichage_de_l_animation			; on l'affiche
			call	rom_off
			
			
			ld		c,bank_programme_rom
			call	rom_on
			call	destination_items_case_3_ROM_bank3
			call	rom_off
				
			
			ld		hl,DMA_LIST_2
			ld		(#6C00),hl
			ld		a,1
			ld		(#6C0F),a
			jp	retour_avant_test_fire

		destination_items_case_2
			; test pour empecher l'objet partit d'arriver dans le hud et en variable
			call	calcule_piece_items				; on va lire la ligne de la piece en cours
			ld		(pointeur_tableau_item),hl		; le resltat est en reg HL
			inc hl : inc hl : inc hl
			ld		a,(hl)
			push	af
			call	asic_on
			pop		af
			or		a								
			jp		z,retour_avant_test_fire
			dec	hl :dec	hl :dec	hl
		
			ld		c,bank_gfx_hud : call	rom_on					; connexion à la bank des sprites items
			ld		a,6 : ld  	(largeur_animation),a	; ocets de large du sprite
			ld		hl,(adr_item_hud)					; adresse du sprites en ROM	
			ld		de,Emplacement2_adr					; adresse du sprites à l'écran
			ld		b,24								; hauteur du sprite
			call	affichage_de_l_animation			; on l'affiche
			call	rom_off
			
			
			ld		c,bank_programme_rom
			call	rom_on
			call	destination_items_case_2_ROM_bank3
			call	rom_off
			
			
			
			ld		hl,DMA_LIST_2
			ld		(#6C00),hl
			ld		a,1
			ld		(#6C0F),a
			jp	retour_avant_test_fire

		destination_items_case_1
		; test pour empecher l'objet partit d'arriver dans le hud et en variable
			call	calcule_piece_items				; on va lire la ligne de la piece en cours
			ld		(pointeur_tableau_item),hl		; le resltat est en reg HL
			inc hl : inc hl : inc hl
			ld		a,(hl)
			push	af
			call	asic_on
			pop		af
			or		a								
			jp		z,retour_avant_test_fire
			dec	hl :dec	hl :dec	hl
		
			ld		c,bank_gfx_hud : call	rom_on					; connexion à la bank des sprites items
			ld		a,6 : ld  	(largeur_animation),a	; ocets de large du sprite
			ld		hl,(adr_item_hud)					; adresse du sprites en ROM	
			ld		de,Emplacement1_adr					; adresse du sprites à l'écran
			ld		b,24								; hauteur du sprite
			call	affichage_de_l_animation			; on l'affiche
			call	rom_off
			
			ld		c,bank_programme_rom
			call	rom_on
			call	destination_items_case_1_ROM_bank3
			call	rom_off
			
			ld		hl,DMA_LIST_2
			ld		(#6C00),hl
			ld		a,1
			ld		(#6C0F),a
			jp	retour_avant_test_fire


on_affiche_le_parchemin
	ld		c,bank_programme_rom
	call	rom_on
	call	on_affiche_le_parchemin_ROM
	call	rom_off
	ld		hl,depart_scr_parchemin
	ld		de,depart_asic_parchemin
	ld		b,hauteur_parch_haut+hauteur_parch_bas
		boucle_sauver_decors
					push	bc
					push	hl
					ld		bc,largeur_parchemin
					ldir
					pop		hl
					ex		de,hl
					call	LIGNE_INFERIEUR
					ex		de,hl
					pop		bc
					djnz	boucle_sauver_decors
	call	asic_on
; on affiche le parchemin depuis la rom
	ld		c,bank_parchemin
	call	rom_on
	ld		hl,parchemin_rom
	ld		de,depart_scr_parchemin
	ld		bc,largeur_parchemin
	ld		(largeur_des_parchemins),bc
	ld		b,hauteur_parch_haut
	call	boucle_du_parchemin
		
	ld		hl,parchemin_rom2

	ld		b,hauteur_parch_bas
	call	boucle_du_parchemin
	call	asic_off
	call	test_texte_parchemin
	

	call	asic_on
	call	rom_off	
	jp	boucle_parchemin

boucle_du_parchemin
					push	bc
					push	de
					ld		bc,(largeur_des_parchemins)
					ldir
					pop		de
					call	LIGNE_INFERIEUR
					pop		bc
					djnz	boucle_du_parchemin
					ret


	Liste_inventaire_en_cours
Objet1
	item_sprh_1		dw	RIEN_SPRH
	item_hud_1		dw	RIEN_HUD
	item_ID_1		ds	1,0
Objet2
	item_sprh_2		dw	RIEN_SPRH
	item_hud_2		dw	RIEN_HUD
	item_ID_2		ds	1,0
Objet3
	item_sprh_3		dw	RIEN_SPRH
	item_hud_3		dw	RIEN_HUD
	item_ID_3		ds	1,0
Objet_en_plus		dw	RIEN_SPRH
					ds	3,0
Objet_absent		dw	RIEN_SPRH
					dw	RIEN_HUD
					ds	1,0
Tableau_item_en_cours
adr_item_sprh		ds		2,0
adr_item_hud		ds		2,0
id_item				ds		1,0
pos_X_item			ds		2,0
pos_Y_item			ds		2,0	
taille_item			ds		2,0


Flag_des_items			
flag_parchamin			ds		1,0
flag_sac_de_ble			ds		1,0
flag_pq					ds		1,0
flag_lampe_torche		ds		1,0
flag_pot_de_confiture	ds		1,0
flag_poisson			ds		1,0
flag_verre_de_soda		ds		1,0
flag_cassette			ds		1,0
flag_elixir_vert		ds		1,0






