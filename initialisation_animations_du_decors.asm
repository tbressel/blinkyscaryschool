; /////////////////////////////////////////////////////////////////////////////////////////////////////////////////
; /////////////////////////////////////////////////////////////////////////////////////////////////////////////////
; //////////////////////////////      INITIALISATION DES EVENTS DES ANIMATIONS DU DECORS   ////////////////////////
; /////////////////////////////////////////////////////////////////////////////////////////////////////////////////
; /////////////////////////////////////////////////////////////////////////////////////////////////////////////////
calcule_presence_animation_du_decors
	
	; pour savoir quelle ligne de la table lire il faut multiplier leur longueur par le no de la ligne alias la salle
		ld		a,(no_de_la_salle)		; de contient le numero de la salle actuelle
		ld		h,0
		ld		l,a
		add 	hl,hl					; x2 les lignes font 24 octets de longeure donc on multiplie par 24 (n * 16)+(n * 8)
		add		hl,hl					; x4
		add 	hl,hl					; x8
		add		hl,hl					; x16
		ld		d,h
		ld		e,l
		
		ld		a,(no_de_la_salle)		; de contient le numero de la salle actuelle
		ld		h,0
		ld		l,a
		add 	hl,hl					; x2 les lignes font 24 octets de longeure donc on multiplie par 24 (n * 16)+(n * 8)
		add		hl,hl					; x4
		add 	hl,hl					; x8
		
		add		hl,de
		ld		d,h
		ld		e,l		
		; DE contient ce qu'il faut additionner à l'adresse départ de la table
				
		ld		c,bank_table_animation_decors		; bank 8
		call	rom_on
		ld		hl,table_animations					; je recupère l'adresse de la table à LIRE
		add		hl,de								; là on additionne pour tomber sur la bonne ligne à LIRE
		ld		a,nbr_d_animations_decors			; maximum 4 animations
		ld		ix,adr_ecran_des_anim_en_cours		; et on ECRIT dans cette table là
		ld		iy,event_animations					; adresse dans la boucle où afficher l'event
	; je lit dans la table_animation les adresses des routines qui affiche une animation ainsi que 
	; l'endroit où elles doivent s'animer.
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
				jr		z,	animation_suivante													
					
	; on affiche chaque evenement d'animation dans la boucle
	ld		(iy),#CD					; CALL que l'on ecrit à l'adresse iy
	ld		(iy+1),bc					; on ecrit l'adresse de la routine à l'adresse IY+1
	animation_suivante
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
	call	rom_off
	ret
	
	