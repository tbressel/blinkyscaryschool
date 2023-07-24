; ///////////////////////////////////////////////////////////////////////////////////
; ///////////////////////////////////////////////////////////////////////////////////
; //////////////////              GESTION poissonvert                       //////////
; ///////////////////////////////////////////////////////////////////////////////////
; ///////////////////////////////////////////////////////////////////////////////////

poissonvert							; routine dédié aux ennemis de type #01
	ld		a,(etape_poissonvert)
	or		a
	jp		z,init_poissonvert
	or		a
	jp		nz,deplacement_poissonvert
	ret
	init_poissonvert
		; on recherche dans les tableau RAM où est l'ennemis de type 1
		ld 		hl,tableau_ennemy_RAM+3
		ld		b,4
		boucle_init_poissonvert
			ld		a,(hl)
			cp		a,ennemis_poisson_vert
			JP		z,on_continu_poissonvert
			ld		de,16
			add		hl,de
			djnz	boucle_init_poissonvert
		on_continu_poissonvert
			dec		hl
			dec		hl
			dec		hl
			ld		de,tableau_poissonvert
			ldi:ldi:ldi:ldi:ldi:ldi
			ldi:ldi:ldi:ldi:ldi:ldi
			ldi:ldi:ldi:ldi
	ld		a,bank_sprh_ennemy2				; on choisit le no de bank
	ld		c,a
	call	rom_on								; on connecte la bank
	ld		hl,(adr_poissonvert)
	ld		de,(sprh_de_depart_poissonvert)						; destination ASIC
	ld		bc,#200								; on choisit 2 sprites
	LDIR										; PAF on copie
	call	rom_off								; on deconnecte la ROM
	
	
	ld		c,bank_programme_rom
	call	rom_on
	call	init_poissonvert_ROM
	call	rom_off



; si on se trouve dans une piece non éclairé alors on éteinds les sprites	
	ld		a,(flag_lumiere)
	or		a
	ret		NZ
	xor		a
	ld		hl,(sprh_zoom_poissonvert)
	ld		(hl),a
	ld		de,-8
	add		hl,de
	ld		(hl),a	
	ret
deplacement_poissonvert
	ld		hl,(pos_x_poissonvert)
	ld		(sprh_x_ennemis),hl
	ld		hl,(pos_y_poissonvert)
	ld		(sprh_y_ennemis),hl
	call	collision_avec_blinky
	ld		a,(direction_poissonvert)
	cp		a,1
	jp		z,deplacement_poissonvert_droite
	cp		a,2
	jp		z,deplacement_poissonvert_gauche
deplacement_poissonvert_droite
	ld		a,(animation_poissonvert)
	dec		a
	ld		(animation_poissonvert),a
	call	z,anim_poissonvert_1
	ld		a,(distance_X_poissonvert)
	dec		a
	ld		(distance_X_poissonvert),a
	jp		z,reinit_deplacement_poissonvert_gauche
	ld		hl,(pos_x_poissonvert)
	ld		de,(vitesse_X_poissonvert)
	ld		d,0
	add		hl,de
	ld		(pos_x_poissonvert),hl
	ld		ix,(sprh_xyz_poissonvert)
	ld		(ix),hl
	ld		(ix+8),hl
	ret
deplacement_poissonvert_gauche
	ld		a,(animation_poissonvert)
	dec		a
	ld		(animation_poissonvert),a
	call	z,anim_poissonvert_2
	ld		a,(distance_X_poissonvert)
	dec		a
	ld		(distance_X_poissonvert),a
	jp		z,reinit_deplacement_poissonvert_droite
	ld		hl,(pos_x_poissonvert)
	ld		de,(vitesse_X_poissonvert)
	ld		d,0
	sbc		hl,de
	ld		(pos_x_poissonvert),hl
	ld		ix,(sprh_xyz_poissonvert)
	ld		(ix),hl
	ld		(ix+8),hl
	ret
reinit_deplacement_poissonvert_gauche
	ld		a,(distance_X_poissonvert_save)
	ld		(distance_X_poissonvert),a
	ld		a,2						; on va à gauche
	ld		(direction_poissonvert),a
	xor		a
	ld			(etape_anim_poissonvert),a
	ld		hl,Tableau_anim_poissonvert_gauche
	ld		(adr_des_animations_poissonvert),hl
	ld		hl,poisson_vert
	ld		(adr_poissonvert),hl
	ld		a,bank_sprh_ennemy2					; on choisit le no de bank
	ld		c,a
	call	rom_on		
	ld		hl,(adr_poissonvert)
	ld		de,(sprh_de_depart_poissonvert)						; destination ASIC
	ld		bc,#200								; on choisit 2 sprites
	LDIR										; PAF on copie
	call	rom_off								; on deconnecte la ROM
	ret
reinit_deplacement_poissonvert_droite
	ld		a,(distance_X_poissonvert_save)
	ld		(distance_X_poissonvert),a
	ld		a,1						; on va à gauche
	ld		(direction_poissonvert),a
	xor		a
	ld		(etape_anim_poissonvert),a
	ld		hl,Tableau_anim_poissonvert_droite
	ld		(adr_des_animations_poissonvert),hl
	ld		hl,poisson_vert+#800
	ld		(adr_poissonvert),hl

	ld		a,bank_sprh_ennemy2					; on choisit le no de bank
	ld		c,a
	call	rom_on		
	ld		hl,(adr_poissonvert)
	ld		de,(sprh_de_depart_poissonvert)						; destination ASIC
	ld		bc,#200								; on choisit 2 sprites
	LDIR										; PAF on copie
	call	rom_off								; on deconnecte la ROM
	
	ld		ix,(sprh_x_poissonvert)
	ld		(sprh_x_poissonvert),ix
	ld		hl,(pos_x_poissonvert_save)
	ld		(pos_x_poissonvert),hl
	ld		(ix),hl
	
	
	
	ld		ix,(sprh_y_poissonvert)

	ld		hl,(pos_y_poissonvert_save)
	ld		(pos_y_poissonvert),hl
	ld		(ix-8),hl
	inc		ix
	inc		ix
	
		
	inc		ix
	inc		ix
	inc		ix
	inc		ix 	
	
	; on se place sur la pos X du prochain sprite hard
; on initialise le sprite du haut
	ld		ix,(sprh_x_poissonvert)
	ld		hl,(pos_x_poissonvert_save)
	ld		(pos_x_poissonvert),hl
	ld		(ix),hl
	inc		ix
	inc		ix
	ld		ix,(sprh_y_poissonvert)
	
	ld		hl,(pos_y_poissonvert_save)
	ld		(pos_y_poissonvert),hl
	
	ld		(ix-8),hl
	ret

anim_poissonvert_1
		ld			a,(etape_anim_poissonvert)
		inc			a
		cp			a,4
		jp			z,reinit_anim_poissonvert_1
		ld			(etape_anim_poissonvert),a
		ld			hl,(adr_des_animations_poissonvert)
		inc			hl
		inc			hl
		ld			(adr_des_animations_poissonvert),hl
		ld			a,(hl)
		ld			e,a
		inc			hl
		ld			a,(hl)
		ld			d,a
		ld			(adr_poissonvert),de
	retour_reinit_anim_poissonvert_1
			ld		a,(animation_poissonvert_save)
			ld		(animation_poissonvert),a
			ld		a,bank_sprh_ennemy2				; on choisit le no de bank
			ld		c,a
			call	rom_on		
			ld		hl,(adr_poissonvert)
			ld		de,(sprh_de_depart_poissonvert)						; destination ASIC
			ld		bc,#200								; on choisit 1 sprites
			LDIR										; PAF on copie
			call	rom_off								; on deconnecte la ROM
			ld		hl,(pos_y_poissonvert)
			dec		l
			dec		l
			ld		(pos_y_poissonvert),hl
			ld		ix,(sprh_y_poissonvert)
			ld		(ix+-8),hl							
			ld		de,-16
			add		hl,de
			ld		(ix),hl
			ret
		reinit_anim_poissonvert_1
				ld		hl,Tableau_anim_poissonvert_droite
				ld		(adr_des_animations_poissonvert),hl
				ld		hl,poisson_vert
				ld		(adr_poissonvert),hl
				xor		a
				ld		(etape_anim_poissonvert),a
				jp		retour_reinit_anim_poissonvert_1
		
	anim_poissonvert_2
		ld			a,(etape_anim_poissonvert)
		inc			a
		cp			a,4
		jp		z,reinit_anim_poissonvert_2
		ld			(etape_anim_poissonvert),a
		ld			hl,(adr_des_animations_poissonvert)
		inc			hl
		inc			hl
		ld			(adr_des_animations_poissonvert),hl
		ld			a,(hl)
		ld			e,a
		inc			hl
		ld			a,(hl)
		ld			d,a
		ld			(adr_poissonvert),de
	retour_reinit_anim_poissonvert_2
			ld		a,(animation_poissonvert_save)
			ld		(animation_poissonvert),a
			ld		a,bank_sprh_ennemy2				; on choisit le no de bank
			ld		c,a
			call	rom_on		
			ld		hl,(adr_poissonvert)
			ld		de,(sprh_de_depart_poissonvert)						; destination ASIC
			ld		bc,#200								; on choisit 1 sprites
			LDIR										; PAF on copie
			call	rom_off								; on deconnecte la ROM
	ld		hl,(pos_y_poissonvert)
	inc		l
	inc		l
	ld		(pos_y_poissonvert),hl
	ld		ix,(sprh_y_poissonvert)
	ld		(ix+-8),hl							
	ld		de,-16
	add		hl,de
	ld		(ix),hl
	ret
		reinit_anim_poissonvert_2
		ld		hl,Tableau_anim_poissonvert_gauche
				ld		(adr_des_animations_poissonvert),hl
		
				ld		hl,poisson_vert+#800
				ld		(adr_poissonvert),hl
				xor		a
				ld		(etape_anim_poissonvert),a
				jp		retour_reinit_anim_poissonvert_2
				
Tableau_anim_poissonvert_droite
DW		poisson_vert,poisson_vert+#200,poisson_vert+#400,poisson_vert+#600
Tableau_anim_poissonvert_gauche
DW		poisson_vert+#800,poisson_vert+#A00,poisson_vert+#C00,poisson_vert+#E00




