;       Player of sound effects, for Lightweight the player, for the SHARP MZ 700.

;       No Player Configuration is managed for the sound effects, the sounds are so simple, all the code is required.

;Initializes the sound effects. It MUST be called at any times before a first sound effect is triggered.
;It doesn't matter whether the song is playing or not, or if it has been initialized or not.
;IN:    HL = Address to the sound effects data.
PLY_LW_InitSoundEffectsDisarkGenerateExternalLabel:
PLY_LW_InitSoundEffects:
        ld (PLY_LW_SE_PtSoundEffectTable + 1),hl
        ret


;Plays a sound effect. If a previous one was already playing on the same channel, it is replaced.
;This does not actually plays the sound effect, but programs its playing.
;The music player, when called, will call the PLY_LW_PlaySoundEffectsStream method below.
;IN:    A = Sound effect number (>0!).
PLY_LW_PlaySoundEffectDisarkGenerateExternalLabel:
PLY_LW_PlaySoundEffect:
        ;Gets the address to the sound effect.
        dec a                   ;The 0th is not encoded.
dknr3:
PLY_LW_SE_PtSoundEffectTable: ld hl,0
        ld e,a
        ld d,0
        add hl,de
        add hl,de
        ld e,(hl)
        inc hl
        ld d,(hl)
        ;Reads the header of the sound effect to get the speed.
        ld a,(de)
        inc de

        ;Stores the pointer to the sound effect.
        ld hl,PLY_LW_Channel1_SoundEffectData
        ld (hl),e
        inc hl
        ld (hl),d
        inc hl        
        
        ;Resets the current speed, stores the instrument speed.
        ld (hl),0
        inc hl
        ld (hl),a

        ret

;Stops a sound effect. Nothing happens if there was no sound effect.
PLY_LW_StopSoundEffectFromChannelDisarkGenerateExternalLabel:
PLY_LW_StopSoundEffectFromChannel:
        ;Puts 0 to the pointer of the sound effect.
        ld hl,PLY_LW_Channel1_SoundEffectData
        xor a
        ld (hl),a               ;0 means "no sound".
        inc hl
        ld (hl),a
        ret

;Plays the sound effects, if any has been triggered by the user.
;This does not actually send registers to the PSG, it only overwrite the required values of the registers of the player.
;The sound effects initialization method must have been called before!
;As R7 is required, this must be called after the music has been played, but BEFORE the registers are sent to the PSG.
;IN:    A = R7.
;OUT:   A = new R7.
PLY_LW_PlaySoundEffectsStream:
        ;Shifts the R7 to the left twice, so that bit 2 and 5 only can be set for each track, below.
        rla
	rla

        ;Plays the sound effects on every track.
        ld ix,PLY_LW_Channel1_SoundEffectData
        ld iy,PLY_LW_Track1_Registers
        ld c,a
        call PLY_LW_PSES_Play
        rr c
        rr c

        ld a,c
        and %111111
        ret


;Plays the sound stream from the given pointer to the sound effect. If 0, no sound is played.
;The given R7 is given shift twice to the left, so that this code MUST set/reset the bit 2 (sound), and maybe reset bit 5 (noise).
;This code MUST overwrite these bits because sound effects have priority over the music.
;IN:    IX = Points on the sound effect pointer. If the sound effect pointer is 0, nothing must be played.
;       IY = Points at the beginning of the register structure related to the channel.
;       C = R7, shifted twice to the left.
;OUT:   The pointed pointer by IX may be modified as the sound advances.
;       C = R7, MUST be modified if there is a sound effect.
PLY_LW_PSES_Play:
        ;Reads the pointer pointed by IX.
        ld l,(ix + 0)
        ld h,(ix + 1)
        ld a,l
        or h
        ret z           ;No sound to be played? Returns immediately.

        ;Reads the first byte. What type of sound is it?
PLY_LW_PSES_ReadFirstByte:
        ld a,(hl)
        inc hl
        ld b,a
        rra
        jr c,PLY_LW_PSES_SoftwareOrSoftwareAndHardware

        ;No software, no hardware, or end/loop.
        ;-------------------------------------------
        ;End or loop?
        rra
        jr c,PLY_LW_PSES_S_EndOrLoop

        ;Real sound.
        ;Gets the volume. --> Ignored on Sharp.

        ;Noise? --> Ignored on Sharp.

        jr PLY_LW_PSES_SavePointerAndExit


PLY_LW_PSES_S_EndOrLoop:
        ;Is it an end?
        rra
        jr c,PLY_LW_PSES_S_Loop
        ;End of the sound. Marks the sound pointer with 0, meaning "no sound".
        xor a
        ld (ix + 0),a
        ld (ix + 1),a
        ret
PLY_LW_PSES_S_Loop:
        ;Loops. Reads the pointer and directly uses it.
        ld a,(hl)
        inc hl
        ld h,(hl)
        ld l,a
        jr PLY_LW_PSES_ReadFirstByte


;Saves HL into IX, and exits. This must be called at the end of each Cell.
PLY_LW_PSES_SavePointerAndExit:
        ;Speed reached?
        ld a,(ix + PLY_LW_SoundEffectData_OffsetCurrentStep)
        cp (ix + PLY_LW_SoundEffectData_OffsetSpeed)
        jr c,PLY_LW_PSES_NotReached
        ;The speed has been reached, so resets it and saves the pointer to the next cell to read.
        ld (ix + PLY_LW_SoundEffectData_OffsetCurrentStep),0
        ld (ix + 0),l
        ld (ix + 1),h
        ret
PLY_LW_PSES_NotReached:
        ;Speed not reached. Increases it, that's all. The same cell will be read next time.
        inc (ix + PLY_LW_SoundEffectData_OffsetCurrentStep)
        ret


PLY_LW_PSES_SoftwareOrSoftwareAndHardware:
        ;Software only?
        ;rra
        ;jr c,PLY_LW_PSES_SoftwareAndHardware --> Not present on Sharp.

        ;Software.
        ;-------------------------------------------

        ;Volume. --> Ignored on Sharp.

        ;Noise? --> Ignored on Sharp.
        ;rl b

        ;Opens the "sound" channel.
        res 2,c

        ;Reads the software period from HL and sets the period registers thanks to IY. HL is incremented of 2.
        ld a,(hl)
        ld (iy + PLY_LW_Registers_OffsetSoftwarePeriodLSB),a
        inc hl
        ld a,(hl)
        ld (iy + PLY_LW_Registers_OffsetSoftwarePeriodMSB),a
        inc hl
        jr PLY_LW_PSES_SavePointerAndExit


;The data of the Track.
PLY_LW_Channel1_SoundEffectData:
dkws:
        dw 0                                            ;Points to the sound effect for the track 1, or 0 if not playing.
dkwe:
PLY_LW_Channel1_SoundEffectCurrentStep:
dkbs:
        db 0                                            ;Current step (>=0).
PLY_LW_Channel1_SoundEffectSpeed:
        db 0                                            ;Speed (>=0).
dkbe:

;Offset from the beginning of the data, to reach the inverted volume.
PLY_LW_SoundEffectData_OffsetCurrentStep: equ PLY_LW_Channel1_SoundEffectCurrentStep - PLY_LW_Channel1_SoundEffectData
PLY_LW_SoundEffectData_OffsetSpeed: equ PLY_LW_Channel1_SoundEffectSpeed - PLY_LW_Channel1_SoundEffectData



