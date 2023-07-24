Ram_C0						equ		#C0

Bank_player_intro			equ		20

Bank_palette_intro			equ		21
Bank_screen_intro			equ		22
adr_screen_bank				equ		#c000
adr_screen_ecran			equ		#c000

Bank_palette_intro_2		equ		21
Bank_screen_intro_2			equ		23
adr_screen_2_bank			equ		#c000
adr_screen_2_ecran			equ		#4000

Bank_palette_intro_3		equ		21
Bank_screen_intro_3			equ		24
adr_screen_3_bank			equ		#c150
adr_screen_3_ecran			equ		#C000
adr_palette_screen_3_bank	equ		#c150

adr_player_RAM				equ		#8000
adr_player_bank				equ		#C000

adr_palette_screen_bank		equ		#c000
adr_palette_screen_2_bank	equ		#c0A0

adr_palette_ASIC			equ		#6400
adr_palette_sprh_ASIC		equ		#6422

; ///////////////////////////////////////////////////////////

noir	equ		#0000
blanc	equ		#0FFF
rouge	equ		#00F0
bleu	equ		#000B
vert	equ		#0B00
orange	equ		#0BF0
bleu_clair	equ	#0F6F


departX_fr	equ	86
departY_fr	equ	80

departX_en	equ	530
departY_en	equ	80
; ///////////////////////////////////////////////////////////

timer_switch				equ		#B000		; 2 octets
flag_switch					equ		#B002		; 1 octet
pallette_ligne_40			equ		#B003		; 2 octets
pallette_ligne_60			equ		#B005		; 2 octets
valeur_asic_cpr				equ		#B007		; 1 octet
rom_sectionnee_cpr			equ		#B008		; 2 octets
etat_de_la_rom_cpr			equ		#B00A		; 2 octets

no_inter					equ		#B00E		; 1 octet

adr_interruption			equ		#B00F		; 2 octets
adr_palette_screen_3_RAM	equ		#B011		

flag_langue						equ		#3FFF







french
ASIC OFF
ld	a,1
ld	(flag_langue),a
ASIC ON
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
jp	retour_choix

english
ASIC OFF
ld	a,2
ld	(flag_langue),a
ASIC ON
ld	hl,departX_en		
ld	(#6040),hl			; sprite 8 X
ld	(#6050),hl			; sprite 10 X
ld	de,32
add	hl,de
ld	(#6048),hl			; sprite 9 X
ld	(#6058),hl			; sprite 11 X
ld	hl,departY_en
ld	(#6042),hl			; sprite 8 Y
ld	(#604A),hl			; sprite 9 Y
ld	de,16
add hl,de
ld	(#6052),hl			; sprite 10 Y
ld	(#605A),hl			; sprite 11 Y
jp	retour_choix









	