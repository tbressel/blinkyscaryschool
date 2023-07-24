; -------------> NOTES PERSO
; rasm creation_cartouche.asm  -sw
; -sw  exporte les label
; -sq exporte les equ
; -sa  exporte TOUT !


; ////////////////////////////////////////////////////////////////////////////
; ////////////////////////////////////////////////////////////////////////////
; ////////////////////////////////////////////////////////////////////////////
; ////////////////////////////////////////////////////////////////////////////
; ////////////////////////////////////////////////////////////////////////////
; ////////////////////////////////////////////////////////////////////////////

; Ce fichier sert simplement à créer un fichier CPR

; ////////////////////////////////////////////////////////////////////////////
; ////////////////////////////////////////////////////////////////////////////
; ////////////////////////////////////////////////////////////////////////////
; ////////////////////////////////////////////////////////////////////////////
; ////////////////////////////////////////////////////////////////////////////
; ////////////////////////////////////////////////////////////////////////////
; ////////////////////////////////////////////////////////////////////////////


	

ON  EQU 1
OFF EQU 0

macro Bankon
	ld		a,e
	ld 		bc,#DF80
	add		a,c
	ld		c,a	
	out (c),c						; sélèction de la ROM 28
	ld		a,l
	ld		bc,#7f00
	add		a,c
	ld		c,a	
	out (c),c											; on écrit dans la RAM C3 (de #C000 à #Ffff)
	ld		bc,#7f00+%10000000:out (c),c				; connexion ROM haute et basse
mend

macro Asic switch
	if {switch}
	ld 		bc,#7FB8
	out 	(c),c
	else
	ld 		bc,#7FA0
	out 	(c),c
	endif
mend


buildcpr    ; indique que l'on veut construire une cartouche
bank 0      ; initialisation commence toujours en BANK 0
org 0       ; le tout premier code commence toujours à l'adresse 0
di          ; on désactive les INT au cas ou on reset soft
Asic OFF    ; dans le cas où l'on reboot le soft avec l'Asic ON
jr rom_init ; saut par dessus les interruptions et certaines données

; séquence pour délocker l'ASIC
unlockdata defb #ff,#00,#ff,#77,#b3,#51,#a8,#d4,#62,#39,#9c,#46,#2b,#15,#8a,#cd,#ee
; valeurs pour tous les registres du CRTC (pour avoir un ecran standard avec border)
crtcdata   defb 63,40,46,#8e,38,0,25,30,00,07,00,00,#20,00,00,00

; au cas où nous aurions besoin d'une interruption à l'initialisation, on doit interrompre le vecteur à #38
	org 	#38
;ei
	;ret

jp	interruption_automodif

;****************** ROM INIT ***************

rom_init

;********************* MANDATORY TO EXECUTE WITH A C4CPC ***************
	im 		1 					; don't know why but C4CPC corrupt interruption mode!
;***
	ld 		bc,#7FC0 			; default memory conf
	out 	(c),c
	ld 		sp,0     			; raz 64K with stack
	ld 		bc,4
	ld 		hl,0
	.raz
	repeat 	32
	push 	hl
	rend
	djnz .raz
	dec 	c
	jr 		nz,.raz
;**************************** END OF MANDATORY CODE ********************


;; unlock ASIC so we can access ASIC registers (Kevin Thacker)
AsicUnlock
	ld 		b,#bc
	ld 		hl,unlockdata
	ld 		e,17
	.loop
	inc 	b
	outi
	dec 	e
	jr 		nz,.loop

CrtcSettings
ld 			c,0
ld 			e,16
.loop
out 		(c),c
ld 			a,(hl)
inc 		hl
inc 		b
out 		(c),a
dec 		b
inc 		c
dec 		e
jr 			nz,.loop


; R12 selectionne et Ecran en #c000
LD BC,#BC0C:OUT (C),C
LD BC,#BD00+%00110000:OUT (C),C


Asic On

; all colors to black and sprites disabled (DO NOT USE LDIR with a real CPC except if you like the red color ;)
AsicRazParam
	ld 		hl,#6000
	ld 		hl,#6400
	ld 		b,128
	xor 	a
.loop
	ld 		(hl),a
	ld 		(de),a
	inc 	l
	inc 	e
	djnz 	.loop

; init du PPI

ld bc,#f782                     ; setup initial PPI port directions
out (c),c
ld bc,#f400                     ; set initial PPI port A (AY)
out (c),c
ld b,#f6                        ; set initial PPI port C (AY direction)
out (c),c
ld bc,#EF7F                     ; firmware printer init d0->d6=1
out (c),c

; initialisation de la pile !!!
 ld	sp,#BFFE

asic off
; //////////////////////////////////////////////////////////////////
; //////////////////////////////////////////////////////////////////
; ////////////////////         FIN INIT  CPR       /////////////////
; //////////////////////////////////////////////////////////////////
; //////////////////////////////////////////////////////////////////
ld	hl,interruption_main0
ld	(adr_interruption),hl
; //////////////////////////////////////////////////////////////////
; //////////////////////////////////////////////////////////////////
; ////////////////      MISE A ZERO DE LA RAM    ///////////////////
; //////////////////////////////////////////////////////////////////
; //////////////////////////////////////////////////////////////////
Mise_a_zero_RAM
; mise à zéros de la bank #4000-#BFFF
	xor		a
	ld		hl,#4000
	ld		e,l
	ld		d,h
	inc		de
	ld		(hl),a
	ld		bc,#3ffd
	LDIR
; //////////////////////////////////////////////////////////////////
; //////////////////////////////////////////////////////////////////
; ///////////     INITIALISATION SCREENS D'INTRO      //////////////
; //////////////////////////////////////////////////////////////////
; //////////////////////////////////////////////////////////////////
	; palette du screen d'intro
	ASIC ON
	ld		e,Bank_palette_intro
	ld		l,Ram_C0
	Bankon
	ld		hl,adr_palette_screen_bank					; emplacement départ des données de la palette 
	ld		de,adr_palette_ASIC							; emplacement en RAM centrale où copier les données de la palette
	ld		bc,#20										; longueur des données de la palette
	LDIR
	; screen d'intro
	ld		e,Bank_screen_intro
	ld		l,Ram_C0
	Bankon
	ld		hl,adr_screen_bank									; emplacement départ des données de la palette 
	ld		de,adr_screen_ecran									; emplacement en RAM centrale où copier les données de la palette
	ld		bc,#4000									; longueur des données de la palette
	LDIR
	; screen d'intro 2
	ASIC OFF
	ld		e,Bank_screen_intro_2
	ld		l,Ram_C0
	Bankon
	ld		hl,adr_screen_2_bank									; emplacement départ des données de la palette 
	ld		de,adr_screen_2_ecran									; emplacement en RAM centrale où copier les données de la palette
	ld		bc,#4000									; longueur des données de la palette
	LDIR
	; musique
	player en ram
	ld		e,Bank_player_intro
	ld		l,Ram_C0
	Bankon
	ld		hl,adr_player_bank									; emplacement départ des données de la palette 
	ld		de,adr_player_RAM									; emplacement en RAM centrale où copier les données de la palette
	ld		bc,#1000								; longueur des données de la palette
	LDIR

	ld 		hl,Music         ; Initialisation
    xor 	a               ; Subsong #0.
    call 	PLY_AKG_Init
	ld		hl,#FFFF
	ld		(timer_switch),hl
	EI
; //////////////////////////////////////////////////////////////////
; //////////////////////////////////////////////////////////////////
; ////////////////////        SCREEN INTRO      ////////////////////
; //////////////////////////////////////////////////////////////////
; //////////////////////////////////////////////////////////////////
boucle_screen
	LD      B,#F5
frame_intro
	IN      A,(C)
	RRA
	JR 		NC,frame_intro

	call	routine_clavier
	BIT		4,A
	JP 		Z,start_menu
;	on switch les ecrans
	ld		hl,(timer_switch)
	dec		hl
	ld		(timer_switch),hl
	ld		de,1
	sbc		hl,de
	or		a
	ld		a,h
	cp		a,#FE
	call	z,flip_screen
	jp boucle_screen



flip_screen
	ld		hl,#FFFF
	ld		(timer_switch),hl
	ld		a,(flag_switch)
	cp		a,#40
	jp		z,mettre_ecran_en_C000
	cp		a,#C0
	jp		z,mettre_ecran_en_4000
mettre_ecran_en_4000
; palette du screen d'intro 2
	ld	a,#40
	ld	(flag_switch),a
	ASIC ON
	ld		e,Bank_palette_intro_2
	ld		l,Ram_C0
	Bankon
	ld		hl,adr_palette_screen_2_bank					; emplacement départ des données de la palette 
	ld		de,adr_palette_ASIC							; emplacement en RAM centrale où copier les données de la palette
	ld		bc,#20										; longueur des données de la palette
	LDIR
	ASIC OFF
	ld		bc,#7f00+%10000001:out (c),c				; mode 1
	LD 		BC,#BC0C:OUT (C),C      				;R12 selectionne
	LD 		BC,#BD10:OUT (C),C 						;Ecran en #4000
	ret

mettre_ecran_en_C000
; palette du screen d'intro 2
	ld	a,#C0
	ld	(flag_switch),a
	ASIC ON
	ld		e,Bank_palette_intro
	ld		l,Ram_C0
	Bankon
	ld		hl,adr_palette_screen_bank					; emplacement départ des données de la palette 
	ld		de,adr_palette_ASIC							; emplacement en RAM centrale où copier les données de la palette
	ld		bc,#20										; longueur des données de la palette
	LDIR
	ld		bc,#7f00+%10000000:out (c),c		
	LD 		BC,#BC0C:OUT (C),C      			; R12 selectionne
	LD 		BC,#BD30:OUT (C),C 					; Ecran en #c000
	ret

routine_clavier
	LD		BC,#F40E:OUT (C),c
	LD		BC,#F6C0:OUT (C),C
	LD		BC,#F600:OUT (C),C
	LD		BC,#F792:OUT (C),C
	LD		BC,#F649:OUT (C),C
	LD		B,#F4:IN A,(C)
	LD		BC,#F782:OUT (C),C
	LD		BC,#F600:OUT (C),C
	RET

PLY_AKG_HARDWARE_cpc = 1 



; //////////////////////////////////////////////////////////////////
; //////////////////////////////////////////////////////////////////
; ////////////////////////  INITIALISATION  MENU  //////////////////
; //////////////////////////////////////////////////////////////////
; //////////////////////////////////////////////////////////////////
start_menu
DI
ld	a,1
ld	(no_inter),a
ld	hl,interruption_main
ld	(adr_interruption),hl



	ld		bc,#7f00+%10000000:out (c),c		
	LD 		BC,#BC0C:OUT (C),C      			; R12 selectionne
	LD 		BC,#BD30:OUT (C),C 					; Ecran en #c000
; on place les palettes dans la RAM
	ld		e,Bank_palette_intro_3
	ld		l,Ram_C0
	Bankon
	ld		hl,adr_palette_screen_3_bank						; emplacement départ des données de la palette 
	ld		de,adr_palette_screen_3_RAM							; emplacement en RAM centrale où copier les données de la palette
	ld		bc,68										; longueur des données de la palette
	LDIR
; screen d'intro 3
	ld		e,Bank_screen_intro_3
	ld		l,Ram_C0
	Bankon
	ld		hl,adr_screen_3_ecran						; emplacement départ des données de la palette 
	ld		de,adr_screen_3_ecran						; emplacement en RAM centrale où copier les données de la palette
	ld		bc,#4000									; longueur des données de la palette
	LDIR
; palette sprite hard 
	ld		e,21
	ld		l,Ram_C0
	Bankon
	ASIC ON
	ld		hl,#C200										; emplacement départ des données de la palette 
	ld		de,adr_palette_sprh_ASIC										; emplacement de la palette dans l'ASIC
	ld		bc,#20											; longueur de la pellette à copier dans l'ASIC
	LDIR													; on copie
; drapeaux sprite hard 
	ld		e,25
	ld		l,Ram_C0
	Bankon
	ld		hl,#C000										; emplacement départ des données de la palette 
	ld		de,#4000										; emplacement de la palette dans l'ASIC
	ld		bc,#C00											; longueur de la pellette à copier dans l'ASIC
	LDIR													; on copie
	
; on affiche les zoom des drapeaux
	ld	a,#09
	ld	(#6004),a
	ld	(#600C),a
	ld	(#6014),a
	ld	(#601C),a
	ld	(#6024),a
	ld	(#602C),a
	ld	(#6034),a
	ld	(#603C),a
	ld	(#6044),a
	ld	(#604C),a
	ld	(#6054),a
	ld	(#605C),a
; on place les drapeaux	
ld	hl,departX_en+1		
ld	(#6000),hl			; sprite 0 X
ld	(#6010),hl			; sprite 2 X
ld	de,32
add	hl,de
ld	(#6008),hl			; sprite 1 X
ld	(#6018),hl			; sprite 3 X
ld	hl,departY_en+1
ld	(#6002),hl			; sprite 0 Y
ld	(#600A),hl			; sprite 1 Y
ld	de,16
add hl,de
ld	(#6012),hl			; sprite 2 Y
ld	(#601A),hl			; sprite 3 Y

ld	hl,departX_fr+1		
ld	(#6020),hl			; sprite 4 X
ld	(#6030),hl			; sprite 6 X
ld	de,32
add	hl,de
ld	(#6028),hl			; sprite 5 X
ld	(#6038),hl			; sprite 7 X

ld	hl,departY_fr+1
ld	(#6022),hl			; sprite 4 Y
ld	(#602A),hl			; sprite 5 Y

ld	de,16
add hl,de
ld	(#6032),hl			; sprite 6 Y
ld	(#603A),hl			; sprite 7 Y


ld	hl,departX_fr		
ld	(#6040),hl			; sprite 8 X
ld	(#6050),hl			; sprite 10 X
ld	de,32
add	hl,de
ld	(#6048),hl			; sprite 9 X
ld	(#6058),hl			; sprite 11 X
ld	hl,departY_fr
ld	(#6042),hl			; sprite 8 Y
ld	(#604A),hl			; sprite 9 Y
ld	de,16
add hl,de
ld	(#6052),hl			; sprite 10 Y
ld	(#605A),hl			; sprite 11 Y
EI
; //////////////////////////////////////////////////////////////////
; //////////////////////////////////////////////////////////////////
; ////////////////////////    MENU  ////////////////////////////////
; //////////////////////////////////////////////////////////////////
; //////////////////////////////////////////////////////////////////
boucle_menu
	LD      B,#F5
frame_menu
	IN      A,(C)
	RRA
	JR 		NC,frame_menu

	call	routine_clavier
	BIT		5,A
	JP 		Z,start_game
	BIT		2,A
	JP 		Z,french
	BIT		3,A
	JP 		Z,english
	retour_choix
	jp boucle_menu
	
pallette_asic_zero
dw 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

; //////////////////////////////////////////////////////////////////
; //////////////////////////////////////////////////////////////////
; /////////////        COPIE DES PALLETTES EN RAM      /////////////
; //////////////////////////////////////////////////////////////////
; //////////////////////////////////////////////////////////////////
start_game
	; pallette des sprites hard
	di
call 	PLY_AKG_Stop
call	extinction_des_couleurs	



	; palette des décors
	ld 		bc,#DF04+#80:out (c),c						; sélèction de la ROM 4 (#DF0A)
	ld		bc,#7fC0:out (c),c							; on écrit dans la RAM C0 (de #0000 à #3fff)
	ld		bc,#7f00+%10000000:out (c),c				; connexion ROM haute et basse
	ld		hl,#F300									; emplacement départ des données de la palette 
	ld		de,#0040									; emplacement en RAM centrale où copier les données de la palette
	ld		bc,#60										; longueur des données de la palette
	LDIR
	; palette du parchemin
	ld		hl,#f3DE
	ld		de,#0000
	ld		bc,#20
	LDIR
	; pallette des sprites hard
	ASIC ON
	
	ld		a,0
	ld	(#6004),a
	ld	(#600C),a
	ld	(#6014),a
	ld	(#601C),a
	ld	(#6024),a
	ld	(#602C),a
	ld	(#6034),a
	ld	(#603C),a
	ld	(#6044),a
	ld	(#604C),a
	ld	(#6054),a
	ld	(#605C),a
	
	
	
	ld		hl,#F340										; emplacement départ des données de la palette 
	ld		de,adr_palette_sprh_ASIC										; emplacement de la palette dans l'ASIC
	ld		bc,#1D											; longueur de la pellette à copier dans l'ASIC
	LDIR													; on copie
	ASIC OFF
	
	
	
	
	
	
; //////////////////////////////////////////////////////////////////
; //////////////////////////////////////////////////////////////////
; /////////////        COPIE PROGRAMME 2 en #4000     //////////////
; //////////////////////////////////////////////////////////////////
; //////////////////////////////////////////////////////////////////
ld 		bc,#DF02+#80:out (c),c						; sélèction de la ROM 2 (#DF0A)
ld		bc,#7fC0:out (c),c							; on écrit dans la RAM C0 (de #0000 à #3fff)
ld		bc,#7f00+%10000000:out (c),c				; connexion ROM haute et basse
ld		hl,#C000
ld		de,#4000
ld		bc,#3FFE
LDIR


; //////////////////////////////////////////////////////////////////
; //////////////////////////////////////////////////////////////////
; /////////////////    COPIE DU PROGRAMME 1 en #8000  //////////////
; //////////////////////////////////////////////////////////////////
; //////////////////////////////////////////////////////////////////
	ld 		bc,#DF01+#80:out (c),c						; sélèction de la ROM 01 (#DF01)
	ld		bc,#7fC0:out (c),c							; on écrit dans la RAM C0 (de #0000 à #3fff)
	ld		bc,#7f00+%10000000:out (c),c				; connexion ROM haute et basse
	ld		hl,#c000									; emplcaement du programme en ROM
	ld		de,#8000									; emplacement du programme en RAM centrale 
	ld		bc,#4000									; longueur du programme
	LDIR												; on copie

	JP		#8000										; go ahead and JUMP !


Music



        ; La configuration n'est pas obligatoire, mais elle permet
        ; de réduire la taille du binaire produit (ici 1.6K au lieu de 1.8K)
        ;include"musique_playerconfig.asm"
		include"musique/musique_intro_playerconfig.asm"
        ; Soundtrack exporté
        ;include"musique2.asm" 
		include"musique/musique_intro.asm" 
		
read"constantes_cartouche.asm"
read"interruptions_cartouche.asm"


extinction_des_couleurs	
ASIC ON
		ld		hl,#6400			; l'emplacement de ma pallette dans l'ASIC
		ld		b,#30				; la longueur d'une pallette
fade_out_RVB_boucle_general
		push	bc
		LD      B,#F5
framervb  	
	IN      A,(C)
	RRA
	JR 		NC,framervb
		call	fade_out_RVB_de_chaque_encre
		call temporisation_du_du_fondu
		pop		bc
		djnz	fade_out_RVB_boucle_general
		RET

fade_out_RVB_de_chaque_encre	
		ld		hl,#6400			; l'emplacement de ma pallette dans l'ASIC
		ld		b,#20				; la longueur d'une pallette
fade_out_RVB_boucle
		push	bc
	fade_out_du_rouge	
		ld		a,(hl)				; on met dans a, la valeur du rouge et bleu
		AND %11110000
		or		a
		jr		z,fade_out_du_bleu
		ld		b,16				; tout les 16, les bits 4 à 7 décremente de 1
		sub		a,b					; on a diminué de rouge
		ld		(hl),a			; on renvoye dans la pelette la valeur modifiée
	fade_out_du_bleu
		ld		a,(hl)				; on met dans a, la valeur du rouge et bleu
		AND %00001111
		or		a
		jr		z,fade_out_du_vert
		dec		a					; les bits 0 à 3 décremente de 1  on a diminué le bleu
		ld		(hl),a			; on renvoye dans la pelette la valeur modifiée
	fade_out_du_vert	
		inc		hl					; on se positionne sur l'adresse de l'octet pour le vert
		ld		a,(hl)				; on met dans a, la valeur du vert
		or		a
		jr		z,encre_suivante
		dec		a					; les bits 0 à 3 décremente de 1 on a diminué le vert
		ld		(hl),a			; on renvoye dans la pelette la valeur modifiée
	encre_suivante
		inc		hl
		pop		bc
djnz fade_out_RVB_boucle
RET
temporisation_du_du_fondu
ld	b,255
boucle_tempo
push BC
NOP
pop BC
djnz boucle_tempo
ret



; ///////////////////////////////////////////////////////////////////////////////
; ///////////////////////////////////////////////////////////////////////////////
; //////////////// ENVOIE DES FICHIERS DANS LES ROMS ////////////////////////////
; ///////////////////////////////////////////////////////////////////////////////
; ///////////////////////////////////////////////////////////////////////////////

; /////////////////////////////////////////////
; /////////////////// CODE	///////////////////
; /////////////////////////////////////////////
bank 1
	include"programme.asm"									; le programme principal qui est copié en RAM en #8000
bank 2
ORG #4000												; programme en #4000 avec l'asic de déconnecté	
	include"programme_4000.asm"
bank 3
	include"Programme_ROM_bank3.asm"						; programme lu directement dans la ROM

; //////////////////////////////////////////////
; /////////////////// GFX & PALETTE	////////////
; //////////////////////////////////////////////
bank 4
ORG	#C000
	incbin"contenu_cartouche/gfx/itemset2.imp"							; commence en #C1DB largeur 6 et hauteur 24
	incbin"contenu_cartouche/gfx/fontmask.imp"							; 3 octets de large par 8 lignes de haut #E493
	incbin"contenu_cartouche/gfx/fontevie.imp"							; 3 octets de large par 9 ligne de heut en #F0c6
ORG	#F300
; la palette des décors
	DW #0000,#0666,#0888,#0361,#0230,#0BBB,#0592,#0FFF 
	DW #0004,#0DD0,#01D0,#0216,#0621,#0529,#0931,#07B8
; palette du hud
	DW #0000,#0666,#0FFF,#02F2,#0230,#0BBB,#0592,#0FFF 
	DW #0004,#0DD0,#01D0,#0216,#0621,#0529,#0931,#07B8
	incbin"contenu_cartouche/pallettes/pallette_sprh.kit"				; la palette des sprites hard #F340
	incbin"contenu_cartouche/pallettes/pallette_parchemin.kit"			; la pallette du parchemin #F360
ORG #F500
	incbin"contenu_cartouche/gfx/anim1.imp"								; bulle du chaudron 8x16. feu du chaudron  8x8. Tete de mort 8x16
	incbin"contenu_cartouche/gfx/anim2.imp"								; bougies 4x22
	incbin"contenu_cartouche/gfx/anim3.imp"								; eau 16x8
bank 5			
	incbin"contenu_cartouche/gfx/parchaut.imp"							; commence en #C000 largeur 50 hauteur 84
	incbin"contenu_cartouche/gfx/parcbas.imp"							; commence en #D481 largeur 50 hauteur 80
	incbin"contenu_cartouche/gfx/petitpar.imp"							; commence en #E794 largeur 33 hauteur 95


; //////////////////////////////////////////////
; //////////////////SPRITES HARD	////////////
; //////////////////////////////////////////////
bank 6					
	incbin"contenu_cartouche/sprites_hard/BLINKY.spr"
bank 7				
	incbin"contenu_cartouche/sprites_hard/ITEMS1.spr"
bank 8				
	incbin"contenu_cartouche/sprites_hard/ENNEMY.spr"
bank 9			
	incbin"contenu_cartouche/sprites_hard/ENNEMY2.spr"
bank 10				
	incbin"contenu_cartouche/sprites_hard/BLINKWAT.spr"

; //////////////////////////////////////////////
; //////////////////   DECORS      ////////////
; //////////////////////////////////////////////
bank 11			
	incbin"contenu_cartouche/gfx/tilset1.imp"							; tileset du décors statique : largeur : 4 octets. hauteur : 8				
bank 12
	incbin"contenu_cartouche/gfx/tileset2.imp"	
bank 13
	incbin"contenu_cartouche/map_tiles/decors.prg"						; Maptile 1 à 20 du décors statique
bank 14
	incbin"contenu_cartouche/map_tiles/decors2.prg"					; Maptile 21 à 41 du décors statique	
bank 15
	incbin"contenu_cartouche/map_tiles/decors3.prg"					; Maptile 42 à 62 du décors statique	
bank 16
	incbin"contenu_cartouche/map_tiles/decors4.prg"					; Maptile 63 à 83 du décors statique	

; /////////////////////////////////////////////
; /////////////////////////////////////////////	
; /////////////////////////////////////////////		
bank 17				
	incbin"contenu_cartouche/tables/table_ennemis.prg"
Bank 18
	incbin"contenu_cartouche/map_tiles/decors5.prg"					; Maptile 63 à 83 du décors statique	
Bank 19			
	incbin"contenu_cartouche/gfx/hudbdc.scr"						; 80 par 32
bank 20	
	ORG #8000
	include"PlayerAKG2.asm"
bank 21
	ORG	#C000
	incbin"contenu_cartouche/gfx/introduction/screen.kit"			
	incbin"contenu_cartouche/gfx/introduction/screen2.kit"
	ORG #C150
	palette_1				;#0VRB 
	dw		noir,#0009,#000A,#0008
	palette_2								; Haut de blinky
	dw		noir,#08F0,#07F0,#06F0			
	palette_3								; Bas de blinky
	dw		noir,#0BF0,#0AF0,#09F0
	palette_4								; haut de la lune
	dw		noir,blanc,#1111,#0CF0
	
	palette_5
	dw		noir,blanc,rouge,#1111			; fenetre rouge
	palette_6
	dw		noir,blanc,#2222,vert			; fenetre verte
	palette_7
	dw		noir,blanc,#3333,orange			; fenetre rouge
	
	palette_8
	dw		noir,blanc,#0F6F,#066F			; bas de porte et haut de texte
	palette_9
	dw		noir,#000F,#0F0F,vert			
	ORG #C200
	incbin"contenu_cartouche/pallettes/drapeaux.kit"
	incbin"contenu_cartouche/pallettes/fin.kit"
	incbin"contenu_cartouche/gfx/animdoor.imp"	

ORG #E000
	include"table_animation_du_decors.asm" 									; animation du décors

	
bank 22
	incbin"contenu_cartouche/gfx/introduction/screen.scr"
bank 23
	incbin"contenu_cartouche/gfx/introduction/screen2.scr"
bank 24
	incbin"contenu_cartouche/gfx/introduction/menu.scr"
bank 25
	incbin"contenu_cartouche/sprites_hard/DRAPEAUX.spr"
bank 26
	incbin"contenu_cartouche/sprites_hard/ITEMS2.spr"
bank 27
	incbin"contenu_cartouche/map_tiles/decors6.prg"						
bank 28
	incbin"contenu_cartouche/gfx/fin/fin.scr"
bank 29
	include"samplefin.asm"
bank 30
;org DMA_LIST_1
	include"sample.asm"
	include"sample2.asm"			;#D242
	include"sample3.asm"			;#E186
bank 31
;org	DMA_LIST_4
	include"sample4.asm"



