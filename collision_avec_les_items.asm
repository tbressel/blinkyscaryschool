; /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
; /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
; //////////////////////////////////////////////// COLLISION ITEMS /////////////////////////////////////////////////
; /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
; /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
collision_avec_les_items
xor		a
		ld		(flag_on_touche_un_item),a
		or a
	collision_ITX1
		LD		hl,(SPRH0_X)					; à partir du coin haut-gauche de Blinky
		LD		de,40
		add		hl,de							; 64 pixels plus loin on est sur le coin haut-droite
		LD		de,(pos_X_item)						; à partir du coin haut-gauche du monstre
		SBC		hl,de
		RET		C								; si hl>=de le flag C est à zero
	collision_ITX2
		LD		hl,(pos_X_item)						; à partir du coin haut-gauche du monstre
		LD		de,10
		add		hl,de							; 31 pixels plus loin on est sur le coin haut_droite
		LD		de,(SPRH0_X)					; à partir du coin haut-gauche de link
		SBC		hl,de
		RET		C
						; si hl>=de le flag C est à zero

	collision_ITY1
		LD		hl,(SPRH0_Y)					; à partir du coin haut-gauche de link
		LD		de,20
		add		hl,de							; 15 pixels plus loin (sinon Golem va me faire un caca nerveu si j'écrit 16) 
											; on est sur le coin haut-droite
		LD		de,(pos_Y_item)						; à partir du coin haut-gauche du monstre
		SBC		hl,de
		RET 	C								; si hl>=de le flag C est à zero
	
	collision_ITY2
		LD		hl,(pos_Y_item)						; à partir du coin haut-gauche de link
		LD		de,5
		add		hl,de							; 15 pixels plus loin (sinon Golem va me faire un caca nerveu si j'écrit 16) 
											; on est sur le coin haut-droite
		LD		de,(SPRH0_Y)					; à partir du coin haut-gauche du monstre
		SBC		hl,de
		JP 		NC,blinky_touche_un_item					; si hl>=de le flag C est à zero
		RET
		
		blinky_touche_un_item
		;ld		a,(flag_pq)
		;or		a
		;ret		NZ
		
		ld		a,1
		ld		(flag_on_touche_un_item),a
		ret
		
		
		