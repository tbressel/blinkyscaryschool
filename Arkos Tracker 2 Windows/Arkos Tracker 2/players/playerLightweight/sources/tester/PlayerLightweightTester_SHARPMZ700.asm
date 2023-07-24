        ;Tests the Lightweight player, for SHARP MZ 700.
        ;Compiled with RASM.
        ;Then use BIN2M12 from Z88DK (/support/mz folder) to convert it to M12, loadable in an emulator.
        
        ;A huge thanks to Vincent Cruz and "Le Glafouk" for their help.
        
        ;Watch out for the value of the #e005 register below, change it according to the frequency of the screen (50/60hz).

        org #1200
        
        ;Initializes the music.
        ld hl,Music
        xor a                                   ;Subsong 0.
        call PLY_LW_Init

        ld hl,CodeToCall
        ld (#1039),hl

	ld hl,#e007                             ;Counter 2.
	ld (hl),#b0
	dec hl
	ld (hl),1
	ld (hl),0

	ld hl,#e007                             ;100 Hz (plays the music at 50hz).
	ld (hl),#74
	ld hl,#e005
	ld (hl),156                             ;156 for 60Hz, 110 for 50hz.
	ld (hl),0

        ei
        
        jr $


CodeToCall:
        di
        push af
        push hl
        push bc
        push de
        push ix
        push iy
        
        ld hl,#e006
        ld a,1
        ld (hl),a
        xor a
        ld (hl),a
        
        call PLY_LW_Play        
        
        pop iy
        pop ix
        pop de
        pop bc
        pop hl
        pop af
        
        ei
        reti



Music:
        ;Include here the Player Configuration source of the songs (you can generate them with AT2 while exporting the songs).
        ;If you don't have any, the player will use a default Configuration (full code used), which may not be optimal.
        ;If you have several songs, include all their configuration here, their flags will stack up!
        ;Warning, this must be included BEFORE the player is compiled.
        include "../resources/MusicSharpMZ700_playerconfig.asm"

        include "../resources/MusicSharpMZ700.asm"

        
Player:
        ;IMPORTANT: enables the sound effects in the player. This must be declared BEFORE the player itself.
        ;PLY_LW_MANAGE_SOUND_EFFECTS = 1
        
        include "../PlayerLightweight_SHARPMZ700.asm"
