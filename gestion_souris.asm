; ///////////////////////////////////////////////////////////////////////////////////
; ///////////////////////////////////////////////////////////////////////////////////
; //////////////////              GESTION SOURIS                       //////////
; ///////////////////////////////////////////////////////////////////////////////////
; ///////////////////////////////////////////////////////////////////////////////////

souris							; routine dédié aux ennemis de type #01
	ld		a,(etape_souris)
	or	a
	jp		z,init_souris
	or	a
	jp		nz,deplacement_souris
	ret
	init_souris
		; on recherche dans les tableau RAM où est l'ennemis de type 1
		ld 		hl,tableau_ennemy_RAM+3
		ld		b,4
		boucle_init_souris
			ld		a,(hl)
			cp		a,ennemis_souris
			JP		z,on_continu_souris
			ld		de,16
			add		hl,de
			djnz	boucle_init_souris
		on_continu_souris
			dec		hl
			dec		hl
			dec		hl
			ld		de,tableau_souris
			ldi:ldi:ldi:ldi:ldi:ldi
			ldi:ldi:ldi:ldi:ldi:ldi
			ldi:ldi:ldi:ldi
	ld		a,(bank_souris)					; on choisit le no de bank
	ld		c,a
	call	rom_on								; on connecte la bank
	ld		hl,(adr_souris)
	ld		de,(sprh_de_depart_souris)						; destination ASIC
	ld		bc,#100								; on choisit 2 sprites
	LDIR										; PAF on copie
	call	rom_off								; on deconnecte la ROM
	
	
	ld		ix,(sprh_xyz_souris)
	ld		(sprh_x_souris),ix
	ld		hl,(pos_x_souris)
	ld		(ix),hl
	inc		ix
	inc		ix
	
	ld		(sprh_y_souris),ix
	ld		hl,(pos_y_souris)
	ld		(ix),hl
	inc		ix
	inc		ix
	ld		(sprh_zoom_souris),ix
	ld		a,ZOOM_mode_0						; on choisit son mode de zoom
	ld		(ix),a						; on allume les 4 sprites hard
	
	ld		a,(distance_X_souris)
	ld		(distance_X_souris_save),a
	ld		a,1
	ld		(etape_souris),a
	ld		(direction_souris),a
	ld		a,4
	ld		(animation_souris),a
	ld		(animation_souris_save),a
	
	ld		a,(flag_lumiere)
	or		a
	ret		NZ
	
	xor		a
	ld		hl,(sprh_zoom_souris)
	ld		(hl),a
	ret
deplacement_souris
	ld		hl,(pos_x_souris)
	ld		(sprh_x_ennemis),hl
	ld		hl,(pos_y_souris)
	ld		(sprh_y_ennemis),hl
	call	collision_avec_blinky
	
	ld		a,(direction_souris)
	cp		a,1
	jp		z,deplacement_souris_droite
	cp		a,2
	jp		z,deplacement_souris_gauche
deplacement_souris_droite
	ld		a,(animation_souris)
	dec		a
	ld		(animation_souris),a
	call	z,animation_souris_suivante
	ld		a,(distance_X_souris)
	dec		a
	ld		(distance_X_souris),a
	jp		z,reinit_deplacement_souris_gauche
	ld		hl,(pos_x_souris)
	ld		de,(vitesse_X_souris)
	ld		d,0
	add		hl,de
	ld		(pos_x_souris),hl
	ld		ix,(sprh_x_souris)
	ld		(ix),hl
	ret
deplacement_souris_gauche
	ld		a,(animation_souris)
	dec		a
	ld		(animation_souris),a
	call	z,animation_souris_suivante
	ld		a,(distance_X_souris)
	dec		a
	ld		(distance_X_souris),a
	jp		z,reinit_deplacement_souris_droite
	ld		hl,(pos_x_souris)
	ld		de,(vitesse_X_souris)
	ld		d,0
	sbc		hl,de
	ld		(pos_x_souris),hl
	ld		ix,(sprh_x_souris)
	ld		(ix),hl
	ret
reinit_deplacement_souris_gauche
	ld		a,(distance_X_souris_save)
	ld		(distance_X_souris),a
	ld		a,2						; on va à gauche
	ld		(direction_souris),a
	ld		a,(bank_souris)					; on choisit le no de bank
	ld		c,a
	call	rom_on		
	ld		hl,(adr_souris)
	inc		h
	inc		h
	ld		(adr_souris),hl
	ld		de,(sprh_de_depart_souris)						; destination ASIC
	ld		bc,#100								; on choisit 2 sprites
	LDIR										; PAF on copie
	call	rom_off								; on deconnecte la ROM
	ret
reinit_deplacement_souris_droite
	ld		a,(distance_X_souris_save)
	ld		(distance_X_souris),a
	ld		a,1						; on va à gauche
	ld		(direction_souris),a
	ld		a,(bank_souris)					; on choisit le no de bank
	ld		c,a
	call	rom_on		
	ld		hl,(adr_souris)
	dec		h
	dec		h
	ld		(adr_souris),hl
	ld		de,(sprh_de_depart_souris)						; destination ASIC
	ld		bc,#100								; on choisit 2 sprites
	LDIR										; PAF on copie
	call	rom_off								; on deconnecte la ROM
	ret
animation_souris_suivante
	ld		hl,(adr_souris)
	bit		0,h
	jp		z,anim_souris_1
	jp		anim_souris_2
		anim_souris_1
			set		0,h		
			ld		(adr_souris),hl
			ld		a,(animation_souris_save)
			ld		(animation_souris),a
			ld		a,(bank_souris)					; on choisit le no de bank
			ld		c,a
			call	rom_on		
			ld		hl,(adr_souris)
			ld		de,(sprh_de_depart_souris)						; destination ASIC
			ld		bc,#100								; on choisit 2 sprites
			LDIR										; PAF on copie
			call	rom_off								; on deconnecte la ROM
			ret
		anim_souris_2
			res		0,h
			ld		(adr_souris),hl
			ld		a,(animation_souris_save)
			ld		(animation_souris),a
			ld		a,(bank_souris)					; on choisit le no de bank
			ld		c,a
			call	rom_on		
			ld		hl,(adr_souris)
			ld		de,(sprh_de_depart_souris)						; destination ASIC
			ld		bc,#100								; on choisit 2 sprites
			LDIR										; PAF on copie
			call	rom_off								; on deconnecte la ROM
			ret
