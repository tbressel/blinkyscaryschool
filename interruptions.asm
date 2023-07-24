; //////////////////////////////////////////////////////////////////
; //////////////////////////////////////////////////////////////////
; ////////////////////        INTERRUPTIONS      ///////////////////
; //////////////////////////////////////////////////////////////////
; //////////////////////////////////////////////////////////////////

interruption_ligne_160
; sauvegarde des registres
	push af : push hl : push de
	push bc : push ix : push iy

; connexion ASIC
	ld		bc,#7F00+%10111000			 
	out 	(c),c
; envoie de la ligne dans le PRI
 	ld		a,220
	ld		(#6800),a
	ld		hl,interruption_ligne_200
	ld		(#39),hl

; chargement palette du hud
	ld		hl,(pallette_en_cours_hud)
	ld		de,#6400
	ldi:ldi:ldi:ldi:ldi:ldi:ldi:ldi
; remise en place de l'asic
	ld		a,(valeur_asic)
	ld		b,#7F
	out		(c),a

; remise en place des connexions de bank ROM
	ld		bc,(rom_sectionnee)
	out 	(c),c
	ld		bc,(etat_de_la_rom)
	out 	(c),c
; je recupère les bits 2 & 3 contenus dans C
; pour lire les bits on prends la valeur à lire
; puis on la AND avec une valeur dont les bits à lire
; sont mis à 1
; exemple : une bank connecté = 1000 0100
; on veut lire les bits  2 et 3 donc on AND avec :
; la valeur 0000 1100 et on obtien 0000 0100
	ld	a,c
	and %00001100		; on AND une valeur avec le registre a.
	ld	e,a				; on sauvegarde le résultat
; sélèction du mode 1 en mettant les bits 2 et 3 à zéro
; pour les "OR"er et conserver l'état des Bank rétablies
; dans l'opération précédante. Si on les laisse à 1, le OR
; les laissera à 1. exemple : 
; e = 0100 qu'on OR avec c = 1101, résultat = 1101 = pas bon
; e = 0100 qu'on OR avec c = 0001, résultat = 0101 = bon
	ld  bc,#7F00+%10000001
	ld	(etat_du_mode),bc
; on envoie les bits 2 & 3 dans c
	ld	a,c
	or	e		; on OR ce qu'il y a dans le reg a avec la valeur du reg e.
; on execute le changement de mode sans toucher au Bank
	 out (c),a
	 
	 ld		c,a
	 ld		(etat_roms_mode),bc

automodif_mode_1 
	ld	a,1
	ld	(mode),a
	
; récuperation des registres
	pop iy : pop ix : pop bc
	pop de : pop hl : pop af	
	ei
	ret	
	

	
interruption_ligne_200
; sauvegarde des registres
	push af : push hl : push de
	push bc : push ix : push iy
event_musique			ds			3,0				;call 	PLY_AKG_Play

; connexion ASIC
	ld	bc,#7FB8:out (c),c
; envoie de la ligne dans le PRI
automodif_ligne
 	ld	a,160
	ld	(#6800),a
	ld	hl,interruption_ligne_160
	ld	(#39),hl
; chargement palette du decors
	ld		hl,(pallette_en_cours_decors)
	ld		de,#6400
	ld		bc,#20
	LDIR
; remise en place de l'asic
	ld	a,(valeur_asic)
	ld	b,#7F
	out	(c),a

; remise en place des connexion de bank ROM
	ld	bc,(rom_sectionnee)
	out (c),c
	ld	bc,(etat_de_la_rom)
	out (c),c

	ld	a,c
	and %00001100		; on AND une valeur avec le registre a.
	ld	e,a				; on sauvegarde le résultat
	ld  bc,#7F00+%10000000
	ld	(etat_du_mode),bc
	ld	a,c
	or	e
	out (c),a
	
	 ld		c,a
	 ld		(etat_roms_mode),bc

	xor a
	ld	(mode),a


; récuperation des registres
	pop iy : pop ix : pop bc
	pop de : pop hl : pop af
	ei
	ret	
	
	
	
