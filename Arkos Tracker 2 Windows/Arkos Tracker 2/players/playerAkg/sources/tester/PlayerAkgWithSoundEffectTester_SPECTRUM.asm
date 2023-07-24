        ;Tests the AKG player, as well as the sound effects, for SPECTRUM.
        ;Note that the sound effects work on every platform of course!
        
        ;This tester was coded by Rob Pearmain, thanks a lot!
        ;The following demo plays a different FX every time you press ‘1’.
        
        ;This compiles with RASM. Please check the compatibility page on the website, you can convert these sources to ANY assembler!

	;Don't forget to set the PLY_AKG_MANAGE_SOUND_EFFECTS to 1 BEFORE the player is compiled (see at the bottom of the source).

		
        org #8000
Start:  equ $

        di

        ;Initializes the music.
        ld hl,Music_Start
        xor a                   ;Subsong 0.
        call PLY_AKG_Init

        ;Initializes the sound effects.
        ld hl,SoundEffects
        call PLY_AKG_InitSoundEffects

Sync:
        ei
        nop
        halt
        di

        ld bc,63486         ; keyboard row 1-5/joystick port 2.
        in a,(c)            ; see what keys are pressed.
        rra                 ; outermost bit = key 1.
        jr nc,playfx        ; if carry then no key pressed
        
        xor a
        ld (keypressed),a
        jr playmusic

playfx:
        ld a,(keypressed)
        and 255
        jr nz,playmusic

        ld a,(SelectedSoundEffect)
        inc a
        cp 6
        jr nz,playfx2
        ld a,1
playfx2:
        ld (SelectedSoundEffect),a
        ld c,1
        ld b,0          ;Full volume.
        call PLY_AKG_PlaySoundEffect
        ld a,1
        ld (keypressed),a

playmusic:      
        call PLY_AKG_Play
    
        jr Sync

SelectedSoundEffect: db 0                       ;The selected sound effect (>=1). The code increases the counter first, so setting 0 is fine.       
keypressed: db 0

Main_Player_Start:
        ;Selects the hardware. Mandatory, as Amstrad CPC is default.
        PLY_AKG_HARDWARE_SPECTRUM = 1
        
        ;IMPORTANT: enables the sound effects in the player. This must be declared BEFORE the player itself.
        PLY_AKG_MANAGE_SOUND_EFFECTS = 1
        
        ;Want a ROM player (a player without automodification)?
        ;PLY_AKG_Rom = 1                         ;Must be set BEFORE the player is included.
            
        ;Include here the Player Configuration source of the songs (you can generate them with AT2 while exporting the songs).
        ;If you don't have any, the player will use a default Configuration (full code used), which may not be optimal.
        ;If you have several songs, include all their configuration here, their flags will stack up!
        ;Warning, this must be included BEFORE the player is compiled.
        ;Warning, if you use player configuration, you must ALSO include the configuration file for the sound effects.
        ;include "../resources/Music_AHarmlessGrenade_playerconfig.asm"

        include "../PlayerAkg.asm"
        
        ;Declares the buffer for the ROM player, if you're using it. You can declare it anywhere of course.
        ;LIMITATION: the SIZE of the buffer (PLY_AKG_ROM_BufferSize) is only known *after* ther player is compiled.
        ;A bit annoying, but you can compile once, get the buffer size, and hardcode it to put the buffer wherever you want.
        ;Note that the size of the buffer shrinks when using the Player Configuration feature. Use the largest size and you'll be safe.
        IFDEF PLY_AKG_Rom
                PLY_AKG_ROM_Buffer = #c000
        ENDIF
        
Main_Player_End:

Music_Start:       
        include "../resources/Music_AHarmlessGrenade.asm"
        ;include "../resources/Music_Empty.asm"		;Useful to listen to the sound effects alone.
Music_End:

SoundEffects:
        include "../resources/SoundEffects.asm"