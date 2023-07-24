ORG #8000
di										; on désactive les interruptions

; //////////////////////////////////////////////////////////////////
; //////////////////////////////////////////////////////////////////
; ////////////////        INIT CONNEXION ROM      //////////////////
; //////////////////////////////////////////////////////////////////
; //////////////////////////////////////////////////////////////////
	ld		c,bank_rom_0					; sélection de la ROM n°0
	ld		a,#80				
	add		a,c							; on ajoute #80 au numéros de la ROM
	ld		c,a							; le reg C contient la valeur de sélection de la ROM
	ld		b,#DF
	ld		(rom_sectionnee),bc
	out		(c),c						; on execute la sélèction de la ROM
	ld		bc,#7F00+%10001100			; ROM inf déconnectée, ROM sup déconnectée, MODE 0
	ld		(etat_de_la_rom),bc
	out		(c),c						; on exécute la connexion de la ROM sélectionnée.
; ////////////////////////////////////////////////////////////////////////
; ////////////////////////////////////////////////////////////////////////
; ////////////////        MISE A ZERO DES PALLETTES     //////////////////
; ////////////////////////////////////////////////////////////////////////
; ////////////////////////////////////////////////////////////////////////
	ld		hl,pallette_noire
	ld		(pallette_en_cours_decors),hl
	ld		(pallette_en_cours_hud),hl
; //////////////////////////////////////////////////////////////////
; //////////////////////////////////////////////////////////////////
; ////////////////        INIT INTERRUPTIONS      //////////////////
; //////////////////////////////////////////////////////////////////
; //////////////////////////////////////////////////////////////////
	ld		a,#C3
	ld		(#38),a
	ld		hl,interruption_ligne_160
	ld		(#39),hl
	EI
; //////////////////////////////////////////////////////////////////
; //////////////////////////////////////////////////////////////////
; ///////////////////        INIT du jeu      //////////////////////
; //////////////////////////////////////////////////////////////////
; //////////////////////////////////////////////////////////////////
	call	asic_off
	ld		c,bank_programme_rom
	call	rom_on
	call	initialisation_du_jeu_ROM
	call	rom_off
	call	COPIE_RAM_SAMPLES
; //////////////////////////////////////////////////////////////////
; //////////////////////////////////////////////////////////////////
; ///////////////////        INIT du HUD      //////////////////////
; //////////////////////////////////////////////////////////////////
; //////////////////////////////////////////////////////////////////

ld		hl,DMA_LIST_1
call	set_DMA
ld		hl,DMA_LIST_2
call	set_DMA
ld		hl,DMA_LIST_3
call	set_DMA
NOUVELLE_PIECE_APRES_TIME_OUT
	call	asic_off
	call	on_affiche_le_hud
	call	init_barre_energie
	call	asic_on
	call	afficher_les_items
; //////////////////////////////////////////////////////////////////
; //////////////////////////////////////////////////////////////////
; ////////////////        INIT CHANGEMENT DE      //////////////////
; ////////////////             PIECE              //////////////////
; //////////////////////////////////////////////////////////////////
; //////////////////////////////////////////////////////////////////
NOUVELLE_PIECE
	call	rom_off
	call	asic_off
	call	init_event_nouvelle_piece
	call	asic_on
	ld		hl,pallette_noire
	ld		(pallette_en_cours_decors),hl
	call	on_efface_les_sprh_ennemis
	call	asic_off
	call	calcule_presence_animation_du_decors					; animation_de_decors.asm
	call 	calcule_presence_ennemis
	call	asic_off
	call	passage_secret
	call	on_affiche_le_decors	; decors.asm
	call	on_affiche_nbr_de_vie
	call	asic_on
	call	test_lumiere
; //////////////////////////////////////////////////////////////////
; //////////////////////////////////////////////////////////////////
; //////////////////        BOUCLE DU JEU      /////////////////////
; //////////////////            DEBUT          /////////////////////
; //////////////////////////////////////////////////////////////////
BOUCLE_PRINCIPALE
		LD    B,#F5    			;adresse du port B du PPI
		FRAME   IN    A,(C)     		;On récupère l'octet contenu sur le port dans A
				RRA              		;On fait une rotation afin de récupérer le bit 0 dans le flag carry
				JR    NC,FRAME  			;tant que le flag carry n'est pas à 1 on boucle au label frm
		event_boucle_fin_du_jeu			ds	3,0
		call	asic_off
		call	le_temps_qui_passe
		call	asic_on

		event_gameover					ds	3,0
		retour_gameover
		event_boucle_gameover			ds	3,0
		
		event_blinky
			call	blinky
			call	afficher_les_items
	; animations du décors
		event_animations				ds	15,0
	
		event_salle_no4					ds	3,0
	; ennemis
		event_chauve_rouge				ds	3,0
		event_chauve_vert				ds	3,0
		
		event_abeille_jaune				ds	3,0
		event_abeille_grise				ds	3,0
		
		event_araignee_bleue			ds	3,0
		event_araignee_jaune			ds	3,0
		
		event_poisson_vert				ds	3,0
		event_poisson_rouge				ds	3,0
		
		event_souris					ds	3,0
		
		event_escargot_vert				ds	3,0
		event_escargot_rouge			ds	3,0
		
		event_grenouille_verte			ds	3,0
		event_grenouille_rouge			ds	3,0
		
		event_pierre_qui_tombe_1		ds	3,0
		event_pierre_qui_tombe_2		ds	3,0
		event_pierre_qui_tombe_3		ds	3,0
		
	; contrôle				
test_de_touches
		call	test_du_clavier_direction
		ld		a,(resultat_test_de_touche)
		 haut_jpz			bit		0,a
							jp		z,haut
							bit		5,a
		fire2_jpz			jp		z,inventaire
		retour_fire2
							bit		2,a
		gauche_jpz			jp		z,gauche
							
							bit 	3,a
		droite_jpz			jp		z,droite
		retour_avant_test_fire
		
		call	test_du_clavier_saut
		ld		a,(resultat_test_de_touche)
							bit		4,a
		fire1_jpz			jp		z,saut
		 bas_jpz			ds		5,0
		
		retour_test_de_touches
	
		event_tombe			ds		3,0
		event_remonte		ds		3,0
		jp	tombe
		retour_tombe
		retour_remonte
		retour_du_saut
		retour_direction
JP BOUCLE_PRINCIPALE
; //////////////////////////////////////////////////////////////////
; //////////////////////////////////////,////////////////////////////
; //////////////////        BOUCLE DU JEU      /////////////////////
; //////////////////             FIN           /////////////////////
; //////////////////////////////////////////////////////////////////
boucle_parchemin
					call	asic_off
					call	VBL2
					call	test_du_clavier_direction
					bit		4,a
	fire1b_jpz		jp		z,fin_parchemin
					jp	boucle_parchemin


retour_fin_parchemin
	ld		c,bank_programme_rom
	call	rom_on
	call	retour_fin_parchemin_ROM
	call	rom_off	
	jp	boucle_principale
	
	
	



	
	
	VBL2
	LD    B,#F5    			;adresse du port B du PPI
		FRAME2   IN    A,(C)     		;On récupère l'octet contenu sur le port dans A
				RRA              		;On fait une rotation afin de récupérer le bit 0 dans le flag carry
				JR    NC,FRAME2  			;tant que le flag carry n'est pas à 1 on boucle au label frm
	RET
; //////////////////////////////////////////////////////////////////
; //////////////////////////////////////////////////////////////////
; ////////////////////       SOUS-ROUTINE  /////////////////////////
; //////////////////////////////////////////////////////////////////
; //////////////////////////////////////////////////////////////////
test_du_clavier_direction
	LD		BC,#F40E:OUT (C),c
	LD		BC,#F6C0:OUT (C),C
	LD		BC,#F600:OUT (C),C
	LD		BC,#F792:OUT (C),C				; on place le port A en sortie (#92)
	LD		BC,#F649:OUT (C),C				; test la ligne 9 avec #F6 + %0100 1001 (#49)
	LD		B,#F4:IN A,(C)
	LD		BC,#F782:OUT (C),C				; on place le port A en entrée (#82)
	LD		BC,#F600:OUT (C),C
	ld		(resultat_test_de_touche),a

	RET



test_du_clavier_saut
	LD		BC,#F40E:OUT (C),c
	LD		BC,#F6C0:OUT (C),C
	LD		BC,#F600:OUT (C),C
	LD		BC,#F792:OUT (C),C				; on place le port A en sortie (#92)
	LD		BC,#F649:OUT (C),C				; test la ligne 9 avec #F6 + %0100 1001 (#49)
	LD		B,#F4:IN A,(C)
	LD		BC,#F782:OUT (C),C				; on place le port A en entrée (#82)
	LD		BC,#F600:OUT (C),C
	ld		(resultat_test_de_touche),a
	cp		a,%11101111			;#EF si c'est juste un saut
	jp		z,fire1_on
	cp		a,%11100111			;#E7 si c'est un saut à droit
	jp		z,fire1_on
	cp		a,%11101011			;#EB si c'est saut à gauche
	jp		z,fire1_on
	jp		fire1_off

fire1_on
	ld		a,(switch_bouton_fire1)		; switch = 0 au départ avant le saut et on 
	cp		a,1							; arrive ici juste après pression fire 1							
	ret		Z							; switch = 1 on init le saut
	ld		a,1							; on indique que l'on est en train d'appuyer
	ld		(bouton_fire1),a
	RET
fire1_off
	xor		a						; on appuye plus donc on reinit 
	ld		(switch_bouton_fire1),a		; l'accès au saut
	ld		(bouton_fire1),a
	RET

ligne_inferieur
	ld		a,d				; on travail avec DE. #CO est dans D
	add		a,8				; on doit passer en #C8, donc #C0 + 8
	ld		d,a				; on rebalance le résultat dans D.
	ret		nc				; on revient si résultat PAS NEGATIF
	ex		hl,de			; comme on bosse avec de, on change avec hl
	ld		bc,#c050		; décalage pour le bloc de ligne suivante
	add		hl,bc			; le résultat est dans hl.
	ex		de,hl			; et on remet dans DE pour continuer.
	ret
on_efface_les_sprh_ennemis
	xor		a
	ld		hl,SPRH4_ADR
	ld		e,l
	ld		d,h
	inc		de
	ld		(hl),a
	ld		bc,#800
	LDIR
	ret
	
set_DMA
ld		b,6
boucle_dma
ld		a,0
ld		(hl),a
inc		hl
dec		b
jr		nz,boucle_dma		
ret
		


; //////////////////////////////////////////////////////////////////
; //////////////////////////////////////////////////////////////////
; ////////////        FICHIER CONNEXES AU PROGRAMME      ///////////
; //////////////////////////////////////////////////////////////////
; //////////////////////////////////////////////////////////////////
; blinky
read"gestion_de_blinky.asm"
read"animation_de_blinky.asm"
read"changement_salle.asm"
; données
read"variables.asm"
; ennemy
read"gestion_souris.asm"
read"gestion_escargot_vert.asm"
read"gestion_escargot_rouge.asm"
read"gestion_araignee_bleue.asm"
read"gestion_araignee_jaune.asm"
read"gestion_chauve_rouge.asm"
read"gestion_chauve_vert.asm"
read"gestion_grenouille_verte.asm"
read"gestion_grenouille_rouge.asm"
read"gestion_abeille_jaune.asm"
read"gestion_abeille_grise.asm"
read"gestion_pierres_qui_tombent.asm"
read"gestion_poisson_vert.asm"
read"gestion_poisson_rouge.asm"
; items
read"affichage_des_items.asm"
;read"decors.asm"
read"animation_du_decors.asm"
; moteur
read"collision_avec_le_decors.asm"
read"collision_avec_les_ennemis.asm"
read"collision_avec_les_items.asm"
read"interruptions.asm"
read"interrupteurs.asm"

read"gestion_de_inventaire.asm"



read"constantes.asm"







