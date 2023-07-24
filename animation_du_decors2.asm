; /////////////////////////////////////////////////////////////////////////////////////////////////////////////////
; /////////////////////////////////////////////////////////////////////////////////////////////////////////////////
; //////////////////////////////      INITIALISATION DES EVENTS DES ANIMATIONS DU DECORS   ////////////////////////
; /////////////////////////////////////////////////////////////////////////////////////////////////////////////////
; /////////////////////////////////////////////////////////////////////////////////////////////////////////////////
calcule_presence_animation_du_decors
		ld		a,(no_bank_maptile_deco)
		ld		c,a
		ld		c,bank_maptile_decors
		call	rom_on
		ld		hl,(adresse_du_decors_en_rom)
		ld		a,(hl)
		ld		e,a
		inc 	hl
		ld		a,(hl)
		ld		d,a
	; de contient le numero de la tile à lire
	; pour savoir quelle ligne de la table lire il faut multiplier leur longueur par le no de la ligne alias la salle
		ld		a,(no_de_la_salle)		; de contient le numero de la salle actuelle
		ld		h,0
		ld		l,a
		add 	hl,hl					; x2 les lignes font 16 octets de longeure donc on multiplie par 16
		add		hl,hl					; x4
		add 	hl,hl					; x8
		add		hl,hl					; x16
		ld		d,h
		ld		e,l						
	; DE contient ce qu'il faut additionner à l'adresse départ de la table
		ld		hl,table_animations					; je recupère l'adresse de la table à LIRE
		add		hl,de								; là on additionne pour tomber sur la bonne ligne à LIRE
		ld		a,nbr_d_animations_decors			; maximum 4 animations
		ld		ix,adr_ecran_des_anim_en_cours				; et on ECRIT dans cette table là
		ld		iy,event_animations					; adresse dans la boucle où afficher l'event
				; je lit dans la table_animation les adresses des routines qui affiche une animation ainsi que 
				; l'endroit où elles doivent d'animer.
			boucle_calcule_presence
				ld		c,(hl)					; on recupère l'octet de l'adresse poid faible
												; on sauvegarde dans L
				inc		hl						; octet suivant dans la table
				ld		b,(hl)					; on recupère l'octet de l'adresse poids fort
												; on sauvegarde dans H.
								; HL contient l'adresse de la routine d'animation.
								; on ecrit un CALL dans A (#CD)
				
				; on test si il existe une autre animation présente dans table
				; si résultat = 0 alors on sort de la boucle car il n'y a plus d'animations
				; si différent de zéros alors on continue pour lire et écrire la prochaine animations
				push	hl
				push	bc
				ld		h,b
				ld		l,c
				ld		bc,#0000
				SBC		hl,bc
				pop		bc
				pop		hl
				RET		Z														
					
	; on affiche chaque evenement d'animation dans la boucle
	ld		(iy),#CD					; CALL que l'on ecrit à l'adresse iy
	ld		(iy+1),bc					; on ecrit l'adresse de la routine à l'adresse IY+1
	inc		hl							; on passe soit à l'adr ecran de l'anim (ou de la routine suivante)
	ld		e,(hl)						; on lit l'octet de hl qu'on stock dans e
	inc		hl							; octet suivant
	ld		d,(hl)						; on lit l'ocet de hl qu'on stock dans d
	; de contient l'adr ecran de l'anim (ou de la routine suivante)
	ld		(ix),de						; on ecrit l'adresse écran dans la adr_ecran_des_anim_en_cours
	inc		ix							
	inc		ix							; on deplace le pointeur pour écrire la suite
	inc		hl							; on déplace le pointeur pour lire la prochaine anim dans la table
	inc		iy							
	inc		iy
	inc		iy							; on déplace le pointeur pour ecrire le prochain event dans la boucle 
	dec		a							; on decremente le compteur d'anim
	jr		nz,boucle_calcule_presence	; si c'est pas à zéro alors on recommence pour l'animation suivante
	ret

adr_ecran_des_anim_en_cours ; ici s'écrivent les adresses lu dans la table 
DW	0,0,0,0

; /////////////////////////////////////////////////////////////////////////////////////////////////////////////////
; /////////////////////////////////////////////////////////////////////////////////////////////////////////////////
; //////////////////////////////             ANIMATIONS DES ELEMENTS DU DECORS             ////////////////////////
; /////////////////////////////////////////////////////////////////////////////////////////////////////////////////
; /////////////////////////////////////////////////////////////////////////////////////////////////////////////////

; //////////////////////////////             LES BUILLES DU CHAUDRON             ///////////////////////////
anim_bulles_du_chaudron
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

		;ld		c,bank_sprite_genere			; on sélectionne la bank contenant les sprites générés
		;call	rom_on							; on s'y connecte
		;ld		de,#c000						; DEstination ecran du sprite
		;call	#c000							; Lecture / affichage du sprite
		;call	rom_off							; déconnexion de la bank
		;ret



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
					call	rom_off
					ret


