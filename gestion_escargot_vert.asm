; ///////////////////////////////////////////////////////////////////////////////////
; ///////////////////////////////////////////////////////////////////////////////////
; //////////////////              GESTION escargotvert                       //////////
; ///////////////////////////////////////////////////////////////////////////////////
; ///////////////////////////////////////////////////////////////////////////////////

escargotvert							; routine dédié aux ennemis de type #01
	ld		a,(etape_escargotvert)
	or		a
	jp		z,init_escargotvert
	or		a
	jp		nz,deplacement_escargotvert
	ret
	init_escargotvert
		; on recherche dans les tableau RAM où est l'ennemis de type 1
		ld 		hl,tableau_ennemy_RAM+3
		ld		b,4
		boucle_init_escargotvert
			ld		a,(hl)
			cp		a,ennemis_escargot_vert
			JP		z,on_continu_escargotvert
			ld		de,16
			add		hl,de
			djnz	boucle_init_escargotvert
		on_continu_escargotvert
			dec		hl
			dec		hl
			dec		hl
			ld		de,tableau_escargotvert
			ldi:ldi:ldi:ldi:ldi:ldi
			ldi:ldi:ldi:ldi:ldi:ldi
			ldi:ldi:ldi:ldi
	ld		a,(bank_escargotvert)					; on choisit le no de bank
	ld		c,a
	call	rom_on								; on connecte la bank
	ld		hl,(adr_escargotvert)
	ld		de,(sprh_de_depart_escargotvert)						; destination ASIC
	ld		bc,#200								; on choisit 2 sprites
	LDIR										; PAF on copie
	call	rom_off								; on deconnecte la ROM


	ld		c,bank_programme_rom
	call	rom_on
	call	init_escargotvert_ROM
	call	rom_off
	
	
		; si on se trouve dans une piece non éclairé alors on éteinds les sprites	
	ld		a,(flag_lumiere)
	or		a
	ret		NZ
	xor		a
	ld		hl,(sprh_zoom_escargotvert)
	ld		(hl),a
	ld		de,-8
	add		hl,de
	ld		(hl),a	
	ret
deplacement_escargotvert
	ld		hl,(pos_x_escargotvert)
	ld		(sprh_x_ennemis),hl
	ld		hl,(pos_y_escargotvert)
	ld		(sprh_y_ennemis),hl
	call	collision_avec_blinky
	ld		a,(direction_escargotvert)
	cp		a,1
	jp		z,deplacement_escargotvert_droite
	cp		a,2
	jp		z,deplacement_escargotvert_gauche
deplacement_escargotvert_droite
	ld		a,(animation_escargotvert)
	dec		a
	ld		(animation_escargotvert),a
	call	z,animation_escargotvert_suivante
	ld		a,(distance_X_escargotvert)
	dec		a
	ld		(distance_X_escargotvert),a
	jp		z,reinit_deplacement_escargotvert_gauche
	ld		hl,(pos_x_escargotvert)
	ld		de,(vitesse_X_escargotvert)
	ld		d,0
	add		hl,de
	ld		(pos_x_escargotvert),hl
	ld		ix,(sprh_xyz_escargotvert)
	ld		(ix),hl
	ld		(ix+8),hl
	ret
deplacement_escargotvert_gauche
	ld		a,(animation_escargotvert)
	dec		a
	ld		(animation_escargotvert),a
	call	z,animation_escargotvert_suivante
	ld		a,(distance_X_escargotvert)
	dec		a
	ld		(distance_X_escargotvert),a
	jp		z,reinit_deplacement_escargotvert_droite
	ld		hl,(pos_x_escargotvert)
	ld		de,(vitesse_X_escargotvert)
	ld		d,0
	sbc		hl,de
	ld		(pos_x_escargotvert),hl
	ld		ix,(sprh_xyz_escargotvert)
	ld		(ix),hl
	ld		(ix+8),hl
	ret
reinit_deplacement_escargotvert_gauche
	ld		a,(distance_X_escargotvert_save)
	ld		(distance_X_escargotvert),a
	ld		a,2						; on va à gauche
	ld		(direction_escargotvert),a
	ld		a,(bank_escargotvert)					; on choisit le no de bank
	ld		c,a
	call	rom_on		
	ld		hl,(adr_escargotvert)
	inc		h
	inc		h
	inc		h
	inc		h
	ld		(adr_escargotvert),hl
	ld		de,(sprh_de_depart_escargotvert)						; destination ASIC
	ld		bc,#200								; on choisit 2 sprites
	LDIR										; PAF on copie
	call	rom_off								; on deconnecte la ROM
	ret
reinit_deplacement_escargotvert_droite
	ld		a,(distance_X_escargotvert_save)
	ld		(distance_X_escargotvert),a
	ld		a,1						; on va à gauche
	ld		(direction_escargotvert),a
	ld		a,(bank_escargotvert)					; on choisit le no de bank
	ld		c,a
	call	rom_on		
	ld		hl,(adr_escargotvert)
	dec		h
	dec		h
	dec		h
	dec		h
	ld		(adr_escargotvert),hl
	ld		de,(sprh_de_depart_escargotvert)						; destination ASIC
	ld		bc,#200								; on choisit 2 sprites
	LDIR										; PAF on copie
	call	rom_off								; on deconnecte la ROM
	ret
animation_escargotvert_suivante
	ld		hl,(adr_escargotvert)
	bit		1,h
	jp		z,anim_escargotvert_1
	jp		anim_escargotvert_2
		anim_escargotvert_1
			set		1,h		
			ld		(adr_escargotvert),hl
			ld		a,(animation_escargotvert_save)
			ld		(animation_escargotvert),a
			ld		a,(bank_escargotvert)					; on choisit le no de bank
			ld		c,a
			call	rom_on		
			ld		hl,(adr_escargotvert)
			ld		de,(sprh_de_depart_escargotvert)						; destination ASIC
			ld		bc,#200								; on choisit 2 sprites
			LDIR										; PAF on copie
			call	rom_off								; on deconnecte la ROM
			ret
		anim_escargotvert_2
			res		1,h
			ld		(adr_escargotvert),hl
			ld		a,(animation_escargotvert_save)
			ld		(animation_escargotvert),a
			ld		a,(bank_escargotvert)					; on choisit le no de bank
			ld		c,a
			call	rom_on		
			ld		hl,(adr_escargotvert)
			ld		de,(sprh_de_depart_escargotvert)						; destination ASIC
			ld		bc,#200								; on choisit 2 sprites
			LDIR										; PAF on copie
			call	rom_off								; on deconnecte la ROM
			ret
