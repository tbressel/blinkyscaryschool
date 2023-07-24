; ///////////////////////////////////////////////////////////////////////////////////
; ///////////////////////////////////////////////////////////////////////////////////
; //////////////////              GESTION chauverouge                       //////////
; ///////////////////////////////////////////////////////////////////////////////////
; ///////////////////////////////////////////////////////////////////////////////////

chauverouge							; routine dédié aux ennemis de type #01
	ld		a,(etape_chauverouge)
	or		a
	jp		z,init_chauverouge
	or		a
	jp		nz,deplacement_chauverouge
	ret
	init_chauverouge
		; on recherche dans les tableau RAM où est l'ennemis de type 1
		ld 		hl,tableau_ennemy_RAM+3
		ld		b,4
		boucle_init_chauverouge
			ld		a,(hl)
			cp		a,ennemis_chauve_rouge
			JP		z,on_continu_chauverouge
			ld		de,16
			add		hl,de
			djnz	boucle_init_chauverouge
		on_continu_chauverouge
			dec		hl
			dec		hl
			dec		hl
			ld		de,tableau_chauverouge
			ldi:ldi:ldi:ldi:ldi:ldi
			ldi:ldi:ldi:ldi:ldi:ldi
			ldi:ldi:ldi:ldi
	ld		a,(bank_chauverouge)					; on choisit le no de bank
	ld		c,a
	call	rom_on								; on connecte la bank
	ld		hl,(adr_chauverouge)
	ld		de,(sprh_de_depart_chauverouge)						; destination ASIC
	ld		bc,#100								; on choisit 2 sprites
	LDIR										; PAF on copie
	call	rom_off								; on deconnecte la ROM
	
	
			
	ld		c,bank_programme_rom
	call	rom_on
	call	init_chauverouge_ROM
	call	rom_off

	

	; si on se trouve dans une piece non éclairé alors on éteinds les sprites		
	ld		a,(flag_lumiere)
	or		a
	ret		NZ
	xor		a
	ld		hl,(sprh_zoom_chauverouge)
	ld		(hl),a
	ret
deplacement_chauverouge
	ld		hl,(pos_x_chauverouge)
	ld		(sprh_x_ennemis),hl
	ld		hl,(pos_y_chauverouge)
	ld		(sprh_y_ennemis),hl
	call	collision_avec_blinky
	ld		a,(direction_chauverouge)
	cp		a,1
	jp		z,deplacement_chauverouge_droite
	cp		a,2
	jp		z,deplacement_chauverouge_gauche
deplacement_chauverouge_droite
	ld		a,(animation_chauverouge)
	dec		a
	ld		(animation_chauverouge),a
	call	z,anim_chauverouge_1
	ld		a,(distance_X_chauverouge)
	dec		a
	ld		(distance_X_chauverouge),a
	jp		z,reinit_deplacement_chauverouge_gauche
	ld		hl,(pos_x_chauverouge)
	ld		de,(vitesse_X_chauverouge)
	ld		d,0
	add		hl,de
	ld		(pos_x_chauverouge),hl
	ld		ix,(sprh_x_chauverouge)
	ld		(ix),hl
	ret
deplacement_chauverouge_gauche
	ld		a,(animation_chauverouge)
	dec		a
	ld		(animation_chauverouge),a
	call	z,anim_chauverouge_2
	ld		a,(distance_X_chauverouge)
	dec		a
	ld		(distance_X_chauverouge),a
	jp		z,reinit_deplacement_chauverouge_droite
	ld		hl,(pos_x_chauverouge)
	ld		de,(vitesse_X_chauverouge)
	ld		d,0
	sbc		hl,de
	ld		(pos_x_chauverouge),hl
	ld		ix,(sprh_x_chauverouge)
	ld		(ix),hl
	ret
reinit_deplacement_chauverouge_gauche
	ld		a,(distance_X_chauverouge_save)
	ld		(distance_X_chauverouge),a
	ld		a,2						; on va à gauche
	ld		(direction_chauverouge),a
	xor		a
	ld		(etape_anim_chauverouge),a
	ld		hl,Tableau_anim_chauverouge_gauche
	ld		(adr_des_animations_chauverouge),hl
	ld		hl,CHAUVE_ROUGE+#600
	ld		(adr_chauverouge),hl
	ld		a,(bank_chauverouge)					; on choisit le no de bank
	ld		c,a
	call	rom_on		
	ld		hl,(adr_chauverouge)
	ld		de,(sprh_de_depart_chauverouge)						; destination ASIC
	ld		bc,#100								; on choisit 2 sprites
	LDIR										; PAF on copie
	call	rom_off								; on deconnecte la ROM
	ret
reinit_deplacement_chauverouge_droite
	ld		a,(distance_X_chauverouge_save)
	ld		(distance_X_chauverouge),a
	ld		a,1						; on va à gauche
	ld		(direction_chauverouge),a
	xor		a
	ld			(etape_anim_chauverouge),a
	ld		hl,Tableau_anim_chauverouge_droite
	ld		(adr_des_animations_chauverouge),hl
	ld		hl,CHAUVE_ROUGE
	ld		(adr_chauverouge),hl
	ld		a,(bank_chauverouge)					; on choisit le no de bank
	ld		c,a
	call	rom_on		
	ld		hl,(adr_chauverouge)
	ld		de,(sprh_de_depart_chauverouge)						; destination ASIC
	ld		bc,#100								; on choisit 2 sprites
	LDIR										; PAF on copie
	call	rom_off								; on deconnecte la ROM
	ret

anim_chauverouge_1
		ld			a,(etape_anim_chauverouge)
		inc			a
		cp			a,7
		jp			z,reinit_anim_chauverouge_1
		ld			(etape_anim_chauverouge),a
		ld			hl,(adr_des_animations_chauverouge)
		inc			Hl
		inc			hl
		ld			(adr_des_animations_chauverouge),hl
		ld			a,(hl)
		ld			e,a
		inc			hl
		ld			a,(hl)
		ld			d,a
		ld			(adr_chauverouge),de
	retour_reinit_anim_chauverouge_1
			ld		a,(animation_chauverouge_save)
			ld		(animation_chauverouge),a
			ld		a,(bank_chauverouge)					; on choisit le no de bank
			ld		c,a
			call	rom_on		
			ld		hl,(adr_chauverouge)
			ld		de,(sprh_de_depart_chauverouge)						; destination ASIC
			ld		bc,#100								; on choisit 1 sprites
			LDIR										; PAF on copie
			call	rom_off								; on deconnecte la ROM
			ret
		reinit_anim_chauverouge_1
				ld		hl,Tableau_anim_chauverouge_droite
				ld		(adr_des_animations_chauverouge),hl
				ld		hl,CHAUVE_ROUGE
				ld		(adr_chauverouge),hl
				xor		a
				ld		(etape_anim_chauverouge),a
				jp		retour_reinit_anim_chauverouge_1
	anim_chauverouge_2
		ld			a,(etape_anim_chauverouge)
		inc			a
		cp			a,7
		jp		z,reinit_anim_chauverouge_2
		ld			(etape_anim_chauverouge),a
		ld			hl,(adr_des_animations_chauverouge)
		inc			hl
		inc			hl
		ld			(adr_des_animations_chauverouge),hl
		ld			a,(hl)
		ld			e,a
		inc			hl
		ld			a,(hl)
		ld			d,a
		ld			(adr_chauverouge),de
	retour_reinit_anim_chauverouge_2
			ld		a,(animation_chauverouge_save)
			ld		(animation_chauverouge),a
			ld		a,(bank_chauverouge)					; on choisit le no de bank
			ld		c,a
			call	rom_on		
			ld		hl,(adr_chauverouge)
			ld		de,(sprh_de_depart_chauverouge)						; destination ASIC
			ld		bc,#100								; on choisit 1 sprites
			LDIR										; PAF on copie
			call	rom_off								; on deconnecte la ROM
			ret
		reinit_anim_chauverouge_2
				ld		hl,Tableau_anim_chauverouge_gauche
				ld		(adr_des_animations_chauverouge),hl
				ld		hl,CHAUVE_ROUGE+#600
				ld		(adr_chauverouge),hl
				xor		a
				ld			(etape_anim_chauverouge),a
				jp		retour_reinit_anim_chauverouge_2
				
Tableau_anim_chauverouge_droite
DW		CHAUVE_ROUGE,CHAUVE_ROUGE+#100,CHAUVE_ROUGE+#200,CHAUVE_ROUGE+#300,CHAUVE_ROUGE+#400,CHAUVE_ROUGE+#500,CHAUVE_ROUGE+#200
Tableau_anim_chauverouge_gauche
DW		CHAUVE_ROUGE+#600,CHAUVE_ROUGE+#700,CHAUVE_ROUGE+#800,CHAUVE_ROUGE+#900,CHAUVE_ROUGE+#A00,CHAUVE_ROUGE+#B00,CHAUVE_ROUGE+#800



