blinky
	ld		a,(etape_anim_blinky)
	cp		0
	jr		z,init_blinky
	cp		1
	jp		z,animations
	cp		2
	jp		z,init_blinky_dans_leau
	cp		3
	jp		z,init_blinky_sur_terre
	ret
; ///////////////////////////////////////////////////////////////////////////////////
; ///////////////////////////////////////////////////////////////////////////////////
; //////////////////       INITIALISATION DE BLINKY                        //////////
; ///////////////////////////////////////////////////////////////////////////////////
; ///////////////////////////////////////////////////////////////////////////////////
init_blinky
	ld		a,1
	ld		(etape_anim_blinky),a

	call	update_position_X_de_blinky			; on met blinky là
	call	update_position_Y_de_blinky			; et là

	ld		c,bank_sprh_blinky					; on choisit le no de bank
	call	rom_on								; on connecte la bank
	ld		hl,blinky_sprh_1_saut_droite_ROM
	ld		(animation_blinky_saute),hl
	ld		hl,#400
	ld		(longueur_du_sprh),hl
	ld		hl,(animation_blinky_en_cours)		; endroit où sont les sprh de blinky

	ld		de,SPRH0_ADR						; destination ASIC
	ld		bc,(longueur_du_sprh)							; on choisit 4 sprites
	LDIR										; PAF on copie
	call	rom_off								; on deconnecte la ROM

	LD		hl,vitesse_X_deplacement_blinky
	ld		(vitesse_X_blinky),hl
	ret

; ///////////////////////////////////////////////////////////////////////////////////
; ///////////////////////////////////////////////////////////////////////////////////
; ////////////////////////////       DIRECTION GAUCHE          //////////////////////
; ///////////////////////////////////////////////////////////////////////////////////
; ///////////////////////////////////////////////////////////////////////////////////
gauche
	ld		a,(flag_on_plonge)
	or		a
	jp		nz,retour_avant_test_fire

	ld		a,(etat_blinky_en_cours)		;  on recupère la direction précédente
	cp		a,va_a_gauche
	jr 		z,on_continue_vers_la_gauche  	;et si c'était à 3 (donc gauche) on continu d'aller à gauche


init_blinky_gauche
	ld		a,(flag_saut_en_cours)
	or		a
	jp		nz,retour_avant_test_fire

	ld		a,va_a_gauche
	ld		(etat_blinky_en_cours),a

	ld		a,1
	ld		(no_animation_blinky),a

	ld		a,(flag_lumiere)
	or		a
	jr		z,on_init_lumiere_sprh_gauche



	ld		a,(no_bank_sprh_blinky)					; on choisit le no de bank
	ld		c,a
	call	rom_on								; on connecte la bank
	ld		hl,blinky_sprh_1_gauche_ROM			; endroit où sont les sprh de blinky
	ld		(blinky_gauche_adr),hl
	ld		(animation_blinky_en_cours),hl
	ld		(animation_blinky_saute),hl
	ld		de,SPRH0_ADR						; destination ASIC
	ld		bc,#400
	ld		(longueur_du_sprh),bc
	LDIR										; PAF on copie
	call	rom_off								; on deconnecte la ROM

	jr		on_continue_vers_la_gauche


on_init_lumiere_sprh_gauche
	ld		a,bank_sprh_blinky2				; on choisit le no de bank
	ld		c,a
	call	rom_on								; on connecte la bank
	ld		hl,#F300					; sprite des yeux à gauche
	ld		(blinky_gauche_adr),hl
	ld		(animation_blinky_en_cours),hl
	ld		(animation_blinky_saute),hl
	ld		bc,#100
	ld		(longueur_du_sprh),bc
	ld		de,SPRH0_ADR						; destination ASIC
	ld		bc,(longueur_du_sprh)								; on choisit 4 sprites
	LDIR										; PAF on copie
	call	rom_off								; on deconnecte la ROM

on_continue_vers_la_gauche
	ld		a,(flag_saut_en_cours)
	or		a
	jr		nz,on_deplace_blinky_gauche
	ld		a,(flag_on_tombe)
	or		a
	jr		nz,on_deplace_blinky_gauche
	ld		a,(vitesse_animation_blinky)
	dec		a
	ld		(vitesse_animation_blinky),a

on_deplace_blinky_gauche

; on déplace blinky
	ld		hl,(pos_X_blinky)
	ld		de,(vitesse_X_blinky)
	or		A
	sbc		hl,de
	ld		(pos_X_blinky),hl
	call	update_position_X_de_blinky

; test des collisions avec le décors
	call	collision_gauche
	ld		de,tile_plateforme
	ld		hl,(no_de_la_tile)
	sbc		hl,de
	call	nc,stop_blinky_gauche

	; test des collisions avec le bord de l'écran
	ld		hl,(SPRH3_X)
	ld		de,#0020
	sbc		hl,de
	jp		c,on_change_de_piece

	jp	retour_avant_test_fire

stop_blinky_gauche
	ld		hl,(pos_X_blinky)
	ld		de,(vitesse_X_blinky)
	add		hl,de
	ld		(pos_X_blinky),hl
	call	update_position_X_de_blinky


	ret

; ///////////////////////////////////////////////////////////////////////////////////
; ///////////////////////////////////////////////////////////////////////////////////
; ////////////////////////////       DIRECTION DROITE          //////////////////////
; ///////////////////////////////////////////////////////////////////////////////////
; ///////////////////////////////////////////////////////////////////////////////////
droite
	ld		a,(flag_on_plonge)
	or		a
	jp		nz,retour_avant_test_fire
	ld		a,(etat_blinky_en_cours)		;  on recupère la direction précédente
	cp		a,va_a_droite
	jr 		z,on_continue_vers_la_droite		; si c'était à 4 (donc droite) on continu d'aller à droite
init_blinky_droite
	ld		a,(flag_saut_en_cours)
	or		a
	jp		nz,retour_avant_test_fire

	ld		a,va_a_droite
	ld		(etat_blinky_en_cours),a

	ld		a,(flag_lumiere)
	or		a
	jr		z,on_init_lumiere_sprh_droite

	ld		a,(no_bank_sprh_blinky)					; on choisit le no de bank
	ld		c,a
	call	rom_on								; on connecte la bank
	ld		hl,blinky_sprh_1_droite_ROM			; endroit où sont les sprh de blinky
	ld		(blinky_droite_adr),hl
	ld		(animation_blinky_en_cours),hl
	ld		(animation_blinky_saute),hl
	ld		de,SPRH0_ADR						; destination ASIC
	ld		bc,#400
	ld		(longueur_du_sprh),bc
	LDIR										; PAF on copie
	call	rom_off								; on deconnecte la ROM

	jr		on_continue_vers_la_droite


on_init_lumiere_sprh_droite
	ld		a,bank_sprh_blinky2				; on choisit le no de bank
	ld		c,a
	call	rom_on
	ld		hl,#F000					; sprite des yeux à gauche
	ld		(blinky_droite_adr),hl
	ld		(animation_blinky_en_cours),hl
	ld		(animation_blinky_saute),hl
	ld		bc,#100
	ld		(longueur_du_sprh),bc
	ld		de,SPRH0_ADR						; destination ASIC
	ld		bc,(longueur_du_sprh)								; on choisit 4 sprites
	LDIR										; PAF on copie
	call	rom_off								; on deconnecte la ROM
on_continue_vers_la_droite
	ld		a,(flag_saut_en_cours)
	or		a
	jr		nz,on_deplace_blinky_droite

	ld		a,(flag_on_tombe)
	or		a
	jr		nz,on_deplace_blinky_droite

	ld		a,(vitesse_animation_blinky)
	dec		a
	ld		(vitesse_animation_blinky),a
on_deplace_blinky_droite
;on déplace blinky
	ld		hl,(pos_X_blinky)
	ld		de,(vitesse_X_blinky)
	add		hl,de
	ld		(pos_X_blinky),hl
	
; test collision pour la piece 25
automodif_collision25
	jr		on_zap_collision_piece25
	ld		hl,(SPRH2_X)
	ld		de,#020f
	sbc		hl,de
	call	nc,stop_blinky_droite
on_zap_collision_piece25
; test des collisions avec le décors
	call	collision_droite
	ld		de,tile_plateforme
	ld		hl,(no_de_la_tile)
	sbc		hl,de
	call	nc,stop_blinky_droite
	call	update_position_X_de_blinky
	

; test des collisions avec le bord de l'écran
	ld		hl,(SPRH2_X)
	ld		de,(adr_bord_droit)
	sbc		hl,de
	jp		nc,on_change_de_piece
	jp		retour_avant_test_fire

stop_blinky_droite
	ld		hl,(pos_X_blinky)
	ld		de,(vitesse_X_blinky)
	or		a
	sbc		hl,de
	ld		(pos_X_blinky),hl
	call	update_position_X_de_blinky
	ret
; ///////////////////////////////////////////////////////////////////////////////////
; ///////////////////////////////////////////////////////////////////////////////////
; ////////////////////////////         BLINKY SAUTE            //////////////////////
; ///////////////////////////////////////////////////////////////////////////////////
; ///////////////////////////////////////////////////////////////////////////////////
saut
	ld		a,(flag_on_tombe)					; on test voir si on tombe ou pas
	or		a									; si on tombe alors on ne peut pas sauter
	jp		nz,retour_test_de_touches			; on retourne dans la boucle pour tester les autre touches

	ld		a,(flag_saut_en_cours)				; on test voir si on est déjà en train de sauter
	or		a									; Si c'est oui
	jp		nz,on_continue_le_saut				; continu les calcule pour le saut a la frame suivante

	ld		a,(flag_blinky_est_dans_leau)		; est ce que Blinky est dans l'eau ?
	or		a									; Si c'est le cas
	jp		nz,test_si_on_sort_de_leau			; alors on test voir si c'est pour sortir de l'eau

init_blinky_saut								; si c'est non, alors on initialise le saut.
	; on vérifie que l'on a bien relaché la touche fire 1 en testant le bit 4
	ld		a,(switch_bouton_fire1)
	or		a
	jp		nz,retour_test_de_touches
	; ld		a,(bouton_fire1)
	; cp		a,1
	; jp		z,on_authorise_le_saut
on_authorise_le_saut
	ld		a,1
	ld		(no_animation_blinky),a					; on choisit la première animation
	ld		(switch_bouton_fire1),a
	ld		(flag_saut_en_cours),a					; on flag à 1 pour dire que le saut commence.
	ld		a,config_gravite_saut
	ld		(gravite_du_saut),a						; la gravité du saut est réglé à 1

	ld		a,(vitesse_du_saut_en_cours)			; on récupère la vitesse du saut en cours paramétré
													; dans initialisation_du_jeu.asm et constantes.asm (réglé à 8 par défaut)
	ld		(vitesse_du_saut),a						; init de la vitesse du saut transféré.
													; init de la valeur qui va freiner dans sa crête
	ld		hl,vitesse_X_saut_blinky
	ld		(vitesse_X_blinky),hl
	ld 		a,vitesse_animation_blinky_saute_cfg	; réglé à 4 par défaut dans contantes.asm
	ld		(vitesse_animation_blinky_saute),a

	ld		a,(flag_lumiere)						; ATTENTION : si on est dans une pièce noire on
	or		a										; on initialise un autre jeu de sprite
	jr		z,on_init_lumiere_sprh_saute			; ne contenant que les yeux de Blinky

	ld		c,bank_sprh_blinky					; on choisit le no de bank
	call	rom_on								; on connecte la bank
	ld		hl,(animation_blinky_saute)
	set		2,h									; en mettant les bits 2 et 4 à "1", c'est
	set		4,h									; comme si on additionnait #1F
	ld		(animation_blinky_saute),hl
	ld		(animation_blinky_en_cours),hl
	ld		de,SPRH0_ADR						; destination ASIC
	ld		bc,(longueur_du_sprh)								; on choisit 4 sprites
	LDIR										; PAF on copie
	call	rom_off		; on deconnecte la ROM
	ld		hl,DMA_LIST_3
	ld		(#6C00),hl
	ld		a,1
	ld		(#6C0F),a
	jr		on_continue_le_saut

on_init_lumiere_sprh_saute
	ld		c,bank_sprh_blinky2					; on choisit le no de bank
	call	rom_on								; on connecte la bank
	ld		hl,#F300
	ld		(animation_blinky_saute),hl
	ld		(animation_blinky_en_cours),hl
	ld		de,SPRH0_ADR						; destination ASIC
	ld		bc,(longueur_du_sprh)								; on choisit 4 sprites
	LDIR										; PAF on copie
	call	rom_off		; on deconnecte la ROM
	ld		hl,DMA_LIST_3
	ld		(#6C00),hl
	ld		a,1
	ld		(#6C0F),a

on_continue_le_saut
	ld		a,(vitesse_animation_blinky_saute)		; quand ca arrive à zero on change d'animation
	dec		a
	ld		(vitesse_animation_blinky_saute),a
	; on test le saut avec les murs (360) mais pas les plateformes (460)
	ld		a,(vitesse_du_saut)			;	on récupère la vitesse du saut
	ld		b,a							; 	on la déplace dans le reg B
	ld		hl,(pos_Y_blinky)			; 	on récupère la pox Y de Blinky sprh 0
	ld		a,l							;   on la déplace dans reg A
	sub		a,b							; 	Position - Vitesse du saut = nouvelle position Y de Blinky
	ld		l,a
	ld		(pos_Y_blinky),hl			; posistion Y de Blinky - la gravité
	
		
	ld		a,(vitesse_du_saut)				; si la vitesse du saut est positive on monte donc on test le haut
	bit		7,a								; le bit 7 est à zero quand on monte on ne zap pas
	jr		nz,on_zap_les_collisions_saut	; les collision du saut


	ld		hl,(SPRH0_Y)
	bit		7,l
	jp		nz,vers_la_piece_haut
	
		; si on heurte un mur avec le sprite 2
		call	collision_saut
		ld		de,tile_murs
		ld		hl,(no_de_la_tile)
		or		a
		sbc		hl,de
		jp		nc,stop_blinky_saut
	; si on heurte un mur avec le sprite 3
		call 	collision_saut_bis
		ld		de,tile_murs
		ld		hl,(no_de_la_tile)
		or		a
		sbc		hl,de
		jp		nc,stop_blinky_saut
		jr		mise_a_jour_blinky_saut
	; test des collisions avec le décors
on_zap_les_collisions_saut
	or		a
	ld		de,(SPRH2_Y)
	ld		hl,blinky_sort_ecran_bas
	sbc		hl,de
	jp		c,vers_la_piece_bas
	; avec le sprite 2
		call	collision_tombe
		ld		de,tile_plateforme
		ld		hl,(no_de_la_tile)
		or		a
		sbc		hl,de
		jr		nc,stop_blinky_retombe
	; avec le sprite 3
		call 	collision_tombe_bis
		ld		de,tile_plateforme
		ld		hl,(no_de_la_tile)
		or		a
		sbc		hl,de
		jr		nc,stop_blinky_retombe
	; avec une tile d'eau
		call	collision_tombe_eau
		ld		de,227
		ld		hl,(no_de_la_tile)
		sbc		hl,de
		jp		z,blinky_va_dans_leau

	on_zap_les_collisions_retombe

mise_a_jour_blinky_saut
	; si on heurte rien alors on met les coordonnée de blinky à jour
	call	update_position_Y_de_blinky
	; on calcule la prochaine vitesse pour la prochaine frame
	ld		a,(gravite_du_saut)
	ld		b,a
	ld		a,(vitesse_du_saut)
	sub		a,b
	ld		(vitesse_du_saut),a
	jp		retour_du_saut
stop_blinky_saut
	ld		a,(vitesse_du_saut)
	ld		b,a
	ld		hl,(pos_Y_blinky)
	ld		a,l
	add		a,b						; posistion Y de Blinky - la gravité
	ld		l,a
	res		0,a
	res		1,a
	res		2,a
	ld		(pos_Y_blinky),hl
	ld		a,1
	ld		(flag_on_tombe),a
	xor		a
	ld		(flag_saut_en_cours),a
	ld		hl,vitesse_X_deplacement_blinky
	ld		(vitesse_X_blinky),hl
	ld		a,(flag_lumiere)
	or		a
	jp		z,retour_tombe
	ld		hl,(animation_blinky_saute)
	res		2,h									; en mettant les bits 2 et 4 à "1", c'est
	res		4,h									; comme si on additionnait #1F
	ld		(animation_blinky_saute),hl
	ld		(animation_blinky_en_cours),hl
	jp		retour_tombe
stop_blinky_retombe
	ld		a,(vitesse_du_saut)
	ld		b,a
	ld		hl,(pos_Y_blinky)
	ld		a,l
	add		a,b						; posistion Y de Blinky - la gravité
	ld		l,a
	ld		(pos_Y_blinky),hl
	call	corriger_position_Y_de_blinky
	call	update_position_Y_de_blinky
	xor		a
	ld		(flag_on_tombe),a
	ld		(flag_saut_en_cours),a
	ld		hl,vitesse_X_deplacement_blinky
	ld		(vitesse_X_blinky),hl
	ld		a,(flag_lumiere)
	or		a
	jp		z,retour_tombe
	ld		c,bank_sprh_blinky					; on choisit le no de bank
	call	rom_on								; on connecte la bank
	ld		hl,(animation_blinky_saute)
	res		2,h									; en mettant les bits 2 et 4 à "1", c'est
	res		4,h									; comme si on additionnait #1F
	ld		(animation_blinky_saute),hl
	ld		(animation_blinky_en_cours),hl
	ld		de,SPRH0_ADR						; destination ASIC
	ld		bc,#400								; on choisit 4 sprites
	LDIR										; PAF on copie
	call	rom_off								; on deconnecte la ROM
	jp		retour_tombe





test_si_on_sort_de_leau
	ld		hl,(pos_Y_blinky)
	dec		l
	ld		(pos_Y_blinky),hl
	call	collision_haut_bis
	ld		hl,(no_de_la_tile)
	ld		de,070
	sbc		hl,de
	jp		z,blinky_sort_de_leau
	ld		hl,(pos_Y_blinky)
	inc		l
	ld		(pos_Y_blinky),hl
	jp		retour_test_de_touches




; ///////////////////////////////////////////////////////////////////////////////////
; ///////////////////////////////////////////////////////////////////////////////////
; ////////////////////////////        BLINKY TOMBE             //////////////////////
; ///////////////////////////////////////////////////////////////////////////////////
; ///////////////////////////////////////////////////////////////////////////////////
tombe
	ld		a,(flag_blinky_est_dans_leau)
	or		a
	jp		nz,retour_tombe
	ld		a,(flag_saut_en_cours)
	or		a
	jp		nz,on_continue_le_saut
; test des collisions avec le décors
	ld		de,(SPRH2_Y)
	ld		hl,blinky_sort_ecran_bas
	sbc		hl,de
	jp		c,vers_la_piece_bas
	ld		hl,(pos_Y_blinky)
	inc		l
	inc		l
	inc		l
	inc		l
	ld		(pos_Y_blinky),hl
	
	
	ld		a,(etat_blinky_en_cours)
	cp		a,va_a_droite
	jr		z,on_test_tombe_droite
	cp		a,va_a_gauche
	jr		z,on_test_tombe_gauche
on_test_tombe_droite	
	; avec une tile piege
		call	collision_tombe_droite
		ld		de,580
		ld		hl,(no_de_la_tile)
		sbc		hl,de
		jp		z,blinky_perd_une_vie_piege
	; avec une tile piege
		call	collision_tombe_droite
		ld		de,519
		ld		hl,(no_de_la_tile)
		sbc		hl,de
		jp		z,blinky_perd_une_vie_piege
		call	collision_tombe_droite
		ld		de,559
		ld		hl,(no_de_la_tile)
		sbc		hl,de
		jp		z,blinky_perd_une_vie_piege
		jr		on_zap_tombe_gauche
on_test_tombe_gauche		
			; avec une tile piege
		call	collision_tombe_gauche
		ld		de,580
		ld		hl,(no_de_la_tile)
		sbc		hl,de
		jp		z,blinky_perd_une_vie_piege
	; avec une tile piege
		call	collision_tombe_gauche
		ld		de,519
		ld		hl,(no_de_la_tile)
		sbc		hl,de
		jp		z,blinky_perd_une_vie_piege
		call	collision_tombe_gauche
		ld		de,559
		ld		hl,(no_de_la_tile)
		sbc		hl,de
		jp		z,blinky_perd_une_vie_piege
		call	collision_tombe_gauche
		ld		de,467
		ld		hl,(no_de_la_tile)
		sbc		hl,de
		call	z,blinky_a_gagne
		on_zap_tombe_gauche
		

ld		a,(flag_pq)
cp		a,0
jp		z,on_zap_collisions_WC

		; avec une tile WC
		call	collision_tombe
		ld		de,470
		ld		hl,(no_de_la_tile)
		sbc		hl,de
		jp		z,blinky_se_teleporte
		call	collision_tombe
		ld		de,471
		ld		hl,(no_de_la_tile)
		sbc		hl,de
		jp		z,blinky_se_teleporte
	on_zap_collisions_WC
	; test du chaudron
		call	collision_tombe
		ld		de,462
		ld		hl,(no_de_la_tile)
		sbc		hl,de
		jp		z,blinky_items_chaudron

	; avec le sprite 2
		call	collision_tombe
		ld		de,tile_plateforme
		ld		hl,(no_de_la_tile)
		sbc		hl,de
		jp		nc,stop_blinky_tombe
	; avec le sprite 3
		call 	collision_tombe_bis
		ld		de,tile_plateforme
		ld		hl,(no_de_la_tile)
		sbc		hl,de
		jp		nc,stop_blinky_tombe
	; avec une tile d'eau
		call	collision_tombe
		ld		de,227
		ld		hl,(no_de_la_tile)
		sbc		hl,de
		jp		z,blinky_va_dans_leau

ld		a,(flag_on_tombe)
or		a
jr		nz,on_continue_de_tomber
init_blinky_tombe
	ld		a,1
	ld		(flag_on_tombe),a

	ld		a,(flag_lumiere)
	or		a
	jr		z,init_blinky_tombe_lumiere


	ld		c,bank_sprh_blinky					; on choisit le no de bank
	call	rom_on								; on connecte la bank
	ld		hl,(animation_blinky_saute)
	set		2,h									; en mettant les bits 2 et 4 à "1", c'est
	set		4,h									; comme si on additionnait #1F
	ld		de,SPRH0_ADR						; destination ASIC
	ld		(animation_blinky_saute),hl
	ld		(animation_blinky_en_cours),hl
	ld		bc,#400								; on choisit 4 sprites
	LDIR										; PAF on copie
	call	rom_off								; on deconnecte la ROM
	jr		on_continue_de_tomber

init_blinky_tombe_lumiere
	ld		c,bank_sprh_blinky2					; on choisit le no de bank
	call	rom_on								; on connecte la bank
	ld		hl,#F300
	ld		de,SPRH0_ADR						; destination ASIC
	ld		(animation_blinky_saute),hl
	ld		(animation_blinky_en_cours),hl
	ld		bc,#100								; on choisit 4 sprites
	LDIR										; PAF on copie
	call	rom_off								; on deconnecte la ROM

on_continue_de_tomber
	call	update_position_Y_de_blinky
	jp	retour_tombe


stop_blinky_tombe
	ld		a,(flag_on_tombe)
	or		a
	jr		z,on_continue_de_stop_tomber

	ld		a,vitesse_saut_blinky
	ld		(vitesse_du_saut_en_cours),a

	ld		a,(flag_lumiere)
	or		a
	jr		z,on_continue_de_stop_tomber


	ld		c,bank_sprh_blinky					; on choisit le no de bank
	call	rom_on								; on connecte la bank
	ld		hl,(animation_blinky_saute)
	res		2,h									; en mettant les bits 2 et 4 à "1", c'est
	res		3,h
	res		4,h									; comme si on additionnait #1F
	ld		(animation_blinky_saute),hl
	ld		(animation_blinky_en_cours),hl
	ld		de,SPRH0_ADR						; destination ASIC
	ld		bc,#400								; on choisit 4 sprites
	LDIR										; PAF on copie
	call	rom_off								; on deconnecte la ROM





on_continue_de_stop_tomber
	xor		a
	ld		(flag_on_tombe),a
	ld		(flag_saut_en_cours),a
	ld		hl,(pos_Y_blinky)
	dec		l
	dec		l
	dec		l
	dec		l
	ld		(pos_Y_blinky),hl
	call	corriger_position_Y_de_blinky
	call	update_position_Y_de_blinky

	ld		hl,vitesse_X_deplacement_blinky
	ld		(vitesse_X_blinky),hl


	jp		retour_tombe

; ///////////////////////////////////////////////////////////////////////////////////
; ///////////////////////////////////////////////////////////////////////////////////
; ////////////////////////////        BLINKY COULE             //////////////////////
; ///////////////////////////////////////////////////////////////////////////////////
; ///////////////////////////////////////////////////////////////////////////////////
bas
	
; on déplace blinky vers le bas pour trouver des trappe easter eggs
	ld		hl,(pos_Y_blinky)
	inc		l
	ld		(pos_Y_blinky),hl
; test des collisions avec le décors
	ld		de,(SPRH0_Y)
	; ld		hl,blinky_sort_ecran_bas
	ld		hl,blinky_sort_ecran_bas_eau
	sbc		hl,de
	jp		c,vers_la_piece_bas
; avec le sprite 2
		call	collision_bas
		ld		de,tile_murs
		ld		hl,(no_de_la_tile)
		sbc		hl,de
		jr		nc,stop_blinky_bas
		call	update_position_Y_de_blinky
		jp		retour_direction
stop_blinky_bas
	ld		hl,(pos_Y_blinky)
	dec		l
	ld		(pos_Y_blinky),hl
	jp		retour_direction

; ///////////////////////////////////////////////////////////////////////////////////
; ///////////////////////////////////////////////////////////////////////////////////
; ////////////////////////////        BLINKY REMONTE             //////////////////////
; ///////////////////////////////////////////////////////////////////////////////////
; ///////////////////////////////////////////////////////////////////////////////////
remonte
	ld		a,(flag_on_plonge)
	or		a
	jr		nz,on_continu_de_plonger
	or		a
	jr		z,on_remonte

on_continu_de_plonger
		xor		a
	ld		(fire1_jpz),a
	ld		(fire1_jpz+1),a
	ld		(fire1_jpz+2),a

	xor		a
	ld		(flag_saut_en_cours),a
	ld		(flag_on_tombe),a
	ld		hl,vitesse_X_deplacement_blinky
	ld		(vitesse_X_blinky),hl
	ld		a,10
	ld		(vitesse_du_saut_en_cours),a
	ld		a,(distance_plongon)
	inc		a
	ld		(distance_plongon),a
	cp		a,30
	jr		z,on_ne_plonge_plus



	ld		hl,(pos_Y_blinky)
	inc		l
	ld		(pos_Y_blinky),hl
	ld		de,(SPRH0_Y)
	ld		hl,blinky_sort_ecran_bas
	sbc		hl,de
	jp		c,vers_la_piece_bas


	call	update_position_Y_de_blinky
	jp		retour_remonte

on_ne_plonge_plus
	xor		a
	ld		(flag_on_plonge),a
	ld		(distance_plongon),a
	jp		retour_remonte

on_remonte
	ld		hl,(pos_Y_blinky)
	dec		l
	ld		(pos_Y_blinky),hl

	ld		de,-16
	add		hl,de

	bit		7,l
	jp		nz,vers_la_piece_haut


	ld		hl,(pos_Y_blinky)
	call	collision_haut			; on test les collision avec les murs
	ld		de,tile_murs
	ld		hl,(no_de_la_tile)
	sbc		hl,de
	jr		nc,stop_blinky_haut

	call	collision_haut_bis
	ld		hl,(no_de_la_tile)
	ld		de,070
	sbc		hl,de
	jr		z,stop_blinky_haut

	call	update_position_Y_de_blinky
		ld		a,#ca					; JP  z
	ld		(fire1_jpz),a			; on rétablie la possibilité de faire fire B quand on intègre une pièce allumé
	ld		hl,saut			; sinon à la prise d'un parchemein la palette change et la pièce reste allumé
	ld		(fire1_jpz+1),hl
	jp		retour_remonte

stop_blinky_haut
	ld		hl,(pos_Y_blinky)
	inc		l
	ld		(pos_Y_blinky),hl
	jp		retour_remonte
; ///////////////////////////////////////////////////////////////////////////////////
; ///////////////////////////////////////////////////////////////////////////////////
; ////////////////////       UPDATE POSITION DE BLINKY          /////////////////////
; ///////////////////////////////////////////////////////////////////////////////////
; ///////////////////////////////////////////////////////////////////////////////////
update_position_X_de_blinky
	ld		hl,(pos_X_blinky)
	ld		(SPRH0_X),hl
	ld		(SPRH2_X),hl
	ld		de,32
	add		hl,de
	ld		(SPRH1_X),hl
	ld		(SPRH3_X),hl
	ret


update_position_Y_de_blinky
	ld 		hl,(pos_Y_blinky)
	res		7,h
	ld		(SPRH0_Y),hl
	ld		(SPRH1_Y),hl
	ld		de,16
	add		hl,de
	res		7,h
	ld		(SPRH2_Y),hl
	ld		(SPRH3_Y),hl
	ret

corriger_position_Y_de_blinky
	ld 		hl,(pos_Y_blinky)

	bit		2,l				; on test le bit 2
	jr	nz,on_arrondit_vers_le_haut		; s'il n'est PAS à zero c'est que la coordonnée
											; est en dessous la valeur normalement attendu
			; si le bit 2 est à 1 alors le poid faible est obligatoirement supérieur à C
			;	OU BIEN  si le bit 2 est à zéro alors le poid faible est inférieur à C
			; donc on met les bit à zeros

	res		0,l			; on ne touche PAS au bit 3 car la valeur du saut peut être à #8 dans le poid faible
	res		1,l
	res		2,l
retour_arrondit
	res		7,h
	ld		(pos_Y_blinky),hl
	ret

on_arrondit_vers_le_haut
	res		0,l		; dans le cas ou l'on aurtait une coordonnée en 0 ou 8 à obtenir dans le poid faible
	res		1,l		; ces trois bit 0,1 et 2 doivent être à zero
	res		2,l
	; si on a un résultat avec un bit 3 à 0, il faut le mettre à 1
	; si on a un résultat avec un bit 3 à 1, il faut le mettre à 0
	bit		3,l
	jr		z,on_met_a_1
retour_met_a_1
	; sinon c'est qu'il est à 1 et donc il faut le mettre à zero
	res		3,l
	; puis comme le poid fort est forcement inférieur à 1 maximum on le remonte de 1
	ld		a,#10
	ld		b,l
	add		a,l
	ld		l,a
	jr		retour_arrondit
on_met_a_1
	set		3,l
	jr		retour_arrondit



; ///////////////////////////////////////////////////////////////////////////////////
; ///////////////////////////////////////////////////////////////////////////////////
; ////////////////////       BLINKY VA DANS L'EAU         /////////////////////
; ///////////////////////////////////////////////////////////////////////////////////
; ///////////////////////////////////////////////////////////////////////////////////

blinky_va_dans_leau
ld		a,(nbr_ingredient_chaudron_2)
cp		a,4
jp		nz,blinky_perd_une_vie_piege


ld		a,1
ld		(flag_blinky_est_dans_leau),a
ld		(flag_on_plonge),a

ld		a,2
ld		(etape_anim_blinky),a
jp		retour_tombe


init_blinky_dans_leau
	ld		c,bank_programme_rom
	call	rom_on
	call	init_blinky_dans_leau_ROM
	call	rom_off

	ld		a,(etat_blinky_en_cours)
	cp		a,va_a_droite
	jp		z,blinky_eau_anim_droite

	ld		c,bank_sprh_blinky2
	call	rom_on
	ld		hl,blinky_sprh_eau_gauche_ROM

	ld		de,SPRH0_ADR
	ld		bc,#400
	LDIR
	call	rom_off
	ret

blinky_eau_anim_droite
ld		c,bank_sprh_blinky2
call	rom_on
ld		hl,blinky_sprh_eau_droite_ROM

ld		de,SPRH0_ADR
ld		bc,#400
LDIR
call	rom_off

ret


; ///////////////////////////////////////////////////////////////////////////////////
; ///////////////////////////////////////////////////////////////////////////////////
; ////////////////////       BLINKY SORT DE L'EAU         /////////////////////
; ///////////////////////////////////////////////////////////////////////////////////
; ///////////////////////////////////////////////////////////////////////////////////

blinky_sort_de_leau
xor		a
ld		(flag_blinky_est_dans_leau),a
ld		(flag_on_plonge),a
ld		a,1
ld		(etape_anim_blinky),a
ld		(flag_on_tombe),a
ld		a,3
ld		(vitesse_animation_blinky),a

init_blinky_sur_terre
	ld		c,bank_programme_rom
	call	rom_on
	call	asic_off
	call	init_blinky_sur_terre_ROM
	call	asic_on
	call	rom_off
	
	ld		a,(etat_blinky_en_cours)
	cp		a,va_a_droite
	jr		z,blinky_chateau_anim_droite


	ld		c,20
	call	rom_on
	ld		hl,blinky_sprh_1_gauche_ROM
	ld		(animation_blinky_en_cours),hl
	ld		de,SPRH0_ADR
	ld		bc,#400
	LDIR
	call	rom_off
	ld		hl,#D400
	ld		(animation_blinky_saute),hl
	ld		(animation_blinky_en_cours),hl
	jp init_blinky_saut


blinky_chateau_anim_droite
	ld		c,20
	call	rom_on
	ld		hl,blinky_sprh_1_droite_ROM
	ld		(animation_blinky_en_cours),hl
	ld		de,SPRH0_ADR
	ld		bc,#400
	LDIR
	call	rom_off
	ld		hl,#F400
	ld		(animation_blinky_saute),hl
	ld		(animation_blinky_en_cours),hl
	jp init_blinky_saut




; ///////////////////////////////////////////////////////////////////////////////////
; ///////////////////////////////////////////////////////////////////////////////////
; /////////////////////////       BLINKY SE TELEPORTE        /////////////////////////
; ///////////////////////////////////////////////////////////////////////////////////
; ///////////////////////////////////////////////////////////////////////////////////
blinky_se_teleporte
ld		a,(flag_lumiere)
or		a
jp		z,retour_tombe



call	on_efface_les_events
LD		a,ZOOM_mode_1
		ld		(SPRH0_ZOOM),a
		ld		(SPRH1_ZOOM),a
		ld		(SPRH2_ZOOM),a
		ld		(SPRH3_ZOOM),a
ld		a,1
ld		(flag_on_se_teleporte),a
xor		a
ld		(flag_pq),a
	ld		a,#C3
	ld		hl,teleportation
	ld		(event_gameover),a
	ld		(event_gameover+1),hl
	ld		a,#C3
	ld		hl,BOUCLE_PRINCIPALE
	ld		(event_boucle_gameover),a
	ld		(event_boucle_gameover+1),hl




	jp		teleportation

; ///////////////////////////////////////////////////////////////////////////////////
; ///////////////////////////////////////////////////////////////////////////////////
; ////////////////////       BLINKY entre vers le haut       ////////////////////////
; ///////////////////////////////////////////////////////////////////////////////////
; ///////////////////////////////////////////////////////////////////////////////////
haut
		call	collision_porte
		ld		de,285			
		ld		hl,(no_de_la_tile)
		sbc		hl,de
		jr		z,ok_grille

		ld		hl,(SPRH1_X)
		ld		(pos_X_blinky),hl
		call	collision_gauche
		ld		de,tile_porte_ferme
		ld		hl,(no_de_la_tile)
		sbc		hl,de
		jp		z,init_blinky_ouvre
		
		call	collision_gauche
		ld		de,tile_porte_ouverte
		ld		hl,(no_de_la_tile)
		sbc		hl,de
		jp		z,test_des_portes
		call	collision_gauche
		ld		de,tile_porte_ouverte+1
		ld		hl,(no_de_la_tile)
		sbc		hl,de
		jp		z,test_des_portes
		
		
		retour_test_des_portes
		ld		hl,(SPRH0_X)
		ld		(pos_X_blinky),hl
		jp	retour_test_de_touches
ok_grille
	
	ld		a,(etape_init_grille)
	or		a
	jr		z,on_init_ouvre_la_grille
	cp		a,1
	jr		z,on_ouvre_la_grille
	jp		retour_test_de_touches
on_init_ouvre_la_grille
	ld	hl,Tbl_grille_adr
	ld	(pointeur_grille_adr),hl
	ld	a,3
	ld	(vitesse_grille),a
	ld	a,1
	ld	(etape_init_grille),a
	jp	retour_test_de_touches

on_ouvre_la_grille
	ld		c,bank_programme_rom
	call	rom_on
	jp	on_ouvre_la_grille_rom
	retour_on_ouvre_la_grille_rom
	call	rom_off
	ld	b,32
		boucle_ouvre_grille
					push	bc				; compteur le ligne
					push	hl
					push	de
					ld		bc,32			; 8 tiles de 4 octets de long
					ldir					; on recopie une ligne
					pop		de				; on recupère les valeur de debut de ligne
					call	ligne_inferieur			; on calcule la ligne inferieur pour DE
					pop		hl
					ex		de,hl
					call	ligne_inferieur			; on calcule la ligne inferieur pour HL
					ex		hl,de
					pop		bc
					djnz	boucle_ouvre_grille
	ld	a,3
	ld	(vitesse_grille),a	
	ld		hl,DMA_LIST_2
			ld		(#6C00),hl
			ld		a,1
			ld		(#6C0F),a
jp	retour_test_de_touches


retour_grille_ouverte
	call	rom_off
	pop	iy
		jp	vers_la_piece_droite


Tbl_grille_adr
dw		#c3dc,#c33c,#c29c,#c1fc,#c15c,#c0bc,#FFFF
pointeur_grille_adr		ds		2,0
etape_init_grille		ds		1,0
vitesse_grille			ds		1,0
vitesse_anim_porte		ds		1,0




init_blinky_ouvre
		
			ld		hl,Item_ID_pour_chaudron
	ld		b,3
boucle_pour_ouvrir
	ld		a,(hl)
	cp		a,19
	jr		z,on_peut_ouvrir
	inc		hl
	djnz	boucle_pour_ouvrir
	ld		hl,DMA_LIST_2
					ld		(#6C00),hl
					ld		a,1
					ld		(#6C0F),a
	
	jp		retour_test_des_portes
	
	
	
	
	on_peut_ouvrir
		ld		hl,(SPRH0_X)
		ld		(pos_X_blinky),hl
		
		ld		a,(vitesse_anim_porte)
		dec		a
		ld		(vitesse_anim_porte),a
		jp		nz,retour_test_de_touches
	
ld		c,bank_programme_rom
call	rom_on
call	on_peut_ouvrir_ROM
call	rom_off
pop	iy
jp		retour_test_de_touches
		
		
anim_porte_1
		pop	iy
		inc		a
		ld		(etape_anim_porte),a
		ld		de,(adr_anim_porte)
		ld		hl,ADR_PORTE
		ld		c,bank_anim_portes
		call	rom_on
		ld		b,56
		jr		boucle_ouvre_porte
anim_porte_2
		pop	iy
		inc		a
		ld		(etape_anim_porte),a
		ld		de,(adr_anim_porte)
		ld		hl,ADR_PORTE+#1c0
		ld		c,bank_anim_portes
		call	rom_on
		ld		b,56
		jr		boucle_ouvre_porte
anim_porte_3
		pop	iy
		inc		a
		ld		(etape_anim_porte),a
		ld		de,(adr_anim_porte)
		ld		hl,ADR_PORTE+#380
		ld		c,bank_anim_portes
		call	rom_on
		ld		b,56
		
		
		boucle_ouvre_porte
					push	bc					; compteur le ligne
					push	de					; on sauve l'adr destination
					ld		bc,8				; 2 tiles de 4 octets de long
					ldir						; on recopie une ligne
					pop		de					; on recupère les valeur de debut de ligne
					call	ligne_inferieur		; on calcule la ligne inferieur pour DE
					pop		bc
					djnz	boucle_ouvre_porte
					ld		hl,DMA_LIST_2
					ld		(#6C00),hl
					ld		a,1
					ld		(#6C0F),a
					call	rom_off
					
					
					ld		hl,(SPRH0_X)
					ld		(pos_X_blinky),hl
					ld		a,conf_vitesse_anim_porte
					ld		(vitesse_anim_porte),a
					; ret
					
					jp		retour_test_de_touches
					
					
etape_anim_porte	ds		1,0
ADR_PORTE			equ		#c4fe
bank_anim_portes	equ		21


test_des_portes

	ld		c,bank_programme_rom
	call	rom_on
	call	test_des_portes_ROM
	call	rom_off
	ld		a,conf_vitesse_anim_porte
	ld		(vitesse_anim_porte),a
	call	update_position_X_de_blinky
	call 	update_position_Y_de_blinky
	jp		nouvelle_piece






; ///////////////////////////////////////////////////////////////////////////////////
; ///////////////////////////////////////////////////////////////////////////////////
; ////////////////////////////       BLINKY chaudron       //////////////////////////
; ///////////////////////////////////////////////////////////////////////////////////
; ///////////////////////////////////////////////////////////////////////////////////
blinky_items_chaudron
	xor		a
	ld		(flag_on_tombe),a
	ld		(flag_saut_en_cours),a
	ld		hl,(pos_Y_blinky)
	dec		l
	dec		l
	dec		l
	dec		l
	ld		(pos_Y_blinky),hl
	call	update_position_Y_de_blinky
	ld		hl,vitesse_X_deplacement_blinky
	ld		(vitesse_X_blinky),hl





	ld	a,(no_de_la_salle)
	cp	a,1
	jr	z,chaudron_n_1
	cp	a,50
	jr	z,chaudron_n_2
	cp	a,87
	jr	z,chaudron_n_0
chaudron_n_0
		ld		a,(nbr_ingredient_chaudron_0)	; on recupère le nombre d'ingrédient déposé dans le chaudron
		cp		a,4								; est ce qu'il y en a 4 ?
		jr		z,passage_secret_ok				; si oui blinky s'envole
		ld		ix,Item_ID_pour_chaudron
		ld		hl,Formule_chaudron_0
		jr		boucle_chaudron
chaudron_n_1
		ld		a,(nbr_ingredient_chaudron_1)	; on recupère le nombre d'ingrédient déposé dans le chaudron
		cp		a,4								; est ce qu'il y en a 4 ?
		jr		z,blinky_senvole				; si oui blinky s'envole
		ld		ix,Item_ID_pour_chaudron
		ld		hl,Formule_chaudron_1
		jr		boucle_chaudron
chaudron_n_2
		ld		ix,Item_ID_pour_chaudron
		ld		hl,Formule_chaudron_2


boucle_chaudron
	ld		b,1
	ld		a,(hl)
	cp		a,255
	jr 		z,fin_formule

	cp 		(ix+0)
	jp 		z,on_vide_la_case1
	inc 	b
	cp 		(ix+1)
	jp 		z,on_vide_la_case2
	inc 	b
	cp 		(ix+2)
	jp 		z,on_vide_la_case3
	inc 	hl
	jr  	boucle_chaudron
fin_formule
	jp		retour_tombe
	

	
passage_secret_ok
	ld	a,1
	ld	(flag_passage),a
	jp		retour_tombe


blinky_senvole
	ld		hl,100
	ld		(pos_X_blinky),hl
	ld		hl,16
	ld		(pos_Y_blinky),hl
	call	update_position_X_de_blinky
	call	update_position_Y_de_blinky
	jp		retour_tombe




	
on_vide_la_case1
		ld		c,bank_programme_rom
		call	rom_on		
		call	on_vide_la_case1_ROM
		call	rom_off
		call	on_update_le_hud
		jr		on_ajoute_un_ingredient
on_vide_la_case2
		ld		c,bank_programme_rom
		call	rom_on		
		call	on_vide_la_case2_ROM
		call	rom_off
		call	on_update_le_hud
		jr		on_ajoute_un_ingredient
on_vide_la_case3
		ld		c,bank_programme_rom
		call	rom_on		
		call	on_vide_la_case3_ROM
		call	rom_off
		call	on_update_le_hud
	

on_ajoute_un_ingredient
			ld		hl,DMA_LIST_2
			ld		(#6C00),hl
			ld		a,1
			ld		(#6C0F),a
			ld		a,(no_de_la_salle)
			cp		a,50
			jr		z,on_zap_le_chaudron_1
			cp		a,87
			jr		z,on_zap_le_chaudron_2
			ld		a,(nbr_ingredient_chaudron_1)
			inc		a
			ld		(nbr_ingredient_chaudron_1),a
			jp		retour_tombe
on_zap_le_chaudron_1
			ld		a,(nbr_ingredient_chaudron_2)
			inc		a
			ld		(nbr_ingredient_chaudron_2),a
			jp		retour_tombe
on_zap_le_chaudron_2
			ld		a,(nbr_ingredient_chaudron_0)
			inc		a
			ld		(nbr_ingredient_chaudron_0),a
			jp		retour_tombe





	
	
blinky_a_gagne
DI
	ld		hl,Item_ID_pour_chaudron
	ld		b,3
	boucle_gagne
	ld		a,(hl)
	cp		a,16
	jp		z,ecran_de_fin
	inc		hl
	djnz	boucle_gagne
	ret


ecran_de_fin
	ld	a,(no_de_la_salle)
	cp	a,51
	ret	nz
	pop	ix
	xor		a
	ld		hl,SPRH0_ADR
	ld		e,l
	ld		d,h
	inc		de
	ld		(hl),a
	ld		bc,#4000
	LDIR
	call	asic_off
	call	init_ecran_de_fin
	call	asic_on
	
	ld		C,21				; sélèction de la banque contenant
	call	rom_on
	ld		hl,#C29e
	ld		de,#0000				; adresse de départ 
	ld		bc,#20	
	ldir
	call	rom_off
	
; on allume les palettes
	ld		hl,pallette_parchemin
	ld		(pallette_en_cours_decors),hl
	ld		(pallette_en_cours_hud),hl
	jp		boucle_principale
	
Formule_chaudron_0
db		21,22,20,18,255
Formule_chaudron_1
db		1,5,6,8,255
Formule_chaudron_2
db		9,13,12,15,255
Item_ID_pour_chaudron
db		0,0,0


