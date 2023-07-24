; //////////////////////////////////////////////////////////////////
; //////////////////////////////////////////////////////////////////
; ////////////////////        INTERRUPTIONS      ///////////////////
; //////////////////////////////////////////////////////////////////
; //////////////////////////////////////////////////////////////////
int1		equ		255
int2		equ		22
int3		equ		38
int4		equ		86
int5		equ		94
int6		equ		109
int7		equ		118
int8		equ		142
int9		equ		150



interruption_main0
di
; sauvegarde des registres
	push af : push hl : push de
	push bc
; connexion ASIC
	ld		bc,#7F00+%10111000			 
	out 	(c),c
	
; envoie de la ligne dans le PRI
 	ld		a,250
	ld		(#6800),a
call 	PLY_AKG_Play
	 pop bc
	 pop de : pop hl : pop af	
	 ei
ret



interruption_automodif
ld		hl,(adr_interruption)
jp		(hl)

interruption_main
; sauvegarde des registres
	push af : push hl : push de
	push bc
ld	a,(no_inter)
cp		a,1
call		z,interruption_1
cp		a,2
call		z,interruption_2
cp		a,3
call		z,interruption_3
cp		a,4
call		z,interruption_4
cp		a,5
call		z,interruption_5
cp		a,6
call		z,interruption_6
cp		a,7
call		z,interruption_7
cp		a,8
call		z,interruption_8
cp		a,9
call		z,interruption_9

	 pop bc
	 pop de : pop hl : pop af	
	EI
	RET
	



interruption_1
; sauvegarde des registres
	inc		a
	ld		(no_inter),a
; connexion ASIC
	ld		bc,#7F00+%10111000			 
	out 	(c),c
; connexion MODE 1
	ld		bc,#7f00+%10000001
	out 	(c),c				; mode 1	
; envoie de la ligne dans le PRI
 	ld		a,int1
	ld		(#6800),a
; chargement palette du hud
	ld		hl,adr_palette_screen_3_RAM
	ld		de,#6400
	ldi:ldi:ldi:ldi:ldi:ldi:ldi:ldi
	call 	PLY_AKG_Play
	xor		a
	ret	
; //////////////////////////////////////////////////////////////////
; //////////////////////////////////////////////////////////////////
; //////////////////////////////////////////////////////////////////
; //////////////////////////////////////////////////////////////////
interruption_2
	inc		a
	ld		(no_inter),a
; sauvegarde des registres
	; push af : push hl : push de
	; push bc
	; push ix : push iy
; connexion ASIC
	ld	bc,#7FB8
	out (c),c
; envoie de la ligne dans le PRI
 	ld	a,int2
	ld	(#6800),a
	; ld	hl,interruption_3
	; ld	(adr_interruption),hl
; chargement palette du decors
	ld		hl,adr_palette_screen_3_RAM+8
	ld		de,#6400
	ldi:ldi:ldi:ldi:ldi:ldi:ldi:ldi
; récuperation des registres
	; pop iy : pop ix
	; pop bc
	; pop de : pop hl : pop af
	; ei
	xor		a
	ret	
; //////////////////////////////////////////////////////////////////
; //////////////////////////////////////////////////////////////////
; //////////////////////////////////////////////////////////////////
; //////////////////////////////////////////////////////////////////
interruption_3
inc		a
	ld		(no_inter),a
; sauvegarde des registres
	; push af : push hl : push de
	; push bc 
	; push ix : push iy
; connexion ASIC
	ld	bc,#7FB8:out (c),c
; envoie de la ligne dans le PRI
 	ld	a,int3
	ld	(#6800),a
	; ld	hl,interruption_4
	; ld	(adr_interruption),hl
; chargement palette du decors
	ld		hl,adr_palette_screen_3_RAM+16
	ld		de,#6400
	ldi:ldi:ldi:ldi:ldi:ldi:ldi:ldi
; récuperation des registres
	; pop iy : pop ix
	; pop bc
	; pop de : pop hl : pop af
	; ei
	xor		a
	ret		
; //////////////////////////////////////////////////////////////////
; //////////////////////////////////////////////////////////////////
; //////////////////////////////////////////////////////////////////
; //////////////////////////////////////////////////////////////////
interruption_4
inc		a
	ld		(no_inter),a
; sauvegarde des registres
	; push af : push hl : push de
	; push bc 
	; push ix : push iy
; connexion ASIC
	ld	bc,#7FB8:out (c),c
; envoie de la ligne dans le PRI
 	ld	a,int4
	ld	(#6800),a
	; ld	hl,interruption_5
	; ld	(adr_interruption),hl
; chargement palette du decors
	ld		hl,adr_palette_screen_3_RAM+24
	ld		de,#6400
	ldi:ldi:ldi:ldi:ldi:ldi:ldi:ldi
; récuperation des registres
	; pop iy : pop ix 
	; pop bc
	; pop de : pop hl : pop af
	; ei
	xor		a
	ret		
; //////////////////////////////////////////////////////////////////
; //////////////////////////////////////////////////////////////////
; //////////////////////////////////////////////////////////////////
; //////////////////////////////////////////////////////////////////
interruption_5
inc		a
	ld		(no_inter),a
; sauvegarde des registres
	; push af : push hl : push de
	; push bc
	; push ix : push iy
; connexion ASIC
	ld	bc,#7FB8:out (c),c
; envoie de la ligne dans le PRI
 	ld	a,int5
	ld	(#6800),a
	; ld	hl,interruption_6
	; ld	(adr_interruption),hl
; chargement palette du decors
	ld		hl,adr_palette_screen_3_RAM+32
	ld		de,#6400
	ldi:ldi:ldi:ldi:ldi:ldi:ldi:ldi
; récuperation des registres
	; pop iy : pop ix 
	; pop bc
	; pop de : pop hl : pop af
	; ei
	xor		a
	ret			
; //////////////////////////////////////////////////////////////////
; //////////////////////////////////////////////////////////////////
; //////////////////////////////////////////////////////////////////
; //////////////////////////////////////////////////////////////////
interruption_6
inc		a
	ld		(no_inter),a
; sauvegarde des registres
	; push af : push hl : push de
	; push bc 
	; push ix : push iy
; connexion ASIC
	ld	bc,#7FB8:out (c),c
; envoie de la ligne dans le PRI
 	ld	a,int6
	ld	(#6800),a
	; ld	hl,interruption_7
	; ld	(adr_interruption),hl
; chargement palette du decors
	ld		hl,adr_palette_screen_3_RAM+40
	ld		de,#6400
	ldi:ldi:ldi:ldi:ldi:ldi:ldi:ldi
; récuperation des registres
	; pop iy : pop ix 
	; pop bc
	; pop de : pop hl : pop af
	; ei
	xor		a
	ret	
; //////////////////////////////////////////////////////////////////
; //////////////////////////////////////////////////////////////////
; //////////////////////////////////////////////////////////////////
; //////////////////////////////////////////////////////////////////
interruption_7
; sauvegarde des registres
inc		a
	ld		(no_inter),a
	; push af : push hl : push de
	; push bc 
	; push ix : push iy
; connexion ASIC
	ld	bc,#7FB8:out (c),c
; envoie de la ligne dans le PRI
 	ld	a,int7
	ld	(#6800),a
	; ld	hl,interruption_8
	; ld	(adr_interruption),hl
; chargement palette du decors
	ld		hl,adr_palette_screen_3_RAM+48
	ld		de,#6400
	ldi:ldi:ldi:ldi:ldi:ldi:ldi:ldi
; récuperation des registres
	; pop iy : pop ix
	; pop bc
	; pop de : pop hl : pop af
	; ei
	xor		a
	ret			
; //////////////////////////////////////////////////////////////////
; //////////////////////////////////////////////////////////////////
; //////////////////////////////////////////////////////////////////
; //////////////////////////////////////////////////////////////////
interruption_8
inc		a
	ld		(no_inter),a
; connexion ASIC
	ld	bc,#7FB8:out (c),c
; envoie de la ligne dans le PRI
 	ld	a,int8
	ld	(#6800),a
; chargement palette du decors
	ld		hl,adr_palette_screen_3_RAM+56
	ld		de,#6400
	ldi:ldi:ldi:ldi:ldi:ldi:ldi:ldi
	xor		a
	ret			
; //////////////////////////////////////////////////////////////////
; //////////////////////////////////////////////////////////////////
; //////////////////////////////////////////////////////////////////
; //////////////////////////////////////////////////////////////////
interruption_9
	ld		a,1
	ld		(no_inter),a
; connexion ASIC
	ld	bc,#7FB8:out (c),c
; envoie de la ligne dans le PRI
 	ld	a,int9
	ld	(#6800),a
; chargement palette du decors
	ld		hl,adr_palette_screen_3_RAM+64
	ld		de,#6400
	ldi:ldi:ldi:ldi:ldi:ldi:ldi:ldi
	xor		a
	ret					
