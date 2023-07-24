; ///////////////////////////////////////////////////////////////////////////////////
; ///////////////////////////////////////////////////////////////////////////////////
; ////////////////////       ANIMATIONS DE BLINKY        /////////////////////
; ///////////////////////////////////////////////////////////////////////////////////
; ///////////////////////////////////////////////////////////////////////////////////

fin_anim_blinky_teleporte_ROM_bank3
	xor		a
	ld		(event_gameover),a
	ld		(event_gameover+1),a
	ld		(event_gameover+2),a
	ld		(event_gameover+3),a
	ld		(event_gameover+4),a
	ld		(event_gameover+5),a
	ld		(flag_on_se_teleporte),a


		ld		a,(no_de_la_salle)
		cp		a,17
		jp		z,teleporte_piece_90
		cp		a,107
		jp		z,teleporte_piece_90
		cp		a,28
		jp		z,teleporte_piece_3
		cp		a,64
		jp		z,teleporte_piece_59
		cp		a,100
		jp		z,teleporte_piece_90
	teleporte_piece_3
		; on prepare l'arrivée dans la piece de destinartion
		ld		a,3
		ld		(no_de_la_salle),a
		ld		a,13
		ld		(no_bank_maptile_deco),a
		ld		hl,salle_03+18
		ld		(adr_piece_actuelle),hl
		ld		(adresse_du_decors_en_rom),hl	
		ld		hl,#014F
		ld		(pos_X_blinky),hl
		ld		hl,#0020
		ld		(pos_Y_blinky),hl
		call	update_position_X_de_blinky
		call	update_position_Y_de_blinky
		jp		test_enlever_pq_du_hud
	
	teleporte_piece_90
		; sauf si le chaudron 0 est fini on se teleporte en, piece 3
		ld		a,(nbr_ingredient_chaudron_0)
		cp		a,4
		jr		z,teleporte_piece_3
	
	
	
			; on prepare l'arrivée dans la piece de destinartion
		ld		a,90
		ld		(no_de_la_salle),a
		ld		a,18
		ld		(no_bank_maptile_deco),a
		ld		hl,salle_90+18
		ld		(adr_piece_actuelle),hl
		ld		(adresse_du_decors_en_rom),hl	
		ld		hl,#012b
		ld		(pos_X_blinky),hl
		ld		hl,#0020
		ld		(pos_Y_blinky),hl
		call	update_position_X_de_blinky
		call	update_position_Y_de_blinky
		jp		test_enlever_pq_du_hud
	
	
	teleporte_piece_59
		; on prepare l'arrivée dans la piece de destinartion
		ld		a,59
		ld		(no_de_la_salle),a
		ld		a,15
		ld		(no_bank_maptile_deco),a
		ld		hl,salle_59+18
		ld		(adr_piece_actuelle),hl
		ld		(adresse_du_decors_en_rom),hl	
		ld		hl,#014F
		ld		(pos_X_blinky),hl
		ld		hl,#0070
		ld		(pos_Y_blinky),hl
		call	update_position_X_de_blinky
		call	update_position_Y_de_blinky
		
		test_enlever_pq_du_hud
		; on enlève le PQ du hud
		ld		a,(item_ID_1)
		cp		a,2
		jp		z,on_efface_la_case1
		ld		a,(item_ID_2)
		cp		a,2
		jp		z,on_efface_la_case2
		ld		a,(item_ID_3)
		cp		a,2
		jp		z,on_efface_la_case3
	
on_efface_la_case1
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
			ret

on_efface_la_case2
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
			ret
			
on_efface_la_case3
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
			

			