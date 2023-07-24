        ;Tests the Lightweight player, for MSX.
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
        ld hl,Music
        xor a                                   ;Subsong 0.
        call PLY_LW_Init
        
MainLoop:
        xor a
        call #00d8      ;Checks the space bar. If pressed, stops the music.
        or a
        jp nz,PLY_LW_Stop
        
        ei
        halt
        
        ;Plays one frame of the music.
        call PLY_LW_Play
        
        jr MainLoop
        

Music:
        ;Include here the Player Configuration source of the songs (you can generate them with AT2 while exporting the songs).
        ;If you don't have any, the player will use a default Configuration (full code used), which may not be optimal.
        ;If you have several songs, include all their configuration here, their flags will stack up!
        ;Warning, this must be included BEFORE the player is compiled.
        include "../resources/MusicMolusk_playerconfig.asm"

        include "../resources/MusicMolusk.asm"

Player:
        ;Selects the hardware. Mandatory, as CPC is default.
        PLY_LW_HARDWARE_MSX = 1
        
        include "../PlayerLightweight.asm"
TesterEnd:
