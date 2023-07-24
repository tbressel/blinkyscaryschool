; ///////////////////////////////////////////////////////////////////////////////////
; ///////////////////////////////////////////////////////////////////////////////////
; //////////////////              GESTION grenouille verte                       //////////
; ///////////////////////////////////////////////////////////////////////////////////
; ///////////////////////////////////////////////////////////////////////////////////

grenouilleverte							; routine dédié aux ennemis de type #01
	ld		a,(etape_grenouilleverte)
	or		a
	jp		z,init_grenouilleverte
	or		a
	jp		nz,deplacement_grenouilleverte
	ret
	init_grenouilleverte
		; on recherche dans les tableau RAM où est l'ennemis de type 1
		ld 		hl,tableau_ennemy_RAM+3
		ld		b,4
		boucle_init_grenouilleverte
			ld		a,(hl)
			cp		a,ennemis_grenouille_verte
			JP		z,on_continu_grenouilleverte
			ld		de,16
			add		hl,de
			djnz	boucle_init_grenouilleverte
		on_continu_grenouilleverte
			dec		hl
			dec		hl
			dec		hl
			ld		de,tableau_grenouilleverte
			ldi:ldi:ldi:ldi:ldi:ldi
			ldi:ldi:ldi:ldi:ldi:ldi
			ldi:ldi:ldi:ldi
	ld		a,(bank_grenouilleverte)					; on choisit le no de bank
	ld		c,a
	call	rom_on								; on connecte la bank
	ld		hl,(adr_grenouilleverte)
	ld		de,(sprh_de_depart_grenouilleverte)						; destination ASIC
	ld		bc,#100								; on choisit 2 sprites
	LDIR										; PAF on copie
	call	rom_off								; on deconnecte la ROM
	
	ld		c,bank_programme_rom
	call	rom_on
	call	init_grenouilleverte_ROM
	call	rom_off
	
	

	
	
	ld		a,(flag_lumiere)
	or		a
	ret		NZ
	
	xor		a
	ld		hl,(sprh_zoom_grenouilleverte)
	ld		(hl),a
	ret
	
	deplacement_grenouilleverte
	ld		hl,(pos_x_grenouilleverte)
	ld		(sprh_x_ennemis),hl
	ld		hl,(pos_y_grenouilleverte)
	ld		(sprh_y_ennemis),hl
	call	collision_avec_blinky
	ld		a,(flag_saut_grenouilleverte_en_cours)
	or	a
	jp		z,on_attend_le_saut_grenouilleverte
	
	ld		a,(animation_grenouilleverte)
	dec		a
	ld		(animation_grenouilleverte),a
	jp		z,on_change_anim_grenouilleverte
	
	ld		a,(vitesse_du_saut_grenouilleverte)
	ld		b,a
	ld		hl,(pos_y_grenouilleverte)
	ld		a,l
	sub		a,b						
	ld		l,a
	ld		(pos_y_grenouilleverte),hl			; posistion Y de Blinky - la gravité
	ld		ix,(sprh_xyz_grenouilleverte)
	ld		(ix+2),hl
	ld		hl,(pos_x_grenouilleverte)
	ld		de,(vitesse_X_grenouilleverte)
	sbc		hl,de
	ld		(pos_x_grenouilleverte),hl
	ld		(ix),hl
	
	
	
	
	ld		a,(gravite_du_saut_grenouilleverte)
	ld		b,a
	ld		a,(vitesse_du_saut_grenouilleverte)
	sub		a,b
	ld		(vitesse_du_saut_grenouilleverte),a
	ld		hl,(pos_y_grenouilleverte)
	ld		a,l
	ld		de,(pos_y_depart_grenouilleverte)
	cp		a,e
	jp		z,on_stop_le_saut_grenouilleverte
	ret
	

	on_attend_le_saut_grenouilleverte
	ld		a,(timing_saut_grenouilleverte)
	inc		a
	ld		(timing_saut_grenouilleverte),a
	cp		a,#40
	jp		z,on_prepare_saut_grenouilleverte
	cp		a,#80
	jp		z,on_authorise_saut_grenouilleverte
	cp		a,#A0
	jp		z,on_reinit_saut_grenouilleverte
	ret
	
	on_prepare_saut_grenouilleverte
	xor		a
	ld		(flag_saut_grenouilleverte_en_cours),a
	ld		hl,(adr_grenouilleverte)
	ld		de,#100
	add		hl,de
	ld		(adr_grenouilleverte),hl
	ld		c,bank_sprh_ennemy
	call	rom_on
	ld		hl,(adr_grenouilleverte)
	ld		de,(sprh_de_depart_grenouilleverte)
	ld		bc,#100
	LDIR
	call	rom_off
	ld		a,1
	ld		(animation_grenouilleverte),a
	ret
	
	on_authorise_saut_grenouilleverte
	ld		a,1
	ld		(flag_saut_grenouilleverte_en_cours),a
	ld		hl,(adr_grenouilleverte)
	ld		de,#100
	add		hl,de
	ld		(adr_grenouilleverte),hl
	ld		c,bank_sprh_ennemy
	call	rom_on
	ld		hl,(adr_grenouilleverte)
	ld		de,(sprh_de_depart_grenouilleverte)
	ld		bc,#100
	LDIR
	call	rom_off
	ld		a,1
	ld		(animation_grenouilleverte),a
	ld		a,(nbr_de_saut_grenouilleverte)
	dec		a
	ld		(nbr_de_saut_grenouilleverte),a
	ret
	
	on_change_anim_grenouilleverte
	ld		hl,(adr_grenouilleverte)
	ld		de,#100
	add		hl,de
	ld		(adr_grenouilleverte),hl
	ld		a,h
	condition_derniere_anim
	cp		a,#F0
	call	z,derniere_anim_grenouilleverte
	ld		c,bank_sprh_ennemy
	call	rom_on
	ld		hl,(adr_grenouilleverte)
	ld		de,(sprh_de_depart_grenouilleverte)
	ld		bc,#100
	LDIR
	call	rom_off
	ld		a,8
	ld		(animation_grenouilleverte),a
	ret
		derniere_anim_grenouilleverte
				ld	hl,#EF00
				ld	(adr_grenouilleverte),hl
				ret
	
	
	on_stop_le_saut_grenouilleverte
		xor		a
		ld		(flag_saut_grenouilleverte_en_cours),a
	on_reinit_saut_grenouilleverte
		xor		a
		ld		(timing_saut_grenouilleverte),a
		ld		(flag_saut_grenouilleverte_en_cours),a
		ld		a,10
		ld		(vitesse_du_saut_grenouilleverte),a					; init de la vitesse du saut
		ld		a,1
		ld		(gravite_du_saut_grenouilleverte),a					; init de la valeur qui va freiner dans sa crête
		ld		(animation_grenouilleverte),a
		ld		hl,4
		ld		(vitesse_X_grenouilleverte),hl
		ld		a,(nbr_de_saut_grenouilleverte)
		or		a
		jp		z,on_change_de_sens_grenouilleverte
		
		ld		c,bank_sprh_ennemy
		call	rom_on
		ld		hl,(adr_grenouilleverte)
		ld		de,(sprh_de_depart_grenouilleverte)
		ld		bc,#100
		LDIR
		call	rom_off
		ret
	
	on_change_de_sens_grenouilleverte
		; vers la droite
		
		ld		a,(direction_grenouilleverte)
		or		a
		jp		nz,on_va_vers_la_droite_grenouilleverte
on_continue_vers_la_gauche_grenouilleverte		
		ld		c,bank_sprh_ennemy
		call	rom_on
		ld		hl,GRENOUILLE_VERTE
		ld		(adr_grenouilleverte),hl
		ld		de,(sprh_de_depart_grenouilleverte)
		ld		bc,#100
		LDIR
		call	rom_off
		ld		a,#F0
		ld		(condition_derniere_anim+1),a
		ld		a,#ef
		ld		(derniere_anim_grenouilleverte+2),a
		ld		a,1
		ld		(direction_grenouilleverte),a
		
		ld		(nbr_de_saut_grenouilleverte),a
		ld		hl,4
		ld		(vitesse_X_grenouilleverte),hl
		ret
on_va_vers_la_droite_grenouilleverte		
		ld		c,bank_sprh_ennemy
		call	rom_on
		ld		hl,GRENOUILLE_VERTE+#400
		ld		(adr_grenouilleverte),hl
		ld		de,(sprh_de_depart_grenouilleverte)
		ld		bc,#100
		LDIR
		call	rom_off
		ld		a,#F4
		ld		(condition_derniere_anim+1),a
		ld		a,#F3
		ld		(derniere_anim_grenouilleverte+2),a
		ld		hl,-5
		ld		(vitesse_X_grenouilleverte),hl
		xor		a
		ld		(direction_grenouilleverte),a
		ld		a,1
		ld		(nbr_de_saut_grenouilleverte),a
		ret
	
	
	
	
	