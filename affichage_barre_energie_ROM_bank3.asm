; ///////////////////////////////////////////////////////////////////////////////////
; ///////////////////////////////////////////////////////////////////////////////////
; //////////////////       INITIALISATION DE LE BARRE D'ENERGIE           //////////
; ///////////////////////////////////////////////////////////////////////////////////
; ///////////////////////////////////////////////////////////////////////////////////
init_barre_energie_ROM_bank3
ld		a,#c7
ld		(posY_barre),a
ld		a,#5E
ld		(posX_barre),a
ld		hl,#C75E				; point de départ de l'affichage de la barre d'énergie
ld		(adr_barre),hl
ld		hl,#FFFF
ld		(valeur_barre),hl

; on affiche la barre pleine
ld		de,(adr_barre)
ld		hl,(valeur_barre)
ld		b,8
ld		c,8
boucle_affichage_barre
push	bc
ld		a,l
ld		(de),a
inc		e
ld		a,h
ld		(de),a
dec		e
	
ld		b,8		; on calcule la ligne du dessous
ld		a,d
add		a,b
ld		d,a
pop		bc
djnz	boucle_affichage_barre
set		7,d
set		6,d
inc		e
inc		e
ld		b,8
dec		c
ld		a,c
cp		a,0
jp		z,fin_init_barre
jp		boucle_affichage_barre

fin_init_barre
ld		de,#c76d
ld		(adr_barre),de
ret





diminuer_la_barre_energie_ROM_bank3
	ld	a,(flag_blinky_est_deja_touche)
	or	a
	jp	nz,on_continu_diminuer_la_barre_energie
init_diminuer_la_barre_energie
	ld		hl,Tableau_valeur_bloc_energie+2
	ld		(pointeur_tableau_valeur_bloc_energie),hl
	ld		a,(hl)
	ld		e,a
	inc		hl
	ld		a,(hl)
	ld		d,a				
	ex		de,hl				; HL contien la valeur suivante
	ld		(valeur_barre),hl		; par defaut est remplie #FFFF
	ld		de,(adr_barre)			; on est a la fin de la barre d'energie
	ld		a,8
	ld		(nbr_de_bloc_energie),a
	ld		(nbr_de_barre_energie),a
	ld		b,8
	call	boucle_diminuer_la_barre_energie
	ld		a,1
	ld		(flag_blinky_est_deja_touche),a
	ret

on_continu_diminuer_la_barre_energie
	ld		a,(nbr_de_bloc_energie)
	CP		a,0
	ret		z
	ld		a,(nbr_de_barre_energie)
	dec		a
	ld		(nbr_de_barre_energie),a
	cp		a,0
	call	z,bloc_energie_suivant
	
	ld		hl,(pointeur_tableau_valeur_bloc_energie)
	inc		hl
	inc		hl
	ld		(pointeur_tableau_valeur_bloc_energie),hl
	ld		a,(hl)
	ld		e,a
	inc		hl
	ld		a,(hl)
	ld		d,a				
	ex		de,hl				; HL contien la valeur suivante
	ld		(valeur_barre),hl
	ld		de,(adr_barre)
	ld		b,8	
	call	boucle_diminuer_la_barre_energie
	ret



	
boucle_diminuer_la_barre_energie
	push	bc
	ld		a,l
	ld		(de),a
	dec		e
	ld		a,h
	ld		(de),a
	inc		e
	
	ld		b,8		; on calcule la ligne du dessous
	ld		a,d
	add		a,b
	ld		d,a
	pop		bc
	djnz	boucle_diminuer_la_barre_energie
	set		7,d
	set		6,d
	ret
	



bloc_energie_suivant
	ld		a,8
	ld		(nbr_de_barre_energie),a
	ld		hl,Tableau_valeur_bloc_energie
	ld		(pointeur_tableau_valeur_bloc_energie),hl
	ld		hl,(adr_barre)
	dec		hl
	dec		hl
	ld		(adr_barre),hl
	ld		a,(nbr_de_bloc_energie)
	dec		a
	ld		(nbr_de_bloc_energie),a
	cp		a,0
	jp		z,blinky_perd_une_vie
	ret
	
	