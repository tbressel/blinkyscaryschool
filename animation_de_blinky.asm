; ///////////////////////////////////////////////////////////////////////////////////
; ///////////////////////////////////////////////////////////////////////////////////
; ////////////////////       ANIMATIONS DE BLINKY        /////////////////////
; ///////////////////////////////////////////////////////////////////////////////////
; ///////////////////////////////////////////////////////////////////////////////////


animations
ld		a,(flag_lumiere)
or	a
jp		z,animations_des_yeux

ld		a,(flag_blinky_est_dans_leau)
or	a
ret		nz

ld		a,(flag_saut_en_cours)
or	a
jp		nz,animations_saut
ld		a,(flag_on_tombe)
or	a
ret		nz
or		a
ld		a,(vitesse_animation_blinky)	; on change d'animation toutes les X fois
cp		a,0								; tant que c'est pas à zéro on retourne d'où on vient
ret		nz								; quand c'est à zero on passe
jp		update_animation_blinky


animations_saut
ld		a,(flag_on_tombe)
or	a
ret		nz
or		a
ld		a,(vitesse_animation_blinky_saute)	; on change d'animation toutes les X fois
cp		a,0								; tant que c'est pas à zéro on retourne d'où on vient
ret		nz								; quand c'est à zero on passe
jp		update_animation_blinky_saute


update_animation_blinky
	ld		a,(no_animation_blinky)
	inc		a
	ld		(no_animation_blinky),a
	cp		a,6
	jp		z,fin_anim
	ld		c,bank_sprh_blinky						; on choisit le no de bank
	call	rom_on								; on connecte la bank
	ld		hl,(animation_blinky_en_cours)
	ld		de,#400
	add		hl,de
	
	ld		a,h				; suite à un bug à la retombé du saut HL prends la valeur #0000
	cp		a,0				; l'automodif ne se déclenche donc pas. Donc ici je corrige le problème 
	call	z,correction_anim_saut	; si h=0 alors on rectifie la valeur
		; endroit où sont les sprh de blinky
	ld		(animation_blinky_en_cours),hl
	ld		de,SPRH0_ADR						; destination ASIC
	ld		bc,#400								; on choisit 4 sprites
	LDIR										; PAF on copie
	call	rom_off								; on deconnecte la ROM

	ld		a,vitesse_animation_blinky_cfg
	ld		(vitesse_animation_blinky),a
	ret

update_animation_blinky_saute
	ld		a,vitesse_animation_blinky_saute_cfg
	ld		(vitesse_animation_blinky_saute),a
	
	ld		a,(no_animation_blinky)
	inc		a
	ld		(no_animation_blinky),a
	cp		a,4
	call	z,debut_anim_retombe
	cp		a,5
	jp		z,fin_anim_saute
	
	ld		c,bank_sprh_blinky						; on choisit le no de bank
	call	rom_on								; on connecte la bank
	ld		hl,(animation_blinky_en_cours)
	ld		de,#400
	automodif_retombe
	add		hl,de
	NOP
		; endroit où sont les sprh de blinky
	
	ld		a,h				; suite à un bug à la retombé du saut HL prends la valeur #0000
	cp		a,0				; l'automodif ne se déclenche donc pas. Donc ici je corrige le problème 
	call	z,correction_anim_saut	; si h=0 alors on rectifie la valeur
	ld		(animation_blinky_en_cours),hl
	ld		de,SPRH0_ADR						; destination ASIC
	ld		bc,#400								; on choisit 4 sprites
	LDIR										; PAF on copie
	call	rom_off								; on deconnecte la ROM
	ret
correction_anim_saut
	ld		hl,#FC00
	ret

debut_anim_retombe
ld	a,#ED
ld	(automodif_retombe),a
ld	a,#52
ld	(automodif_retombe+1),a
ret



fin_anim
	ld		a,1
	ld		(no_animation_blinky),a
	ld		a,vitesse_animation_blinky_cfg
	ld		(vitesse_animation_blinky),a
	ld		hl,(animation_blinky_en_cours)
	res		4,h
	res		2,h
	res		3,H
	ld		(animation_blinky_en_cours),hl
	ld		(animation_blinky_saute),hl
	ret
fin_anim_saute
	ld		a,1
	ld		(no_animation_blinky),a
	ld		a,vitesse_animation_blinky_saute_cfg
	ld		(vitesse_animation_blinky_saute),a
	ld		hl,(animation_blinky_en_cours)
	res		4,h
	res		2,h
	res		3,H
	ld		(animation_blinky_en_cours),hl
	ld		(animation_blinky_saute),hl
	ld		a,#19
	ld		(automodif_retombe),a
	xor		a
	ld		(automodif_retombe+1),a	
	ret


anim_blinky_meurt
	xor		a
	ld		(flag_reboot),a
	ld		a,(vitesse_anim_blinky_meurt)
	dec		a
	ld		(vitesse_anim_blinky_meurt),a
	ret		nz


	ld		a,(etape_blinky_meurt)
	cp		a,0
	jp		z,anim_blinky_meurt_1
	cp		a,1
	jp		z,anim_blinky_meurt_2
	cp		a,2
	jp		z,anim_blinky_meurt_3
	cp		a,3
	jp		z,anim_blinky_meurt_4
	cp		a,4
	jp		z,anim_blinky_meurt_5
	cp		a,5
	jp		z,anim_blinky_meurt_6
	cp		a,6
	jp		z,fin_anim_blinky_meurt
	
anim_blinky_meurt_1
	ld		c,bank_sprh_blinky2
	call	rom_on
	ld		hl,#C400
	ld		de,#4000
	ld		bc,#400
	LDIR
	call	rom_off
	ld		a,1
	ld		(etape_blinky_meurt),a
	ld		a,vitesse_anim_blinky_meurt_cfg
	ld		(vitesse_anim_blinky_meurt),a
	ret
anim_blinky_meurt_2
	ld		c,bank_sprh_blinky2
	call	rom_on
	ld		hl,#C800
	ld		de,#4000
	ld		bc,#400
	LDIR
	call	rom_off
	ld		a,2
	ld		(etape_blinky_meurt),a
	ld		a,vitesse_anim_blinky_meurt_cfg
	ld		(vitesse_anim_blinky_meurt),a
	ret
anim_blinky_meurt_3
	ld		c,bank_sprh_blinky2
	call	rom_on
	ld		hl,#CC00
	ld		de,#4000
	ld		bc,#400
	LDIR
	call	rom_off
	ld		a,3
	ld		(etape_blinky_meurt),a
	ld		a,vitesse_anim_blinky_meurt_cfg
	ld		(vitesse_anim_blinky_meurt),a
	ret
anim_blinky_meurt_4
	ld		c,bank_sprh_blinky2
	call	rom_on
	ld		hl,#D000
	ld		de,#4000
	ld		bc,#400
	LDIR
	call	rom_off
	ld		a,4
	ld		(etape_blinky_meurt),a
	ld		a,vitesse_anim_blinky_meurt_cfg
	ld		(vitesse_anim_blinky_meurt),a
	ret
anim_blinky_meurt_5
	xor		a
	ld		(SPRH0_ZOOM),a
	ld		(SPRH1_ZOOM),a
	ld		c,bank_sprh_blinky2
	call	rom_on
	ld		hl,#D400
	ld		de,#4200
	ld		bc,#200
	LDIR
	call	rom_off
	ld		a,5
	ld		(etape_blinky_meurt),a
	ld		a,vitesse_anim_blinky_meurt_cfg
	ld		(vitesse_anim_blinky_meurt),a
	ret
anim_blinky_meurt_6
	ld		c,bank_sprh_blinky2
	call	rom_on
	ld		hl,#D600
	ld		de,#4200
	ld		bc,#200
	LDIR
	call	rom_off
	ld		a,6
	ld		(etape_blinky_meurt),a
	ld		a,vitesse_anim_blinky_meurt_cfg
	ld		(vitesse_anim_blinky_meurt),a
	ret
fin_anim_blinky_meurt
	ld		a,(flag_on_se_teleporte)
	or		a
	jp		nz,fin_anim_blinky_teleporte

	ld		a,vitesse_anim_blinky_meurt_cfg
	ld		(vitesse_anim_blinky_meurt),a
	xor		a
	ld		(SPRH2_ZOOM),a
	ld		(SPRH3_ZOOM),a
	ld		(flag_blinky_est_deja_touche),a
	
	xor		a
	ld		(event_gameover),a
	ld		(event_gameover+1),a
	ld		(event_gameover+2),a
	ld		(event_gameover+3),a
	ld		(event_gameover+4),a
	ld		(event_gameover+5),a
	ld		(etape_blinky_meurt),a
	call	asic_off
	call	init_barre_energie
	call	asic_on
	ld		c,bank_sprh_blinky
	call	rom_on
	ld		hl,#C000
	ld		de,#4000
	ld		bc,#400
	LDIR
	call	rom_off
	
	ld		a,(flag_ennemis_mortel)
	cp		a,1
	jr		z,retour_salle_1
	
	ld		hl,(pos_X_blinky_debut_tableau)
	ld		(pos_X_blinky),hl
	ld		hl,(pos_Y_blinky_debut_tableau)
		ld		(pos_Y_blinky),hl
		call	update_position_X_de_blinky
		call	update_position_Y_de_blinky
		call	asic_off
		call	COPIE_RAM_SAMPLES
		call	asic_on
		ld		hl,DMA_LIST_1
call	set_DMA
ld		hl,DMA_LIST_2
call	set_DMA
ld		hl,DMA_LIST_3
call	set_DMA
	pop	iy
	jp	NOUVELLE_PIECE
	
retour_salle_1
	; initialisation de la salle de départ et sa bankrom

ld		a,(nbr_ingredient_chaudron_0)
cp		a,4
jr		z,level_2


	ld		hl,salle_82+#12
	ld		(adr_piece_actuelle),hl
																		
	ld		(adresse_du_decors_en_rom),hl				
	ld		a,82
	ld		(no_de_la_salle),a
	ld		a,18
	ld		(no_bank_maptile_deco),a
	
		; ld		hl,salle_01+#12
	; ld		(adr_piece_actuelle),hl
	; ld		(adresse_du_decors_en_rom),hl				
	; ld		a,1
	; ld		(no_de_la_salle),a
	; ld		a,13
	; ld		(no_bank_maptile_deco),a
	
	jr		init_positions
	
level_2
	ld		hl,salle_01+#12
	ld		(adr_piece_actuelle),hl
														
	ld		(adresse_du_decors_en_rom),hl				
	ld		a,1
	ld		(no_de_la_salle),a
	ld		a,13
	ld		(no_bank_maptile_deco),a
	
	
init_positions	
; initialisation de la position de blinky

	ld		hl,#0188
	ld		(pos_X_blinky),hl
	ld		hl,#0040
	ld		(pos_Y_blinky),hl
	
	
	call	update_position_X_de_blinky
	call	update_position_Y_de_blinky
	call	asic_off
	call	COPIE_RAM_SAMPLES
	call	asic_on
	ld		hl,DMA_LIST_1
call	set_DMA
ld		hl,DMA_LIST_2
call	set_DMA
ld		hl,DMA_LIST_3
call	set_DMA
	jp	NOUVELLE_PIECE

fin_anim_blinky_teleporte
		
	ld		a,vitesse_anim_blinky_meurt_cfg
	ld		(vitesse_anim_blinky_meurt),a
	ld		c,bank_sprh_blinky
	call	rom_on
	ld		hl,#C000
	ld		de,#4000
	ld		bc,#400
	LDIR
	call	rom_off


	ld		c,bank_programme_rom
	call	rom_on
	call	fin_anim_blinky_teleporte_ROM_bank3
	call	rom_off
	call	on_update_le_hud
	
	call	asic_off
	call	COPIE_RAM_SAMPLES
	call	asic_on
	ld		hl,DMA_LIST_1
call	set_DMA
ld		hl,DMA_LIST_2
call	set_DMA
ld		hl,DMA_LIST_3
call	set_DMA
	jp	NOUVELLE_PIECE
	
	
			
	on_update_le_hud
		; on va afficher les objets décalé dans	le hud
			ld		c,bank_gfx_hud
			call	rom_on					; connexion à la bank des sprites items
			ld		a,6
			ld  	(largeur_animation),a	; ocets de large du sprite
			ld		hl,(item_hud_3)						; adresse du sprites en ROM	
			ld		de,Emplacement3_adr					; adresse du sprites à l'écran
			ld		b,24								; hauteur du sprite
			call	affichage_de_l_animation			; on l'affiche
			
			ld		hl,(item_hud_2)					; adresse du sprites en ROM	
			ld		de,Emplacement2_adr					; adresse du sprites à l'écran
			ld		b,24								; hauteur du sprite
			call	affichage_de_l_animation			; on l'affiche
			
			ld		hl,(item_hud_1)					; adresse du sprites en ROM	
			ld		de,Emplacement1_adr					; adresse du sprites à l'écran
			ld		b,24								; hauteur du sprite
			call	affichage_de_l_animation			; on l'affiche
			call	rom_off
			ret
			



animations_des_yeux
ld		a,(etape_anim_yeux)
inc		a
ld		(etape_anim_yeux),a
cp		1
jp		z,anim_yeux_1
cp		5
jp		z,anim_yeux_2
cp		10
jp		z,anim_yeux_3
cp		60
jp		z,anim_yeux_2
cp		70
jp		z,reinit_anim_yeux
ret

anim_yeux_1
ld		a,(etat_blinky_en_cours)
cp		a,va_a_gauche
jp		z,anim_yeux_gauche_1
cp		a,va_a_droite
jp		z,anim_yeux_droite_1


anim_yeux_droite_1
ld		c,bank_sprh_blinky2
call	rom_on
ld		hl,#f000
ld		(animation_blinky_en_cours),hl
ld		(blinky_droite_adr),hl
ld		de,SPRH0_ADR
ld		bc,(longueur_du_sprh)
LDIR
call	rom_off
ret
anim_yeux_gauche_1
ld		c,bank_sprh_blinky2
call	rom_on
ld		hl,#f300
ld		(animation_blinky_en_cours),hl
ld		(blinky_gauche_adr),hl
ld		de,SPRH0_ADR
ld		bc,(longueur_du_sprh)
LDIR
call	rom_off
ret
anim_yeux_2
ld		a,(etat_blinky_en_cours)
cp		a,va_a_gauche
jp		z,anim_yeux_gauche_2
cp		a,va_a_droite
jp		z,anim_yeux_droite_2


anim_yeux_droite_2
ld		c,bank_sprh_blinky2
call	rom_on
ld		hl,#f100
ld		(animation_blinky_en_cours),hl
ld		de,SPRH0_ADR
ld		bc,(longueur_du_sprh)
LDIR
call	rom_off
ret
anim_yeux_gauche_2
ld		c,bank_sprh_blinky2
call	rom_on
ld		hl,#f400
ld		(animation_blinky_en_cours),hl
ld		de,SPRH0_ADR
ld		bc,(longueur_du_sprh)
LDIR
call	rom_off
ret
anim_yeux_3
ld		a,(etat_blinky_en_cours)
cp		a,va_a_gauche
jp		z,anim_yeux_gauche_3
cp		a,va_a_droite
jp		z,anim_yeux_droite_3


anim_yeux_droite_3
ld		c,bank_sprh_blinky2
call	rom_on
ld		hl,#f200
ld		(animation_blinky_en_cours),hl
ld		de,SPRH0_ADR
ld		bc,(longueur_du_sprh)
LDIR
call	rom_off
ret
anim_yeux_gauche_3
ld		c,bank_sprh_blinky2
call	rom_on
ld		hl,#f500
ld		(animation_blinky_en_cours),hl
ld		de,SPRH0_ADR
ld		bc,(longueur_du_sprh)
LDIR
call	rom_off
ret

reinit_anim_yeux
xor		a
ld	(etape_anim_yeux),a

ret







