
on_affiche_le_hud
		ld		c,19
		call	rom_on
		ld		hl,#c000
		ld		de,#c000
		ld		bc,#4000
		ldir	
		call	rom_off
		ret
		
		