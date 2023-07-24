on_vide_la_case1_ROM
			; on va décaler les objets dans	le tableau de l'inventaire
			ld		hl,RIEN_HUD						; on prends d'adr un sprite noir
			ld		(item_hud_1),hl					; l'item 1 du heu sera noir donc effacé
			xor		a
			ld		(Item_ID_pour_chaudron),a		; l'ID de l'item 1, est mis à zéro
			ld		(flag_item_case_1),a			; le flag est mis à zero car plus d'item


			ld		hl,Objet2						; on déclare l'item 2 vers l'item 1
			ld		de,Objet1
			LDI : LDI : LDI : LDI : LDI
			ld		hl,Item_ID_pour_chaudron+1		; on décale les ID item 2 vers 1
			ld		de,Item_ID_pour_chaudron
			LDI
			ld		a,(flag_item_case_2)			; on décale les flags 2 vers 1
			ld		(flag_item_case_1),a


			ld		hl,Objet3						; on déclare l'item 3 vers l'item 2
			ld		de,Objet2
			LDI : LDI : LDI : LDI : LDI
			ld		hl,Item_ID_pour_chaudron+2		; on décale les ID item 3 vers 2
			ld		de,Item_ID_pour_chaudron+1
			LDI
			ld		a,(flag_item_case_3)			; et 3 vers 2
			ld		(flag_item_case_2),a

			ld		hl,Objet_absent					; l'item 3 est vide
			ld		de,Objet3
			LDI : LDI : LDI : LDI : LDI
			xor a
			ld		(Item_ID_pour_chaudron+2),a		; l'ID de l'iten est à zero
			ld		(flag_item_case_3),a			; et donc la case est vide
			RET
			
on_vide_la_case2_ROM
; on va décaler les objets dans	le tableau de l'inventaire
			ld		hl,RIEN_HUD
			ld		(item_hud_2),hl
			xor		a
			ld		(Item_ID_pour_chaudron+1),a
			ld		(flag_item_case_2),a


			ld		hl,Objet3
			ld		de,Objet2
			LDI : LDI : LDI : LDI : LDI
			ld		hl,Item_ID_pour_chaudron+2
			ld		de,Item_ID_pour_chaudron+1
			LDI
			ld		a,(flag_item_case_3)
			ld		(flag_item_case_2),a

			ld		hl,Objet_absent
			ld		de,Objet3
			LDI : LDI : LDI : LDI : LDI
			xor		a
			ld		(Item_ID_pour_chaudron+2),a
			ld		(flag_item_case_3),a
			RET
on_vide_la_case3_ROM
		; on va décaler les objets dans	le tableau de l'inventaire
			ld		hl,RIEN_HUD
			ld		(item_hud_3),hl
			xor		a
			ld		(Item_ID_pour_chaudron+2),a
			ld		hl,Objet_absent
			ld		de,Objet3
			LDI : LDI : LDI : LDI : LDI
			xor		a
			ld		(flag_item_case_3),a
			ret



init_blinky_sur_terre_ROM
	ld		hl,(pos_Y_blinky)
	inc		l
	ld		(pos_Y_blinky),hl
; on athorise plus la direction bas
	xor		a
	ld		(bas_jpz),a
	ld		(bas_jpz+1),a
	ld		(bas_jpz+2),a
	ld		(bas_jpz+3),a
	ld		(bas_jpz+4),a

; blinky arrête de remonter
	xor 	a
	ld		(event_tombe),a
	ld		(event_tombe+1),a
	ld		(event_tombe+2),a
; blinky tombe
	ld		hl,tombe
	ld		ix,event_tombe
	ld		a,#c3
	ld		(ix),a
	ld		(ix+1),hl
; initialisation de la position de blinky quand on change de salle
	ld		hl,pos_Y_blinky_bas_chateau
	ld		(posY_blinky_bas),hl
	ld		hl,pos_Y_blinky_haut_chateau
	ld		(posY_blinky_haut),hl
;	on configure les nouveau sprites
	ld		hl,blinky_sprh_1_gauche_ROM
	ld		(blinky_gauche_adr),hl
	ld		hl,blinky_sprh_1_droite_ROM
	ld		(blinky_droite_adr),hl
	ld		a,bank_sprh_blinky
	ld		(no_bank_sprh_blinky),a
	ret			
			