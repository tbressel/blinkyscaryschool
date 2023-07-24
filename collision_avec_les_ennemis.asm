; /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
; /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
; //////////////////////////////////////////////// COLLISION MONSTRES /////////////////////////////////////////////////
; /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
; /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
collision_avec_blinky
		or a
	collision_X1
		LD		hl,(SPRH2_X)					; à partir du coin haut-gauche de Blinky
		LD		de,40
		add		hl,de							; 64 pixels plus loin on est sur le coin haut-droite
		LD		de,(sprh_x_ennemis)						; à partir du coin haut-gauche du monstre
		SBC		hl,de
		RET		C								; si hl>=de le flag C est à zero
	collision_X2
		LD		hl,(sprh_x_ennemis)						; à partir du coin haut-gauche du monstre
		LD		de,10
		add		hl,de							; 31 pixels plus loin on est sur le coin haut_droite
		LD		de,(SPRH2_X)					; à partir du coin haut-gauche de link
		SBC		hl,de
		RET		C
						; si hl>=de le flag C est à zero

	collision_Y1
		LD		hl,(SPRH0_Y)					; à partir du coin haut-gauche de link
		LD		de,20
		add		hl,de							; 15 pixels plus loin (sinon Golem va me faire un caca nerveu si j'écrit 16) 
											; on est sur le coin haut-droite
		LD		de,(sprh_y_ennemis)						; à partir du coin haut-gauche du monstre
		SBC		hl,de
		RET 	C								; si hl>=de le flag C est à zero
	
	collision_Y2
		LD		hl,(sprh_y_ennemis)						; à partir du coin haut-gauche de link
		LD		de,5
		add		hl,de							; 15 pixels plus loin (sinon Golem va me faire un caca nerveu si j'écrit 16) 
											; on est sur le coin haut-droite
		LD		de,(SPRH0_Y)					; à partir du coin haut-gauche du monstre
		SBC		hl,de
		JP 		NC,blinky_est_touche					; si hl>=de le flag C est à zero
	
		RET



blinky_est_touche
	ld		a,(flag_ennemis_mortel)
	or		a
	jp		nz,blinky_perd_une_vie_piege
	
	call	asic_off
	call	diminuer_la_barre_energie
	call	asic_on
	
	ld		hl,DMA_LIST_1
	ld		(#6C00),hl
	ld		a,1
	ld		(#6C0F),a
	ret

blinky_perd_une_vie
	
	call	asic_on
	pop		iy
	pop		iy
	pop		iy
	pop		iy
	jr		blinky_perd_une_vie_suite
blinky_perd_une_vie_piege
	ld	a,1
	ld	(flag_ennemis_mortel),a
	blinky_perd_une_vie_suite

	ld		a,(nbr_de_vie)
	dec		a
	ld		(nbr_de_vie),a
	call	on_efface_les_events
	LD		a,ZOOM_mode_1
		ld		(SPRH0_ZOOM),a
		ld		(SPRH1_ZOOM),a
		ld		(SPRH2_ZOOM),a
		ld		(SPRH3_ZOOM),a
	
	call	event_gameover_creer
	
	ld		C,bank_sample2								; sélèction de la banque contenant
	call	rom_on
	ld		hl,#C000
	ld		de,DMA_LIST_4				; adresse de départ du player en RAM 
	ld		bc,LONGUEUR_DMALIST4						 
	ldir
	call	rom_off
	ld		hl,DMA_LIST_4
	call	set_DMA
	ld		hl,DMA_LIST_4
	ld		(#6C00),hl
	ld		a,1
	ld		(#6C0F),a
	pop		iy


	jp		gameover

blinky_meurt
	ret

gameover
ld		a,1
ld		(flag_reboot),a
call	anim_blinky_meurt

jp	retour_gameover


teleportation
call	anim_blinky_meurt
jp	retour_gameover

fin_du_jeu
	call	asic_on
	; on affiche le petit parchemin depuis la rom
	ld		a,(le_temps_passe_decompte)
	cp		a,0
	call	z,init_text_time_out
	xor		a
	ld		(SPRH0_ZOOM),a
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
	ld		hl,pallette_parchemin
	ld		(pallette_en_cours_decors),hl
	call	asic_on
	ld		c,bank_parchemin
	call	rom_on
	ld		hl,petit_parchemin_rom
	ld		de,depart_scr_petit_parchemin
	ld		bc,largeur_petit_parchemin
	ld		(largeur_des_parchemins),bc
	ld		b,hauteur_petit_parchemin
	call	boucle_du_parchemin
	

	call	asic_off
	call	rom_off
	ld		a,1
	ld		(flag_reboot),a
	ld		a,12
	ld		(nbr_de_lettre),a
	ld		a,2						; il y a 6 ligne de texte à afficher
	ld		(nbr_ligne_texte),a			; on les stock dans la variable
	ld		b,a							; on envoie dans B qui sera le compteur
automodif_texte_gameover
	ld		de,TEXTE_GAMEOVER			; l'adresse du texte
	ld		(adr_ligne_de_texte),de		; on le stock dans la variable
	ld		hl,#C394					; adresse ECRAN du texte
	ld		(adr_depart_texte),hl		; on stock dans la variable	
	call	boucle_texte_parchemin		; on affiche !	
jp	boucle_principale

init_text_time_out
ld		de,TEXTE_TIMEOUT
ld		a,e
ld		(automodif_texte_gameover+1),a
ld		a,d
ld		(automodif_texte_gameover+2),a
event_gameover_creer
	
	ld		a,#C3
	ld		hl,gameover
	ld		(event_gameover),a
	ld		(event_gameover+1),hl
	ld		a,#C3
	ld		hl,BOUCLE_PRINCIPALE
	ld		(event_boucle_gameover),a
	ld		(event_boucle_gameover+1),hl
ret



