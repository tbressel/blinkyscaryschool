        ;Tests the AKG player, for MSX.
        ;This compiles with RASM. Please check the compatibility page on the website, you can convert these sources to ANY assembler!
        
        ;A binary file (to load with the BLOAD MSX command) is generated.
        ;It can then be included inside a DSK file (using the DiskMgr software for example). Tested with the BlueMSX emulator.
        
        org #b000
        
        ;This is the header for a BINary file for MSX. See https://www.faq.msxnet.org/suffix.html
        db #fe
        dw TesterStart
        dw TesterEnd
        dw TesterStart          ;Execution address.
        
        
TesterStart:
        
        ;Initializes the music.
        ld hl,Music_Start
        xor a                                   ;Subsong 0.
        call PLY_AKG_Init
        
MainLoop:
        xor a
        call #00d8      ;Checks the space bar. If pressed, stops the music.
        or a
        jr nz,ExitProg
        
        ei
        nop
        halt
        
	;Plays one frame of the music.
        call PLY_AKG_Play
        
        jr MainLoop
        
ExitProg:        
        call PLY_AKG_Stop
        ret


Music_Start:
        ;Include here the Player Configuration source of the songs (you can generate them with AT2 while exporting the songs).
        ;If you don't have any, the player will use a default Configuration (full code used), which may not be optimal.
        ;If you have several songs, include all their configuration here, their flags will stack up!
        ;Warning, this must be included BEFORE the player is compiled.
        ;include "../resources/Music_AHarmlessGrenade_playerconfig.asm"
        
        include "../resources/Music_AHarmlessGrenade.asm"
Music_End:

Main_Player_Start:
        ;Selects the hardware. Mandatory, as CPC is default.
        PLY_AKG_HARDWARE_MSX = 1
        
        ;Want a ROM player (a player without automodification)?
        ;PLY_AKG_Rom = 1                         ;Must be set BEFORE the player is included.
        
        ;Declares the buffer for the ROM player, if you're using it. You can declare it anywhere of course.
        ;LIMITATION: the SIZE of the buffer (PLY_AKG_ROM_BufferSize) is only known *after* ther player is compiled.
        ;A bit annoying, but you can compile once, get the buffer size, and hardcode it to put the buffer wherever you want.
        ;Note that the size of the buffer shrinks when using the Player Configuration feature. Use the largest size and you'll be safe.
        IFDEF PLY_AKG_Rom
                PLY_AKG_ROM_Buffer = #f000                  ;Can be set anywhere.
        ENDIF

        include "../PlayerAkg.asm"
Main_Player_End:

TesterEnd: