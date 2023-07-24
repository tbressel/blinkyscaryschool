; ///////////////////////////////////////////////////////////////////////////////////
; ///////////////////////////////////////////////////////////////////////////////////
; //////////////////              GESTION escargotrouge                       //////////
; ///////////////////////////////////////////////////////////////////////////////////
; ///////////////////////////////////////////////////////////////////////////////////

escargotrouge							; routine dédié aux ennemis de type #01
	ld		a,(etape_escargotrouge)
	or		a
	jp		z,init_escargotrouge
	or		a
	jp		nz,deplacement_escargotrouge
	ret
	init_escargotrouge
		; on recherche dans les tableau RAM où est l'ennemis de type 1
		ld 		hl,tableau_ennemy_RAM+3
		ld		b,4
		boucle_init_escargotrouge
			ld		a,(hl)
			cp		a,ennemis_escargot_rouge
			JP		z,on_continu_escargotrouge
			ld		de,16
			add		hl,de
			djnz	boucle_init_escargotrouge
		on_continu_escargotrouge
			dec		hl
			dec		hl
			dec		hl
			ld		de,tableau_escargotrouge
			ldi:ldi:ldi:ldi:ldi:ldi
			ldi:ldi:ldi:ldi:ldi:ldi
			ldi:ldi:ldi:ldi
	ld		a,(bank_escargotrouge)					; on choisit le no de bank
	ld		c,a
	call	rom_on								; on connecte la bank
	ld		hl,(adr_escargotrouge)
	ld		de,(sprh_de_depart_escargotrouge)						; destination ASIC
	ld		bc,#200								; on choisit 2 sprites
	LDIR										; PAF on copie
	call	rom_off								; on deconnecte la ROM


ld		c,bank_programme_rom
	call	rom_on
	call	init_escargotrouge_ROM
	call	rom_off

		; si on se trouve dans une piece non éclairé alors on éteinds les sprites	
	ld		a,(flag_lumiere)
	or		a
	ret		NZ
	xor		a
	ld		hl,(sprh_zoom_escargotrouge)
	ld		(hl),a
	ld		de,-8
	add		hl,de
	ld		(hl),a	
	ret
deplacement_escargotrouge
	ld		hl,(pos_x_escargotrouge)
	ld		(sprh_x_ennemis),hl
	ld		hl,(pos_y_escargotrouge)
	ld		(sprh_y_ennemis),hl
	call	collision_avec_blinky
	ld		a,(direction_escargotrouge)
	cp		a,1
	jp		z,deplacement_escargotrouge_droite
	cp		a,2
	jp		z,deplacement_escargotrouge_gauche
deplacement_escargotrouge_droite
	ld		a,(animation_escargotrouge)
	dec		a
	ld		(animation_escargotrouge),a
	call	z,animation_escargotrouge_suivante
	ld		a,(distance_X_escargotrouge)
	dec		a
	ld		(distance_X_escargotrouge),a
	jp		z,reinit_deplacement_escargotrouge_gauche
	ld		hl,(pos_x_escargotrouge)
	ld		de,(vitesse_X_escargotrouge)
	ld		d,0
	add		hl,de
	ld		(pos_x_escargotrouge),hl
	ld		ix,(sprh_xyz_escargotrouge)
	ld		(ix),hl
	ld		(ix+8),hl
	ret
deplacement_escargotrouge_gauche
ld		a,(animation_escargotrouge)
	dec		a
	ld		(animation_escargotrouge),a
	call	z,animation_escargotrouge_suivante
	ld		a,(distance_X_escargotrouge)
	dec		a
	ld		(distance_X_escargotrouge),a
	jp		z,reinit_deplacement_escargotrouge_droite
	ld		hl,(pos_x_escargotrouge)
	ld		de,(vitesse_X_escargotrouge)
	ld		d,0
	sbc		hl,de
	ld		(pos_x_escargotrouge),hl
	ld		ix,(sprh_xyz_escargotrouge)
	ld		(ix),hl
	ld		(ix+8),hl
	ret
reinit_deplacement_escargotrouge_gauche
	ld		a,(distance_X_escargotrouge_save)
	ld		(distance_X_escargotrouge),a
	ld		a,2						; on va à gauche
	ld		(direction_escargotrouge),a
	ld		a,(bank_escargotrouge)					; on choisit le no de bank
	ld		c,a
	call	rom_on		
	ld		hl,(adr_escargotrouge)
	inc		h
	inc		h
	inc		h
	inc		h
	ld		(adr_escargotrouge),hl
	ld		de,(sprh_de_depart_escargotrouge)						; destination ASIC
	ld		bc,#200								; on choisit 2 sprites
	LDIR										; PAF on copie
	call	rom_off								; on deconnecte la ROM
	ret
reinit_deplacement_escargotrouge_droite
	ld		a,(distance_X_escargotrouge_save)
	ld		(distance_X_escargotrouge),a
	ld		a,1						; on va à gauche
	ld		(direction_escargotrouge),a
	ld		a,(bank_escargotrouge)					; on choisit le no de bank
	ld		c,a
	call	rom_on		
	ld		hl,(adr_escargotrouge)
	dec		h
	dec		h
	dec		h
	dec		h
	ld		(adr_escargotrouge),hl
	ld		de,(sprh_de_depart_escargotrouge)						; destination ASIC
	ld		bc,#200								; on choisit 2 sprites
	LDIR										; PAF on copie
	call	rom_off								; on deconnecte la ROM
	ret
animation_escargotrouge_suivante
	ld		hl,(adr_escargotrouge)
	bit		1,h
	jp		z,anim_escargotrouge_1
	jp		anim_escargotrouge_2
		anim_escargotrouge_1
			set		1,h		
			ld		(adr_escargotrouge),hl
			ld		a,(animation_escargotrouge_save)
			ld		(animation_escargotrouge),a
			ld		a,(bank_escargotrouge)					; on choisit le no de bank
			ld		c,a
			call	rom_on		
			ld		hl,(adr_escargotrouge)
			ld		de,(sprh_de_depart_escargotrouge)						; destination ASIC
			ld		bc,#200								; on choisit 2 sprites
			LDIR										; PAF on copie
			call	rom_off								; on deconnecte la ROM
			ret
		anim_escargotrouge_2
			res		1,h
			ld		(adr_escargotrouge),hl
			ld		a,(animation_escargotrouge_save)
			ld		(animation_escargotrouge),a
			ld		a,(bank_escargotrouge)					; on choisit le no de bank
			ld		c,a
			call	rom_on		
			ld		hl,(adr_escargotrouge)
			ld		de,(sprh_de_depart_escargotrouge)						; destination ASIC
			ld		bc,#200								; on choisit 2 sprites
			LDIR										; PAF on copie
			call	rom_off								; on deconnecte la ROM
			ret
