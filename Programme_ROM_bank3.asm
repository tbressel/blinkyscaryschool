ORG		#C000

read"affichage_barre_energie_ROM_bank3.asm"
read"changement_salle_ROM_bank3.asm"
read"gestion_de_inventaire_ROM_bank3.asm"
read"animation_de_blinky_ROM_bank3.asm"
read"gestion_blinky_ROM_bank3.asm"

fin_parchemin_ROM
	ld		hl,pallette_decors_ram
	ld		(pallette_en_cours_decors),hl
; on reaffiche le décors
	
	ld		hl,depart_asic_parchemin
	ld		de,depart_scr_parchemin
	ld		b,hauteur_parch_haut+hauteur_parch_bas
		boucle_remet_decors
					push	bc
					push	de
					ld		bc,largeur_parchemin
					ldir
					pop		de
					call	LIGNE_INFERIEUR
					pop		bc
					djnz	boucle_remet_decors
					ret

initialisation_du_jeu_ROM
; initialisation de la salle de départ et sa bankrom
	ld		hl,salle_82+#12
	ld		(adr_piece_actuelle),hl
	ld		(adresse_du_decors_en_rom),hl				
	ld		a,82
	ld		(no_de_la_salle),a
	ld		a,18
	ld		(no_bank_maptile_deco),a
	; ld		hl,salle_01+#12
	; ld		(adr_piece_actuelle),hl
	; ld		(adresse_du_decors_en_rom),hl				
	; ld		a,1
	; ld		(no_de_la_salle),a
	; ld		a,13
	; ld		(no_bank_maptile_deco),a
	
	ld		hl,#0188
	ld		(pos_X_blinky),hl
	ld		hl,#0040
	ld		(pos_Y_blinky),hl
	
	
	ld		a,0
	ld		(nbr_ingredient_chaudron_1),a
	ld		a,0
	ld		(nbr_ingredient_chaudron_2),a
	ld		a,0
	ld		(nbr_ingredient_chaudron_0),a
; initialisation de la vitesse de blinky
	ld		hl,vitesse_X_deplacement_blinky
	ld		(vitesse_X_blinky),hl
	ld		hl,vitesse_Y_deplacement_blinky
	ld		(vitesse_Y_blinky),hl
	ld		hl,blinky_sprh_1_gauche_ROM
	ld		(blinky_gauche_adr),hl
	ld		hl,blinky_sprh_1_droite_ROM
	ld		(blinky_droite_adr),hl
	ld		a,bank_sprh_blinky
	ld		(no_bank_sprh_blinky),a
	ld		a,vitesse_saut_blinky
	ld		(vitesse_du_saut_en_cours),a

; initialisation de la position de blinky quand on change de salle
	ld		hl,pos_Y_blinky_bas_chateau
	ld		(posY_blinky_bas),hl
	ld		hl,pos_Y_blinky_haut_chateau
	ld		(posY_blinky_haut),hl
	xor		a
	ld		(flag_item_case_1),a
	ld		(flag_item_case_2),a
	ld		(flag_item_case_3),a
	ld		hl,blinky_sprh_1_droite_ROM
	ld		(animation_blinky_en_cours),hl
	ld		a,3
	ld		(vitesse_animation_blinky),a
	ld		a,9
	ld		(nbr_de_vie),a
	ld		a,vitesse_anim_blinky_meurt_cfg
	ld		(vitesse_anim_blinky_meurt),a
	ld		hl,soleil_hud
	ld		(pointeur_soleil_ROM),hl
	ld		hl,#E692
	ld		(pointeur_soleil_ecran),hl
; collision bord droit de l'écran	
	ld		hl,#024C
	ld		(adr_bord_droit),hl
	
ld	a,(flag_langue)
cp	a,0
jp	z,config_fr
cp	a,1
jp	z,config_fr
cp	a,2
jp	z,config_en


config_fr
ld	hl,TEXTE_PIECE_82
ld	(langue_txt_piece82),hl
ld	hl,TEXTE_PIECE_3
ld	(langue_txt_piece3),hl
ld	hl,TEXTE_PIECE_10
ld	(langue_txt_piece10),hl
ld	hl,TEXTE_PIECE_18
ld	(langue_txt_piece18),hl
ld	hl,TEXTE_PIECE_35
ld	(langue_txt_piece35),hl
ld	hl,TEXTE_PIECE_49
ld	(langue_txt_piece49),hl
ld	hl,TEXTE_PIECE_67
ld	(langue_txt_piece67),hl
ld	hl,TEXTE_PIECE_66
ld	(langue_txt_piece66),hl
ld	hl,TEXTE_PIECE_93
ld	(langue_txt_piece93),hl
ld	hl,TEXTE_PIECE_89
ld	(langue_txt_piece89),hl
ret

config_en
ld	hl,TEXTE_PIECE_82_EN
ld	(langue_txt_piece82),hl
ld	hl,TEXTE_PIECE_3_EN
ld	(langue_txt_piece3),hl
ld	hl,TEXTE_PIECE_10_EN
ld	(langue_txt_piece10),hl
ld	hl,TEXTE_PIECE_18_EN
ld	(langue_txt_piece18),hl
ld	hl,TEXTE_PIECE_35_EN
ld	(langue_txt_piece35),hl
ld	hl,TEXTE_PIECE_49_EN
ld	(langue_txt_piece49),hl
ld	hl,TEXTE_PIECE_67_EN
ld	(langue_txt_piece67),hl
ld	hl,TEXTE_PIECE_66_EN
ld	(langue_txt_piece66),hl
ld	hl,TEXTE_PIECE_93_EN
ld	(langue_txt_piece93),hl
ld	hl,TEXTE_PIECE_89_EN
ld	(langue_txt_piece89),hl
ret


init_event_nouvelle_piece_ROM
	ld		a,(nbr_de_vie)
	cp		a,-1
	jp		z,fin_du_jeu
	xor		a
	ld		(timing_fire_2),a
	ld		(flag_ennemis_mortel),a
	ld		(etape_blinky_meurt),a
	ld		(etape_init_grille),a
	ld		(etape_anim_porte),a
	ld		hl,#0B18
	ld		(automodif_collision25),hl
	ld		a,conf_vitesse_anim_porte
	ld		(vitesse_anim_porte),a
; on désactive les sprh car même si le zoom est à zéros, il peut y avoir une collision sur une pièce sur un item invisible
	ld		hl,0
	ld		(pos_X_item),hl
	ld		(pos_Y_item),hl
	ret
grille_entree_chateau_on
; on athorise la direction haut
	ld		ix,haut_jpz
	ld		hl,#47cb     ; bit 0,A
	ld		(ix),hl
	ld		a,#CA		; JP	Z,
	ld		(ix+2),a
	ld		hl,haut
	ld		(ix+3),hl
	ret
grille_entree_chateau_off
; on athorise plus la direction haut
	xor		a
	ld		(haut_jpz),a
	ld		(haut_jpz+1),a
	ld		(haut_jpz+2),a
	ld		(haut_jpz+3),a
	ld		(haut_jpz+4),a
	ret
retour_fin_parchemin_ROM
	call	asic_on	
	ld		a,ZOOM_mode_1
	ld		(SPRH0_ZOOM),a
	ld		(SPRH1_ZOOM),a
	ld		(SPRH2_ZOOM),a
	ld		(SPRH3_ZOOM),a
	ld		(SPRH12_ZOOM),a
	ld		(SPRH13_ZOOM),a
	ld		(SPRH14_ZOOM),a
	ld		(SPRH15_ZOOM),a
	
	ld		a,ZOOM_mode_0
	ld		(SPRH4_ZOOM),a
	ld		(SPRH5_ZOOM),a
	ld		(SPRH6_ZOOM),a
	ld		(SPRH7_ZOOM),a
	ld		(SPRH8_ZOOM),a
	ld		(SPRH9_ZOOM),a
	ld		(SPRH10_ZOOM),a
	ld		(SPRH11_ZOOM),a
	ret


on_change_de_ligne_soleil_ROM
ld		a,(nbr_ligne_soleil)
inc		a
ld		(nbr_ligne_soleil),a
cp		a,24
jp		z,fin_du_temps
ld		hl,(pointeur_soleil_ecran)
ld		de,-6
add		hl,de
ld		(pointeur_soleil_ecran),hl
ex		hl,de
call	ligne_inferieur
ld		(pointeur_soleil_ecran),de
xor a
ld	(nbr_colonne_soleil),a
ret

fin_du_temps
call	on_efface_les_events_ROM_bank3
xor 	a
ld		(nbr_colonne_soleil),a
xor		a
ld		(le_temps_passe_decompte),a
ld		(nbr_ligne_soleil),a
ld		hl,soleil_hud
ld		(pointeur_soleil_ROM),hl
ld		hl,#E692
ld		(pointeur_soleil_ecran),hl
ld		a,-1
ld		(nbr_de_vie),a
JP		NOUVELLE_PIECE_APRES_TIME_OUT




init_pierresquitombent_ROM	
	ld		a,(no_de_la_salle)
	cp		a,19
	jp		z,pierre_de_la_salle19
	ld		hl,pierre1_X_salle4
	ld		(SPRH7_X),hl
	ld		hl,pierre2_X_salle4
	ld		(SPRH8_X),hl
	ld		hl,pierre3_X_salle4
	ld		(SPRH9_X),hl
	ld		hl,32
	ld		(SPRH7_Y),hl
	ld		(SPRH8_Y),hl
	ld		(SPRH9_Y),hl
	ld		a,distance_tombe_pierre4
	ld		(distance_tombe_pierre),a
	jp		suite_pierre
pierre_de_la_salle19	
	ld		hl,pierre1_X_salle19
	ld		(SPRH7_X),hl
	ld		hl,pierre2_X_salle19
	ld		(SPRH8_X),hl
	ld		hl,pierre3_X_salle19
	ld		(SPRH9_X),hl
	ld		hl,16
	ld		(SPRH7_Y),hl
	ld		(SPRH8_Y),hl
	ld		(SPRH9_Y),hl
	ld		a,distance_tombe_pierre19
	ld		(distance_tombe_pierre),a
suite_pierre
	ld		a,r
	ld		(timing_pierre_2),a		; PAF on copie
	ld		a,r
	ld		(timing_pierre_1),a
	ld		a,1
	ld		(etape_pierresquitombent),a
	ld		a,r
	ld		(timing_pierre_3),a	
	ld		a,(flag_lumiere)
	or		a
	ret		z
	ld		a,ZOOM_mode_0
	ld		(SPRH7_ZOOM),a
	ld		(SPRH8_ZOOM),a
	ld		(SPRH9_ZOOM),a
	ret
	
	



on_affiche_le_parchemin_ROM
	ld		hl,pallette_parchemin
	ld		(pallette_en_cours_decors),hl
	xor		a
	ld		(SPRH0_ZOOM),a
	ld		(SPRH1_ZOOM),a
	ld		(SPRH2_ZOOM),a
	ld		(SPRH3_ZOOM),a
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
; on sauvegarde le décors
	call	asic_off
	ret


init_blinky_dans_leau_ROM
; on athorise la direction bas
	ld		ix,bas_jpz
	ld		hl,#4fcb     ; bit 1,A
	ld		(ix),hl
	ld		a,#CA		; JP	Z,
	ld		(ix+2),a
	ld		hl,bas
	ld		(ix+3),hl
; blinky arrête de tomber
	xor 	a
	ld		(event_tombe),a
	ld		(event_tombe+1),a
	ld		(event_tombe+2),a
; blinky remonte
	ld		hl,remonte
	ld		ix,event_remonte
	ld		a,#c3
	ld		(ix),a
	ld		(ix+1),hl
; initialisation de la position de blinky quand on change de salle
	ld		hl,pos_Y_blinky_bas_eau
	ld		(posY_blinky_bas),hl
	ld		hl,pos_Y_blinky_haut_eau
	ld		(posY_blinky_haut),hl
; on configure les nouveau sprites
	ld		hl,blinky_sprh_eau_gauche_ROM
	ld		(blinky_gauche_adr),hl
	ld		hl,blinky_sprh_eau_droite_ROM
	ld		(blinky_droite_adr),hl
	ld		a,bank_sprh_blinky2
	ld		(no_bank_sprh_blinky),a
	ld		a,1
	ld		(etape_anim_blinky),a
	ret
	
test_texte_parchemin_ROM
	ld		a,25
	ld		(nbr_de_lettre),a
	ld		a,(no_de_la_salle)
	cp		a,82
	jp		z,texte_parchemin_piece_82
	cp		a,3
	jp		z,texte_parchemin_piece_3
	cp		a,10
	jp		z,texte_parchemin_piece_10
	cp		a,18
	jp		z,texte_parchemin_piece_18
	cp		a,35
	jp		z,texte_parchemin_piece_35
	cp		a,49
	jp		z,texte_parchemin_piece_49
	cp		a,66
	jp		z,texte_parchemin_piece_66
	cp		a,67
	jp		z,texte_parchemin_piece_67
	cp		a,93
	jp		z,texte_parchemin_piece_93
	cp		a,89
	jp		z,texte_parchemin_piece_89
texte_parchemin_piece_82
	ld		a,15							; il y a 6 ligne de texte à afficher
	ld		(nbr_ligne_texte),a			; on les stock dans la variable
	ld		b,a							; on envoie dans B qui sera le compteur
	ld		de,(langue_txt_piece82)			; l'adresse du texte
	ld		(adr_ligne_de_texte),de		; on le stock dans la variable
	ld		hl,#C8f6					; adresse ECRAN du texte
	ld		(adr_depart_texte),hl		; on stock dans la variable	
	jp		boucle_texte_parchemin_ROM		; on affiche !	
texte_parchemin_piece_3
	ld		a,15							; il y a 6 ligne de texte à afficher
	ld		(nbr_ligne_texte),a			; on les stock dans la variable
	ld		b,a							; on envoie dans B qui sera le compteur
	ld		de,(langue_txt_piece3)			; l'adresse du texte
	ld		(adr_ligne_de_texte),de		; on le stock dans la variable
	ld		hl,#C8f6					; adresse ECRAN du texte
	ld		(adr_depart_texte),hl		; on stock dans la variable	
	jp		boucle_texte_parchemin_ROM		; on affiche !	
texte_parchemin_piece_10
	ld		a,8						; il y a 11 ligne de texte à afficher
	ld		(nbr_ligne_texte),a			; on les stock dans la variable
	ld		b,a							; on envoie dans B qui sera le compteur
	ld		de,(langue_txt_piece10)			; l'adresse du texte
	ld		(adr_ligne_de_texte),de		; on le stock dans la variable
	ld		hl,#C8f6					; adresse ECRAN du texte
	ld		(adr_depart_texte),hl		; on stock dans la variable	
	jp		boucle_texte_parchemin_ROM		; on affiche !
texte_parchemin_piece_18
	ld		a,7						; il y a 11 ligne de texte à afficher
	ld		(nbr_ligne_texte),a			; on les stock dans la variable
	ld		b,a							; on envoie dans B qui sera le compteur
	ld		de,(langue_txt_piece18)			; l'adresse du texte
	ld		(adr_ligne_de_texte),de		; on le stock dans la variable
	ld		hl,#C8f6					; adresse ECRAN du texte
	ld		(adr_depart_texte),hl		; on stock dans la variable	
	jp		boucle_texte_parchemin_ROM		; on affiche !
texte_parchemin_piece_35
	ld		a,7						; il y a 11 ligne de texte à afficher
	ld		(nbr_ligne_texte),a			; on les stock dans la variable
	ld		b,a							; on envoie dans B qui sera le compteur
	ld		de,(langue_txt_piece35)			; l'adresse du texte
	ld		(adr_ligne_de_texte),de		; on le stock dans la variable
	ld		hl,#C8f6					; adresse ECRAN du texte
	ld		(adr_depart_texte),hl		; on stock dans la variable	
	jp		boucle_texte_parchemin_ROM		; on affiche !

texte_parchemin_piece_49
	ld		a,15						; il y a 11 ligne de texte à afficher
	ld		(nbr_ligne_texte),a			; on les stock dans la variable
	ld		b,a							; on envoie dans B qui sera le compteur
	ld		de,(langue_txt_piece49)			; l'adresse du texte
	ld		(adr_ligne_de_texte),de		; on le stock dans la variable
	ld		hl,#C8f6					; adresse ECRAN du texte
	ld		(adr_depart_texte),hl		; on stock dans la variable	
	jp		boucle_texte_parchemin_ROM		; on affiche !
texte_parchemin_piece_67
	ld		a,11						; il y a 11 ligne de texte à afficher
	ld		(nbr_ligne_texte),a			; on les stock dans la variable
	ld		b,a							; on envoie dans B qui sera le compteur
	ld		de,(langue_txt_piece67)			; l'adresse du texte
	ld		(adr_ligne_de_texte),de		; on le stock dans la variable
	ld		hl,#C8f6					; adresse ECRAN du texte
	ld		(adr_depart_texte),hl		; on stock dans la variable	
	jp		boucle_texte_parchemin_ROM		; on affiche !
texte_parchemin_piece_66
	ld		a,7						; il y a 11 ligne de texte à afficher
	ld		(nbr_ligne_texte),a			; on les stock dans la variable
	ld		b,a							; on envoie dans B qui sera le compteur
	ld		de,(langue_txt_piece66)			; l'adresse du texte
	ld		(adr_ligne_de_texte),de		; on le stock dans la variable
	ld		hl,#C8f6					; adresse ECRAN du texte
	ld		(adr_depart_texte),hl		; on stock dans la variable	
	jp		boucle_texte_parchemin_ROM		; on affiche !

texte_parchemin_piece_93
	ld		a,10							; il y a 6 ligne de texte à afficher
	ld		(nbr_ligne_texte),a			; on les stock dans la variable
	ld		b,a							; on envoie dans B qui sera le compteur
	ld		de,(langue_txt_piece93)			; l'adresse du texte
	ld		(adr_ligne_de_texte),de		; on le stock dans la variable
	ld		hl,#C8f6					; adresse ECRAN du texte
	ld		(adr_depart_texte),hl		; on stock dans la variable	
	jp		boucle_texte_parchemin_ROM		; on affiche !	
texte_parchemin_piece_89
	ld		a,15							; il y a 6 ligne de texte à afficher
	ld		(nbr_ligne_texte),a			; on les stock dans la variable
	ld		b,a							; on envoie dans B qui sera le compteur
	ld		de,(langue_txt_piece89)			; l'adresse du texte
	ld		(adr_ligne_de_texte),de		; on le stock dans la variable
	ld		hl,#C8f6					; adresse ECRAN du texte
	ld		(adr_depart_texte),hl		; on stock dans la variable	
	jp		boucle_texte_parchemin_ROM		; on affiche !	
boucle_texte_parchemin_ROM

RET

TEXTE_PIECE_82_EN
	DEFM	"Blinky's Scary School for"
	DEFM	"the Amstrad GX4000 ...   "
	DEFM	"                         "
	DEFM	"                         "
	DEFM	"                         "
	DEFM	"Welcome to Drumtrochie   "
	DEFM	"Castle ready to put in a "
	DEFM	"solid night's haunting   "
	DEFM	"totally unware of the    "
	DEFM	"deadly machinery ticking "
	DEFM	"quietly in the bowels of "
	DEFM	"the castle.              "
	DEFM	"                         "
	DEFM	"                         "
	DEFM	"                Zisquier."

TEXTE_PIECE_82
	DEFM	"Blinky's Scary School sur"
	DEFM	"    Amstrad GX4000 ...   "
	DEFM	"                         "
	DEFM	"                         "
	DEFM	"                         "
	DEFM	"  Bienvenue au chateau   "
	DEFM	"Drumtrochie.             "
	DEFM	"Tu n'as qu'une seule nuit"
	DEFM	"pour dejouer les pieges  "
	DEFM	"de Lord McTravisch.      "
	DEFM	"Tu dois l'empecher de    "
	DEFM	"dormir en paix. Que cette"
	DEFM	"nuit soit effrayante !   "
	DEFM	"                         "
	DEFM	"                Zisquier."
	

	
TEXTE_PIECE_93_EN
	DEFM	"                         "
	DEFM	"                         "
	DEFM	"If I drew this opened    "
	DEFM	"door, it's not just to   "
	DEFM	"look pretty !!!          "
	DEFM	"                         "
	DEFM	"                         "
	DEFM	"Place yourself in front  "
	DEFM	"of it and press UP button"
	DEFM	"                         "
TEXTE_PIECE_93
	DEFM	"                         "
	DEFM	"                         "
	DEFM	"Si je laisse cette porte "
	DEFM	"ouverte, c'est pas juste "
	DEFM	"pour faire jolie !!!     "
	DEFM	"                         "
	DEFM	"                         "
	DEFM	"Place-toi devant et      "
	DEFM	"appuye sur la direction  "
	DEFM	"HAUT !                   "

TEXTE_PIECE_89
	DEFM	"  Pour faire apparaitre  "
	DEFM	" un passage secret :     "
	DEFM	"                         "
	DEFM	"                         "
	DEFM	"- Un trefle de la chance "
	DEFM	"pour forcer le destin... "
	DEFM	"                         "
	DEFM	"- Le  Dieu Michel , ayant"
	DEFM	"appartenu a Tante Edna..."
	DEFM	"                         "
	DEFM	"- Une flacon de parfum,  "
	DEFM	"pour embaumer la recette."
	DEFM	"                         "
	DEFM	"- Et pour tourner la page"
	DEFM	"de cette histoire un ...?"
TEXTE_PIECE_89_EN
	DEFM	"To make appear           "
	DEFM	"    a secret passage :   "
	DEFM	"                         "
	DEFM	"                         "
	DEFM	"- A lucky clover just to "
	DEFM	"force fate...            "
	DEFM	"                         "
	DEFM	"- A dildo having belonged"
	DEFM	"to Aunt Edna...          "
	DEFM	"                         "
	DEFM	"- A bottle of perfume to "
	DEFM	"embalm this recipe...    "
	DEFM	"                         "
	DEFM	"- And to turn the page of"
	DEFM	"this story, a ...?       "



TEXTE_PIECE_3
	DEFM	"   Pour atteindre ces    "
	DEFM	" hauteurs vertigineuses :"
	DEFM	"                         "
	DEFM	"                         "
	DEFM	"- Farine auto-levante,   "
	DEFM	"pour aller plus haut...  "
	DEFM	"                         "
	DEFM	"- Potion menstruelle de  "
	DEFM	"Tante Ednas...           "
	DEFM	"                         "
	DEFM	"- Au seuil de sa vie un  "
	DEFM	"poisson pourrit...       "
	DEFM	"                         "
	DEFM	"- Un soda petillant a la "
	DEFM	"framboise ...            "
TEXTE_PIECE_3_EN
	DEFM	"To reach those dizzy     "
	DEFM	"             heights ... "
	DEFM	"                         "
	DEFM	"                         "
	DEFM	"- Flour self raising     "
	DEFM	"for extra lift ...       "
	DEFM	"                         "
	DEFM	"- Perfume Aunt Edna's    "
	DEFM	"christmas gift ...       "
	DEFM	"                         "
	DEFM	"- On the shore of life   "
	DEFM	"a scarlet fish ...       "
	DEFM	"                         "
	DEFM	"- Fizzy raspberry pop    "
	DEFM	"now make a wish ...      "
	
	
TEXTE_PIECE_10
	DEFM	"                         "
	DEFM	"                         "
	DEFM	"                         "
	DEFM	"                         "
	DEFM	"... pense a voyager au   "
	DEFM	"travers des WC, mais     "
	DEFM	"surtout n'oublie pas de  "
	DEFM	"t'essuyer !!!            "


TEXTE_PIECE_10_EN
	DEFM	"                         "
	DEFM	"                         "
	DEFM	"                         "
	DEFM	"                         "
	DEFM	"                         "
	DEFM	"                         "	
	DEFM	"... Here is an extra clue"
	DEFM	"travel by the loo !!!    "

	
TEXTE_PIECE_18
	DEFM	"                         "
	DEFM	"                         "
	DEFM	"                         "
	DEFM	"                         "
	DEFM	"... la foie t'aidera a   "
	DEFM	"lever le mystere qui se  "
	DEFM	"cache entre ces murs...  "

TEXTE_PIECE_18_EN
	DEFM	"                         "
	DEFM	"                         "
	DEFM	"                         "
	DEFM	"                         "
	DEFM	"... Faith will help you  "
	DEFM	"to see hidden places...  "
	DEFM	"                         "

TEXTE_PIECE_35
	DEFM	"                         "
	DEFM	"Le reveil sera difficile "
	DEFM	"sans l'anneau sacre.     "
	DEFM	"En sa possession, a l'Est"
	DEFM	"des 3 cranes, le passage "
	DEFM	"s'ouvrira ;)             "
	DEFM	"                         "

TEXTE_PIECE_35_EN
	DEFM	"                         "
	DEFM	"Wake uuuuuup !!!!        "
	DEFM	"                         "
	DEFM	"Find the sacred ring !   "
	DEFM	"At the Est of the three  "
	DEFM	"skulls, you will find    "
	DEFM	"a way !!!                "
TEXTE_PIECE_49
	DEFM	"Pour sonder ces sombres  "
	DEFM	"profondeurs bleutees  :  "
	DEFM	"                         "
	DEFM	"                         "
	DEFM	"- Une bouteille de gaz a "
	DEFM	"air comprimee            "
	DEFM	"                         "
	DEFM	"- Un extincteur          "
	DEFM	"pour je sais pas quoi    "
	DEFM	"                         "	
	DEFM	"- Un oeil de triton      "
	DEFM	"(decoupe a vif)          "
	DEFM	"                         "
	DEFM	"- Un bonbon chewing-gum  "
	DEFM	"pour faire des bulles    "
TEXTE_PIECE_49_EN
	DEFM	"To plumb those dark      "
	DEFM	"          blue depths :  "
	DEFM	"                         "
	DEFM	"                         "
	DEFM	"- One cylinder of air    "
	DEFM	"inflatory gas            "
	DEFM	"                         "
	DEFM	"- Aunt Edna's rockcake   "
	DEFM	"ballastic mass           "
	DEFM	"                         "	
	DEFM	"- A staring eye of newt  "
	DEFM	"(taken neat)             "
	DEFM	"                         "
	DEFM	"- A stick of chewy gum   "
	DEFM	"a bubble sweet           "
	
TEXTE_PIECE_66
	DEFM	"                         "
	DEFM	"                         "
	DEFM	"C'est la tete dans les   "
	DEFM	"nuages qu'un autre monde "
	DEFM	"s'ouvre parfois ....     "
	DEFM	"                         "
	DEFM	"                         "
TEXTE_PIECE_66_EN
	DEFM	"                         "
	DEFM	"                         "
	DEFM	"Head in the clouds may   "
	DEFM	"sometimes drive you to   "
	DEFM	"another world....        "
	DEFM	"                         "
	DEFM	"                         "
TEXTE_PIECE_67
	DEFM	"                         "
	DEFM	"                         "
	DEFM	"ATTENTION !!! Derriere   "
	DEFM	"cette porte ....  nan... "
	DEFM	"                         "
	DEFM	"rien ... En fait ....    "
	DEFM	"                         "
	DEFM	"Ne pas deranger, je dors !"	
	DEFM	"                         "
	DEFM	"        Lord McTravisch. "
	DEFM    "        ... le priprio..."
TEXTE_PIECE_67_EN
	DEFM	"                         "
	DEFM	"                         "
	DEFM	"WARNING !!! Behind this  "
	DEFM	"last door   ....  no ... "
	DEFM	"                         "
	DEFM	"well ... Mmmmm ....      "
	DEFM	"                         "
	DEFM	"Do not disturb please !  "	
	DEFM	"                         "
	DEFM	"        Lord McTravisch. "
	DEFM    "        ... the owner ..."

TEXTE_GAMEOVER
	DEFM	"  GAME OVER "
	DEFM	"            "
TEXTE_TIMEOUT
		DEFM	" TIME OUT ! " 
		DEFM	"            "


on_ouvre_la_grille_rom
	ld	a,(vitesse_grille)
	dec	a
	ld	(vitesse_grille),a
	jp	nz,retour_test_de_touches
	
	ld	bc,(pointeur_grille_adr)	; on recupère le pointeur qui lit l'adresse dans la tableau
	ld	a,(bc)						
	ld	l,a
	inc	bc	
	ld	a,(bc)
	cp	a,#c0
	jp	z,grille_ouverte
	
	ld	h,a							; on transfer les octet dans HL qui contient l'adresse source
	inc	bc							
	ld	a,(bc)
	ld	e,a
	inc	bc
	ld	a,(bc)
	ld	d,a					   		; on recupère les cotets dans DE qui contient l'adr d'affichage
	dec	bc
	ld	(pointeur_grille_adr),bc	; on met à jour le pointeur
	jp	retour_on_ouvre_la_grille_rom
	


					
	grille_ouverte
		ld		hl,#30
		ld		(pos_Y_blinky),hl
		push		iy
		jp		retour_grille_ouverte

test_des_portes_ROM
ld		a,3										; corrige un bug lié au fait que blinky ne s'animaait plus quand on
ld		(vitesse_animation_blinky),a			; prenait une porte allumé vers eteinds + quelque pas et revenir	
call	on_efface_les_events_ROM_bank3
ld	a,(no_de_la_salle)
cp	a,93
jp	z,config_porte_93
cp	a,94
jp	z,config_porte_94
cp	a,75
jp	z,config_porte_75
cp	a,97
jp	z,config_porte_97
cp	a,108
jp	z,config_porte_108
cp	a,109
jp	z,config_porte_109
cp	a,112
jp	z,config_porte_112
cp	a,113
jp	z,config_porte_113
cp	a,114
jp	z,config_porte_114
cp	a,106
jp	z,config_porte_piege
cp	a,77
jp	z,config_porte_piege
cp	a,95
jp	z,config_porte_piege
cp	a,91
jp	z,config_porte_piege
cp	a,67
jp	z,config_porte_67
cp	a,48
jp	z,config_porte_48
ret
salle_67		equ		#d65e
salle_48		equ		#d65e
salle_94		equ		#ECBC
salle_93		equ		#E98A
salle_97		equ		#F652
salle_109		equ		#dff4
salle_108		equ		#dcc2
salle_112 		equ		#e98a	
salle_113 		equ		#ecbc
salle_114 		equ		#efee
salle_120		equ		#f984
; salle_75		equ		#EFEE
config_porte_93
		ld		hl,#60
		ld		(pos_Y_blinky),hl
		ld		hl,#100
		ld		(pos_X_blinky),hl
		ld		a,18
		ld		(no_bank_maptile_deco),a
		ld		hl,salle_94+18
		ld		(adr_piece_actuelle),hl
		
		ld		(adresse_du_decors_en_rom),hl
		ld		a,94
		ld		(no_de_la_salle),a
		ret
	config_porte_94
		ld		hl,#60
		ld		(pos_Y_blinky),hl
		ld		hl,#100
		ld		(pos_X_blinky),hl
		ld		a,18
		ld		(no_bank_maptile_deco),a
		ld		hl,salle_93+18
		ld		(adr_piece_actuelle),hl
		ld		(adresse_du_decors_en_rom),hl
		ld		a,93
		ld		(no_de_la_salle),a
		ret
	config_porte_75
		ld		hl,#60
		ld		(pos_Y_blinky),hl
		ld		hl,#100
		ld		(pos_X_blinky),hl
		ld		a,18
		ld		(no_bank_maptile_deco),a
		ld		hl,salle_97+18
		ld		(adr_piece_actuelle),hl
		ld		(adresse_du_decors_en_rom),hl
		ld		a,97
		ld		(no_de_la_salle),a
		ret
	config_porte_67
		ld		hl,#48
		ld		(pos_Y_blinky),hl
		ld		hl,#001b
		ld		(pos_X_blinky),hl
		ld		a,15
		ld		(no_bank_maptile_deco),a
		ld		hl,salle_48+18
		ld		(adr_piece_actuelle),hl
		ld		(adresse_du_decors_en_rom),hl
		ld		a,48
		ld		(no_de_la_salle),a
		ret
	config_porte_48
		ld		hl,#70
		ld		(pos_Y_blinky),hl
		ld		hl,#0150
		ld		(pos_X_blinky),hl
		ld		a,16
		ld		(no_bank_maptile_deco),a
		ld		hl,salle_67+18
		ld		(adr_piece_actuelle),hl
		ld		(adresse_du_decors_en_rom),hl
		ld		a,67
		ld		(no_de_la_salle),a
		ret
	config_porte_97
		ld		hl,#60
		ld		(pos_Y_blinky),hl
		ld		hl,#01c2
		ld		(pos_X_blinky),hl
		ld		a,16
		ld		(no_bank_maptile_deco),a
		ld		hl,salle_75+18
		ld		(adr_piece_actuelle),hl
		ld		(adresse_du_decors_en_rom),hl
		ld		a,75
		ld		(no_de_la_salle),a
		ret
	config_porte_108
		ld		hl,#60
		ld		(pos_Y_blinky),hl
		ld		hl,#0118
		ld		(pos_X_blinky),hl
		ld		a,27
		ld		(no_bank_maptile_deco),a
		ld		hl,salle_109+18
		ld		(adr_piece_actuelle),hl
		ld		(adresse_du_decors_en_rom),hl
		ld		a,109
		ld		(no_de_la_salle),a
		ret
	config_porte_109
		ld		hl,#50
		ld		(pos_Y_blinky),hl
		ld		hl,#013c
		ld		(pos_X_blinky),hl
		ld		a,27
		ld		(no_bank_maptile_deco),a
		ld		hl,salle_108+18
		ld		(adr_piece_actuelle),hl
		ld		(adresse_du_decors_en_rom),hl
		ld		a,108
		ld		(no_de_la_salle),a
		ret
	config_porte_112
		ld		hl,#50
		ld		(pos_Y_blinky),hl
		ld		hl,#013c
		ld		(pos_X_blinky),hl
		ld		hl,#1E6
		ld		(pos_X_blinky_debut_tableau),hl
		
		
		ld		a,27
		ld		(no_bank_maptile_deco),a
		ld		hl,salle_113+18
		ld		(adr_piece_actuelle),hl
		ld		(adresse_du_decors_en_rom),hl
		ld		a,113
		ld		(no_de_la_salle),a
		ret
	config_porte_113
		ld		hl,#50
		ld		(pos_Y_blinky),hl
		ld		hl,#013c
		ld		(pos_X_blinky),hl
		
		ld		a,27
		ld		(no_bank_maptile_deco),a
		ld		hl,salle_114+18
		ld		(adr_piece_actuelle),hl
		ld		(adresse_du_decors_en_rom),hl
		ld		a,114
		ld		(no_de_la_salle),a
		ret
	config_porte_114
		ld		hl,#50
		ld		(pos_Y_blinky),hl
		ld		hl,#013c
		ld		(pos_X_blinky),hl
		ld		a,27
		ld		(no_bank_maptile_deco),a
		ld		hl,salle_112+18
		ld		(adr_piece_actuelle),hl
		ld		(adresse_du_decors_en_rom),hl
		ld		a,112
		ld		(no_de_la_salle),a
		ret
		config_porte_piege
		ld		hl,#8
		ld		(pos_Y_blinky),hl
		ld		hl,#123
		ld		(pos_X_blinky),hl
		ld		a,27
		ld		(no_bank_maptile_deco),a
		ld		hl,salle_120+18
		ld		(adr_piece_actuelle),hl
		
		ld		(adresse_du_decors_en_rom),hl
		ld		a,120
		ld		(no_de_la_salle),a
		ret



on_peut_ouvrir_ROM
		ld		a,(etape_anim_porte)
		cp		a,1
		jp		z,anim_porte_1
		cp		a,2
		jp		z,anim_porte_2
		cp		a,3
		jp		z,anim_porte_3
		cp		a,4
		jp		z,test_des_portes
		
		inc		a
		ld		(etape_anim_porte),a

	; calculer où se touve la tile de collision à l'écran
		ld		hl,(nieme_tile)
		srl H : rr L				; disive par 2 car on lis des valeurs sur 16 bits donc tous les 2 octets
		add		hl,hl
		add		hl,hl				; on multiplie par 4 octets (une tile)
		 ld		de,-4
		 add		hl,de				; puis on recule de -4 
	
		ld		de,#C000
		add		hl,de				; je récupère l'adr de la tile coliisionnée
		
		ld		bc,480					; le début de la porte par rapport à cette tile est 480 octets plus haut
		sbc		hl,bc
		ld		(adr_anim_porte),hl		; on a l'adresse où afficher les anim de cette porte
		ld		a,conf_vitesse_anim_porte
		ld		(vitesse_anim_porte),a

ret

; /////////////////////////////////////////////////////////////////////////////////////////////
; /////////////////////////////////////////////////////////////////////////////////////////////
; /////////////////////////////////////////////////////////////////////////////////////////////
; /////////////////      INITIALISATION  DES POSITIONS ET ZOOM ENNEMIS        /////////////////
; /////////////////////////////////////////////////////////////////////////////////////////////
; /////////////////////////////////////////////////////////////////////////////////////////////
; /////////////////////////////////////////////////////////////////////////////////////////////
init_grenouillerouge_ROM	
	ld		ix,(sprh_xyz_grenouillerouge)
	ld		(sprh_x_grenouillerouge),ix
	ld		hl,(pos_x_grenouillerouge)
	ld		(ix),hl
	inc		ix
	inc		ix
	ld		(sprh_y_grenouillerouge),ix
	ld		hl,(pos_y_grenouillerouge)
	ld		(pos_y_depart_grenouillerouge),hl
	ld		(ix),hl
	inc		ix
	inc		ix
	ld		(sprh_zoom_grenouillerouge),ix
	ld		a,ZOOM_mode_0						; on choisit son mode de zoom
	ld		(ix),a
	ld		a,1
	ld		(etape_grenouillerouge),a
	ld		(gravite_du_saut_grenouillerouge),a					; init de la valeur qui va freiner dans sa crête
	ld		(nbr_de_saut_grenouillerouge),a
	ld		(animation_grenouillerouge),a
	ld		(direction_grenouillerouge),a
	ld		a,10
	ld		(vitesse_du_saut_grenouillerouge),a					; init de la vitesse du saut
	ld		hl,4
	ld		(vitesse_X_grenouillerouge),hl
	xor		a
	ld		(timing_saut_grenouillerouge),a
	ld		(flag_saut_grenouillerouge_en_cours),a
	ret
init_grenouilleverte_ROM
	ld		ix,(sprh_xyz_grenouilleverte)
	ld		(sprh_x_grenouilleverte),ix
	ld		hl,(pos_x_grenouilleverte)
	ld		(ix),hl
	inc		ix
	inc		ix
	ld		(sprh_y_grenouilleverte),ix
	ld		hl,(pos_y_grenouilleverte)
	ld		(pos_y_depart_grenouilleverte),hl
	ld		(ix),hl
	inc		ix
	inc		ix
	ld		(sprh_zoom_grenouilleverte),ix
	ld		a,ZOOM_mode_0						; on choisit son mode de zoom
	ld		(ix),a
	ld		a,1
	ld		(etape_grenouilleverte),a
	ld		(gravite_du_saut_grenouilleverte),a					; init de la valeur qui va freiner dans sa crête
	ld		(nbr_de_saut_grenouilleverte),a
	ld		(animation_grenouilleverte),a
	ld		(direction_grenouilleverte),a
	ld		a,10
	ld		(vitesse_du_saut_grenouilleverte),a					; init de la vitesse du saut
	ld		hl,4
	ld		(vitesse_X_grenouilleverte),hl
	xor		a
	ld		(timing_saut_grenouilleverte),a
	ld		(flag_saut_grenouilleverte_en_cours),a
	ret
init_escargotvert_ROM
; on initialise le sprite du bas
	ld		ix,(sprh_xyz_escargotvert)
	ld		(sprh_x_escargotvert),ix
	ld		hl,(pos_x_escargotvert)
	ld		(ix),hl
	inc		ix
	inc		ix
	ld		(sprh_y_escargotvert),ix
	ld		hl,(pos_y_escargotvert)
	ld		(ix),hl
	inc		ix
	inc		ix
	ld		(sprh_zoom_escargotvert),ix
	ld		a,ZOOM_mode_0						; on choisit son mode de zoom
	ld		(ix),a
	inc		ix :	inc		ix : inc		ix :	inc		ix 	; on se place sur la pos X du prochain sprite hard
; on initialise le sprite du haut
	ld		(sprh_x_escargotvert),ix
	ld		hl,(pos_x_escargotvert)
	ld		(ix),hl
	inc		ix
	inc		ix
	ld		(sprh_y_escargotvert),ix
	ld		hl,(pos_y_escargotvert)
	ld		de,-16
	add		hl,de
	ld		(ix),hl
	inc		ix
	inc		ix
	ld		(sprh_zoom_escargotvert),ix
	ld		a,ZOOM_mode_0						; on choisit son mode de zoom
	ld		(ix),a
	ld		a,(distance_X_escargotvert)
	ld		(distance_X_escargotvert_save),a
	ld		a,1
	ld		(etape_escargotvert),a
	ld		(direction_escargotvert),a
	ld		a,4
	ld		(animation_escargotvert),a
	ld		(animation_escargotvert_save),a
	ret
init_escargotrouge_ROM
; on initialise le sprite du bas
	ld		ix,(sprh_xyz_escargotrouge)
	ld		(sprh_x_escargotrouge),ix
	ld		hl,(pos_x_escargotrouge)
	ld		(ix),hl
	inc		ix
	inc		ix
	ld		(sprh_y_escargotrouge),ix
	ld		hl,(pos_y_escargotrouge)
	ld		(ix),hl
	inc		ix
	inc		ix
	ld		(sprh_zoom_escargotrouge),ix
	ld		a,ZOOM_mode_0						; on choisit son mode de zoom
	ld		(ix),a
	inc		ix :	inc		ix : inc		ix :	inc		ix 	; on se place sur la pos X du prochain sprite hard
; on initialise le sprite du haut
	ld		(sprh_x_escargotrouge),ix
	ld		hl,(pos_x_escargotrouge)
	ld		(ix),hl
	inc		ix
	inc		ix
	ld		(sprh_y_escargotrouge),ix
	ld		hl,(pos_y_escargotrouge)
	ld		de,-16
	add		hl,de
	ld		(ix),hl
	inc		ix
	inc		ix
	ld		(sprh_zoom_escargotrouge),ix
	ld		a,ZOOM_mode_0						; on choisit son mode de zoom
	ld		(ix),a
	ld		a,(distance_X_escargotrouge)
	ld		(distance_X_escargotrouge_save),a
	ld		a,1
	ld		(etape_escargotrouge),a
	ld		(direction_escargotrouge),a
	ld		a,4
	ld		(animation_escargotrouge),a
	ld		(animation_escargotrouge_save),a
	ret
init_abeillegrise_ROM	
	; on initialise le sprite du bas
	ld		ix,(sprh_xyz_abeillegrise)
	ld		(sprh_x_abeillegrise),ix
	ld		hl,(pos_x_abeillegrise)
	ld		(pos_x_abeillegrise_save),hl
	ld		(ix),hl
	inc		ix
	inc		ix
	ld		(sprh_y_abeillegrise),ix
	ld		hl,(pos_y_abeillegrise)
	ld		(pos_y_abeillegrise_save),hl
	ld		(ix),hl
	inc		ix
	inc		ix
	ld		(sprh_zoom_abeillegrise),ix
	ld		a,ZOOM_mode_0						; on choisit son mode de zoom
	ld		(ix),a						; on allume les 4 sprites hard
	inc		ix :	inc		ix : inc		ix :	inc		ix 	; on se place sur la pos X du prochain sprite hard
; on initialise le sprite du haut
	ld		(sprh_x_abeillegrise),ix
	ld		hl,(pos_x_abeillegrise)
	ld		(ix),hl
	inc		ix
	inc		ix
	ld		(sprh_y_abeillegrise),ix
	ld		hl,(pos_y_abeillegrise)
	ld		de,-16
	add		hl,de
	ld		(ix),hl
	inc		ix
	inc		ix
	ld		(sprh_zoom_abeillegrise),ix
	ld		a,ZOOM_mode_0						; on choisit son mode de zoom
	ld		(ix),a
	ld		a,(distance_X_abeillegrise)
	ld		(distance_X_abeillegrise_save),a
	ld		a,1
	ld		(etape_abeillegrise),a
	ld		(direction_abeillegrise),a
	ld		a,5
	ld		(animation_abeillegrise),a
	ld		(animation_abeillegrise_save),a
	xor		a
	ld		(etape_anim_abeillegrise),a
	ld		hl,Tableau_anim_abeillegrise_droite
	ld		(adr_des_animations_abeillegrise),hl
	ret
init_abeillejaune_ROM	
	; on initialise le sprite du bas
	ld		ix,(sprh_xyz_abeillejaune)
	ld		(sprh_x_abeillejaune),ix
	ld		hl,(pos_x_abeillejaune)
	ld		(pos_x_abeillejaune_save),hl
	ld		(ix),hl
	inc		ix
	inc		ix
	ld		(sprh_y_abeillejaune),ix
	ld		hl,(pos_y_abeillejaune)
	ld		(pos_y_abeillejaune_save),hl
	ld		(ix),hl
	inc		ix
	inc		ix
	ld		(sprh_zoom_abeillejaune),ix
	ld		a,ZOOM_mode_0						; on choisit son mode de zoom
	ld		(ix),a						; on allume les 4 sprites hard
	inc		ix :	inc		ix : inc		ix :	inc		ix 	; on se place sur la pos X du prochain sprite hard
; on initialise le sprite du haut
	ld		(sprh_x_abeillejaune),ix
	ld		hl,(pos_x_abeillejaune)
	ld		(ix),hl
	inc		ix
	inc		ix
	ld		(sprh_y_abeillejaune),ix
	ld		hl,(pos_y_abeillejaune)
	ld		de,-16
	add		hl,de
	ld		(ix),hl
	inc		ix
	inc		ix
	ld		(sprh_zoom_abeillejaune),ix
	ld		a,ZOOM_mode_0						; on choisit son mode de zoom
	ld		(ix),a
	ld		a,(distance_X_abeillejaune)
	ld		(distance_X_abeillejaune_save),a
	ld		a,1
	ld		(etape_abeillejaune),a
	ld		a,2
	ld		(direction_abeillejaune),a
	ld		a,5
	ld		(animation_abeillejaune),a
	ld		(animation_abeillejaune_save),a
	xor		a
	ld		(etape_anim_abeillejaune),a
	ld		hl,Tableau_anim_abeillejaune_gauche
	ld		(adr_des_animations_abeillejaune),hl
	ret
init_chauvevert_ROM
	ld		ix,(sprh_xyz_chauvevert)
	ld		(sprh_x_chauvevert),ix
	ld		hl,(pos_x_chauvevert)
	ld		(ix),hl
	inc		ix
	inc		ix
	ld		(sprh_y_chauvevert),ix
	ld		hl,(pos_y_chauvevert)
	ld		(ix),hl
	inc		ix
	inc		ix
	ld		(sprh_zoom_chauvevert),ix
	ld		a,ZOOM_mode_0						; on choisit son mode de zoom
	ld		(ix),a						; on allume les 4 sprites hard
	ld		a,(distance_X_chauvevert)
	ld		(distance_X_chauvevert_save),a
	ld		a,1
	ld		(etape_chauvevert),a
	ld		(direction_chauvevert),a
	ld		a,4
	ld		(animation_chauvevert),a
	ld		(animation_chauvevert_save),a
	xor		a
	ld		(etape_anim_chauvevert),a
	ld		hl,Tableau_anim_chauvevert_droite
	ld		(adr_des_animations_chauvevert),hl
	ret
init_chauverouge_ROM	
	ld		ix,(sprh_xyz_chauverouge)
	ld		(sprh_x_chauverouge),ix
	ld		hl,(pos_x_chauverouge)
	ld		(ix),hl
	inc		ix
	inc		ix
	ld		(sprh_y_chauverouge),ix
	ld		hl,(pos_y_chauverouge)
	ld		(ix),hl
	inc		ix
	inc		ix
	ld		(sprh_zoom_chauverouge),ix
	ld		a,ZOOM_mode_0						; on choisit son mode de zoom
	ld		(ix),a						; on allume les 4 sprites hard
	ld		a,(distance_X_chauverouge)
	ld		(distance_X_chauverouge_save),a
	ld		a,1
	ld		(etape_chauverouge),a
	ld		a,2
	ld		(direction_chauverouge),a
	ld		a,4
	ld		(animation_chauverouge),a
	ld		(animation_chauverouge_save),a
	xor		a
	ld		(etape_anim_chauverouge),a
	ld		hl,Tableau_anim_chauverouge_gauche
	ld		(adr_des_animations_chauverouge),hl
	ret
init_araigneejaune_ROM	
	; on initialise le sprite du bas
	ld		ix,(sprh_xyz_araigneejaune)
	ld		(sprh_x_araigneejaune),ix
	ld		hl,(pos_x_araigneejaune)
	ld		(ix),hl
	inc		ix
	inc		ix
	ld		(sprh_y_araigneejaune),ix
	ld		hl,(pos_y_araigneejaune)
	ld		(ix),hl
	inc		ix
	inc		ix
	ld		(sprh_zoom_araigneejaune),ix
	ld		a,ZOOM_mode_0						; on choisit son mode de zoom
	ld		(ix),a
	inc		ix :	inc		ix : inc		ix :	inc		ix 	; on se place sur la pos X du prochain sprite hard
; on initialise le sprite du haut
	ld		(sprh_x_araigneejaune),ix
	ld		hl,(pos_x_araigneejaune)
	ld		(ix),hl
	inc		ix
	inc		ix
	ld		(sprh_y_araigneejaune),ix
	ld		hl,(pos_y_araigneejaune)
	ld		de,-16
	add		hl,de
	ld		(ix),hl
	inc		ix
	inc		ix
	ld		(sprh_zoom_araigneejaune),ix
	ld		a,ZOOM_mode_0						; on choisit son mode de zoom
	ld		(ix),a
	ld		a,(distance_Y_araigneejaune)
	ld		(distance_Y_araigneejaune_save),a
	ld		a,1
	ld		(etape_araigneejaune),a
	ld		(direction_araigneejaune),a
	ld		a,10
	ld		(animation_araigneejaune),a
	ld		(animation_araigneejaune_save),a
	ret
init_araigneebleue_ROM
	; on initialise le sprite du bas
	ld		ix,(sprh_xyz_araigneebleue)
	ld		(sprh_x_araigneebleue),ix
	ld		hl,(pos_x_araigneebleue)
	ld		(ix),hl
	inc		ix
	inc		ix
	ld		(sprh_y_araigneebleue),ix
	ld		hl,(pos_y_araigneebleue)
	ld		(ix),hl
	inc		ix
	inc		ix
	ld		(sprh_zoom_araigneebleue),ix
	ld		a,ZOOM_mode_0						; on choisit son mode de zoom
	ld		(ix),a
	inc		ix :	inc		ix : inc		ix :	inc		ix 	; on se place sur la pos X du prochain sprite hard
; on initialise le sprite du haut
	ld		(sprh_x_araigneebleue),ix
	ld		hl,(pos_x_araigneebleue)
	ld		(ix),hl
	inc		ix
	inc		ix
	ld		(sprh_y_araigneebleue),ix
	ld		hl,(pos_y_araigneebleue)
	ld		de,-16
	add		hl,de
	ld		(ix),hl
	inc		ix
	inc		ix
	ld		(sprh_zoom_araigneebleue),ix
	ld		a,ZOOM_mode_0						; on choisit son mode de zoom
	ld		(ix),a
	ld		a,(distance_Y_araigneebleue)
	ld		(distance_Y_araigneebleue_save),a
	ld		a,1
	ld		(etape_araigneebleue),a
	ld		(direction_araigneebleue),a
	ld		a,10
	ld		(animation_araigneebleue),a
	ld		(animation_araigneebleue_save),a
	ret
init_poissonrouge_ROM	
	; on initialise le sprite du bas
	ld		ix,(sprh_xyz_poissonrouge)
	ld		(sprh_x_poissonrouge),ix
	ld		hl,(pos_x_poissonrouge)
	ld		(pos_x_poissonrouge_save),hl
	ld		(ix),hl
	inc		ix
	inc		ix
	
	ld		(sprh_y_poissonrouge),ix
	ld		hl,(pos_y_poissonrouge)
	ld		(pos_y_poissonrouge_save),hl
	ld		(ix),hl
	inc		ix
	inc		ix
	ld		(sprh_zoom_poissonrouge),ix
	ld		a,ZOOM_mode_0						; on choisit son mode de zoom
	ld		(ix),a						; on allume les 4 sprites hard
	inc		ix :	inc		ix : inc		ix :	inc		ix 	; on se place sur la pos X du prochain sprite hard
; on initialise le sprite du haut
	ld		(sprh_x_poissonrouge),ix
	ld		hl,(pos_x_poissonrouge)
	ld		(ix),hl
	inc		ix
	inc		ix
	ld		(sprh_y_poissonrouge),ix
	ld		hl,(pos_y_poissonrouge)
	ld		de,-16
	add		hl,de
	ld		(ix),hl
	inc		ix
	inc		ix
	ld		(sprh_zoom_poissonrouge),ix
	ld		a,ZOOM_mode_0						; on choisit son mode de zoom
	ld		(ix),a
	ld		a,(distance_X_poissonrouge)
	ld		(distance_X_poissonrouge_save),a
	ld		a,1
	ld		(etape_poissonrouge),a
	ld		(direction_poissonrouge),a
	ld		a,5
	ld		(animation_poissonrouge),a
	ld		(animation_poissonrouge_save),a
	xor		a
	ld		(etape_anim_poissonrouge),a
	ld		hl,Tableau_anim_poissonrouge_droite
	ld		(adr_des_animations_poissonrouge),hl
	ret
init_poissonvert_ROM	
	; on initialise le sprite du bas
	ld		ix,(sprh_xyz_poissonvert)
	ld		(sprh_x_poissonvert),ix
	ld		hl,(pos_x_poissonvert)
	ld		(pos_x_poissonvert_save),hl
	ld		(ix),hl
	inc		ix
	inc		ix
	ld		(sprh_y_poissonvert),ix
	ld		hl,(pos_y_poissonvert)
	ld		(pos_y_poissonvert_save),hl
	ld		(ix),hl
	inc		ix
	inc		ix
	ld		(sprh_zoom_poissonvert),ix
	ld		a,ZOOM_mode_0						; on choisit son mode de zoom
	ld		(ix),a						; on allume les 4 sprites hard
	inc		ix :	inc		ix : inc		ix :	inc		ix 	; on se place sur la pos X du prochain sprite hard
; on initialise le sprite du haut
	ld		(sprh_x_poissonvert),ix
	ld		hl,(pos_x_poissonvert)
	ld		(ix),hl
	inc		ix
	inc		ix
	ld		(sprh_y_poissonvert),ix
	ld		hl,(pos_y_poissonvert)
	ld		de,-16
	add		hl,de
	ld		(ix),hl
	inc		ix
	inc		ix
	ld		(sprh_zoom_poissonvert),ix
	ld		a,ZOOM_mode_0						; on choisit son mode de zoom
	ld		(ix),a
	ld		a,(distance_X_poissonvert)
	ld		(distance_X_poissonvert_save),a
	ld		a,1
	ld		(etape_poissonvert),a
	ld		(direction_poissonvert),a
	ld		a,5
	ld		(animation_poissonvert),a
	ld		(animation_poissonvert_save),a
	xor		a
	ld		(etape_anim_poissonvert),a
	ld		hl,Tableau_anim_poissonvert_droite
	ld		(adr_des_animations_poissonvert),hl
	ret

