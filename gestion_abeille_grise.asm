; ///////////////////////////////////////////////////////////////////////////////////
; ///////////////////////////////////////////////////////////////////////////////////
; //////////////////              GESTION abeillegrise                       //////////
; ///////////////////////////////////////////////////////////////////////////////////
; ///////////////////////////////////////////////////////////////////////////////////

abeillegrise							; routine dédié aux ennemis de type #01
	ld		a,(etape_abeillegrise)
	or		a
	jp		z,init_abeillegrise
	or		a
	jp		nz,deplacement_abeillegrise
	ret
	init_abeillegrise
		; on recherche dans les tableau RAM où est l'ennemis de type 1
		ld 		hl,tableau_ennemy_RAM+3
		ld		b,4
		boucle_init_abeillegrise
			ld		a,(hl)
			cp		a,ennemis_abeille_grise
			JP		z,on_continu_abeillegrise
			ld		de,16
			add		hl,de
			djnz	boucle_init_abeillegrise
		on_continu_abeillegrise
			dec		hl
			dec		hl
			dec		hl
			ld		de,tableau_abeillegrise
			ldi:ldi:ldi:ldi:ldi:ldi
			ldi:ldi:ldi:ldi:ldi:ldi
			ldi:ldi:ldi:ldi
	ld		a,bank_sprh_ennemy2				; on choisit le no de bank
	ld		c,a
	call	rom_on								; on connecte la bank
	ld		hl,(adr_abeillegrise)
	ld		de,(sprh_de_depart_abeillegrise)						; destination ASIC
	ld		bc,#200								; on choisit 2 sprites
	LDIR										; PAF on copie
	call	rom_off								; on deconnecte la ROM
	
	ld		c,bank_programme_rom
	call	rom_on
	call	init_abeillegrise_ROM
	call	rom_off
	
	

	; si on se trouve dans une piece non éclairé alors on éteinds les sprites	
	ld		a,(flag_lumiere)
	or		a
	ret		NZ
	xor		a
	ld		hl,(sprh_zoom_abeillegrise)
	ld		(hl),a
	ld		de,-8
	add		hl,de
	ld		(hl),a	
	ret
deplacement_abeillegrise
	ld		hl,(pos_x_abeillegrise)
	ld		(sprh_x_ennemis),hl
	ld		hl,(pos_y_abeillegrise)
	ld		(sprh_y_ennemis),hl
	call	collision_avec_blinky
	ld		a,(direction_abeillegrise)
	cp		a,1
	jp		z,deplacement_abeillegrise_droite
	cp		a,2
	jp		z,deplacement_abeillegrise_gauche
deplacement_abeillegrise_droite
	ld		a,(animation_abeillegrise)
	dec		a
	ld		(animation_abeillegrise),a
	call	z,anim_abeillegrise_1
	ld		a,(distance_X_abeillegrise)
	dec		a
	ld		(distance_X_abeillegrise),a
	jp		z,reinit_deplacement_abeillegrise_gauche
	ld		hl,(pos_x_abeillegrise)
	ld		de,(vitesse_X_abeillegrise)
	ld		d,0
	add		hl,de
	ld		(pos_x_abeillegrise),hl
	ld		ix,(sprh_xyz_abeillegrise)
	ld		(ix),hl
	ld		(ix+8),hl
	ret
deplacement_abeillegrise_gauche
	ld		a,(animation_abeillegrise)
	dec		a
	ld		(animation_abeillegrise),a
	call	z,anim_abeillegrise_2
	ld		a,(distance_X_abeillegrise)
	dec		a
	ld		(distance_X_abeillegrise),a
	jp		z,reinit_deplacement_abeillegrise_droite
	ld		hl,(pos_x_abeillegrise)
	ld		de,(vitesse_X_abeillegrise)
	ld		d,0
	sbc		hl,de
	ld		(pos_x_abeillegrise),hl
	ld		ix,(sprh_xyz_abeillegrise)
	ld		(ix),hl
	ld		(ix+8),hl
	ret
reinit_deplacement_abeillegrise_gauche
	ld		a,(distance_X_abeillegrise_save)
	ld		(distance_X_abeillegrise),a
	ld		a,2						; on va à gauche
	ld		(direction_abeillegrise),a
	xor		a
	ld		(etape_anim_abeillegrise),a
	ld		hl,Tableau_anim_abeillegrise_gauche
	ld		(adr_des_animations_abeillegrise),hl
	ld		hl,abeille_grise
	ld		(adr_abeillegrise),hl
	ld		a,bank_sprh_ennemy2					; on choisit le no de bank
	ld		c,a
	call	rom_on		
	ld		hl,(adr_abeillegrise)
	ld		de,(sprh_de_depart_abeillegrise)						; destination ASIC
	ld		bc,#200								; on choisit 2 sprites
	LDIR										; PAF on copie
	call	rom_off								; on deconnecte la ROM
	ret
reinit_deplacement_abeillegrise_droite
	ld		a,(distance_X_abeillegrise_save)
	ld		(distance_X_abeillegrise),a
	ld		a,1						; on va à gauche
	ld		(direction_abeillegrise),a
	xor		a
	ld			(etape_anim_abeillegrise),a
	ld		hl,Tableau_anim_abeillegrise_droite
	ld		(adr_des_animations_abeillegrise),hl
	ld		hl,abeille_grise+#1000
	ld		(adr_abeillegrise),hl

	ld		a,bank_sprh_ennemy2					; on choisit le no de bank
	ld		c,a
	call	rom_on		
	ld		hl,(adr_abeillegrise)
	ld		de,(sprh_de_depart_abeillegrise)						; destination ASIC
	ld		bc,#200								; on choisit 2 sprites
	LDIR										; PAF on copie
	call	rom_off								; on deconnecte la ROM
	
	ld		ix,(sprh_x_abeillegrise)
	ld		hl,(pos_x_abeillegrise_save)
	ld		(pos_x_abeillegrise),hl
	ld		(ix),hl
	
	ld		ix,(sprh_y_abeillegrise)
	ld		hl,(pos_y_abeillegrise_save)
	ld		(pos_y_abeillegrise),hl
	ld		(ix),hl
	inc		ix
	inc		ix
	
	inc		ix :	inc		ix : inc		ix :	inc		ix 	; on se place sur la pos X du prochain sprite hard
; on initialise le sprite du haut
	ld		ix,(sprh_x_abeillegrise)
	ld		hl,(pos_x_abeillegrise_save)
	ld		(pos_x_abeillegrise),hl
	ld		(ix),hl
	inc		ix
	inc		ix
	ld		ix,(sprh_y_abeillegrise)
	ld		hl,(pos_y_abeillegrise_save)
	ld		(pos_y_abeillegrise),hl
	
	ld		(ix),hl
	ret

anim_abeillegrise_1
		ld			a,(etape_anim_abeillegrise)
		inc			a
		cp			a,8
		jp			z,reinit_anim_abeillegrise_1
		ld			(etape_anim_abeillegrise),a
		ld			hl,(adr_des_animations_abeillegrise)
		inc			hl
		inc			hl
		ld			(adr_des_animations_abeillegrise),hl
		ld			a,(hl)
		ld			e,a
		inc			hl
		ld			a,(hl)
		ld			d,a
		ld			(adr_abeillegrise),de
	retour_reinit_anim_abeillegrise_1
			ld		a,(animation_abeillegrise_save)
			ld		(animation_abeillegrise),a
			ld		a,bank_sprh_ennemy2				; on choisit le no de bank
			ld		c,a
			call	rom_on		
			ld		hl,(adr_abeillegrise)
			ld		de,(sprh_de_depart_abeillegrise)						; destination ASIC
			ld		bc,#200								; on choisit 1 sprites
			LDIR										; PAF on copie
			call	rom_off								; on deconnecte la ROM
			ld		hl,(pos_y_abeillegrise)
			dec		l
			dec		l
			ld		(pos_y_abeillegrise),hl
			ld		ix,(sprh_y_abeillegrise)
			ld		(ix+-8),hl							
			ld		de,-16
			add		hl,de
			ld		(ix),hl
			ret
		reinit_anim_abeillegrise_1
				ld		hl,Tableau_anim_abeillegrise_droite
				ld		(adr_des_animations_abeillegrise),hl
				ld		hl,abeille_grise+#1000
				ld		(adr_abeillegrise),hl
				xor		a
				ld		(etape_anim_abeillegrise),a
				jp		retour_reinit_anim_abeillegrise_1
		
	anim_abeillegrise_2
		ld			a,(etape_anim_abeillegrise)
		inc			a
		cp			a,8
		jp		z,reinit_anim_abeillegrise_2
		ld			(etape_anim_abeillegrise),a
		ld			hl,(adr_des_animations_abeillegrise)
		inc			hl
		inc			hl
		ld			(adr_des_animations_abeillegrise),hl
		ld			a,(hl)
		ld			e,a
		inc			hl
		ld			a,(hl)
		ld			d,a
		ld			(adr_abeillegrise),de
	retour_reinit_anim_abeillegrise_2
			ld		a,(animation_abeillegrise_save)
			ld		(animation_abeillegrise),a
			ld		a,bank_sprh_ennemy2				; on choisit le no de bank
			ld		c,a
			call	rom_on		
			ld		hl,(adr_abeillegrise)
			ld		de,(sprh_de_depart_abeillegrise)						; destination ASIC
			ld		bc,#200								; on choisit 1 sprites
			LDIR										; PAF on copie
			call	rom_off								; on deconnecte la ROM
	ld		hl,(pos_y_abeillegrise)
	inc		l
	inc		l
	ld		(pos_y_abeillegrise),hl
	ld		ix,(sprh_y_abeillegrise)
	ld		(ix+-8),hl							
	ld		de,-16
	add		hl,de
	ld		(ix),hl
	ret
		reinit_anim_abeillegrise_2
		ld		hl,Tableau_anim_abeillegrise_gauche
				ld		(adr_des_animations_abeillegrise),hl
		
				ld		hl,abeille_grise
				ld		(adr_abeillegrise),hl
				xor		a
				ld		(etape_anim_abeillegrise),a
				jp		retour_reinit_anim_abeillegrise_2
				
Tableau_anim_abeillegrise_gauche
DW		abeille_grise,abeille_grise+#200,abeille_grise+#400,abeille_grise+#600,abeille_grise+#800,abeille_grise+#600,abeille_grise+#400,abeille_grise+#200
Tableau_anim_abeillegrise_droite
DW		abeille_grise+#1000,abeille_grise+#1200,abeille_grise+#1400,abeille_grise+#1600,abeille_grise+#1800,abeille_grise+#1600,abeille_grise+#1400,abeille_grise+#1200




