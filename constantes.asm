; //////////////////////////////////////////////////////////////////
; /////////////////////       COULEURS        //////////////////////
; //////////////////////////////////////////////////////////////////
pallettes_RAM					equ		#0040
pallette_decors_ram				equ		pallettes_RAM
pallette_hud_ram				equ		pallettes_RAM+#20
pallette_sprites_hard_ram		equ		pallettes_RAM+#40
pallette_noire					equ		pallettes_RAM+#3FA0
pallette_parchemin				equ		#0000
; //////////////////////////////////////////////////////////////////
; /////////////////////  SAMPLES & MUSIQUES   //////////////////////
; //////////////////////////////////////////////////////////////////
	DMA_LIST_1				equ			#13D0
	LONGUEUR_DMALIST1		equ			#1242
	
	DMA_LIST_2				equ			#2614
	LONGUEUR_DMALIST2		equ			#0F44
	
	DMA_LIST_3				equ			#00A0
	LONGUEUR_DMALIST3		equ			#132C
	
	DMA_LIST_4				equ			#00A0
	LONGUEUR_DMALIST4		equ			#3478
	
	DMA_LIST_FIN			equ			#00A0
	LONGUEUR_DMALISTFIN		equ			#CAB4

PLAYER_ADR_RAM				EQU	#00C0		; adresse à reporter manuellement dans creation_cartouche.asm
		LONGUEUR_PLAYER		equ	#0D00
MUSIC_ADR_RAM				EQU #0AC0		; toutes les musiques du jeu
		LONGUEUR_MUSIC		equ	#2000
		


		
		
; //////////////////////////////////////////////////////////////////
; /////////////////////  DEFINITION DES BANK  //////////////////////
; //////////////////////////////////////////////////////////////////

bank_rom_0					equ		0
bank_programme_rom			equ		3
bank_table_animation_decors	equ		21

bank_gfx_hud				equ		4
bank_tilset_hud				equ		4
bank_fonte					equ		4
bank_pallettes				equ		4
bank_animation_decors		equ		4
bank_parchemin				equ		5

bank_sprh_blinky			equ		6
bank_sprh_items				equ		7
bank_sprh_items2			equ		26
bank_sprh_ennemy			equ		8
bank_sprh_ennemy2			equ		9
bank_sprh_blinky2			equ		10


bank_tilset_decors			equ		11
bank_tilset_decors2			equ		12
bank_maptile_decors			equ		13
bank_tables_ennemy			equ		17

bank_screen_fin				equ		28
bank_sample_fin				equ		29
bank_sample1				equ		30
bank_sample2				equ		31

; //////////////////////////////////////////////////////////////////
; /////////////////////   AFFICHAGE  DECORS    //////////////////////
; //////////////////////////////////////////////////////////////////

depart_hud_ecran				equ		#c640
depart_decors_ecran				equ		#c000
adr_table_hud_ROM				equ		#c000
adr_gfx_hud_ROM					equ		#DF1E
adresse_fonte_en_rom			equ		#dd43 ;#E493
adr_fonte_vie_rom				equ		#e976	;#F0c6  
conf_vitesse_anim_porte			equ		5


adresse_maptile_en_rom			equ		#c000

salle_01						equ		#c000
salle_02						equ		#c332
salle_03						equ		#C664
salle_13						equ		#E658
salle_24						EQU		#C996
salle_29						equ		#D990
salle_59 						equ		#F984
salle_75						equ		#efee
salle_82						equ		#c664
salle_90						equ		#dff4
salle_110						equ		#e326
nombre_de_ligne_de_tile			equ		20
nombre_de_tile_sur_une_ligne	equ		20
hauteur_dune_tile				equ		8
tile_murs						equ		500   ;360
tile_plateforme					equ		460	  ;320
tile_porte_ferme						equ		413
tile_porte_ouverte						equ		418
soleil_hud						equ		#CEA0
parchemin_rom					equ		#C000
parchemin_rom2					equ		#D4FB
petit_parchemin_rom				equ		#E794
depart_scr_parchemin			equ		#C000
depart_scr_petit_parchemin		equ		#C200
depart_asic_parchemin			equ		#5940
largeur_parchemin				equ		61
largeur_petit_parchemin			equ		33
hauteur_petit_parchemin			equ		95
hauteur_parch_haut				equ		84
hauteur_parch_bas				equ		78

pierre1_X_salle4					equ		#00c0
pierre2_X_salle4					equ		#0140
pierre3_X_salle4					equ		#01C0
distance_tombe_pierre4				equ		#80
pierre1_X_salle19					equ		#0040
pierre2_X_salle19					equ		#00C0
pierre3_X_salle19					equ		#00C0
distance_tombe_pierre19				equ		#60





; //////////////////////////////////////////////////////////////////
; /////////////////////  ANIMATIONS DU DECORS  /////////////////////
; //////////////////////////////////////////////////////////////////
nbr_d_animations_decors				equ		6

; Bulles du chaudron
hauteur_bulles_du_chaudron			equ	16
largeur_bulles_du_chaudron			equ	8
vitesse_anim_bulles_du_chaudron		equ	9
adr_bulles_du_chaudron_1_ROM		equ	#f500 ;#F400
adr_bulles_du_chaudron_2_ROM		equ	adr_bulles_du_chaudron_1_ROM+#0080
adr_bulles_du_chaudron_3_ROM		equ	adr_bulles_du_chaudron_1_ROM+#0100
adr_bulles_du_chaudron_4_ROM		equ	adr_bulles_du_chaudron_1_ROM+#0180

; Feu du chaudron
hauteur_feu_du_chaudron				equ	8
largeur_feu_du_chaudron				equ	8
vitesse_anim_feu_du_chaudron		equ	5
adr_feu_du_chaudron_1_ROM			equ	#f700 ;#F600
adr_feu_du_chaudron_2_ROM			equ	adr_feu_du_chaudron_1_ROM+#0040
adr_feu_du_chaudron_3_ROM			equ	adr_feu_du_chaudron_1_ROM+#0080
adr_feu_du_chaudron_4_ROM			equ	adr_feu_du_chaudron_1_ROM+#00C0

; tête de mort
hauteur_tete_de_mort			equ	16
largeur_tete_de_mort			equ	8
vitesse_anim_tete_de_mort		equ	15
adr_tete_de_mort_1_ROM			equ	#f800   ;#F700
adr_tete_de_mort_2_ROM			equ	adr_tete_de_mort_1_ROM+#0080
adr_tete_de_mort_3_ROM			equ	adr_tete_de_mort_1_ROM+#0100
adr_tete_de_mort_4_ROM			equ	adr_tete_de_mort_1_ROM+#0080


; bougie
hauteur_bougie				equ	22
largeur_bougie				equ	4
vitesse_anim_bougie			equ	4
adr_bougie_1_ROM			equ	#Fa03 ;#F903
adr_bougie_2_ROM			equ	adr_bougie_1_ROM+#0058
adr_bougie_3_ROM			equ	adr_bougie_1_ROM+#00B0
adr_bougie_4_ROM			equ	adr_bougie_1_ROM+#0108

; eau
hauteur_eau					equ	8
largeur_eau					equ	16
vitesse_anim_eau			equ	4
adr_eau_1_ROM			equ	#Fbe6   ;#fae6
adr_eau_2_ROM			equ	adr_eau_1_ROM+#0080	;#c766
adr_eau_3_ROM			equ	adr_eau_1_ROM+#0100	;#c7e6
adr_eau_4_ROM			equ	adr_eau_1_ROM+#0180	;#c866
adr_eau_5_ROM			equ	adr_eau_1_ROM+#0200 ;#c8e6
adr_eau_6_ROM			equ	adr_eau_1_ROM+#0280	;#c966

; //////////////////////////////////////////////////////////////////
; /////////////////////    GESTION DU HUD      /////////////////////
; //////////////////////////////////////////////////////////////////
VIES		equ	adr_fonte_vie_rom
VIE_0		equ	VIES
VIE_1		equ	VIES+27
VIE_2		equ	VIES+54
VIE_3		equ	VIES+81
VIE_4		equ	VIES+108
VIE_5		equ	VIES+135
VIE_6		equ	VIES+162
VIE_7		equ	VIES+189
VIE_8		equ	VIES+216
VIE_9		equ	VIES+243

adr_ecran_vie	equ		#c7ca

; //////////////////////////////////////////////////////////////////
; /////////////////////    GESTION DE BLINKY   /////////////////////
; //////////////////////////////////////////////////////////////////

; Blinky sprites
longueur_sprh_blinky				equ	#0400
blinky_sprh_1_gauche_ROM			equ	#C000
blinky_sprh_1_droite_ROM			equ	#e000
blinky_sprh_1_saut_gauche_ROM		equ	#D400
blinky_sprh_1_saut_droite_ROM		equ	#f400

blinky_sprh_eau_gauche_ROM			equ #C000
blinky_sprh_eau_droite_ROM			equ #E000


; Blinky animations
nbr_d_animations_blinky				equ	6
nbr_d_animations_blinky_saut		equ	3
vitesse_animation_blinky_cfg		equ 3
vitesse_animation_blinky_saute_cfg	equ 4
vitesse_anim_blinky_meurt_cfg		equ	30

; Blinky deplacements
vitesse_X_deplacement_blinky		equ 3
vitesse_Y_deplacement_blinky		equ 2	
vitesse_chute_de_blinky				equ 4
vitesse_saut_blinky					equ 8
config_gravite_saut					equ	1
vitesse_X_saut_blinky				equ	8

on_bouge_pas					equ	0
on_tombe						equ	1
on_saute						equ 2
va_a_gauche						equ	3
va_a_droite						equ	4
pos_Y_blinky_bas_chateau				equ	#0070
pos_Y_blinky_haut_chateau				equ	#0008
pos_Y_blinky_bas_eau					equ	#007F
pos_Y_blinky_haut_eau					equ	#0008
blinky_sort_ecran_bas					equ	#008A
blinky_sort_ecran_bas_eau				equ	#0080

; Collisions décors Blinky
distance_pied_sol				equ 30		; 30 sur 16 avec le sprite 2 et 3
distance_gauche_mur				equ 18		; 18 sur 32 avec le sprite 2
distance_droite_mur				equ 40		; 40 sur 64 avec le sprite 2

; //////////////////////////////////////////////////////////////////
; /////////////////////    GESTION DES ITEMS  /////////////////////
; //////////////////////////////////////////////////////////////////
; les items du hud en mode 1
ITEMS_DU_HUD				equ		#C000
EXTINCTEUR_HUD				equ		ITEMS_DU_HUD
SANDWICH_HUD				equ		ITEMS_DU_HUD+#90
LAMPE_TORCHE_HUD			equ		ITEMS_DU_HUD+#120
GLOBE_OCULAIRE_HUD			equ		ITEMS_DU_HUD+#1B0
BALLON_HUD					equ		ITEMS_DU_HUD+#240
BONBON_HUD					equ		ITEMS_DU_HUD+#2D0
CONFITURE_HUD				equ		ITEMS_DU_HUD+#360
PELUCHE_HUD					equ		ITEMS_DU_HUD+#3F0
FIOLE_HUD					equ		ITEMS_DU_HUD+#480
REVEIL_HUD					equ		ITEMS_DU_HUD+#510
SAC_DE_BLE_HUD				equ		ITEMS_DU_HUD+#5A0
PQ_HUD						equ		ITEMS_DU_HUD+#630
GAZ_HUD						equ		ITEMS_DU_HUD+#6C0
CASSETTE_HUD				equ		ITEMS_DU_HUD+#750
VERRE_DE_SODA_HUD			equ		ITEMS_DU_HUD+#7E0
POISSON_HUD					equ		ITEMS_DU_HUD+#870
BAGUE_HUD					equ		ITEMS_DU_HUD+#900
CLE_HUD						equ		ITEMS_DU_HUD+#B40
TREFLE_HUD					equ		ITEMS_DU_HUD+#A20
LIVRE_HUD					equ		ITEMS_DU_HUD+#ab0
DILDO_HUD					equ		ITEMS_DU_HUD+#990
RADIO_HUD					equ		ITEMS_DU_HUD+#BD0
RIEN_HUD					equ		ITEMS_DU_HUD+#1560


; emplacement des items dans le hud
Emplacement1_adr	equ #C6EA
Emplacement2_adr	equ #C6F4	
Emplacement3_adr	equ #C6FE

; adresse en ROM des items in game
ITEMS1			equ	#C000
PAPIER_CUL		equ	ITEMS1
VERRE_DE_SODA	equ	ITEMS1+#400
CASSETTE		equ	ITEMS1+#800
PARCHEMIN		equ	ITEMS1+#C00
LAMPE_TORCHE	equ	ITEMS1+#1000
POT_DE_CONFITURE	equ	ITEMS1+#1400
ELIXIR_VERT			equ	ITEMS1+#1800
ELIXIR_BLEU			equ	ITEMS1+#1A00
SAC_DE_BLE			equ	ITEMS1+#1C00
POISSON				equ	ITEMS1+#2000
OEIL				equ	ITEMS1+#2400
BONBON				equ ITEMS1+#2600
PELUCHE				equ	ITEMS1+#2800
BALLON				equ	ITEMS1+#2C00
SANDWICH			equ	ITEMS1+#3000
EXTINCTEUR			equ	ITEMS1+#3400
GAZ					equ	ITEMS1+#3800
REVEIL				equ	ITEMS1+#3C00
RIEN_SPRH			equ #FC00


ITEMS2			equ	#C000
BAGUE			equ	ITEMS2
DILDO			EQU	ITEMS2+#400
CLE				equ	ITEMS2+#600
LIVRE			equ	ITEMS2+#800
TREFLE			equ	ITEMS2+#c00
RADIO			equ	ITEMS2+#1000

; //////////////////////////////////////////////////////////////////
; /////////////////////    GESTION DES ENNEMIS  /////////////////////
; //////////////////////////////////////////////////////////////////
SOURIS_GRISE	equ		#C000
ESCARGOT_VERT	equ		#c400
ESCARGOT_ROUGE	equ		#CC00
ARAIGNEE_BLEUE	equ		#D400
CHAUVE_ROUGE	equ		#E000
CHAUVE_VERT		equ		#F400
PIERRE			equ		#DC00
GRENOUILLE_VERTE	equ	#EC00
GRENOUILLE_ROUGE	equ	#EC00
ABEILLE_JAUNE		equ		#C000
ABEILLE_GRISE		equ		#C000
POISSON_ROUGE		equ		#F000
POISSON_VERT		equ		#E000




tableau_ennemy_ROM				equ	#c000
souris_sprh_droite_ROM			equ	#C000
souris_sprh_gauche_ROM			equ	#C200
vitesse_X_deplacement_souris	equ	4
Tableau_items_piece				equ	#4000



ennemis_souris 			equ	#1
ennemis_escargot_vert	equ	#2
ennemis_escargot_rouge	equ	#21
ennemis_araignee_bleu	equ	#3
ennemis_araignee_jaune	equ	#31
ennemis_chauve_rouge		equ	#4
ennemis_chauve_vert			equ	#41
ennemis_grenouille_verte	equ	#5
ennemis_grenouille_rouge	equ	#51
ennemis_abeille_jaune		equ	#6
ennemis_abeille_grise		equ	#61
ennemis_poisson_vert		equ	#7
ennemis_poisson_rouge		equ	#71



; ________________________________________
;                SPRITE HARD ASIC
; ________________________________________
; ////////////////////////////////////////////////   Adresses  //////////////////////////////////////
SPRH0_ADR		EQU	#4000:SPRH1_ADR		EQU	#4100:SPRH2_ADR		EQU	#4200
SPRH3_ADR		EQU	#4300:SPRH4_ADR		EQU	#4400:SPRH5_ADR		EQU	#4500
SPRH6_ADR		EQU	#4600:SPRH7_ADR		EQU	#4700:SPRH8_ADR		EQU	#4800
SPRH9_ADR		EQU	#4900:SPRH10_ADR		EQU	#4A00:SPRH11_ADR		EQU	#4B00
SPRH12_ADR		EQU	#4C00:SPRH13_ADR		EQU	#4D00:SPRH14_ADR		EQU	#4E00
SPRH15_ADR		EQU	#4F00
; ////////////////////////////////////////////////   Zoom  /////////////////////////////////////////
SPRH0_ZOOM		EQU	#6004:SPRH1_ZOOM		EQU	#600c
SPRH2_ZOOM		EQU	#6014:SPRH3_ZOOM		EQU	#601c
SPRH4_ZOOM		EQU	#6024:SPRH5_ZOOM		EQU	#602c
SPRH6_ZOOM		EQU	#6034:SPRH7_ZOOM		EQU	#603c
SPRH8_ZOOM		EQU	#6044:SPRH9_ZOOM		EQU	#604c
SPRH10_ZOOM		EQU	#6054:SPRH11_ZOOM		EQU	#605c
SPRH12_ZOOM		EQU	#6064:SPRH13_ZOOM		EQU	#606c
SPRH14_ZOOM		EQU	#6074:SPRH15_ZOOM		EQU	#607c

ZOOM_mode_1		equ	#09
ZOOM_mode_0		equ	13

; ////////////////////////////////////////////   Coordonnées  /////////////////////////////////////////
SPRH0_X			EQU	#6000:SPRH0_Y			EQU	#6002
SPRH1_X			EQU	#6008:SPRH1_Y			EQU	#600A
SPRH2_X			EQU	#6010:SPRH2_Y			EQU	#6012
SPRH3_X			EQU	#6018:SPRH3_Y			EQU	#601A
SPRH4_X			EQU	#6020:SPRH4_Y			EQU	#6022
SPRH5_X			EQU	#6028:SPRH5_Y			EQU	#602A
SPRH6_X			EQU	#6030:SPRH6_Y			EQU	#6032
SPRH7_X			EQU	#6038:SPRH7_Y			EQU	#603A
SPRH8_X			EQU	#6040:SPRH8_Y			EQU	#6042
SPRH9_X			EQU	#6048:SPRH9_Y			EQU	#604A
SPRH10_X		EQU	#6050:SPRH10_Y			EQU	#6052
SPRH11_X		EQU	#6058:SPRH11_Y			EQU	#605A
SPRH12_X		EQU	#6060:SPRH12_Y			EQU	#6062
SPRH13_X		EQU	#6068:SPRH13_Y			EQU	#606A
SPRH14_X		EQU	#6070:SPRH14_Y			EQU	#6072
SPRH15_X		EQU	#6078:SPRH15_Y			EQU	#607A
SPRH0_X_Y_ZOOM	EQU	#6000:SPRH1_X_Y_ZOOM	EQU	#6008
SPRH5_X_Y_ZOOM	EQU	#6028:SPRH6_X_Y_ZOOM	EQU	#6030
SPRH7_X_Y_ZOOM	EQU	#6038:SPRH8_X_Y_ZOOM	EQU	#6040
SPRH9_X_Y_ZOOM	EQU	#6048:SPRH10_X_Y_ZOOM	EQU	#6050
SPRH11_X_Y_ZOOM	EQU	#6058:SPRH12_X_Y_ZOOM	EQU	#6060

