le_temps_qui_passe
	ld		a,(decompte_rallonge)
	inc		a
	ld		(decompte_rallonge),a
	cp		a,4
	ret		nz
	
	xor		a
	ld		(decompte_rallonge),a
	ld		a,(le_temps_passe_decompte)
	inc		a
	ld		(le_temps_passe_decompte),a
	cp		a,255
	ret		nz


on_affiche_un pixel
ld		c,bank_gfx_hud
call	rom_on
ld		hl,(pointeur_soleil_ROM)
ld		de,(pointeur_soleil_ecran)
LDI
call	rom_off



ld		(pointeur_soleil_ROM),hl
ld		(pointeur_soleil_ecran),de

ld		a,(nbr_colonne_soleil)
inc		a
ld		(nbr_colonne_soleil),a
cp		a,6
call	z,on_change_de_ligne_soleil
xor		a
ld		(le_temps_passe_decompte),a
ret




on_change_de_ligne_soleil

ld		c,bank_programme_rom
call	rom_on
call	on_change_de_ligne_soleil_ROM
call	rom_off
ret









