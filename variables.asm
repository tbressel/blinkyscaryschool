; //////////////////////////////////////////////////////////////////
; /////////////////////        MOTEUR DU JEU    ////////////////////
; //////////////////////////////////////////////////////////////////
adr_piece_actuelle			ds		2,0
; connexion asic, rom et mode
valeur_asic					ds		1,0
rom_sectionnee				ds		2,0
etat_de_la_rom				ds		2,0
etat_du_mode				ds		2,0
mode						ds		1,0
etat_roms_mode				ds		2,0


save_musique_retour			ds		1,0
DMA0						ds		2,0
SAMPLE						ds		2,0


no_bank_maptile_deco		ds		1,0
no_bank_sprh_ennemy			ds		1,0
no_de_bank_du_tileset		ds		1,0
flag_blinky_est_dans_leau	ds		1,0
vitesse_anim_blinky_meurt	ds		1,0
etape_blinky_meurt			ds		1,0
etape_anim_yeux				ds		1,0
nbr_de_vie					ds		1,0
flag_lumiere				ds		1,0
longueur_du_sprh			ds		2,0
flag_ennemis_mortel			ds		1,0
pointeur_soleil_ROM			ds		2,0
pointeur_soleil_ecran		ds		2,0
nbr_colonne_soleil			ds		1,0
nbr_ligne_soleil			ds		1,0
le_temps_passe_decompte		ds		1,0
decompte_rallonge			ds	1,0
flag_on_touche_un_item		ds		1,0
flag_item_case_1			ds		1,0
flag_item_case_2			ds		1,0
flag_item_case_3			ds		1,0
nbr_ingredient_chaudron_0	ds		1,0
nbr_ingredient_chaudron_1	ds		1,0
nbr_ingredient_chaudron_2	ds		1,0
distance_tombe_pierre		ds		1,0
largeur_des_parchemins		ds		2,0
nbr_de_lettre				ds		1,0
adr_chiffre_vie				ds		2,0
flag_reboot					ds		1,0
adr_anim_porte				ds		2,0
flag_passage				ds		1,0
adr_passage108				ds		2,0


langue_txt_piece1			ds		2,0
langue_txt_piece3           ds		2,0
langue_txt_piece10          ds		2,0
langue_txt_piece18          ds		2,0
langue_txt_piece49          ds		2,0
langue_txt_piece67			ds		2,0
langue_txt_piece66			ds		2,0
langue_txt_piece35			ds		2,0
langue_txt_piece82			ds		2,0
langue_txt_piece93			ds		2,0
langue_txt_piece89			ds		2,0
; //////////////////////////////////////////////////////////////////
; /////////////////////           BLINKY        ////////////////////
; //////////////////////////////////////////////////////////////////

; controle de blinky
resultat_test_de_touche			ds		1,0
resultat_frame_precedante		ds		1,0
bouton_fire1					ds		1,0
switch_bouton_fire1				ds		1,0
etat_blinky_en_cours			ds		1,0			; 1,2,3,4 pour les directions
flag_on_tombe					ds		1,0
flag_saut_en_cours				ds		1,0
pos_X_blinky					ds		2,0
pos_Y_blinky					ds		2,0
pos_X_blinky_debut_tableau		ds		2,0
pos_Y_blinky_debut_tableau		ds		2,0
vitesse_du_saut					ds		1,0
hauteur_max_du_saut				ds		1,0
gravite_du_saut					ds		1,0
vitesse_X_blinky				ds		2,0
vitesse_Y_blinky				ds		2,0
on_passe						ds		1,0

; animation de blinky
etape_anim_blinky				ds		1,0
animation_blinky_en_cours		ds		2,0
animation_blinky_saute			ds		2,0
compteur_animation_blinky		ds		1,0
compteur_animation_en_cours		ds		1,0
no_animation_blinky				ds		1,0
largeur_animation				ds		2,0
vitesse_animation_blinky		ds		1,0
vitesse_animation_blinky_saute		ds		1,0
flag_bague						ds		1,0
posY_barre						ds		1,0
posX_barre						ds		1,0
adr_barre						ds		2,0
valeur_barre					ds		2,0
nbr_de_bloc_energie				ds		1,0
flag_blinky_est_deja_touche		ds		1,0
nbr_de_barre_energie			ds		1,0
pointeur_tableau_valeur_bloc_energie	ds	2,0
blinky_gauche_adr			ds	2,0
blinky_droite_adr			ds	2,0
no_bank_sprh_blinky			ds	1,0
flag_on_plonge				ds	1,0
distance_plongon			ds	1,0
vitesse_du_saut_en_cours	ds	1,0
posY_blinky_bas				ds	2,0
posY_blinky_haut			ds	2,0
on_saute_ou_pas				ds	1,0
resultat_test_de_touche_fire	ds	1,0
adr_bord_droit				ds	2,0

; //////////////////////////////////////////////////////////////////
; /////////////////////           ENNEMY        ////////////////////
; //////////////////////////////////////////////////////////////////
adr_piece_ennemis		ds		2,0
pointeur_piece_ennemis	ds		2,0
adr_type_ennemis			ds		2,0
etape_ennemis_1			ds		1,0
etape_ennemis_2			ds		1,0

timing_pierre_1				ds		1,0
timing_pierre_2				ds		1,0
timing_pierre_3				ds		1,0
etape_pierresquitombent		ds		1,0
sprh_x_ennemis			ds		2,0
sprh_y_ennemis			ds		2,0


; souris										DEBUT
tableau_souris
	adr_souris				ds			2,0
	bank_souris				ds			1,0
	type_souris				ds			1,0
	pos_x_souris			ds			2,0
	pos_y_souris			ds			2,0
	vitesse_X_souris		ds			1,0
	distance_X_souris		ds			1,0
	vitesse_Y_souris		ds			1,0
	distance_Y_souris		ds			1,0
	sprh_de_depart_souris	ds			2,0
	sprh_xyz_souris			ds			2,0


	etape_souris			ds		1,0
	animation_souris		ds		1,0
	animation_souris_save	ds		1,0
	distance_X_souris_save	ds		1,0
	direction_souris		ds		1,0
	sprh_x_souris			ds		2,0
	sprh_y_souris			ds		2,0
	sprh_zoom_souris		ds		2,0

; escargotvert
tableau_escargotvert
	adr_escargotvert					ds			2,0
	bank_escargotvert					ds			1,0
	type_escargotvert					ds			1,0
	pos_x_escargotvert					ds			2,0
	pos_y_escargotvert					ds			2,0
	vitesse_X_escargotvert				ds			1,0
	distance_X_escargotvert				ds			1,0
	vitesse_Y_escargotvert				ds			1,0
	distance_Y_escargotvert				ds			1,0
	sprh_de_depart_escargotvert			ds			2,0
	sprh_xyz_escargotvert				ds			2,0


	etape_escargotvert				ds		1,0
	animation_escargotvert			ds		1,0
	animation_escargotvert_save		ds		1,0
	distance_X_escargotvert_save	ds		1,0
	direction_escargotvert			ds		1,0
	sprh_x_escargotvert			ds		2,0
	sprh_y_escargotvert			ds		2,0
	sprh_zoom_escargotvert		ds		2,0

	; escargotrouge
tableau_escargotrouge
	adr_escargotrouge					ds			2,0
	bank_escargotrouge					ds			1,0
	type_escargotrouge					ds			1,0
	pos_x_escargotrouge					ds			2,0
	pos_y_escargotrouge					ds			2,0
	vitesse_X_escargotrouge				ds			1,0
	distance_X_escargotrouge				ds			1,0
	vitesse_Y_escargotrouge				ds			1,0
	distance_Y_escargotrouge				ds			1,0
	sprh_de_depart_escargotrouge			ds			2,0
	sprh_xyz_escargotrouge				ds			2,0


	etape_escargotrouge				ds		1,0
	animation_escargotrouge			ds		1,0
	animation_escargotrouge_save		ds		1,0
	distance_X_escargotrouge_save	ds		1,0
	direction_escargotrouge			ds		1,0
	sprh_x_escargotrouge			ds		2,0
	sprh_y_escargotrouge			ds		2,0
	sprh_zoom_escargotrouge		ds		2,0

; araigneebleue
tableau_araigneebleue
	adr_araigneebleue			ds			2,0
	bank_araigneebleue			ds			1,0
	type_araigneebleue			ds			1,0
	pos_x_araigneebleue			ds			2,0
	pos_y_araigneebleue			ds			2,0
	vitesse_X_araigneebleue		ds			1,0
	distance_X_araigneebleue		ds			1,0
	vitesse_Y_araigneebleue			ds			1,0
	distance_Y_araigneebleue		ds			1,0
	sprh_de_depart_araigneebleue	ds			2,0
	sprh_xyz_araigneebleue			ds			2,0

	etape_araigneebleue				ds		1,0
	animation_araigneebleue			ds		1,0
	animation_araigneebleue_save	ds		1,0
	distance_Y_araigneebleue_save	ds		1,0
	direction_araigneebleue			ds		1,0
	sprh_x_araigneebleue			ds		2,0
	sprh_y_araigneebleue			ds		2,0
	sprh_zoom_araigneebleue			ds		2,0

; araigneejaune
tableau_araigneejaune
	adr_araigneejaune			ds			2,0
	bank_araigneejaune			ds			1,0
	type_araigneejaune			ds			1,0
	pos_x_araigneejaune			ds			2,0
	pos_y_araigneejaune			ds			2,0
	vitesse_X_araigneejaune		ds			1,0
	distance_X_araigneejaune		ds			1,0
	vitesse_Y_araigneejaune			ds			1,0
	distance_Y_araigneejaune		ds			1,0
	sprh_de_depart_araigneejaune	ds			2,0
	sprh_xyz_araigneejaune			ds			2,0

	etape_araigneejaune				ds		1,0
	animation_araigneejaune			ds		1,0
	animation_araigneejaune_save	ds		1,0
	distance_Y_araigneejaune_save	ds		1,0
	direction_araigneejaune			ds		1,0
	sprh_x_araigneejaune			ds		2,0
	sprh_y_araigneejaune			ds		2,0
	sprh_zoom_araigneejaune			ds		2,0

	; chauverouge
tableau_chauverouge
	adr_chauverouge					ds			2,0
	bank_chauverouge					ds			1,0
	type_chauverouge					ds			1,0
	pos_x_chauverouge					ds			2,0
	pos_y_chauverouge					ds			2,0
	vitesse_X_chauverouge				ds			1,0
	distance_X_chauverouge				ds			1,0
	vitesse_Y_chauverouge				ds			1,0
	distance_Y_chauverouge				ds			1,0
	sprh_de_depart_chauverouge			ds			2,0
	sprh_xyz_chauverouge				ds			2,0


	etape_chauverouge				ds		1,0
	animation_chauverouge			ds		1,0
	animation_chauverouge_save		ds		1,0
	distance_X_chauverouge_save	ds		1,0
	direction_chauverouge			ds		1,0
	sprh_x_chauverouge			ds		2,0
	sprh_y_chauverouge			ds		2,0
	sprh_zoom_chauverouge		ds		2,0
	etape_anim_chauverouge		ds		1,0
	adr_des_animations_chauverouge		ds		2,0

	; chauvevert
tableau_chauvevert
	adr_chauvevert					ds			2,0
	bank_chauvevert					ds			1,0
	type_chauvevert					ds			1,0
	pos_x_chauvevert					ds			2,0
	pos_y_chauvevert					ds			2,0
	vitesse_X_chauvevert				ds			1,0
	distance_X_chauvevert				ds			1,0
	vitesse_Y_chauvevert				ds			1,0
	distance_Y_chauvevert				ds			1,0
	sprh_de_depart_chauvevert			ds			2,0
	sprh_xyz_chauvevert				ds			2,0


	etape_chauvevert				ds		1,0
	animation_chauvevert			ds		1,0
	animation_chauvevert_save		ds		1,0
	distance_X_chauvevert_save	ds		1,0
	direction_chauvevert			ds		1,0
	sprh_x_chauvevert			ds		2,0
	sprh_y_chauvevert			ds		2,0
	sprh_zoom_chauvevert		ds		2,0
	etape_anim_chauvevert		ds		1,0
	adr_des_animations_chauvevert	ds		2,0


	; poissonvert
tableau_poissonvert
	adr_poissonvert					ds			2,0
	bank_poissonvert					ds			1,0
	type_poissonvert					ds			1,0
	pos_x_poissonvert					ds			2,0
	pos_y_poissonvert					ds			2,0
	vitesse_X_poissonvert				ds			1,0
	distance_X_poissonvert				ds			1,0
	vitesse_Y_poissonvert				ds			1,0
	distance_Y_poissonvert				ds			1,0
	sprh_de_depart_poissonvert			ds			2,0
	sprh_xyz_poissonvert				ds			2,0


	etape_poissonvert				ds		1,0
	animation_poissonvert			ds		1,0
	animation_poissonvert_save		ds		1,0
	distance_X_poissonvert_save	ds		1,0
	direction_poissonvert			ds		1,0
	sprh_x_poissonvert			ds		2,0
	sprh_y_poissonvert			ds		2,0
	sprh_zoom_poissonvert		ds		2,0
	etape_anim_poissonvert		ds		1,0
	adr_des_animations_poissonvert		ds		2,0
		pos_y_poissonvert_save			ds		2,0
	pos_x_poissonvert_save			ds		2,0

	; poissonrouge
tableau_poissonrouge
	adr_poissonrouge					ds			2,0
	bank_poissonrouge					ds			1,0
	type_poissonrouge					ds			1,0
	pos_x_poissonrouge					ds			2,0
	pos_y_poissonrouge					ds			2,0
	vitesse_X_poissonrouge				ds			1,0
	distance_X_poissonrouge				ds			1,0
	vitesse_Y_poissonrouge				ds			1,0
	distance_Y_poissonrouge				ds			1,0
	sprh_de_depart_poissonrouge			ds			2,0
	sprh_xyz_poissonrouge				ds			2,0


	etape_poissonrouge				ds		1,0
	animation_poissonrouge			ds		1,0
	animation_poissonrouge_save		ds		1,0
	distance_X_poissonrouge_save	ds		1,0
	direction_poissonrouge			ds		1,0
	sprh_x_poissonrouge			ds		2,0
	sprh_y_poissonrouge			ds		2,0
	sprh_zoom_poissonrouge		ds		2,0
	etape_anim_poissonrouge		ds		1,0
	adr_des_animations_poissonrouge		ds		2,0
		pos_y_poissonrouge_save			ds		2,0
	pos_x_poissonrouge_save			ds		2,0


		; abeillegrise
tableau_abeillegrise
	adr_abeillegrise					ds			2,0
	bank_abeillegrise					ds			1,0
	type_abeillegrise					ds			1,0
	pos_x_abeillegrise					ds			2,0
	pos_y_abeillegrise					ds			2,0
	vitesse_X_abeillegrise				ds			1,0
	distance_X_abeillegrise				ds			1,0
	vitesse_Y_abeillegrise				ds			1,0
	distance_Y_abeillegrise				ds			1,0
	sprh_de_depart_abeillegrise			ds			2,0
	sprh_xyz_abeillegrise				ds			2,0


	etape_abeillegrise				ds		1,0
	animation_abeillegrise			ds		1,0
	animation_abeillegrise_save		ds		1,0
	distance_X_abeillegrise_save	ds		1,0
	direction_abeillegrise			ds		1,0
	sprh_x_abeillegrise				ds		2,0
	sprh_y_abeillegrise				ds		2,0
	sprh_zoom_abeillegrise			ds		2,0
	etape_anim_abeillegrise			ds		1,0
	adr_des_animations_abeillegrise		ds		2,0
	pos_y_abeillegrise_save			ds		2,0
	pos_x_abeillegrise_save			ds		2,0


		; abeillejaune
tableau_abeillejaune
	adr_abeillejaune					ds			2,0
	bank_abeillejaune					ds			1,0
	type_abeillejaune					ds			1,0
	pos_x_abeillejaune					ds			2,0
	pos_y_abeillejaune					ds			2,0
	vitesse_X_abeillejaune				ds			1,0
	distance_X_abeillejaune				ds			1,0
	vitesse_Y_abeillejaune				ds			1,0
	distance_Y_abeillejaune				ds			1,0
	sprh_de_depart_abeillejaune			ds			2,0
	sprh_xyz_abeillejaune				ds			2,0


	etape_abeillejaune				ds		1,0
	animation_abeillejaune			ds		1,0
	animation_abeillejaune_save		ds		1,0
	distance_X_abeillejaune_save	ds		1,0
	direction_abeillejaune			ds		1,0
	sprh_x_abeillejaune			ds		2,0
	sprh_y_abeillejaune			ds		2,0
	sprh_zoom_abeillejaune		ds		2,0
	etape_anim_abeillejaune		ds		1,0
		adr_des_animations_abeillejaune		ds		2,0
pos_y_abeillejaune_save		ds		2,0
pos_x_abeillejaune_save		ds		2,0
timing_abeillejaune			ds		1,0

	; grenouilleverte
tableau_grenouilleverte
	adr_grenouilleverte					ds			2,0
	bank_grenouilleverte					ds			1,0
	type_grenouilleverte					ds			1,0
	pos_x_grenouilleverte					ds			2,0
	pos_y_grenouilleverte					ds			2,0
	vitesse_X_grenouilleverte				ds			1,0
	distance_X_grenouilleverte				ds			1,0
	vitesse_Y_grenouilleverte				ds			1,0
	distance_Y_grenouilleverte				ds			1,0
	sprh_de_depart_grenouilleverte			ds			2,0
	sprh_xyz_grenouilleverte				ds			2,0


	etape_grenouilleverte				ds		1,0
	animation_grenouilleverte			ds		1,0
	animation_grenouilleverte_save		ds		1,0
	distance_X_grenouilleverte_save	ds		1,0
	direction_grenouilleverte			ds		1,0
	sprh_x_grenouilleverte			ds		2,0
	sprh_y_grenouilleverte			ds		2,0
	sprh_zoom_grenouilleverte		ds		2,0
	etape_anim_grenouilleverte		ds		1,0
	vitesse_du_saut_grenouilleverte	ds		1,0
	gravite_du_saut_grenouilleverte	ds		1,0
	timing_saut_grenouilleverte		ds		1,0
	flag_saut_grenouilleverte_en_cours	ds	1,0
	nbr_de_saut_grenouilleverte		ds		1,0
	pos_y_depart_grenouilleverte	ds		2,0
	; grenouillerouge
tableau_grenouillerouge
	adr_grenouillerouge					ds			2,0
	bank_grenouillerouge					ds			1,0
	type_grenouillerouge					ds			1,0
	pos_x_grenouillerouge					ds			2,0
	pos_y_grenouillerouge					ds			2,0
	vitesse_X_grenouillerouge				ds			1,0
	distance_X_grenouillerouge				ds			1,0
	vitesse_Y_grenouillerouge				ds			1,0
	distance_Y_grenouillerouge				ds			1,0
	sprh_de_depart_grenouillerouge			ds			2,0
	sprh_xyz_grenouillerouge				ds			2,0


	etape_grenouillerouge				ds		1,0
	animation_grenouillerouge			ds		1,0
	animation_grenouillerouge_save		ds		1,0
	distance_X_grenouillerouge_save	ds		1,0
	direction_grenouillerouge			ds		1,0
	sprh_x_grenouillerouge			ds		2,0
	sprh_y_grenouillerouge			ds		2,0
	sprh_zoom_grenouillerouge		ds		2,0
	etape_anim_grenouillerouge		ds		1,0
	vitesse_du_saut_grenouillerouge	ds		1,0
	gravite_du_saut_grenouillerouge	ds		1,0
	timing_saut_grenouillerouge		ds		1,0
	flag_saut_grenouillerouge_en_cours	ds	1,0
	nbr_de_saut_grenouillerouge		ds		1,0
	pos_y_depart_grenouillerouge	ds		2,0
; //////////////////////////////////////////////////////////////////
; /////////////////////        AFFICHAGE       ////////////////////
; //////////////////////////////////////////////////////////////////

; le hud
pointeur_hud					ds		2,0
pallette_en_cours_decors		ds		2,0
pallette_en_cours_hud			ds		2,0

; le decors
adresse_du_decors_en_rom		ds		2,0

; parchemin
adr_depart_texte					ds		2,0
adr_ligne_de_texte					ds		2,0
nbr_ligne_texte					ds		1,0
; //////////////////////////////////////////////////////////////////
; /////////////////////    ANIMATION DU DECORS    //////////////////
; //////////////////////////////////////////////////////////////////

; le chaudron
etape_anim_bulles_du_chaudron		ds	1,0
nbr_frame_anim_bulles_du_chaudron	ds	1,0
etape_anim_feu_du_chaudron			ds	1,0
nbr_frame_anim_feu_du_chaudron		ds	1,0

; les têtes de mort
etape_anim_tete_de_mort				ds	1,0
nbr_frame_anim_tete_de_mort			ds	1,0

; les bougies
etape_anim_bougie					ds	1,0
nbr_frame_anim_bougie				ds	1,0

; l'eau
etape_anim_eau						ds	1,0
nbr_frame_anim_eau						ds	1,0
etape_anim_eau2						ds	1,0
nbr_frame_anim_eau2						ds	1,0
; //////////////////////////////////////////////////////////////////
; /////////////////////    COLLISIONS DU DECORS    //////////////////
; //////////////////////////////////////////////////////////////////

collision_decors_sprh_X		ds		2,0
collision_decors_sprh_Y		ds		2,0
collision_decors_sprh3_X		ds		2,0
collision_decors_sprh3_Y		ds		2,0
adr_de_la_tile					ds		2,0
no_de_la_tile					ds		2,0



timing_fire_2					ds		1,0
decalage_octets_salle_suivante	ds		1,0
no_de_la_salle					ds		1,0
adr_anim_no_1					ds		2,0


init_afficher_item		ds		1,0
flag_on_se_teleporte		ds		1,0

pointeur_tableau_item	ds	2,0






tableau_ennemy_RAM
adr_ennemy_1		ds			2,0
bank_ennemy_1		ds			1,0
type_ennemy_1		ds			1,0
pos_x_ennemy_1		ds			2,0
pos_y_ennemy_1		ds			2,0
vitesse_X_ennemy_1	ds			1,0
distance_X_ennemy_1	ds			1,0
vitesse_Y_ennemy_1	ds			1,0
distance_Y_ennemy_1	ds			1,0
sprh_adr_ennemy_1	ds			2,0
sprh_xyz_ennemy_1	ds			2,0



adr_ennemy_2		ds			2,0
bank_ennemy_2		ds			1,0
type_ennemy_2		ds			1,0
pos_x_ennemy_2		ds			2,0
pos_y_ennemy_2		ds			2,0
vitesse_X_ennemy_2	ds			1,0
distance_X_ennemy_2	ds			1,0
vitesse_Y_ennemy_2	ds			1,0
distance_Y_ennemy_2	ds			1,0
sprh_adr_ennemy_2	ds			2,0
sprh_xyz_ennemy_2	ds			2,0



adr_ennemy_3		ds			2,0
bank_ennemy_3		ds			1,0
type_ennemy_3		ds			1,0
pos_x_ennemy_3		ds			2,0
pos_y_ennemy_3		ds			2,0
vitesse_X_ennemy_3	ds			1,0
distance_X_ennemy_3	ds			1,0
vitesse_Y_ennemy_3	ds			1,0
distance_Y_ennemy_3	ds			1,0
sprh_adr_ennemy_3	ds			2,0
sprh_xyz_ennemy_3	ds			2,0


adr_ennemy_4		ds			2,0
bank_ennemy_4		ds			1,0
type_ennemy_4		ds			1,0
pos_x_ennemy_4		ds			2,0
pos_y_ennemy_4		ds			2,0
vitesse_X_ennemy_4	ds			1,0
distance_X_ennemy_4	ds			1,0
vitesse_Y_ennemy_4	ds			1,0
distance_Y_ennemy_4	ds			1,0
sprh_adr_ennemy_4	ds			2,0
sprh_xyz_ennemy_4	ds			2,0

