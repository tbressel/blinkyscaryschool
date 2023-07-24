; ///////////////////////////////////////////////////////////////////////
; ///////////////////////////////////////////////////////////////////////
; //////////////// 	   CALCULE DES COLLISION DECORS       ///////////////
; ///////////////////////////////////////////////////////////////////////
; ///////////////////////////////////////////////////////////////////////
; selection des points de position a tenir compte pour detecter une collision
collision_porte
	; calcule avec le sprite SPRH2 (en bas à gauche de blinky)
	ld	hl,(pos_X_blinky)					; je prends X du sprite 2 (coin haut gauche)
	ld	(collision_decors_sprh_X),hl	; je stock X

	ld	hl,(pos_Y_blinky)					; je prends Y du sprite 2 (par defaut haut gauche)
	ld	(collision_decors_sprh_Y),hl	; je stock Y	
	jp	calcule_des_collisions
collision_gauche
	; calcule avec le sprite SPRH2 (en bas à gauche de blinky)
	ld	hl,(pos_X_blinky)					; je prends X du sprite 2 (coin haut gauche)
	ld	de,distance_gauche_mur+-8				; j'additionne rien
	add	hl,de				
	ld	(collision_decors_sprh_X),hl	; je stock X

	ld	hl,(pos_Y_blinky)					; je prends Y du sprite 2 (par defaut haut gauche)
	ld	de,distance_pied_sol			; je test les pieds de blinky
	add	hl,de					
	ld	(collision_decors_sprh_Y),hl	; je stock Y	
	jp	calcule_des_collisions

collision_droite
	; calcule avec le sprite SPRH2 (en bas à droite de blinky)
	ld	hl,(pos_X_blinky)					; je prends X du sprite 2 (coin haut gauche)
	ld	de,distance_droite_mur+8			; je me décale de 64
	add	hl,de				
	ld	(collision_decors_sprh_X),hl	; je stock X

	ld	hl,(pos_Y_blinky)					; je prends Y du sprite 2 (par defaut haut gauche)
	ld	de,distance_pied_sol			; je test les pieds de blinky
	add	hl,de					
	ld	(collision_decors_sprh_Y),hl	; je stock Y	
	jp	calcule_des_collisions
	

	
collision_tombe
	; calcule avec le sprite SPRH2 (en bas à droite de blinky)
	ld	hl,(pos_X_blinky)					; je prends X du sprite 2 (coin haut gauche)
	ld	de,16							; je me décale de 0 sur 32
	add	hl,de				
	ld	(collision_decors_sprh_X),hl	; je stock X

	ld	hl,(pos_Y_blinky)				; je prends Y du sprite 2 (par defaut haut gauche)
	ld	de,distance_pied_sol			; je test les pieds de blinky
	add	hl,de					
	ld	(collision_decors_sprh_Y),hl	; je stock Y	
	jp	calcule_des_collisions

collision_tombe_droite
	; calcule avec le sprite SPRH2 (en bas à droite de blinky)
	ld	hl,(pos_X_blinky)					; je prends X du sprite 2 (coin haut gauche)
	ld	de,32							; je me décale de 0 sur 32
	add	hl,de				
	ld	(collision_decors_sprh_X),hl	; je stock X

	ld	hl,(pos_Y_blinky)				; je prends Y du sprite 2 (par defaut haut gauche)
	ld	de,distance_pied_sol			; je test les pieds de blinky
	add	hl,de					
	ld	(collision_decors_sprh_Y),hl	; je stock Y	
	jp	calcule_des_collisions

collision_tombe_gauche
	; calcule avec le sprite SPRH2 (en bas à droite de blinky)
	ld	hl,(pos_X_blinky)					; je prends X du sprite 2 (coin haut gauche)
	ld	de,36						; je me décale de 0 sur 32
	add	hl,de				
	ld	(collision_decors_sprh_X),hl	; je stock X

	ld	hl,(pos_Y_blinky)				; je prends Y du sprite 2 (par defaut haut gauche)
	ld	de,distance_pied_sol			; je test les pieds de blinky
	add	hl,de					
	ld	(collision_decors_sprh_Y),hl	; je stock Y	
	jp	calcule_des_collisions
collision_tombe_eau
	; calcule avec le sprite SPRH3 (en bas à gauche de blinky)
	ld	hl,(SPRH2_X)					; je prends X du sprite 3 (coin haut gauche)
	ld	de,16							; je me décale de 16 sur 32
	add	hl,de				
	ld	(collision_decors_sprh_X),hl	; je stock X

	ld	hl,(SPRH2_Y)					; je prends Y du sprite 2 (par defaut haut gauche)
	ld	de,16						; je test les pieds de blinky
	add	hl,de					
	ld	(collision_decors_sprh_Y),hl	; je stock Y	
	jp	calcule_des_collisions




collision_tombe_bis
	; calcule avec le sprite SPRH3 (en bas à gauche de blinky)
	ld	hl,(SPRH3_X)					; je prends X du sprite 3 (coin haut gauche)
	ld	de,16							; je me décale de 16 sur 32
	add	hl,de				
	ld	(collision_decors_sprh_X),hl	; je stock X

	ld	hl,(pos_Y_blinky)					; je prends Y du sprite 2 (par defaut haut gauche)
	ld	de,distance_pied_sol			; je test les pieds de blinky
	add	hl,de					
	ld	(collision_decors_sprh_Y),hl	; je stock Y	
	jr	calcule_des_collisions
	
collision_saut
	; calcule avec le sprite SPRH2 (en bas à droite de blinky)
	ld	hl,(pos_X_blinky)					; je prends X du sprite 2 (coin haut gauche)
	ld	de,16							; je me décale de 0 sur 32
	add	hl,de				
	ld	(collision_decors_sprh_X),hl	; je stock X

	ld	hl,(SPRH2_Y)					; je prends Y du sprite 2 (par defaut haut gauche)
	ld	de,-8							; je test la tête de blinky (9)
	add	hl,de					
	ld	(collision_decors_sprh_Y),hl	; je stock Y	
	jr	calcule_des_collisions
collision_saut_bis
	; calcule avec le sprite SPRH3 (en bas à gauche de blinky)
	ld	hl,(SPRH3_X)					; je prends X du sprite 3 (coin haut gauche)
	ld	de,16							; je me décale de 16 sur 32
	add	hl,de				
	ld	(collision_decors_sprh_X),hl		; je stock X

	ld	hl,(SPRH2_Y)					; je prends Y du sprite 2 (par defaut haut gauche)
	ld	de,-8								; je test les pieds de blinky
	add	hl,de					
	ld	(collision_decors_sprh_Y),hl		; je stock Y	
	jr	calcule_des_collisions

collision_haut
	; calcule avec le sprite SPRH2 (en bas à droite de blinky)
	ld	hl,(pos_X_blinky)					; je prends X du sprite 2 (coin haut gauche)
	ld	de,16							; je me décale de 0 sur 32
	add	hl,de				
	ld	(collision_decors_sprh_X),hl	; je stock X

	ld	hl,(pos_Y_blinky)					; je prends Y du sprite 2 (par defaut haut gauche)
	ld	de,4							; je test la tête de blinky (9)
	add	hl,de					
	ld	(collision_decors_sprh_Y),hl	; je stock Y	
	jr	calcule_des_collisions
collision_haut_bis
	; calcule avec le sprite SPRH2 (en bas à droite de blinky)
	ld	hl,(pos_X_blinky)					; je prends X du sprite 2 (coin haut gauche)
	ld	de,16							; je me décale de 0 sur 32
	add	hl,de				
	ld	(collision_decors_sprh_X),hl	; je stock X

	ld	hl,(pos_Y_blinky)					; je prends Y du sprite 2 (par defaut haut gauche)
	ld	de,12							; je test la tête de blinky (9)
	add	hl,de					
	ld	(collision_decors_sprh_Y),hl	; je stock Y	
	jr	calcule_des_collisions
collision_bas
	; calcule avec le sprite SPRH2 (en bas à droite de blinky)
	ld	hl,(pos_X_blinky)					; je prends X du sprite 2 (coin haut gauche)
	ld	de,16							; je me décale de 0 sur 32
	add	hl,de				
	ld	(collision_decors_sprh_X),hl	; je stock X

	ld	hl,(pos_Y_blinky)					; je prends Y du sprite 2 (par defaut haut gauche)
	ld	de,16							; je test la tête de blinky (9)
	add	hl,de					
	ld	(collision_decors_sprh_Y),hl	; je stock Y	
	jr	calcule_des_collisions
calcule_des_collisions
; ///////////////////////////////////////////////////////////////////////
; ///////////////////////////////////////////////////////////////////////
; //////  N° DE LIGNE DE TILE SUR LA QUELLE SE TROUVE SPRH 02   /////////
; ///////////////////////////////////////////////////////////////////////
; ///////////////////////////////////////////////////////////////////////

		; les tiles font 8 lignes de haut
		; il y a 20 lignes de tile de 0 à 19. 
	    ; coordonnée Y / hauteur d'une tile = n° de la ligne de tile
			
	ld	hl,(collision_decors_sprh_Y)
	srl H : rr L				; disive par 2
	srl H : rr L				; divise par 4
	srl H : rr L				; divise par 8
	push	hl
		; on se cale sur la "n"ième tile de la map tile qui est au début de cette ligne
		; 40 octets (20 tiles de long) * no de la ligne 
		; multiplier par 40 = (n°ligne * 32) + (n°ligne * 8) 
	add 	hl,hl				; on multiplie par 2	
	add 	hl,hl				; on multiplie par 4
	add 	hl,hl				; on multiplie par 8
	add 	hl,hl				; on multiplie par 16
	add 	hl,hl				; on multiplie par 32
	ld 		d,h	
	ld 		e,l					; le resulatat est dans de 
	
	pop		hl
	add 	hl,hl				; on multiplie par 2	
	add 	hl,hl				; on multiplie par 4
	add 	hl,hl				; on multiplie par 8
	
	add		hl,de				; on additionne les 2 multiplications
	
								; Tile début de la "N" ligne où se trouve blinky
	push	hl

; ///////////////////////////////////////////////////////////////////////
; ///////////////////////////////////////////////////////////////////////
; ///////    SUR QUELLE TILE X DE LA MAPTILE TROUVE BLINKY      /////////
; ///////////////////////////////////////////////////////////////////////
; ///////////////////////////////////////////////////////////////////////
	ld	hl,(collision_decors_sprh_X)
	srl H : rr L				; disive par 2
	srl H : rr L				; divise par 4
	srl H : rr L				; divise par 8
	srl H : rr L				; divise par 16
	res 	0,l
	pop		de					; on récupère la valeur mise dans la pile avec HL mais dans DE
	
	add		hl,de				; pour additionner avec HL
	ld		(nieme_tile),hl	
; ///////////////////////////////////////////////////////////////////////
; ///////////////////////////////////////////////////////////////////////
; /////////    ADRESSE DE LA TILES TROUVE DANS LA MAPTILE       /////////
; ///////////////////////////////////////////////////////////////////////
; ///////////////////////////////////////////////////////////////////////
	ld		de,(adr_piece_actuelle)					; on part de ladresse où se situ la maptile
	add		hl,de						; on additionne X tiles plus loin
	ld		(adr_de_la_tile),hl
	ld		a,(no_bank_maptile_deco)
	ld		c,a
	call	rom_on
	ld		e,(hl)
	inc		hl
	ld		d,(hl)
	ld		(no_de_la_tile),de
	call	rom_off	
	
	ret
nieme_tile		ds		2,0
