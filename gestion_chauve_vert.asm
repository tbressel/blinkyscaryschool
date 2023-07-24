; ///////////////////////////////////////////////////////////////////////////////////
; ///////////////////////////////////////////////////////////////////////////////////
; //////////////////              GESTION chauvevert                       //////////
; ///////////////////////////////////////////////////////////////////////////////////
; ///////////////////////////////////////////////////////////////////////////////////

chauvevert							; routine dédié aux ennemis de type #01
	ld		a,(etape_chauvevert)
	OR		a
	jp		z,init_chauvevert
	or		a
	jp		nz,deplacement_chauvevert
	ret
	init_chauvevert
		; on recherche dans les tableau RAM où est l'ennemis de type 1
		ld 		hl,tableau_ennemy_RAM+3
		ld		b,4
		boucle_init_chauvevert
			ld		a,(hl)
			cp		a,ennemis_chauve_vert
			JP		z,on_continu_chauvevert
			ld		de,16
			add		hl,de
			djnz	boucle_init_chauvevert
		on_continu_chauvevert
			dec		hl
			dec		hl
			dec		hl
			ld		de,tableau_chauvevert
			ldi:ldi:ldi:ldi:ldi:ldi
			ldi:ldi:ldi:ldi:ldi:ldi
			ldi:ldi:ldi:ldi
	ld		a,(bank_chauvevert)					; on choisit le no de bank
	ld		c,a
	call	rom_on								; on connecte la bank
	ld		hl,(adr_chauvevert)
	ld		de,(sprh_de_depart_chauvevert)						; destination ASIC
	ld		bc,#100								; on choisit 2 sprites
	LDIR										; PAF on copie
	call	rom_off								; on deconnecte la ROM
	
	
	
		
	ld		c,bank_programme_rom
	call	rom_on
	call	init_chauvevert_ROM
	call	rom_off


	; si on se trouve dans une piece non éclairé alors on éteinds les sprites		
	ld		a,(flag_lumiere)
	or		a
	ret		NZ
	xor		a
	ld		hl,(sprh_zoom_chauvevert)
	ld		(hl),a
	ret
deplacement_chauvevert
	ld		hl,(pos_x_chauvevert)
	ld		(sprh_x_ennemis),hl
	ld		hl,(pos_y_chauvevert)
	ld		(sprh_y_ennemis),hl
	call	collision_avec_blinky
	ld		a,(direction_chauvevert)
	cp		a,1
	jp		z,deplacement_chauvevert_droite
	cp		a,2
	jp		z,deplacement_chauvevert_gauche
deplacement_chauvevert_droite
	ld		a,(animation_chauvevert)
	dec		a
	ld		(animation_chauvevert),a
	call	z,anim_chauvevert_1
	ld		a,(distance_X_chauvevert)
	dec		a
	ld		(distance_X_chauvevert),a
	jp		z,reinit_deplacement_chauvevert_gauche
	ld		hl,(pos_x_chauvevert)
	ld		de,(vitesse_X_chauvevert)
	ld		d,0
	add		hl,de
	ld		(pos_x_chauvevert),hl
	ld		ix,(sprh_x_chauvevert)
	ld		(ix),hl
	ret
deplacement_chauvevert_gauche
	ld		a,(animation_chauvevert)
	dec		a
	ld		(animation_chauvevert),a
	call	z,anim_chauvevert_2
	ld		a,(distance_X_chauvevert)
	dec		a
	ld		(distance_X_chauvevert),a
	jp		z,reinit_deplacement_chauvevert_droite
	ld		hl,(pos_x_chauvevert)
	ld		de,(vitesse_X_chauvevert)
	ld		d,0
	sbc		hl,de
	ld		(pos_x_chauvevert),hl
	ld		ix,(sprh_x_chauvevert)
	ld		(ix),hl
	ret
reinit_deplacement_chauvevert_gauche
	ld		a,(distance_X_chauvevert_save)
	ld		(distance_X_chauvevert),a
	ld		a,2						; on va à gauche
	ld		(direction_chauvevert),a
	xor		a
	ld		(etape_anim_chauvevert),a
	ld		hl,Tableau_anim_chauvevert_gauche
	ld		(adr_des_animations_chauvevert),hl
	ld		hl,CHAUVE_vert+#600
	ld		(adr_chauvevert),hl
	ld		a,(bank_chauvevert)					; on choisit le no de bank
	ld		c,a
	call	rom_on		
	ld		hl,(adr_chauvevert)
	ld		de,(sprh_de_depart_chauvevert)						; destination ASIC
	ld		bc,#100								; on choisit 2 sprites
	LDIR										; PAF on copie
	call	rom_off								; on deconnecte la ROM
	ret
reinit_deplacement_chauvevert_droite
	ld		a,(distance_X_chauvevert_save)
	ld		(distance_X_chauvevert),a
	ld		a,1						; on va à gauche
	ld		(direction_chauvevert),a
	xor		a
	ld		(etape_anim_chauvevert),a
	ld		hl,Tableau_anim_chauvevert_droite
	ld		(adr_des_animations_chauvevert),hl
	ld		hl,CHAUVE_vert
	ld		(adr_chauvevert),hl
	ld		a,(bank_chauvevert)					; on choisit le no de bank
	ld		c,a
	call	rom_on		
	ld		hl,(adr_chauvevert)
	ld		de,(sprh_de_depart_chauvevert)						; destination ASIC
	ld		bc,#100								; on choisit 2 sprites
	LDIR										; PAF on copie
	call	rom_off								; on deconnecte la ROM
	ret
anim_chauvevert_1
		ld			a,(etape_anim_chauvevert)
		inc			a
		cp			a,7
		jp			z,reinit_anim_chauvevert_1
		ld			(etape_anim_chauvevert),a
		ld			hl,(adr_des_animations_chauvevert)
		inc			hl
		inc			hl
		ld			(adr_des_animations_chauvevert),hl
		ld			a,(hl)
		ld			e,a
		inc			hl
		ld			a,(hl)
		ld			d,a
		ld			(adr_chauvevert),de
	retour_reinit_anim_chauvevert_1
			ld		a,(animation_chauvevert_save)
			ld		(animation_chauvevert),a
			ld		a,(bank_chauvevert)					; on choisit le no de bank
			ld		c,a
			call	rom_on		
			ld		hl,(adr_chauvevert)
			ld		de,(sprh_de_depart_chauvevert)						; destination ASIC
			ld		bc,#100								; on choisit 1 sprites
			LDIR										; PAF on copie
			call	rom_off								; on deconnecte la ROM
			ret
		reinit_anim_chauvevert_1
				ld		hl,Tableau_anim_chauvevert_droite
				ld		(adr_des_animations_chauvevert),hl
				ld		hl,CHAUVE_vert
				ld		(adr_chauvevert),hl
				xor		a
				ld		(etape_anim_chauvevert),a
				jp		retour_reinit_anim_chauvevert_1
		
	anim_chauvevert_2
		ld			a,(etape_anim_chauvevert)
		inc			a
		cp			a,7
		jp			z,reinit_anim_chauvevert_2
		ld			(etape_anim_chauvevert),a
		ld			hl,(adr_des_animations_chauvevert)
		inc			hl
		inc			hl
		ld			(adr_des_animations_chauvevert),hl
		ld			a,(hl)
		ld			e,a
		inc			hl
		ld			a,(hl)
		ld			d,a
		ld			(adr_chauvevert),de
	retour_reinit_anim_chauvevert_2
			ld		a,(animation_chauvevert_save)
			ld		(animation_chauvevert),a
			ld		a,(bank_chauvevert)					; on choisit le no de bank
			ld		c,a
			call	rom_on		
			ld		hl,(adr_chauvevert)
			ld		de,(sprh_de_depart_chauvevert)						; destination ASIC
			ld		bc,#100								; on choisit 1 sprites
			LDIR										; PAF on copie
			call	rom_off								; on deconnecte la ROM
			ret
		reinit_anim_chauvevert_2
				ld		hl,Tableau_anim_chauvevert_gauche
				ld		(adr_des_animations_chauvevert),hl
				ld		hl,CHAUVE_vert+#600
				ld		(adr_chauvevert),hl
				xor		a
				ld		(etape_anim_chauvevert),a
				jp		retour_reinit_anim_chauvevert_2
				
Tableau_anim_chauvevert_droite
DW		CHAUVE_VERT,CHAUVE_VERT+#100,CHAUVE_VERT+#200,CHAUVE_VERT+#300,CHAUVE_VERT+#400,CHAUVE_VERT+#500,CHAUVE_VERT+#200
Tableau_anim_chauveVERT_gauche
DW		CHAUVE_VERT+#600,CHAUVE_VERT+#700,CHAUVE_VERT+#800,CHAUVE_VERT+#900,CHAUVE_VERT+#A00,CHAUVE_VERT+#B00,CHAUVE_VERT+#800



