; ///////////////////////////////////////////////////////////////////////////////////
; ///////////////////////////////////////////////////////////////////////////////////
; //////////////////              GESTION poissonrouge                       //////////
; ///////////////////////////////////////////////////////////////////////////////////
; ///////////////////////////////////////////////////////////////////////////////////

poissonrouge							; routine dédié aux ennemis de type #01
	ld		a,(etape_poissonrouge)
	or	a
	jp		z,init_poissonrouge
	or	a
	jp		nz,deplacement_poissonrouge
	ret
	init_poissonrouge
		; on recherche dans les tableau RAM où est l'ennemis de type 1
		ld 		hl,tableau_ennemy_RAM+3
		ld		b,4
		boucle_init_poissonrouge
			ld		a,(hl)
			cp		a,ennemis_poisson_rouge
			JP		z,on_continu_poissonrouge
			ld		de,16
			add		hl,de
			djnz	boucle_init_poissonrouge
		on_continu_poissonrouge
			dec		hl
			dec		hl
			dec		hl
			ld		de,tableau_poissonrouge
			ldi:ldi:ldi:ldi:ldi:ldi
			ldi:ldi:ldi:ldi:ldi:ldi
			ldi:ldi:ldi:ldi
	ld		a,bank_sprh_ennemy2				; on choisit le no de bank
	ld		c,a
	call	rom_on								; on connecte la bank
	ld		hl,(adr_poissonrouge)
	ld		de,(sprh_de_depart_poissonrouge)						; destination ASIC
	ld		bc,#200								; on choisit 2 sprites
	LDIR										; PAF on copie
	call	rom_off								; on deconnecte la ROM
	
	
	ld		c,bank_programme_rom
	call	rom_on
	call	init_poissonrouge_ROM
	call	rom_off
	
; si on se trouve dans une piece non éclairé alors on éteinds les sprites	
	ld		a,(flag_lumiere)
	or		a
	ret		NZ
	xor		a
	ld		hl,(sprh_zoom_poissonrouge)
	ld		(hl),a
	ld		de,-8
	add		hl,de
	ld		(hl),a	

	ret
deplacement_poissonrouge
	ld		hl,(pos_x_poissonrouge)
	ld		(sprh_x_ennemis),hl
	ld		hl,(pos_y_poissonrouge)
	ld		(sprh_y_ennemis),hl
	call	collision_avec_blinky
	ld		a,(direction_poissonrouge)
	cp		a,1
	jp		z,deplacement_poissonrouge_droite
	cp		a,2
	jp		z,deplacement_poissonrouge_gauche
deplacement_poissonrouge_droite
	ld		a,(animation_poissonrouge)
	dec		a
	ld		(animation_poissonrouge),a
	call	z,anim_poissonrouge_1
	ld		a,(distance_X_poissonrouge)
	dec		a
	ld		(distance_X_poissonrouge),a
	jp		z,reinit_deplacement_poissonrouge_gauche
	ld		hl,(pos_x_poissonrouge)
	ld		de,(vitesse_X_poissonrouge)
	ld		d,0
	sbc		hl,de
	ld		(pos_x_poissonrouge),hl
	ld		ix,(sprh_xyz_poissonrouge)
	ld		(ix),hl
	ld		(ix+8),hl
	ret
deplacement_poissonrouge_gauche
	ld		a,(animation_poissonrouge)
	dec		a
	ld		(animation_poissonrouge),a
	call	z,anim_poissonrouge_2
	ld		a,(distance_X_poissonrouge)
	dec		a
	ld		(distance_X_poissonrouge),a
	jp		z,reinit_deplacement_poissonrouge_droite
	ld		hl,(pos_x_poissonrouge)
	ld		de,(vitesse_X_poissonrouge)
	ld		d,0
	add		hl,de
	ld		(pos_x_poissonrouge),hl
	ld		ix,(sprh_xyz_poissonrouge)
	ld		(ix),hl
	ld		(ix+8),hl
	ret
reinit_deplacement_poissonrouge_gauche
	ld		a,(distance_X_poissonrouge_save)
	ld		(distance_X_poissonrouge),a
	ld		a,2						; on va à gauche
	ld		(direction_poissonrouge),a
	xor		a
	ld			(etape_anim_poissonrouge),a
	ld		hl,Tableau_anim_poissonrouge_gauche
	ld		(adr_des_animations_poissonrouge),hl
	ld		hl,poisson_rouge
	ld		(adr_poissonrouge),hl
	ld		a,bank_sprh_ennemy2					; on choisit le no de bank
	ld		c,a
	call	rom_on		
	ld		hl,(adr_poissonrouge)
	ld		de,(sprh_de_depart_poissonrouge)						; destination ASIC
	ld		bc,#200								; on choisit 2 sprites
	LDIR										; PAF on copie
	call	rom_off								; on deconnecte la ROM
	ret
reinit_deplacement_poissonrouge_droite
	ld		a,(distance_X_poissonrouge_save)
	ld		(distance_X_poissonrouge),a
	ld		a,1						; on va à gauche
	ld		(direction_poissonrouge),a
	xor		a
	ld		(etape_anim_poissonrouge),a
	ld		hl,Tableau_anim_poissonrouge_droite
	ld		(adr_des_animations_poissonrouge),hl
	ld		hl,poisson_rouge+#800
	ld		(adr_poissonrouge),hl

	ld		a,bank_sprh_ennemy2					; on choisit le no de bank
	ld		c,a
	call	rom_on		
	ld		hl,(adr_poissonrouge)
	ld		de,(sprh_de_depart_poissonrouge)						; destination ASIC
	ld		bc,#200								; on choisit 2 sprites
	LDIR										; PAF on copie
	call	rom_off								; on deconnecte la ROM
	
	ld		ix,(sprh_x_poissonrouge)
	ld		(sprh_x_poissonrouge),ix
	ld		hl,(pos_x_poissonrouge_save)
	ld		(pos_x_poissonrouge),hl
	ld		(ix),hl
	
	
	
	ld		ix,(sprh_y_poissonrouge)

	ld		hl,(pos_y_poissonrouge_save)
	ld		(pos_y_poissonrouge),hl
	ld		(ix-8),hl
	inc		ix
	inc		ix
	
		
	inc		ix
	inc		ix
	inc		ix
	inc		ix 	
	
	; on se place sur la pos X du prochain sprite hard
; on initialise le sprite du haut
	ld		ix,(sprh_x_poissonrouge)
	ld		hl,(pos_x_poissonrouge_save)
	ld		(pos_x_poissonrouge),hl
	ld		(ix),hl
	inc		ix
	inc		ix
	ld		ix,(sprh_y_poissonrouge)
	
	ld		hl,(pos_y_poissonrouge_save)
	ld		(pos_y_poissonrouge),hl
	
	ld		(ix-8),hl
	ret

anim_poissonrouge_1
		ld			a,(etape_anim_poissonrouge)
		inc			a
		cp			a,4
		jp			z,reinit_anim_poissonrouge_1
		ld			(etape_anim_poissonrouge),a
		ld			hl,(adr_des_animations_poissonrouge)
		inc			hl
		inc			hl
		ld			(adr_des_animations_poissonrouge),hl
		ld			a,(hl)
		ld			e,a
		inc			hl
		ld			a,(hl)
		ld			d,a
		ld			(adr_poissonrouge),de
	retour_reinit_anim_poissonrouge_1
			ld		a,(animation_poissonrouge_save)
			ld		(animation_poissonrouge),a
			ld		a,bank_sprh_ennemy2				; on choisit le no de bank
			ld		c,a
			call	rom_on		
			ld		hl,(adr_poissonrouge)
			ld		de,(sprh_de_depart_poissonrouge)						; destination ASIC
			ld		bc,#200								; on choisit 1 sprites
			LDIR										; PAF on copie
			call	rom_off								; on deconnecte la ROM
			ld		hl,(pos_y_poissonrouge)
			dec		l
			dec		l
			ld		(pos_y_poissonrouge),hl
			ld		ix,(sprh_y_poissonrouge)
			ld		(ix+-8),hl							
			ld		de,-16
			add		hl,de
			ld		(ix),hl
			ret
		reinit_anim_poissonrouge_1
				ld		hl,Tableau_anim_poissonrouge_droite
				ld		(adr_des_animations_poissonrouge),hl
				ld		hl,poisson_rouge
				ld		(adr_poissonrouge),hl
				xor		a
				ld		(etape_anim_poissonrouge),a
				jp		retour_reinit_anim_poissonrouge_1
		
	anim_poissonrouge_2
		ld			a,(etape_anim_poissonrouge)
		inc			a
		cp			a,4
		jp		z,reinit_anim_poissonrouge_2
		ld			(etape_anim_poissonrouge),a
		ld			hl,(adr_des_animations_poissonrouge)
		inc			hl
		inc			hl
		ld			(adr_des_animations_poissonrouge),hl
		ld			a,(hl)
		ld			e,a
		inc			hl
		ld			a,(hl)
		ld			d,a
		ld			(adr_poissonrouge),de
	retour_reinit_anim_poissonrouge_2
			ld		a,(animation_poissonrouge_save)
			ld		(animation_poissonrouge),a
			ld		a,bank_sprh_ennemy2				; on choisit le no de bank
			ld		c,a
			call	rom_on		
			ld		hl,(adr_poissonrouge)
			ld		de,(sprh_de_depart_poissonrouge)						; destination ASIC
			ld		bc,#200								; on choisit 1 sprites
			LDIR										; PAF on copie
			call	rom_off								; on deconnecte la ROM
	ld		hl,(pos_y_poissonrouge)
	inc		l
	inc		l
	ld		(pos_y_poissonrouge),hl
	ld		ix,(sprh_y_poissonrouge)
	ld		(ix+-8),hl							
	ld		de,-16
	add		hl,de
	ld		(ix),hl
	ret
		reinit_anim_poissonrouge_2
		ld		hl,Tableau_anim_poissonrouge_gauche
				ld		(adr_des_animations_poissonrouge),hl
		
				ld		hl,poisson_rouge+#800
				ld		(adr_poissonrouge),hl
				xor		a
				ld		(etape_anim_poissonrouge),a
				jp		retour_reinit_anim_poissonrouge_2
				
Tableau_anim_poissonrouge_droite
DW		poisson_rouge,poisson_rouge+#200,poisson_rouge+#400,poisson_rouge+#600
Tableau_anim_poissonrouge_gauche
DW		poisson_rouge+#800,poisson_rouge+#A00,poisson_rouge+#C00,poisson_rouge+#E00




