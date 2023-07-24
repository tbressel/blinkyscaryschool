test_texte_parchemin

ld		c,bank_programme_rom
call	rom_on
call	test_texte_parchemin_ROM
push	bc
call	rom_off
pop		bc
boucle_texte_parchemin
	push	bc
	push	de
	push	hl
	call	affiche_texte
	pop		hl
	pop 	de
	ld		bc,#50
	add		hl,bc
	ld		(adr_depart_texte),hl
	ld		a,(nbr_de_lettre)
	ld		b,0
	ld		c,a
	ex		hl,de
	add		hl,bc
	ex		de,hl
	ld		(adr_ligne_de_texte),de
	pop		bc
	djnz	boucle_texte_parchemin
	ld		a,(flag_reboot)
	cp		a,0
	ret		Z
	jp		boucle_reboot


on_affiche_nbr_de_vie
	ld	a,(nbr_de_vie)			; on recupère le nombre de vie
	inc	a
	ld	b,a						; on l'envoie dans Reg B pour le compteur
	ld	hl,tableau_nbr_vie		; on place dans HL l'aderesse du tableau des adresse de vies
boucle_adr_vie
	inc		hl
	inc		hl
	djnz	boucle_adr_vie
	ld		a,(hl)
	ld		e,a
	inc		hl
	ld		a,(hl)
	ld		d,a
	ld		(adr_chiffre_vie),de
	ld		hl,adr_ecran_vie
	EX		hl,de
on_affiche_le_chiffre
	ld		c,bank_fonte
	call	rom_on
	ld		b,8				; hauteur de ligne du chiffre
	boucle_affiche_chiffre
	push	bc
	ld		a,(hl)
	ld		(de),a			; on envoye 1 octets
	inc		hl
	inc		de				
	ld		a,(hl)
	ld		(de),a			; on a envoyé 2 octets
	inc		hl
	inc		de
	inc		hl					; octet suivant à lire
	ex		de,hl			
	ld		bc,#800
	add		hl,bc
	dec		hl
	dec		hl
	ex		hl,de
	pop		bc
	djnz	boucle_affiche_chiffre
	call	rom_off
	
	ret
tableau_nbr_vie
DW		0,VIE_0,VIE_1,VIE_2,VIE_3,VIE_4,VIE_5,VIE_6,VIE_7,VIE_8,VIE_9



affiche_texte
	ld		c,bank_programme_rom
	call	rom_on
	ld	HL,(adr_ligne_de_texte)		; adresse du texte à afficher
	ld	a,(nbr_de_lettre)			; il ya 24 lettres MAXIMUM par ligne (octets)
	ld	b,a				; on met dans le reg b, qui sera le compteur
	LD 		A,(HL)        	;l'adresse de HL qui contient 1 octet est mis dans A (le numero ASCII de "H" donc #48 en hexa ou 72 en dec)
	push bc
	push af
	call	rom_off
	pop	 af
	pop  bc
calcule_lettre
	push 	bc			; on sauve l'état du compteur
	Push 	hl			; on sauve l'adresse de la lettre en cours
	SUB 	a,32         ; on soustrait 32 au numero ASCII de la lettre H pour donner sa position dans la fonte (#20 en hexa)
						; donc A=#28 (#48-#20)
	LD 	L,A		 		; donc met le resultat dans L
	LD 	H,0           	; on met 0 dans H (car H ne doit pas etre vide)
						; HL contient la position de la lettre donc HL= #0028    (40 en decimal)     
						; mes lettres font 8 lignes de haut sur 6 pixel de large (donc en mode 0 3 octet de large
						; donc 8 * 3 = 24 octets (longueur d'une lettre en RAM)
						; donc on multiplie la position de la lettre (40) par la longeur d'une lettre (24)(on doit obtenir 40*24=960) 
	push 	hl			; on sauve la position de la lettre dans la fonte
	ADD 	HL,HL        ; 40 + 40 = 80  ca fait x2
	ADD 	HL,HL        ; 80 + 80 = 160  ca fait x4
	ADD 	HL,HL        ; 160 + 160 = 320  ca fait x8
	ADD 	HL,HL        ; 320 + 320 = 640  ca fait x16
	push	hl			; on sauve le 1er resultat
	ex		hl,de		; on stock dans DE
	pop		hl			; on recupère le 1er resultat
	pop		hl			; on recupere la position de la letre dans la fonte
	ADD 	HL,HL        ; 40 + 40 = 80  ca fait x2
	ADD 	HL,HL        ; 80 + 80 = 160  ca fait x4
	ADD 	HL,HL        ; 160 + 160 = 320  ca fait x8
	add		hl,de		; on addition le 1er resultat avec le 2eme
		
							; HL = 2560 soit #0A00  c'est l'adresse de la lettre ->dans la FONTE<- (donc adresse en partant de 0)
	LD 	DE,adresse_fonte_en_rom      ;on met #4000 dans DE qui correspond a l'adresse de notre fonte ->dans la RAM<-
	ADD 	HL,DE        ;on additionne pour avoir l'adresse de la lettre ->dans la RAM<-
    		 ; donc HL = #4A00
	
	
	ld		c,bank_fonte						; on choisit le no de bank
	call	rom_on	
	call	affiche_3_colonnes
	inc		de
	ld		(adr_depart_texte),de
	pop 	hl			; on recupère l'adresse de la lettre en cours
	inc 	hl			; on pointe sur l'octet suivant
	push	bc
	ld		c,bank_programme_rom
	call	rom_on
	pop		bc
	LD 		A,(HL) 			; on met dans A l'octet contenu dans HL
	pop 	bc
	djnz	calcule_lettre
	
	ret

affiche_3_colonnes
	ld		de,(adr_depart_texte)	; emplacement le la 1ere colonne ECRAN
	push 	de					; on la mémorise
	push	hl					; on sauve l'adresse de la 1ere colonne ROM
	call	rom_off				
	CALL 	colonne				; on affiche la colonne
	pop		hl					; on recupere l'adresse de la 1ere colonne ROM
	inc		hl					; on passe a la seconde colonne ROM
	POP 	DE					; on recupère l'adresse de la première colonne ECRAN
	INC 	DE					; on l'incremente
	PUSH 	DE					; on sauve l'adresse de la deuxième colonne ECRAN
	CALL 	colonne
	POP		DE
	RET
colonne
	LD 	B,8		 ; les lettres font 8 lignes de haut sur une longueur BC
boucle_colonne
	PUSH 	BC		 ; on sauve le compteur
	PUSH 	DE		 ; on sauve DE avant que le LDIR le modifie ...
	call	rom_off
	ld		a,(de)	; on recupere l'octet du décors dans A.
	push	af		; on le sauve car la connexion bank modofie A.
	ld		c,bank_fonte	; on choisit le no de bank de la fonte
	call	rom_on			; on se connecte	
	pop		af				; on récupère l'octet du décors dans A.
	and	 	(hl)			; on le AND avec l'octet de la fonte contenu à l'adresse HL.
	
	ld		(de),a			; on envoie l'ocet modifié à l'adresse écran DE.
	POP 	DE		 		; on recupere notre adresse écran DE de la pile
	CALL 	ligne_inferieur	 ; ligne inferieur
	inc		hl				; on va lire la fonte 2 octets plus loin.
	inc		hl
	inc		hl
	POP 	BC		 		; on recupere notre compteur ...
	DJNZ 	boucle_colonne
	RET	

