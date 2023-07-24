on_efface_les_events_ROM_bank3
	xor		a
	ld		hl,event_animations
	ld		b,63
	boucle_efface_events
		ld		(hl),a
		inc		hl
		djnz	boucle_efface_events
		
		xor		a
		ld		(SPRH4_ZOOM),a
		ld		(SPRH5_ZOOM),a
		ld		(SPRH6_ZOOM),a
		ld		(SPRH7_ZOOM),a
		ld		(SPRH8_ZOOM),a
		ld		(SPRH9_ZOOM),a
		ld		(SPRH10_ZOOM),a
		ld		(SPRH11_ZOOM),a
		ld		(SPRH12_ZOOM),a
		ld		(SPRH13_ZOOM),a
		ld		(SPRH14_ZOOM),a
		ld		(SPRH15_ZOOM),a
	on_stop_les_events
			xor		a
			ld		(SPRH0_ZOOM),a
		ld		(SPRH1_ZOOM),a
		ld		(SPRH2_ZOOM),a
		ld		(SPRH3_ZOOM),a
		ld		(etape_souris),a
		ld		(etape_escargotvert),a
		ld		(etape_araigneebleue),a
		ld		(etape_escargotrouge),a
		ld		(etape_araigneejaune),a
		ld		(etape_chauverouge),a
		ld		(etape_chauvevert),a
		ld		(etape_pierresquitombent),a
		ld		(etape_grenouillerouge),a
		ld		(etape_grenouilleverte),a
		ld		(etape_abeillejaune),a
		ld		(etape_abeillegrise),a
		ld		(etape_poissonvert),a
		ld		(etape_poissonrouge),a
		ld		(init_afficher_item),a
		ld		(flag_saut_en_cours),a
		;ld		(flag_ennemis_mortel),a
		ret
	
