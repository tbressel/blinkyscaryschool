; ///////////////////////////////////////////////////////////////////////////////////
; ///////////////////////////////////////////////////////////////////////////////////
; //////////////////              GESTION araigneebleue                       //////////
; ///////////////////////////////////////////////////////////////////////////////////
; ///////////////////////////////////////////////////////////////////////////////////

araigneebleue							; routine dédié aux ennemis de type #01
	ld		a,(etape_araigneebleue)
	or		a
	jp		z,init_araigneebleue
	or		a
	jp		nz,deplacement_araigneebleue
	ret
	init_araigneebleue
		; on recherche dans les tableau RAM où est l'ennemis de type 1
		ld 		hl,tableau_ennemy_RAM+3
		ld		b,4
		boucle_init_araigneebleue
			ld		a,(hl)
			cp		a,ennemis_araignee_bleu
			JP		z,on_continu_araigneebleue
			ld		de,16
			add		hl,de
			djnz	boucle_init_araigneebleue
		on_continu_araigneebleue
			dec		hl
			dec		hl
			dec		hl
			ld		de,tableau_araigneebleue
			ldi:ldi:ldi:ldi:ldi:ldi
			ldi:ldi:ldi:ldi:ldi:ldi
			ldi:ldi:ldi:ldi
	ld		a,(bank_araigneebleue)					; on choisit le no de bank
	ld		c,a
	call	rom_on								; on connecte la bank
	ld		hl,(adr_araigneebleue)
	ld		de,(sprh_de_depart_araigneebleue)						; destination ASIC
	ld		bc,#200								; on choisit 2 sprites
	LDIR										; PAF on copie
	call	rom_off								; on deconnecte la ROM
	
	ld		c,bank_programme_rom
	call	rom_on
	call	init_araigneebleue_ROM
	call	rom_off
; si on se trouve dans une piece non éclairé alors on éteinds les sprites	
	ld		a,(flag_lumiere)
	or		a
	ret		NZ
	xor		a
	ld		hl,(sprh_zoom_araigneebleue)
	ld		(hl),a
	ld		de,-8
	add		hl,de
	ld		(hl),a	
	ret
deplacement_araigneebleue
	ld		hl,(pos_x_araigneebleue)
	ld		(sprh_x_ennemis),hl
	ld		hl,(pos_y_araigneebleue)
	ld		(sprh_y_ennemis),hl
	call	collision_avec_blinky
	
	ld		a,(direction_araigneebleue)
	cp		a,1
	jp		z,deplacement_araigneebleue_bas
	cp		a,2
	jp		z,deplacement_araigneebleue_haut
deplacement_araigneebleue_bas
	ld		a,(animation_araigneebleue)
	dec		a
	ld		(animation_araigneebleue),a
	call	z,animation_araigneebleue_suivante
	ld		a,(distance_Y_araigneebleue)
	dec		a
	ld		(distance_Y_araigneebleue),a
	jp		z,reinit_deplacement_araigneebleue_haut
	ld		hl,(pos_y_araigneebleue)
	ld		de,(vitesse_Y_araigneebleue)
	ld		d,0
	add		hl,de
	ld		(pos_y_araigneebleue),hl
	ld		ix,(sprh_xyz_araigneebleue)
	ld		(ix+2),hl
	ld		de,-16
	add		hl,de
	ld		(ix+10),hl
	ret
deplacement_araigneebleue_haut
	ld		a,(animation_araigneebleue)
	dec		a
	ld		(animation_araigneebleue),a
	call	z,animation_araigneebleue_suivante
	ld		a,(distance_Y_araigneebleue)
	dec		a
	ld		(distance_Y_araigneebleue),a
	jp		z,reinit_deplacement_araigneebleue_bas
	ld		hl,(pos_y_araigneebleue)
	ld		de,(vitesse_Y_araigneebleue)
	ld		d,0
	sbc		hl,de
	ld		(pos_y_araigneebleue),hl
	ld		ix,(sprh_xyz_araigneebleue)
	ld		(ix+2),hl
	ld		de,-16
	add		hl,de
	ld		(ix+10),hl
	ret
reinit_deplacement_araigneebleue_haut
	ld		a,(distance_Y_araigneebleue_save)
	ld		(distance_Y_araigneebleue),a
	ld		a,2						; on va à gauche
	ld		(direction_araigneebleue),a
	ret
reinit_deplacement_araigneebleue_bas
	ld		a,(distance_Y_araigneebleue_save)
	ld		(distance_Y_araigneebleue),a
	ld		a,1						; on va à gauche
	ld		(direction_araigneebleue),a
	ret
animation_araigneebleue_suivante
	ld		hl,(adr_araigneebleue)
	bit		1,h
	jp		z,anim_araigneebleue_1
	jp		anim_araigneebleue_2
		anim_araigneebleue_1
			set		1,h		
			ld		(adr_araigneebleue),hl
			ld		a,(animation_araigneebleue_save)
			ld		(animation_araigneebleue),a
			ld		a,(bank_araigneebleue)					; on choisit le no de bank
			ld		c,a
			call	rom_on		
			ld		hl,(adr_araigneebleue)
			ld		de,(sprh_de_depart_araigneebleue)						; destination ASIC
			ld		bc,#200								; on choisit 2 sprites
			LDIR										; PAF on copie
			call	rom_off								; on deconnecte la ROM
			ret
		anim_araigneebleue_2
			res		1,h
			ld		(adr_araigneebleue),hl
			ld		a,(animation_araigneebleue_save)
			ld		(animation_araigneebleue),a
			ld		a,(bank_araigneebleue)					; on choisit le no de bank
			ld		c,a
			call	rom_on		
			ld		hl,(adr_araigneebleue)
			ld		de,(sprh_de_depart_araigneebleue)						; destination ASIC
			ld		bc,#200								; on choisit 2 sprites
			LDIR										; PAF on copie
			call	rom_off								; on deconnecte la ROM
			ret
