

adr_ecran_des_anim_en_cours ; ici s'écrivent les adresses lu dans la table, 4 animations maximum
DW	0,0,0,0,0,0

; /////////////////////////////////////////////////////////////////////////////////////////////////////////////////
; /////////////////////////////////////////////////////////////////////////////////////////////////////////////////
; //////////////////////////////             ANIMATIONS DES ELEMENTS DU DECORS             ////////////////////////
; /////////////////////////////////////////////////////////////////////////////////////////////////////////////////
; /////////////////////////////////////////////////////////////////////////////////////////////////////////////////

; //////////////////////////////             LES BUILLES DU CHAUDRON             ///////////////////////////
anim_bulles_du_chaudron
call	asic_off
call	anim_bulles_du_chaudron4000
call	asic_on
ret




; //////////////////////////////             LE FEU DU CHAUDRON             ////////////////////////
anim_feu_du_chaudron
		ld		a,(nbr_frame_anim_feu_du_chaudron)
		inc		a
		ld		(nbr_frame_anim_feu_du_chaudron),a
		cp		vitesse_anim_feu_du_chaudron
		ret		nz
		ld		c,bank_animation_decors
		call	rom_on
		ld		de,(adr_ecran_des_anim_en_cours+2)
		ld		hl,largeur_feu_du_chaudron
		ld		(largeur_animation),hl
		ld		b,hauteur_feu_du_chaudron
		ld		a,(etape_anim_feu_du_chaudron)
		inc		a
		ld		(etape_anim_feu_du_chaudron),a
		cp		1
		jr		z,anim_feu_du_chaudron_no_1
		cp		2
		jr		z,anim_feu_du_chaudron_no_2
		cp		3
		jr		z,anim_feu_du_chaudron_no_3
		cp		4
		jr		z,anim_feu_du_chaudron_no_4
			anim_feu_du_chaudron_no_1
				ld		hl,adr_feu_du_chaudron_1_ROM
				call		affichage_de_l_animation
				xor		a
				ld		(nbr_frame_anim_feu_du_chaudron),a
				ret
			anim_feu_du_chaudron_no_2
				ld		hl,adr_feu_du_chaudron_2_ROM
				call		affichage_de_l_animation
				xor		a
				ld		(nbr_frame_anim_feu_du_chaudron),a
				ret
			anim_feu_du_chaudron_no_3
				ld		hl,adr_feu_du_chaudron_3_ROM
				call		affichage_de_l_animation
				xor		a
				ld		(nbr_frame_anim_feu_du_chaudron),a
				ret
			anim_feu_du_chaudron_no_4
				ld		hl,adr_feu_du_chaudron_4_ROM
				call	affichage_de_l_animation
			; on réinitialise le compteur d'étape de l'animation
						xor		a
						ld		(etape_anim_feu_du_chaudron),a
						ld		(nbr_frame_anim_feu_du_chaudron),a
						ret





; //////////////////////////////             LES TETES DE MORT             ////////////////////////
anim_tete_de_mort
		ld		a,(nbr_frame_anim_tete_de_mort)
		inc		a
		ld		(nbr_frame_anim_tete_de_mort),a
		cp		vitesse_anim_tete_de_mort
		ret		nz
		ld		c,bank_animation_decors
		call	rom_on
		ld		de,(adr_ecran_des_anim_en_cours+4)
		ld		b,hauteur_tete_de_mort
		ld		hl,largeur_tete_de_mort
		ld		(largeur_animation),hl
		ld		a,(etape_anim_tete_de_mort)
		inc		a
		ld		(etape_anim_tete_de_mort),a
		cp		1
		jr		z,anim_tete_de_mort_no_1
		cp		2
		jr		z,anim_tete_de_mort_no_2
		cp		3
		jr		z,anim_tete_de_mort_no_3
		cp		4
		jr		z,anim_tete_de_mort_no_4
		
			anim_tete_de_mort_no_1
				ld		hl,adr_tete_de_mort_1_ROM
				call		affichage_de_l_animation
				xor		a
				ld		(nbr_frame_anim_tete_de_mort),a
				ret
			anim_tete_de_mort_no_2
				ld		hl,adr_tete_de_mort_2_ROM
				call	affichage_de_l_animation
				xor		a
				ld		(nbr_frame_anim_tete_de_mort),a
				ret
			anim_tete_de_mort_no_3
				ld		hl,adr_tete_de_mort_3_ROM
				call		affichage_de_l_animation
				xor		a
				ld		(nbr_frame_anim_tete_de_mort),a
				ret
			anim_tete_de_mort_no_4
				ld		hl,adr_tete_de_mort_4_ROM
				call	affichage_de_l_animation
			; on réinitialise le compteur d'étape de l'animation
						xor		a
						ld		(etape_anim_tete_de_mort),a
						ld		(nbr_frame_anim_tete_de_mort),a
						ret

; //////////////////////////////            BOUGIE          ////////////////////////
anim_bougie
		ld		a,(nbr_frame_anim_bougie)
		inc		a
		ld		(nbr_frame_anim_bougie),a
		cp		vitesse_anim_bougie
		ret		nz
		ld		c,bank_animation_decors
		call	rom_on
		ld		de,(adr_ecran_des_anim_en_cours+6)
		ld		b,hauteur_bougie
		ld		hl,largeur_bougie
		ld		(largeur_animation),hl
		ld		a,(etape_anim_bougie)
		inc		a
		ld		(etape_anim_bougie),a
		cp		1
		jr		z,anim_bougie_no_1
		cp		2
		jr		z,anim_bougie_no_2
		cp		3
		jr		z,anim_bougie_no_3
		cp		4
		jr		z,anim_bougie_no_4
		
			anim_bougie_no_1
				ld		hl,adr_bougie_1_ROM
				call	affichage_de_l_animation
				xor		a
				ld		(nbr_frame_anim_bougie),a
				ret
			anim_bougie_no_2
				ld		hl,adr_bougie_2_ROM
				call	affichage_de_l_animation
				xor		a
				ld		(nbr_frame_anim_bougie),a
				ret
			anim_bougie_no_3
				ld		hl,adr_bougie_3_ROM
				call	affichage_de_l_animation
				xor		a
				ld		(nbr_frame_anim_bougie),a
				ret
			anim_bougie_no_4
				ld		hl,adr_bougie_4_ROM
				call	affichage_de_l_animation
			; on réinitialise le compteur d'étape de l'animation
						xor		a
						ld		(etape_anim_bougie),a
						ld		(nbr_frame_anim_bougie),a
						ret

; //////////////////////////////            EAU          ////////////////////////

anim_eau
		ld		a,(nbr_frame_anim_eau)
		inc		a
		ld		(nbr_frame_anim_eau),a
		cp		vitesse_anim_eau
		ret		nz
		ld		c,bank_animation_decors
		call	rom_on
		ld		de,(adr_ecran_des_anim_en_cours+8)
		ld		hl,largeur_eau
		ld		(largeur_animation),hl
		ld		b,hauteur_eau
		ld		a,(etape_anim_eau)
		inc		a
		ld		(etape_anim_eau),a
		cp		1
		jr		z,anim_eau_no_1
		cp		2
		jr		z,anim_eau_no_2
		cp		3
		jr		z,anim_eau_no_3
		cp		4
		jr		z,anim_eau_no_4
		cp		5
		jr		z,anim_eau_no_5
		cp		6
		jr		z,anim_eau_no_6
			anim_eau_no_1
				ld		hl,adr_eau_1_ROM
				call		affichage_de_l_animation
				xor		a
				ld		(nbr_frame_anim_eau),a
				ret
			anim_eau_no_2
				ld		hl,adr_eau_2_ROM
				call		affichage_de_l_animation
				xor		a
				ld		(nbr_frame_anim_eau),a
				ret
			anim_eau_no_3
				ld		hl,adr_eau_3_ROM
				call		affichage_de_l_animation
				xor		a
				ld		(nbr_frame_anim_eau),a
				ret
			anim_eau_no_4
				ld		hl,adr_eau_4_ROM
				call	affichage_de_l_animation
				xor		a
				ld		(nbr_frame_anim_eau),a
				ret
			anim_eau_no_5
				ld		hl,adr_eau_5_ROM
				call	affichage_de_l_animation
				xor		a
				ld		(nbr_frame_anim_eau),a
				ret
			anim_eau_no_6
				ld		hl,adr_eau_6_ROM
				call	affichage_de_l_animation
			; on réinitialise le compteur d'étape de l'animation
						xor		a
						ld		(etape_anim_eau),a
						ld		(nbr_frame_anim_eau),a
						ret
anim_eau2
		ld		a,(nbr_frame_anim_eau2)
		inc		a
		ld		(nbr_frame_anim_eau2),a
		cp		vitesse_anim_eau
		ret		nz
		ld		c,bank_animation_decors
		call	rom_on
		ld		de,(adr_ecran_des_anim_en_cours+10)
		ld		hl,largeur_eau
		ld		(largeur_animation),hl
		ld		b,hauteur_eau
		ld		a,(etape_anim_eau2)
		inc		a
		ld		(etape_anim_eau2),a
		cp		1
		jr		z,anim_eau2_no_1
		cp		2
		jr		z,anim_eau2_no_2
		cp		3
		jr		z,anim_eau2_no_3
		cp		4
		jr		z,anim_eau2_no_4
		cp		5
		jr		z,anim_eau2_no_5
		cp		6
		jr		z,anim_eau2_no_6
			anim_eau2_no_1
				ld		hl,adr_eau_1_ROM
				call		affichage_de_l_animation
				xor		a
				ld		(nbr_frame_anim_eau2),a
				ret
			anim_eau2_no_2
				ld		hl,adr_eau_2_ROM
				call		affichage_de_l_animation
				xor		a
				ld		(nbr_frame_anim_eau2),a
				ret
			anim_eau2_no_3
				ld		hl,adr_eau_3_ROM
				call		affichage_de_l_animation
				xor		a
				ld		(nbr_frame_anim_eau2),a
				ret
			anim_eau2_no_4
				ld		hl,adr_eau_4_ROM
				call	affichage_de_l_animation
				xor		a
				ld		(nbr_frame_anim_eau2),a
				ret
			anim_eau2_no_5
				ld		hl,adr_eau_5_ROM
				call	affichage_de_l_animation
				xor		a
				ld		(nbr_frame_anim_eau2),a
				ret
			anim_eau2_no_6
				ld		hl,adr_eau_6_ROM
				call	affichage_de_l_animation
			; on réinitialise le compteur d'étape de l'animation
						xor		a
						ld		(etape_anim_eau2),a
						ld		(nbr_frame_anim_eau2),a
						ret




affichage_de_l_animation	
				boucle_du_chaudrons
					push	bc
					push	de
					ld		bc,(largeur_animation)
					ldir
					pop		de
					call	LIGNE_INFERIEUR
					pop		bc
					djnz	boucle_du_chaudrons
					
					ret


