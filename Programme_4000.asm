ORG Tableau_items_piece

dw	0,0,0,0,0,0
dw	1,PAPIER_CUL,PQ_HUD,2,#005e,#0010						; piece 6
; dw	2,LAMPE_TORCHE,LAMPE_TORCHE_HUD,3,#0032,#0070		
dw	3,PARCHEMIN,0,0,#00F9,#0070							; piece 3
dw	5,SANDWICH,SANDWICH_HUD,12,#01C4,#0070				; piece 5
dw	6,PAPIER_CUL,PQ_HUD,2,#00CA,#0038						; piece 6
dw	7,CASSETTE,CASSETTE_HUD,7,#004C,#0018					; piece 7
dw	8,POT_DE_CONFITURE,CONFITURE_HUD,4,#01D4,#0040				; piece 8
dw	10,PARCHEMIN,0,0,#01F7,#0060							; piece 10
dw	11,POISSON,POISSON_HUD,5,#000F,#0070						; piece 11
dw	13,PAPIER_CUL,PQ_HUD,2,#018E,#0028							; piece 13
dw	15,VERRE_DE_SODA,VERRE_DE_SODA_HUD,6,#00FE,#0030			; piece 15
dw	16,LAMPE_TORCHE,LAMPE_TORCHE_HUD,3,#00F6,#0070						; piece 16
dw	18,PARCHEMIN,0,0,#003E,#0030							; piece 18
dw	20,OEIL,GLOBE_OCULAIRE_HUD,9,#0122,#0058
dw	22,PELUCHE,PELUCHE_HUD,10,#0048,#0058
dw	23,BALLON,BALLON_HUD,11,#00BD,#0038
dw	25,ELIXIR_VERT,FIOLE_HUD,8,#0159,#0070				; piece 25
dw	26,PAPIER_CUL,PQ_HUD,2,#0183,#0050
dw	35,PARCHEMIN,0,0,#007e,#0018							; piece 49
dw	46,BAGUE,BAGUE_HUD,17,#01BD,#0030
dw	47,EXTINCTEUR,EXTINCTEUR_HUD,14,#00cE,#0038						; piece 47
dw	48,TREFLE,TREFLE_HUD,21,#0143,#0058						; piece 47
dw	49,PARCHEMIN,0,0,#0179,#0050							; piece 49
dw	52,LIVRE,LIVRE_HUD,20,#0105,#0018
dw	54,ELIXIR_BLEU,FIOLE_HUD,18,#0048,#0020
dw	57,BONBON,BONBON_HUD,13,#01C4,#0070
dw	59,RADIO,RADIO_HUD,23,#0224,#0070
dw	64,CASSETTE,CASSETTE_HUD,7,#00D7,#0030
dw	65,PAPIER_CUL,PQ_HUD,2,#01FF,#0010
dw	66,PARCHEMIN,0,0,#0186,#0040
dw	67,PARCHEMIN,0,0,#019B,#0070
dw	68,PARCHEMIN,0,0,#019b,#0060
dw	69,GAZ,GAZ_HUD,15,#0224,#0070	
dw	70,REVEIL,REVEIL_HUD,16,#018,#0018
dw	72,RADIO,RADIO_HUD,23,#00E6,#0030
dw	74,PAPIER_CUL,PQ_HUD,2,#00fb,#0070
dw	75,ELIXIR_BLEU,FIOLE_HUD,18,#00F5,#0050
dw	76,CASSETTE,CASSETTE_HUD,7,#00BF,#0050
dw	80,PAPIER_CUL,PQ_HUD,2,#0068,#0050
dw	82,PARCHEMIN,0,0,#0210,#0060							; piece 3
dw	84,TREFLE,TREFLE_HUD,21,#01e0,#0068							; piece 3

dw	89,PARCHEMIN,0,0,#0090,#0070							; piece 3
dw	91,PAPIER_CUL,PQ_HUD,2,#00e4,#0060
dw	93,PARCHEMIN,0,0,#017B,#0048							; piece 3
dw	95,EXTINCTEUR,EXTINCTEUR_HUD,14,#00a5,#0060
dw	97,SAC_DE_BLE,SAC_DE_BLE_HUD,1,#0045,#0060
dw	99,PAPIER_CUL,PQ_HUD,2,#0108,#0070
dw	101,POT_DE_CONFITURE,CONFITURE_HUD,4,#01a5,#0058
dw	104,DILDO,DILDO_HUD,22,#00c3,#0050
dw	106,PELUCHE,PELUCHE_HUD,10,#0153,#0070
dw	108,CLE,CLE_HUD,19,#0040,#0050
dw	112,PAPIER_CUL,PQ_HUD,2,#0040,#0070
dw	115,LIVRE,LIVRE_HUD,20,#0206,#0070
dw	0,0,0,0,0,0



read"initialisation_musique_et_samples.asm"
read"gestion_temps_qui_passe.asm"
read"affichage_barre_energie.asm"

; affichage
read"hud.asm"
read"decors2.asm"
read"initialisation_animations_du_decors.asm"

; ennemy
read"gestion_ennemy.asm"
read"affichage_textes.asm"


	
	
boucle_reboot
call	asic_off
call	VBL2
					call	test_du_clavier_direction
					bit		4,a
	fire1c_jpz		jp		z,fin_restart
jp	boucle_reboot



fin_restart
	Di
	
	ld	sp,#7FFE
; mise à zéros de la bank #4000-#BFFF
	ld		b,3
	ld		ix,BANK_RAZ_Tbl
boucle_raz
	push	bc
	xor		a
	ld		hl,(ix)
	ld		e,l
	ld		d,h
	inc		de
	ld		(hl),a
	ld		bc,#4000
	LDIR
	inc		ix
	pop		bc
	djnz	boucle_raz
	
	LD		BC,#7F00+%10000000:OUT (C),C 		; connexion de la ROM supérieure et de la ROM inférieure et écran en mode 0.
	LD 		BC,#7FC0:OUT (c),c					; on choisit D'ECRIRE  dans la RAM centrale
	
	JP		#0000
	
BANK_RAZ_Tbl
	DW		#C000,#8000,#0000
	
init_ecran_de_fin
; on eteinds les palettes
	ld		hl,pallette_noire
	ld		(pallette_en_cours_decors),hl
	ld		(pallette_en_cours_hud),hl
; on modifile la ligne du mode 1
	ld		a,219 
	ld		(automodif_ligne+1),a
	
; on efface l'écran
	xor		a
	ld		hl,#c000
	ld		e,l
	ld		d,h
	inc		de
	ld		(hl),a
	ld		bc,#4000
	LDIR
; on modifie la boucle
	ld		hl,BOUCLE_PRINCIPALE
	ld		a,#c3
	ld		(event_boucle_fin_du_jeu),a
	ld		(event_boucle_fin_du_jeu+1),hl
; copie de l'ecran de fin
	ld		C,bank_screen_fin				; sélèction de la banque contenant
	call	rom_on
	ld		hl,#C000
	ld		de,#c000				; adresse de départ du player en RAM 
	ld		bc,#4000						 
	ldir
	call	rom_off

	ret

	
init_event_nouvelle_piece
	ld		c,bank_programme_rom
	call	rom_on
	call	init_event_nouvelle_piece_ROM
	call	rom_off
	ret

	
fin_parchemin
	ld		c,bank_programme_rom
	call	rom_on
	call	fin_parchemin_ROM
	call	rom_off
	jp	retour_fin_parchemin



anim_bulles_du_chaudron4000
		ld		a,(nbr_frame_anim_bulles_du_chaudron)
		inc		a
		ld		(nbr_frame_anim_bulles_du_chaudron),a
		cp		vitesse_anim_bulles_du_chaudron
		ret		nz
		ld		c,bank_animation_decors
		call	rom_on
		ld		de,(adr_ecran_des_anim_en_cours)
		ld		b,hauteur_bulles_du_chaudron
		ld		hl,largeur_bulles_du_chaudron
		ld		(largeur_animation),hl
		ld		a,(etape_anim_bulles_du_chaudron)
		inc		a
		ld		(etape_anim_bulles_du_chaudron),a
		cp		1
		jr		z,anim_bulles_du_chaudron_no_1
		cp		2
		jr		z,anim_bulles_du_chaudron_no_2
		cp		3
		jr		z,anim_bulles_du_chaudron_no_3
		cp		4
		jr		z,anim_bulles_du_chaudron_no_4
		
			anim_bulles_du_chaudron_no_1
				ld		hl,adr_bulles_du_chaudron_1_ROM
				call	affichage_de_l_animation
				xor		a
				ld		(nbr_frame_anim_bulles_du_chaudron),a
				ret
			anim_bulles_du_chaudron_no_2
				ld		hl,adr_bulles_du_chaudron_2_ROM
				call	affichage_de_l_animation
				xor		a
				ld		(nbr_frame_anim_bulles_du_chaudron),a
				ret
			anim_bulles_du_chaudron_no_3
				ld		hl,adr_bulles_du_chaudron_3_ROM
				call		affichage_de_l_animation
				xor		a
				ld		(nbr_frame_anim_bulles_du_chaudron),a
				ret
			anim_bulles_du_chaudron_no_4
				ld		hl,adr_bulles_du_chaudron_4_ROM
				call	affichage_de_l_animation
			; on réinitialise le compteur d'étape de l'animation
						xor		a
						ld		(etape_anim_bulles_du_chaudron),a
						ld		(nbr_frame_anim_bulles_du_chaudron),a
						ret

	


