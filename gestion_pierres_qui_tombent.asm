pierresquitombent
	; LD 		BC,#BC02:OUT (C),C			; on pousse l'ecran vers la droite pour le recentrer
	; LD 		BC,#BD00+40:OUT (C),C	
	; LD 		BC,#BC07:OUT (C),C			; on decale l'ecran vers le haut 
	; LD 		BC,#BD00+33:OUT (C),C	






ld		a,(etape_pierresquitombent)
	cp		a,0
	jp		z,init_pierresquitombent
	cp		a,1
	jp		z,la_pierre_1_tombe
	cp		a,2
	jp		z,la_pierre_2_tombe
	cp		a,3
	jp		z,la_pierre_3_tombe
	ret
	
init_pierresquitombent
	ld		a,bank_sprh_ennemy					; on choisit le no de bank
	ld		c,a
	call	rom_on								; on connecte la bank
	ld		hl,PIERRE
	ld		de,SPRH7_ADR						; destination ASIC
	ld		bc,#100								; on choisit 2 sprites
	LDIR
	ld		a,r
	ld		(timing_pierre_1),a					; PAF on copie
	ld		hl,PIERRE
	ld		de,SPRH8_ADR						; destination ASIC
	ld		bc,#100								; on choisit 2 sprites
	LDIR
	ld		hl,PIERRE
	ld		de,SPRH9_ADR						; destination ASIC
	ld		bc,#100								; on choisit 2 sprites
	LDIR		
		; PAF on copie
	call	rom_off								; on deconnecte la ROM

	ld		c,bank_programme_rom
	call	rom_on
	call	init_pierresquitombent_ROM
	call	rom_off
	ret
	
	
la_pierre_1_tombe
	ld		a,(timing_pierre_1)
	dec 	a
	ld		(timing_pierre_1),a
	ret		nz
	inc		a	
	ld		(timing_pierre_1),a
	ld		a,1
	ld		(flag_ennemis_mortel),a
	ld		hl,(SPRH7_X)
	ld		(sprh_x_ennemis),hl
	ld		hl,(SPRH7_Y)
	ld		(sprh_y_ennemis),hl
	call	collision_avec_blinky
	
	ld		hl,(SPRH7_Y)
	ld		b,8
	ld		a,l
	add		a,b
	ld		l,a
	ld		(SPRH7_Y),hl
	ld		b,l
	ld		a,(distance_tombe_pierre)
	sub		a,b
	jp		c,stop_pierre_1_tombe
	ret
stop_pierre_1_tombe
	ld		hl,(SPRH7_Y)
	ld		b,-8
	ld		a,l
	add		a,b
	ld		l,a
	ld		(SPRH7_Y),hl
	ld		a,2
	ld		(etape_pierresquitombent),a
	; LD 		BC,#BC02:OUT (C),C			; on pousse l'ecran vers la droite pour le recentrer
	; LD 		BC,#BD00+41:OUT (C),C	
	; LD 		BC,#BC07:OUT (C),C			; on decale l'ecran vers le haut 
	; LD 		BC,#BD00+34:OUT (C),C
	
	
	ret


la_pierre_2_tombe
	ld		a,(timing_pierre_2)
	dec 	a
	ld		(timing_pierre_2),a
	ret		nz
	inc		a	
	ld		(timing_pierre_2),a
	ld		a,1
	ld		(flag_ennemis_mortel),a
	ld		hl,(SPRH8_X)
	ld		(sprh_x_ennemis),hl
	ld		hl,(SPRH8_Y)
	ld		(sprh_y_ennemis),hl
	call	collision_avec_blinky
	ld		hl,(SPRH8_Y)
	ld		b,8
	ld		a,l
	add		a,b
	ld		l,a
	ld		(SPRH8_Y),hl
	ld		b,l
	ld		a,(distance_tombe_pierre)
	sub		a,b
	jp		c,stop_pierre_2_tombe
	ret
stop_pierre_2_tombe
	ld	hl,(SPRH8_Y)
	ld	b,-8
	ld	a,l
	add	a,b
	ld	l,a
	ld		(SPRH8_Y),hl
	ld		a,3
	ld		(etape_pierresquitombent),a
	; LD 		BC,#BC02:OUT (C),C			; on pousse l'ecran vers la droite pour le recentrer
	; LD 		BC,#BD00+41:OUT (C),C	
	; LD 		BC,#BC07:OUT (C),C			; on decale l'ecran vers le haut 
	; LD 		BC,#BD00+34:OUT (C),C
	
	ret

la_pierre_3_tombe
		ld		a,(timing_pierre_3)
		dec 	a
		ld		(timing_pierre_3),a
		ret		nz
		inc		a
			ld	a,1
			ld	(flag_ennemis_mortel),a
	ld		(timing_pierre_3),a
		ld		hl,(SPRH9_X)
	ld		(sprh_x_ennemis),hl
	ld		hl,(SPRH9_Y)
	ld		(sprh_y_ennemis),hl
	call	collision_avec_blinky
	ld	hl,(SPRH9_Y)
	ld	b,8
	ld	a,l
	add	a,b
	ld	l,a
	ld		(SPRH9_Y),hl
	ld		b,l
	ld		a,(distance_tombe_pierre)
	sub		a,b
	jp		c,stop_pierre_3_tombe
	ret
stop_pierre_3_tombe
	ld	hl,(SPRH9_Y)
	ld	b,-8
	ld	a,l
	add	a,b
	ld	l,a
	ld		(SPRH9_Y),hl
	ld		a,4
	ld		(etape_pierresquitombent),a
	; LD 		BC,#BC02:OUT (C),C			; on pousse l'ecran vers la droite pour le recentrer
	; LD 		BC,#BD00+40:OUT (C),C	
	; LD 		BC,#BC07:OUT (C),C			; on decale l'ecran vers le haut 
	; LD 		BC,#BD00+33:OUT (C),C	
	
	ret


