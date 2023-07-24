inventaire_est_plein_ROM_bank3
; on sauvegarde l'item en cours
			ld		hl,Tableau_item_en_cours
			ld		de,Objet_en_plus
		
			LDI : LDI : LDI : LDI : LDI
			
			ld		a,(item_ID_1)
			ld		hl,Flag_des_items
			ld		e,a
			ld		d,0
			add		hl,de
			xor		a
			ld		(hl),a
; on doit d'abort faire de la place pour accueillire le nouvel item 		
			call	calcule_piece_items					; on va lire la ligne de la piece en cours
			ld		(pointeur_tableau_item),hl			; le resltat est en reg HL
			push hl
			inc	hl : inc hl								; on se place sur l'adresse sprh du tableau
			ld		de,Objet1							; on va lire l'objet 1 qui doit partir
			ex		hl,de
			call	asic_off
			LDI:LDI							; on remplit le tableau avec item_sprh
			LDI:LDI							; puis avec item_hud
			LDI								; et Item ID
											; l'objet 1 est repartit dans le tableau
			pop hl
			ld		de,Tableau_item_en_cours		; on va écrire dans le Tableau de l'item en cours
			inc	hl : inc hl							; on zappe les octets du numeros de la pièce
			LDI		; adresse du sprite hard
			LDI		
			LDI		; adresse du sprite du HUD
			LDI
			LDI		; identifiant d'item
			call	asic_on
			ret
destination_items_case_3_ROM_bank3
			xor a										; on éteinds le sprite de l'écran
			ld	(SPRH12_ZOOM),a
			ld	(SPRH13_ZOOM),a
			ld	(SPRH14_ZOOM),a
			ld	(SPRH15_ZOOM),a
			ld		a,(id_item)							; on recupère l'ID de l'item en cours			
			ld		(item_ID_3),a						; il est en notre possession
			ld		hl,Flag_des_items
			ld		e,a
			ld		d,0
			add		hl,de
			ld		a,1
			ld		(hl),a	
			ld		hl,(adr_item_sprh)						; donc on ecrit dans notre inventaire
			ld		(item_sprh_3),hl					; son ID, SPRH et HUD
			ld		hl,(adr_item_hud)						
			ld		(item_hud_3),hl
			ld		a,1
			ld		(flag_item_case_3),a				; indique que la case 1 est prise
			call	calcule_piece_items					; on va lire la ligne de la piece en cours
			ld		(pointeur_tableau_item),hl			; le resltat est en reg HL
			inc	hl : inc hl								; on se place sur l'adresse sprh du tableau
			ld		de,Tableau_items_piece				; on va lire des zéros
			ex		hl,de
			call	asic_off
			LDI:LDI:LDI:LDI:LDI:LDI						; et effacer 6 octets
			call	asic_on
			
			ld		a,(item_ID_1)
			ld		(Item_ID_pour_chaudron),a
			ld		a,(item_ID_2)
			ld		(Item_ID_pour_chaudron+1),a
			ld		a,(item_ID_3)
			ld		(Item_ID_pour_chaudron+2),a
			ret


destination_items_case_2_ROM_bank3

			xor a										; on éteinds le sprite de l'écran
			ld	(SPRH12_ZOOM),a
			ld	(SPRH13_ZOOM),a
			ld	(SPRH14_ZOOM),a
			ld	(SPRH15_ZOOM),a
			
			ld		a,(id_item)							; on recupère l'ID de l'item en cours			
			ld		(item_ID_2),a						; il est en notre possession
			ld		hl,Flag_des_items
			ld		e,a
			ld		d,0
			add		hl,de
			ld		a,1
			ld		(hl),a
			ld		hl,(adr_item_sprh)						; donc on ecrit dans notre inventaire
			ld		(item_sprh_2),hl					; son ID, SPRH et HUD
			ld		hl,(adr_item_hud)						
			ld		(item_hud_2),hl
			ld		a,1
			ld		(flag_item_case_2),a				; indique que la case 1 est prise
			call	calcule_piece_items					; on va lire la ligne de la piece en cours
			ld		(pointeur_tableau_item),hl			; le resltat est en reg HL
			inc	hl : inc hl								; on se place sur l'adresse sprh du tableau
			ld		de,Tableau_items_piece				; on va lire des zéros
			ex		hl,de
			call	asic_off
			LDI:LDI:LDI:LDI:LDI:LDI						; et effacer 6 octets
				ld		a,(item_ID_3)
			ld		hl,Flag_des_items
			ld		e,a
			ld		d,0
			add		hl,de
			xor		a
			ld		(hl),a
			
			
			
			call	asic_on
			
			
			ld		a,(item_ID_1)
			ld		(Item_ID_pour_chaudron),a
			ld		a,(item_ID_2)
			ld		(Item_ID_pour_chaudron+1),a
			ld		a,(item_ID_3)
			ld		(Item_ID_pour_chaudron+2),a

ret








destination_items_case_1_ROM_bank3
	xor a										; on éteinds le sprite de l'écran
			ld	(SPRH12_ZOOM),a
			ld	(SPRH13_ZOOM),a
			ld	(SPRH14_ZOOM),a
			ld	(SPRH15_ZOOM),a
			ld		a,(id_item)							; on recupère l'ID de l'item en cours			
			ld		(item_ID_1),a						; il est en notre possession
			ld		hl,Flag_des_items
			ld		e,a
			ld		d,0
			add		hl,de
			ld		a,1
			ld		(hl),a			
			ld		hl,(adr_item_sprh)						; donc on ecrit dans notre inventaire
			ld		(item_sprh_1),hl					; son ID, SPRH et HUD
			ld		hl,(adr_item_hud)						
			ld		(item_hud_1),hl
			ld		a,1
			ld		(flag_item_case_1),a				; indique que la case 1 est prise
			call	calcule_piece_items					; on va lire la ligne de la piece en cours
			ld		(pointeur_tableau_item),hl			; le resltat est en reg HL
			inc	hl : inc hl								; on se place sur l'adresse sprh du tableau
			ld		de,Tableau_items_piece				; on va lire des zéros
			ex		hl,de
			call	asic_off
			LDI:LDI:LDI:LDI:LDI:LDI						; et effacer 6 octets
			call	asic_on
			
			
			ld		a,(item_ID_1)
			ld		(Item_ID_pour_chaudron),a
			ld		a,(item_ID_2)
			ld		(Item_ID_pour_chaudron+1),a
			ld		a,(item_ID_3)
			ld		(Item_ID_pour_chaudron+2),a
			ret
			
			