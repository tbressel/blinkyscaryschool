; ///////////////////////////////////////////////////////////////////////////////////
; ///////////////////////////////////////////////////////////////////////////////////
; //////////////////              GESTION grenouille rouge                       //////////
; ///////////////////////////////////////////////////////////////////////////////////
; ///////////////////////////////////////////////////////////////////////////////////

grenouillerouge							; routine dédié aux ennemis de type #01
	ld		a,(etape_grenouillerouge)
	or	a
	jp		z,init_grenouillerouge
	or	a
	jp		nz,deplacement_grenouillerouge
	ret
	init_grenouillerouge
		; on recherche dans les tableau RAM où est l'ennemis de type 1
		ld 		hl,tableau_ennemy_RAM+3
		ld		b,4
		boucle_init_grenouillerouge
			ld		a,(hl)
			cp		a,ennemis_grenouille_rouge
			JP		z,on_continu_grenouillerouge
			ld		de,16
			add		hl,de
			djnz	boucle_init_grenouillerouge
		on_continu_grenouillerouge
			dec		hl
			dec		hl
			dec		hl
			ld		de,tableau_grenouillerouge
			ldi:ldi:ldi:ldi:ldi:ldi
			ldi:ldi:ldi:ldi:ldi:ldi
			ldi:ldi:ldi:ldi
	ld		a,(bank_grenouillerouge)					; on choisit le no de bank
	ld		c,a
	call	rom_on								; on connecte la bank
	ld		hl,(adr_grenouillerouge)
	ld		de,(sprh_de_depart_grenouillerouge)						; destination ASIC
	ld		bc,#100								; on choisit 2 sprites
	LDIR										; PAF on copie
	call	rom_off								; on deconnecte la ROM
	
	ld		c,bank_programme_rom
	call	rom_on
	call	init_grenouillerouge_ROM
	call	rom_off
	

	ld		a,(flag_lumiere)
	cp		a,1
	ret		Z
	
	xor		a
	ld		hl,(sprh_zoom_grenouillerouge)
	ld		(hl),a
	ret
	
	deplacement_grenouillerouge
	ld		hl,(pos_x_grenouillerouge)
	ld		(sprh_x_ennemis),hl
	ld		hl,(pos_y_grenouillerouge)
	ld		(sprh_y_ennemis),hl
	call	collision_avec_blinky

	ld		a,(flag_saut_grenouillerouge_en_cours)
	or	a
	jp		z,on_attend_le_saut_grenouillerouge
	
	or		a
	ld		a,(animation_grenouillerouge)
	dec		a
	ld		(animation_grenouillerouge),a
	jp		z,on_change_anim_grenouillerouge
	
	ld		a,(vitesse_du_saut_grenouillerouge)
	ld		b,a
	ld		hl,(pos_y_grenouillerouge)
	ld		a,l
	sub		a,b						
	ld		l,a
	ld		(pos_y_grenouillerouge),hl			; posistion Y de Blinky - la gravité
	ld		ix,(sprh_xyz_grenouillerouge)
	ld		(ix+2),hl
	ld		hl,(pos_x_grenouillerouge)
	ld		de,(vitesse_X_grenouillerouge)
	sbc		hl,de
	ld		(pos_x_grenouillerouge),hl
	ld		(ix),hl
	
	
	
	
	ld		a,(gravite_du_saut_grenouillerouge)
	ld		b,a
	ld		a,(vitesse_du_saut_grenouillerouge)
	sub		a,b
	ld		(vitesse_du_saut_grenouillerouge),a
	ld		hl,(pos_y_grenouillerouge)
	ld		a,l
	ld		de,(pos_y_depart_grenouillerouge)
	cp		a,e
	jp		z,on_stop_le_saut_grenouillerouge
	ret
	

	on_attend_le_saut_grenouillerouge
	ld		a,(timing_saut_grenouillerouge)
	inc		a
	ld		(timing_saut_grenouillerouge),a
	cp		a,#25
	jp		z,on_prepare_saut_grenouillerouge
	cp		a,#50
	jp		z,on_authorise_saut_grenouillerouge
	cp		a,#80
	jp		z,on_reinit_saut_grenouillerouge
	ret
	
	on_prepare_saut_grenouillerouge
	xor		a
	ld		(flag_saut_grenouillerouge_en_cours),a
	ld		hl,(adr_grenouillerouge)
	ld		de,#100
	add		hl,de
	ld		(adr_grenouillerouge),hl
	ld		c,bank_sprh_ennemy
	call	rom_on
	ld		hl,(adr_grenouillerouge)
	ld		de,(sprh_de_depart_grenouillerouge)
	ld		bc,#100
	LDIR
	call	rom_off
	ld		a,1
	ld		(animation_grenouillerouge),a
	ret
	
	on_authorise_saut_grenouillerouge
	ld		a,1
	ld		(flag_saut_grenouillerouge_en_cours),a
	ld		hl,(adr_grenouillerouge)
	ld		de,#100
	add		hl,de
	ld		(adr_grenouillerouge),hl
	ld		c,bank_sprh_ennemy
	call	rom_on
	ld		hl,(adr_grenouillerouge)
	ld		de,(sprh_de_depart_grenouillerouge)
	ld		bc,#100
	LDIR
	call	rom_off
		ld		a,1
	ld		(animation_grenouillerouge),a
	ld		a,(nbr_de_saut_grenouillerouge)
	dec		a
	ld		(nbr_de_saut_grenouillerouge),a
	ret
	
	on_change_anim_grenouillerouge
	ld		hl,(adr_grenouillerouge)
	ld		de,#100
	add		hl,de
	ld		(adr_grenouillerouge),hl
	ld		a,h
	condition_derniere_anim2
	cp		a,#F0
	call	z,derniere_anim_grenouillerouge
	ld		c,bank_sprh_ennemy
	call	rom_on
	ld		hl,(adr_grenouillerouge)
	ld		de,(sprh_de_depart_grenouillerouge)
	ld		bc,#100
	LDIR
	call	rom_off
	ld		a,8
	ld		(animation_grenouillerouge),a
	ret
		derniere_anim_grenouillerouge
				ld	hl,#EF00
				ld	(adr_grenouillerouge),hl
				ret
	
	
	on_stop_le_saut_grenouillerouge
		xor		a
		ld		(flag_saut_grenouillerouge_en_cours),a
	on_reinit_saut_grenouillerouge
		xor		a
		ld		(timing_saut_grenouillerouge),a
		ld		(flag_saut_grenouillerouge_en_cours),a
		ld		a,10
		ld		(vitesse_du_saut_grenouillerouge),a					; init de la vitesse du saut
		ld		a,1
		ld		(gravite_du_saut_grenouillerouge),a					; init de la valeur qui va freiner dans sa crête
		ld		(animation_grenouillerouge),a
		ld		hl,4
		ld		(vitesse_X_grenouillerouge),hl
	
		ld		a,(nbr_de_saut_grenouillerouge)
		or		a
		jp		z,on_change_de_sens_grenouillerouge
		
		ld		c,bank_sprh_ennemy
		call	rom_on
		ld		hl,(adr_grenouillerouge)
		ld		de,(sprh_de_depart_grenouillerouge)
		ld		bc,#100
		LDIR
		call	rom_off
		ret
	
	on_change_de_sens_grenouillerouge
		; vers la droite
		
		ld		a,(direction_grenouillerouge)
		or		a
		jp		nz,on_va_vers_la_droite_grenouillerouge
on_continue_vers_la_gauche_grenouillerouge		
		ld		c,bank_sprh_ennemy
		call	rom_on
		ld		hl,GRENOUILLE_rouge
		ld		(adr_grenouillerouge),hl
		ld		de,(sprh_de_depart_grenouillerouge)
		ld		bc,#100
		LDIR
		call	rom_off
		ld		a,#F0
		ld		(condition_derniere_anim2+1),a
		ld		a,#ef
		ld		(derniere_anim_grenouillerouge+2),a
		ld		a,1
		ld		(direction_grenouillerouge),a
		ld		(nbr_de_saut_grenouillerouge),a
		ld		hl,4
		ld		(vitesse_X_grenouillerouge),hl
		ret
on_va_vers_la_droite_grenouillerouge		
		ld		c,bank_sprh_ennemy
		call	rom_on
		ld		hl,GRENOUILLE_rouge+#400
		ld		(adr_grenouillerouge),hl
		ld		de,(sprh_de_depart_grenouillerouge)
		ld		bc,#100
		LDIR
		call	rom_off
		ld		a,#F4
		ld		(condition_derniere_anim2+1),a
		ld		a,#F3
		ld		(derniere_anim_grenouillerouge+2),a
		ld		hl,-5
		ld		(vitesse_X_grenouillerouge),hl
		xor		a
		ld		(direction_grenouillerouge),a
		ld		a,1
		ld		(nbr_de_saut_grenouillerouge),a
		ret
	
	
	
	
	