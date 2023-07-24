; ///////////////////////////////////////////////////////////////////////////////////
; ///////////////////////////////////////////////////////////////////////////////////
; //////////////////              GESTION araigneejaune                       //////////
; ///////////////////////////////////////////////////////////////////////////////////
; ///////////////////////////////////////////////////////////////////////////////////

araigneejaune							; routine dédié aux ennemis de type #01
	ld		a,(etape_araigneejaune)
	or		a
	jp		z,init_araigneejaune
	or		a
	jp		nz,deplacement_araigneejaune
	ret
	init_araigneejaune
		; on recherche dans les tableau RAM où est l'ennemis de type 1
		ld 		hl,tableau_ennemy_RAM+3
		ld		b,4
		boucle_init_araigneejaune
			ld		a,(hl)
			cp		a,ennemis_araignee_jaune
			JP		z,on_continu_araigneejaune
			ld		de,16
			add		hl,de
			djnz	boucle_init_araigneejaune
		on_continu_araigneejaune
			dec		hl
			dec		hl
			dec		hl
			ld		de,tableau_araigneejaune
			ldi:ldi:ldi:ldi:ldi:ldi
			ldi:ldi:ldi:ldi:ldi:ldi
			ldi:ldi:ldi:ldi
	ld		a,(bank_araigneejaune)					; on choisit le no de bank
	ld		c,a
	call	rom_on								; on connecte la bank
	ld		hl,(adr_araigneejaune)
	ld		de,(sprh_de_depart_araigneejaune)						; destination ASIC
	ld		bc,#200								; on choisit 2 sprites
	LDIR										; PAF on copie
	call	rom_off								; on deconnecte la ROM
	
	ld		c,bank_programme_rom
	call	rom_on
	call	init_araigneejaune_ROM
	call	rom_off
	

	; si on se trouve dans une piece non éclairé alors on éteinds les sprites	
	ld		a,(flag_lumiere)
	or		a
	ret		NZ
	xor		a
	ld		hl,(sprh_zoom_araigneejaune)
	ld		(hl),a
	ld		de,-8
	add		hl,de
	ld		(hl),a	
	ret
deplacement_araigneejaune
	ld		hl,(pos_x_araigneejaune)
	ld		(sprh_x_ennemis),hl
	ld		hl,(pos_y_araigneejaune)
	ld		(sprh_y_ennemis),hl
	call	collision_avec_blinky
	ld		a,(direction_araigneejaune)
	cp		a,1
	jp		z,deplacement_araigneejaune_bas
	cp		a,2
	jp		z,deplacement_araigneejaune_haut
deplacement_araigneejaune_bas
	ld		a,(animation_araigneejaune)
	dec		a
	ld		(animation_araigneejaune),a
	call	z,animation_araigneejaune_suivante
	ld		a,(distance_Y_araigneejaune)
	dec		a
	ld		(distance_Y_araigneejaune),a
	jp		z,reinit_deplacement_araigneejaune_haut
	ld		hl,(pos_y_araigneejaune)
	ld		de,(vitesse_Y_araigneejaune)
	ld		d,0
	add		hl,de
	ld		(pos_y_araigneejaune),hl
	ld		ix,(sprh_xyz_araigneejaune)
	ld		(ix+2),hl
	ld		de,-16
	add		hl,de
	ld		(ix+10),hl
	ret
deplacement_araigneejaune_haut
	ld		a,(animation_araigneejaune)
	dec		a
	ld		(animation_araigneejaune),a
	call	z,animation_araigneejaune_suivante
	ld		a,(distance_Y_araigneejaune)
	dec		a
	ld		(distance_Y_araigneejaune),a
	jp		z,reinit_deplacement_araigneejaune_bas
	ld		hl,(pos_y_araigneejaune)
	ld		de,(vitesse_Y_araigneejaune)
	ld		d,0
	sbc		hl,de
	ld		(pos_y_araigneejaune),hl
	ld		ix,(sprh_xyz_araigneejaune)
	ld		(ix+2),hl
	ld		de,-16
	add		hl,de
	ld		(ix+10),hl
	ret
reinit_deplacement_araigneejaune_haut
	ld		a,(distance_Y_araigneejaune_save)
	ld		(distance_Y_araigneejaune),a
	ld		a,2						; on va à gauche
	ld		(direction_araigneejaune),a
	ret
reinit_deplacement_araigneejaune_bas
	ld		a,(distance_Y_araigneejaune_save)
	ld		(distance_Y_araigneejaune),a
	ld		a,1						; on va à gauche
	ld		(direction_araigneejaune),a
	ret
animation_araigneejaune_suivante
	ld		hl,(adr_araigneejaune)
	bit		1,h
	jp		z,anim_araigneejaune_1
	jp		anim_araigneejaune_2
		anim_araigneejaune_1
			set		1,h		
			ld		(adr_araigneejaune),hl
			ld		a,(animation_araigneejaune_save)
			ld		(animation_araigneejaune),a
			ld		a,(bank_araigneejaune)					; on choisit le no de bank
			ld		c,a
			call	rom_on		
			ld		hl,(adr_araigneejaune)
			ld		de,(sprh_de_depart_araigneejaune)						; destination ASIC
			ld		bc,#200								; on choisit 2 sprites
			LDIR										; PAF on copie
			call	rom_off								; on deconnecte la ROM
			ret
		anim_araigneejaune_2
			res		1,h
			ld		(adr_araigneejaune),hl
			ld		a,(animation_araigneejaune_save)
			ld		(animation_araigneejaune),a
			ld		a,(bank_araigneejaune)					; on choisit le no de bank
			ld		c,a
			call	rom_on		
			ld		hl,(adr_araigneejaune)
			ld		de,(sprh_de_depart_araigneejaune)						; destination ASIC
			ld		bc,#200								; on choisit 2 sprites
			LDIR										; PAF on copie
			call	rom_off								; on deconnecte la ROM
			ret
