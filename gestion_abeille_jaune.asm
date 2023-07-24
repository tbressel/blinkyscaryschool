; ///////////////////////////////////////////////////////////////////////////////////
; ///////////////////////////////////////////////////////////////////////////////////
; //////////////////              GESTION abeillejaune                       //////////
; ///////////////////////////////////////////////////////////////////////////////////
; ///////////////////////////////////////////////////////////////////////////////////

abeillejaune							; routine dédié aux ennemis de type #01
	ld		a,(etape_abeillejaune)
	or		a
	jp		z,init_abeillejaune
	or		a
	jp		nz,deplacement_abeillejaune
	ret
	init_abeillejaune
		; on recherche dans les tableau RAM où est l'ennemis de type 1
		ld 		hl,tableau_ennemy_RAM+3
		ld		b,4
		boucle_init_abeillejaune
			ld		a,(hl)
			cp		a,ennemis_abeille_jaune
			JP		z,on_continu_abeillejaune
			ld		de,16
			add		hl,de
			djnz	boucle_init_abeillejaune
		on_continu_abeillejaune
			dec		hl
			dec		hl
			dec		hl
			ld		de,tableau_abeillejaune
			ldi:ldi:ldi:ldi:ldi:ldi
			ldi:ldi:ldi:ldi:ldi:ldi
			ldi:ldi:ldi:ldi
	ld		a,bank_sprh_ennemy2
	ld		c,a
	call	rom_on								; on connecte la bank
	ld		hl,(adr_abeillejaune)
	ld		de,(sprh_de_depart_abeillejaune)						; destination ASIC
	ld		bc,#200								; on choisit 2 sprites
	LDIR										; PAF on copie
	call	rom_off								; on deconnecte la ROM
	
	
	ld		c,bank_programme_rom
	call	rom_on
	call	init_abeillejaune_ROM
	call	rom_off




	
	; si on se trouve dans une piece non éclairé alors on éteinds les sprites	
	ld		a,(flag_lumiere)
	or		a
	ret		NZ
	xor		a
	ld		hl,(sprh_zoom_abeillejaune)
	ld		(hl),a
	ld		de,-8
	add		hl,de
	ld		(hl),a	
	ret
deplacement_abeillejaune
	ld		hl,(pos_x_abeillejaune)
	ld		(sprh_x_ennemis),hl
	ld		hl,(pos_y_abeillejaune)
	ld		(sprh_y_ennemis),hl
	call	collision_avec_blinky
	ld		a,(direction_abeillejaune)
	cp		a,1
	jp		z,deplacement_abeillejaune_droite
	cp		a,2
	jp		z,deplacement_abeillejaune_gauche
deplacement_abeillejaune_droite
	ld		a,(animation_abeillejaune)
	dec		a
	ld		(animation_abeillejaune),a
	call	z,anim_abeillejaune_1
	ld		a,(distance_X_abeillejaune)
	dec		a
	ld		(distance_X_abeillejaune),a
	jp		z,reinit_deplacement_abeillejaune_gauche
	ld		hl,(pos_x_abeillejaune)
	ld		de,(vitesse_X_abeillejaune)
	ld		d,0
	add		hl,de
	ld		(pos_x_abeillejaune),hl
	ld		ix,(sprh_xyz_abeillejaune)
	ld		(ix),hl
	ld		(ix+8),hl
	ret
deplacement_abeillejaune_gauche
	ld		a,(animation_abeillejaune)
	dec		a
	ld		(animation_abeillejaune),a
	call	z,anim_abeillejaune_2
	ld		a,(distance_X_abeillejaune)
	dec		a
	ld		(distance_X_abeillejaune),a
	jp		z,reinit_deplacement_abeillejaune_droite
	ld		hl,(pos_x_abeillejaune)
	ld		de,(vitesse_X_abeillejaune)
	ld		d,0
	sbc		hl,de
	ld		(pos_x_abeillejaune),hl
	ld		ix,(sprh_xyz_abeillejaune)
	ld		(ix),hl
	ld		(ix+8),hl
	ret
reinit_deplacement_abeillejaune_gauche
	ld		a,(distance_X_abeillejaune_save)
	ld		(distance_X_abeillejaune),a
	ld		a,2						; on va à gauche
	ld		(direction_abeillejaune),a
	xor		a
	ld		(etape_anim_abeillejaune),a
	ld		hl,Tableau_anim_abeillejaune_gauche
	ld		(adr_des_animations_abeillejaune),hl
	ld		hl,abeille_jaune
	ld		(adr_abeillejaune),hl
	ld		a,bank_sprh_ennemy2				; on choisit le no de bank
	ld		c,a
	call	rom_on		
	ld		hl,(adr_abeillejaune)
	ld		de,(sprh_de_depart_abeillejaune)						; destination ASIC
	ld		bc,#200								; on choisit 2 sprites
	LDIR										; PAF on copie
	call	rom_off								; on deconnecte la ROM
	
	; on reinit le sprite du bas
	ld		ix,(sprh_x_abeillejaune)
	ld		hl,(pos_x_abeillejaune_save)
	ld		(pos_x_abeillejaune),hl
	ld		(ix),hl
	ld		ix,(sprh_y_abeillejaune)
	ld		hl,(pos_y_abeillejaune_save)
	ld		(pos_y_abeillejaune),hl
	ld		(ix),hl
	inc		ix
	inc		ix
	
	inc		ix :	inc		ix : inc		ix :	inc		ix 	; on se place sur la pos X du prochain sprite hard
; on initialise le sprite du haut
	ld		ix,(sprh_x_abeillejaune)
	ld		hl,(pos_x_abeillejaune_save)
	ld		(pos_x_abeillejaune),hl
	ld		(ix),hl
	inc		ix
	inc		ix
	ld		ix,(sprh_y_abeillejaune)
	ld		hl,(pos_y_abeillejaune_save)
	ld		(pos_y_abeillejaune),hl
	ld		(ix),hl

	ret
reinit_deplacement_abeillejaune_droite
	ld		a,(distance_X_abeillejaune_save)
	ld		(distance_X_abeillejaune),a
	ld		a,1						; on va à gauche
	ld		(direction_abeillejaune),a
	xor		a
	ld		(etape_anim_abeillejaune),a
	ld		hl,Tableau_anim_abeillejaune_droite
	ld		(adr_des_animations_abeillejaune),hl
	ld		hl,abeille_jaune
	ld		(adr_abeillejaune),hl
	ld		a,bank_sprh_ennemy2				; on choisit le no de bank
	ld		c,a
	call	rom_on		
	ld		hl,(adr_abeillejaune)
	ld		de,(sprh_de_depart_abeillejaune)						; destination ASIC
	ld		bc,#200								; on choisit 2 sprites
	LDIR										; PAF on copie
	call	rom_off								; on deconnecte la ROM
	ret

anim_abeillejaune_1
		ld			a,(etape_anim_abeillejaune)
		inc			a
		cp			a,8
		jp			z,reinit_anim_abeillejaune_1
		ld			(etape_anim_abeillejaune),a
		ld			hl,(adr_des_animations_abeillejaune)
		inc			Hl
		inc			hl
		ld			(adr_des_animations_abeillejaune),hl
		ld			a,(hl)
		ld			e,a
		inc			hl
		ld			a,(hl)
		ld			d,a
		ld			(adr_abeillejaune),de
	retour_reinit_anim_abeillejaune_1
			ld		a,(animation_abeillejaune_save)
			ld		(animation_abeillejaune),a
			ld		a,bank_sprh_ennemy2					; on choisit le no de bank
			ld		c,a
			call	rom_on		
			ld		hl,(adr_abeillejaune)
			ld		de,(sprh_de_depart_abeillejaune)						; destination ASIC
			ld		bc,#200								; on choisit 1 sprites
			LDIR										; PAF on copie
			call	rom_off								; on deconnecte la ROM
	
			ld		hl,(pos_y_abeillejaune)				; on prends pos Y du sprite du haut
			dec		l									; on rajoute 2
			dec		l
			ld		(pos_y_abeillejaune),hl				; on sauvegarde
			ld		ix,(sprh_y_abeillejaune)			; on prends l'adress asic de Pos Y du haut
			ld		(ix+-8),hl							
			ld		de,-16
			add		hl,de
			ld		(ix),hl
			
			ret
		reinit_anim_abeillejaune_1
				ld		hl,Tableau_anim_abeillejaune_droite
				ld		(adr_des_animations_abeillejaune),hl
				ld		hl,abeille_jaune+#1000
				ld		(adr_abeillejaune),hl
				xor		a
				ld		(etape_anim_abeillejaune),a
				jp		retour_reinit_anim_abeillejaune_1
		
	anim_abeillejaune_2
		ld			a,(etape_anim_abeillejaune)
		inc			a
		cp			a,8
		jp		z,reinit_anim_abeillejaune_2
		ld			(etape_anim_abeillejaune),a
		ld			hl,(adr_des_animations_abeillejaune)
		inc			hl
		inc			hl
		ld			(adr_des_animations_abeillejaune),hl
		ld			a,(hl)
		ld			e,a
		inc			hl
		ld			a,(hl)
		ld			d,a
		ld			(adr_abeillejaune),de
	retour_reinit_anim_abeillejaune_2
			ld		a,(animation_abeillejaune_save)
			ld		(animation_abeillejaune),a
			ld		a,bank_sprh_ennemy2						; on choisit le no de bank
			ld		c,a
			call	rom_on		
			ld		hl,(adr_abeillejaune)
			ld		de,(sprh_de_depart_abeillejaune)						; destination ASIC
			ld		bc,#200								; on choisit 1 sprites
			LDIR										; PAF on copie
			call	rom_off								; on deconnecte la ROM
	ld		hl,(pos_y_abeillejaune)				; on prends pos Y du sprite du haut
	inc		l									; on rajoute 2
	inc		l
	ld		(pos_y_abeillejaune),hl				; on sauvegarde
	ld		ix,(sprh_y_abeillejaune)			; on prends l'adress asic de Pos Y du haut
	ld		(ix+-8),hl							
	ld		de,-16
	add		hl,de
	ld		(ix),hl
			ret
		reinit_anim_abeillejaune_2
		ld		hl,Tableau_anim_abeillejaune_gauche
				ld		(adr_des_animations_abeillejaune),hl
		
				ld		hl,abeille_jaune
				ld		(adr_abeillejaune),hl
				xor		a
				ld			(etape_anim_abeillejaune),a
				jp		retour_reinit_anim_abeillejaune_2
				
Tableau_anim_abeillejaune_gauche
DW		abeille_jaune,abeille_jaune+#200,abeille_jaune+#400,abeille_jaune+#600,abeille_jaune+#800,abeille_jaune+#600,abeille_jaune+#400,abeille_jaune+#200
Tableau_anim_abeillejaune_droite
DW		abeille_jaune+#1000,abeille_jaune+#1200,abeille_jaune+#1400,abeille_jaune+#1600,abeille_jaune+#1800,abeille_jaune+#1600,abeille_jaune+#1400,abeille_jaune+#1200



