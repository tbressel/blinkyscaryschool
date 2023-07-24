
; ///////////////////////////////////////////////////////////////////////////////////
; ///////////////////////////////////////////////////////////////////////////////////
; //////////////////       INITIALISATION DES ENNEMIS                        //////////
; ///////////////////////////////////////////////////////////////////////////////////
; ///////////////////////////////////////////////////////////////////////////////////

calcule_presence_ennemis
	ld		a,(no_de_la_salle)
	cp		a,4
	call	z,creer_event_salle_no4
	cp		a,19
	call	z,creer_event_salle_no4
	cp		a,25
	call	z,test_hidden_items25
	ld		c,bank_tables_ennemy
	call	rom_on
	call	calcul_piece_ennemis 	; on se place sur la ligne du tableau correspondant à la piece			
	LD		hl,tableau_ennemy_ROM				
	add		hl,de								
	LD		(pointeur_piece_ennemis),hl
	
	inc		l						; on vérifie quand même qu'on a un ennemis en testant le poid fort
	ld		a,(hl)
	or		a
	ret		z						; si y'a rien on se casse
	dec		l
	ld		de,tableau_ennemy_RAM		
	ld		b,4					; 48 octet par ligne
copie_en_RAM
	push	bc
	ldi:ldi			; on copie l'adresse
	ldi				; bank
	ldi				; type
	ldi:ldi			; pos X
	ldi:ldi			; pox Y
	ldi				; vitesse X
	ldi				; distance X
	ldi				; vitesse Y
	ldi				; distance Y
	ldi:ldi			; adr sprh
	ldi:ldi			; xyz
	pop	bc
	djnz 			copie_en_RAM
	
	
	
	
	; création des event
	ld		hl,type_ennemy_1
	ld		(adr_type_ennemis),hl
	ld		b,4								; nombre d'ennemis max par ligne du tableau
boucle_event_ennemis	
	ld		a,(hl)
	or		a
	ret 	z
	push	bc
	cp		a,ennemis_souris
	call	z,creer_event_souris
	cp		a,ennemis_escargot_vert
	call	z,creer_event_escargot_vert
	cp		a,ennemis_escargot_rouge
	call	z,creer_event_escargot_rouge
	cp		a,ennemis_araignee_bleu
	call	z,creer_event_araignee_bleu
	cp		a,ennemis_araignee_jaune
	call	z,creer_event_araignee_jaune
	cp		a,ennemis_chauve_rouge
	call	z,creer_event_chauve_rouge
	cp		a,ennemis_chauve_vert
	call	z,creer_event_chauve_vert
	cp		a,ennemis_grenouille_verte
	call	z,creer_event_grenouille_verte
	cp		a,ennemis_grenouille_rouge
	call	z,creer_event_grenouille_rouge
	cp		a,ennemis_abeille_jaune
	call	z,creer_event_abeille_jaune
	cp		a,ennemis_abeille_grise
	call	z,creer_event_abeille_grise
	cp		a,ennemis_poisson_vert
	call	z,creer_event_poisson_vert
	cp		a,ennemis_poisson_rouge
	call	z,creer_event_poisson_rouge
	ld		hl,(adr_type_ennemis)
	ld		de,16							; 14 octets utilisés par ennemy
	add		hl,de
	ld		(adr_type_ennemis),hl
	pop		bc
	djnz	boucle_event_ennemis
	ret
	
creer_event_souris
	push	af
	ld	a,#CD
	ld	(event_souris),a
	ld	hl,souris
	ld	(event_souris+1),hl
	pop		af
	ret
creer_event_escargot_vert
	push	af
	ld	a,#CD
	ld	(event_escargot_vert),a
	ld	hl,escargotvert
	ld	(event_escargot_vert+1),hl
	pop	af
	ret
creer_event_escargot_rouge
	push	af
	ld	a,#CD
	ld	(event_escargot_rouge),a
	ld	hl,escargotrouge
	ld	(event_escargot_rouge+1),hl
	pop	af
	ret
creer_event_araignee_bleu
	push	af
	ld	a,#CD
	ld	(event_araignee_bleue),a
	ld	hl,araigneebleue
	ld	(event_araignee_bleue+1),hl
	pop	af
	ret
creer_event_araignee_jaune
	push	af
	ld	a,#CD
	ld	(event_araignee_jaune),a
	ld	hl,araigneejaune
	ld	(event_araignee_jaune+1),hl
	pop	af
	ret
creer_event_chauve_rouge
	push	af
	ld	a,#CD
	ld	(event_chauve_rouge),a
	ld	hl,chauverouge
	ld	(event_chauve_rouge+1),hl
	pop	af
	ret
creer_event_chauve_vert
	push	af
	ld	a,#CD
	ld	(event_chauve_vert),a
	ld	hl,chauvevert
	ld	(event_chauve_vert+1),hl
	pop	af
	ret
creer_event_grenouille_verte
	push	af
	ld	a,#CD
	ld	(event_grenouille_verte),a
	ld	hl,grenouilleverte
	ld	(event_grenouille_verte+1),hl
	pop	af
	ret
creer_event_grenouille_rouge
	push	af
	ld	a,#CD
	ld	(event_grenouille_rouge),a
	ld	hl,grenouillerouge
	ld	(event_grenouille_rouge+1),hl
	pop	af
	ret
creer_event_abeille_jaune
	push	af
	ld	a,#CD
	ld	(event_abeille_jaune),a
	ld	hl,abeillejaune
	ld	(event_abeille_jaune+1),hl
	pop	af
	ret
creer_event_abeille_grise
	push	af
	ld	a,#CD
	ld	(event_abeille_grise),a
	ld	hl,abeillegrise
	ld	(event_abeille_grise+1),hl
	pop	af
	ret
creer_event_poisson_vert
	push	af
	ld	a,#CD
	ld	(event_poisson_vert),a
	ld	hl,poissonvert
	ld	(event_poisson_vert+1),hl
	pop	af
	ret
creer_event_poisson_rouge
	push	af
	ld	a,#CD
	ld	(event_poisson_rouge),a
	ld	hl,poissonrouge
	ld	(event_poisson_rouge+1),hl
	pop	af
	ret
calcul_piece_ennemis			; on doit multiplier par 64
	LD		hl,(no_de_la_salle)	; de contient le numero de la piece actuelle
	ld		h,0
	add 	hl,hl					; x2
	add		hl,hl					; x4
	add		hl,hl					; x8
	add 	hl,hl					; x16
	add		hl,hl					; x32
	add		hl,hl					; x64
	LD		(adr_piece_ennemis),hl
	ex		hl,de
	RET

creer_event_salle_no4
ld	a,#CD
	ld	(event_salle_no4),a
	ld	hl,pierresquitombent
	ld	(event_salle_no4+1),hl
ret

test_hidden_items25
	ld	hl,Item_ID_pour_chaudron
	ld	b,3
	boucle_test_hidden_items
		ld	a,(hl)
		cp	a,17				; bague
		jr	z,ok_bague
		inc	hl
		djnz	boucle_test_hidden_items
		ld		hl,0
		ld		(automodif_collision25),hl
		ret
	ok_bague
		ld		hl,#0B18
		ld		(automodif_collision25),hl
		ret

passage_secret
ld		a,(no_de_la_salle)
cp		108
ret		nz
ld		a,(flag_passage)
cp		a,1
call	z,affiche_passage
ret
affiche_passage
		ld	hl,salle_110+18
		ld	(adresse_du_decors_en_rom),hl
		ld	(adr_piece_actuelle),hl
		ret






