;       Stabilized AKY music player - V1.0, for Amstrad CPC.
;       By Julien N�vo a.k.a. Targhan/Arkos.
;       February 2018.

;       PSG sending optimization trick by Madram/Overlanders.
;       Some optimizations submitted by Hicks/Vanity (thanks!).

;       This version of the AKY player is "stabilized", which means that the CPU consumed by the player (on Amstrad CPC) is always the same. It is also slower,
;       since the worst-case branching is always taken in account. However, it is hugely convenient for demos or games with require cycle-accurate timings!
;       The "waiting" also makes the code bigger (and less readable).

;       The init code is not stabilized (is it a problem?).

;       This version does NOT manage sound effects.

;       Current cycles: 1174.

;       The player uses the stack for optimizations. Make sure the interruptions are disabled before it is called.
;       The stack pointer is saved at the beginning and restored at the end.

;       Possible optimizations:
;       Note that the Player Configuration optimizations has NOT been done for this player yet (please ask if you need it).
;       SIZE: The JP hooks at the beginning can be removed if you include this code in yours directly.
;       SIZE: If you don't play a song twice, all the code in PLY_AKYst_Init can be removed, except the first lines that skip the header.
;       SIZE: The header is only needed for players that want to load any song. Most of the time, you don't need it. Erase both the init code and the header bytes in the song.

PLY_AKYst_OPCODE_OR_A: equ #b7                        ;Opcode for "or a".
PLY_AKYst_OPCODE_SCF: equ #37                         ;Opcode for "scf".

;PLY_AKYst_NOP_Loop: equ 35                           ;How much is spent because of the looping.
;PLY_AKYst_NOP_LongestInState: equ 182                ;The longest CPU sent in an IS/NIS subcode.

        ;Disark macro: Word region Start.
        disarkCounter = 0
        IFNDEF dkws
        MACRO dkws
PLY_AKYst_DisarkWordRegionStart_{disarkCounter}
        ENDM
        ENDIF
        ;Disark macro: Word region End.
        IFNDEF dkwe
        MACRO dkwe
PLY_AKYst_DisarkWordRegionEnd_{disarkCounter}:
        disarkCounter = disarkCounter + 1
        ENDM
        ENDIF
        
        ;Disark macro: Pointer region Start.
        disarkCounter = 0
        IFNDEF dkps
        MACRO dkps
PLY_AKYst_DisarkPointerRegionStart_{disarkCounter}
        ENDM
        ENDIF
        ;Disark macro: Pointer region End.
        IFNDEF dkpe
        MACRO dkpe
PLY_AKYst_DisarkPointerRegionEnd_{disarkCounter}:
        disarkCounter = disarkCounter + 1
        ENDM
        ENDIF
        
        ;Disark macro: Byte region Start.
        disarkCounter = 0
        IFNDEF dkbs
        MACRO dkbs
PLY_AKYst_DisarkByteRegionStart_{disarkCounter}
        ENDM
        ENDIF
        ;Disark macro: Byte region End.
        IFNDEF dkbe
        MACRO dkbe
PLY_AKYst_DisarkByteRegionEnd_{disarkCounter}:
        disarkCounter = disarkCounter + 1
        ENDM
        ENDIF

        ;Disark macro: Force "No Reference Area" for 3 bytes (ld hl,xxxx).
        IFNDEF dknr3
        MACRO dknr3
PLY_AKYst_DisarkForceNonReferenceDuring3_{disarkCounter}:
        disarkCounter = disarkCounter + 1
        ENDM
        ENDIF
        
PLY_AKYst_Start:
        ;Hooks for external calls. Can be removed if not needed.
        jp PLY_AKYst_Init             ;Player + 0.
        jp PLY_AKYst_Play             ;Player + 3.


;       Initializes the player.
;       HL = music address.
PLY_AKYst_InitDisarkGenerateExternalLabel:
PLY_AKYst_Init:
        ;Skips the header.
        inc hl                          ;Skips the format version.
        ld a,(hl)                       ;Channel count.
        inc hl
dknr3 (void): ld de,4
PLY_AKYst_Init_SkipHeaderLoop:                ;There is always at least one PSG to skip.
        add hl,de
        sub 3                           ;A PSG is three channels.
        jr z,PLY_AKYst_Init_SkipHeaderEnd
        jr nc,PLY_AKYst_Init_SkipHeaderLoop   ;Security in case of the PSG channel is not a multiple of 3.
PLY_AKYst_Init_SkipHeaderEnd:
        ld (PLY_AKYst_PtLinker + 1),hl        ;HL now points on the Linker.

        ld a,PLY_AKYst_OPCODE_OR_A
        ld (PLY_AKYst_Channel1_RegisterBlockLineState_Opcode),a
        ld (PLY_AKYst_Channel2_RegisterBlockLineState_Opcode),a
        ld (PLY_AKYst_Channel3_RegisterBlockLineState_Opcode),a
dknr3 (void): ld hl,1
        ld (PLY_AKYst_PatternFrameCounter + 1),hl
        ret
        
;---------------------
;Alien codes, used below. Must be within JR range.
PLY_AKYst_PatternFrameCounter_NotOver:
        ;The pattern is not over.
        ld (PLY_AKYst_PatternFrameCounter + 1),hl
                ld b,12                     ;Waits for 55 cycles, JP included.
                djnz $
                jr $ + 2
        jr PLY_AKYst_PatternFrameManagement_End
        
PLY_AKYst_LinkerNotEndSong:
                jr $ + 2         ;Waits for 7 cycles, JP included.
                nop
                jr PLY_AKYst_LinkerNotEndSong_After
;---------------------

;       Plays the music. It must have been initialized before.
;       The interruption SHOULD be disabled (DI), as the stack is heavily used.
PLY_AKYst_PlayDisarkGenerateExternalLabel:
PLY_AKYst_Play:
        ld (PLY_AKYst_Exit + 1),sp

;Linker.
;----------------------------------------
dknr3 (void):
PLY_AKYst_PatternFrameCounter: ld hl,1                ;How many frames left before reading the next Pattern.
        dec hl
        ld a,l
        or h
        jr nz,PLY_AKYst_PatternFrameCounter_NotOver
;The pattern is over. Reads the next one.
dknr3 (void):
PLY_AKYst_PtLinker: ld sp,0                             ;Points on the Pattern of the linker.
        pop hl                                          ;Gets the duration of the Pattern, or 0 if end of the song.
        ld a,l
        or h
        jr nz,PLY_AKYst_LinkerNotEndSong
        ;End of the song. Where to loop?
        pop hl
        ;We directly point on the frame counter of the pattern to loop to.
        ld sp,hl
        ;Gets the duration again. No need to check the end of the song,
        ;we know it contains at least one pattern.
        pop hl
PLY_AKYst_LinkerNotEndSong_After:
        ld (PLY_AKYst_PatternFrameCounter + 1),hl

        pop hl
        ld (PLY_AKYst_Channel1_PtTrack + 1),hl
        pop hl
        ld (PLY_AKYst_Channel2_PtTrack + 1),hl
        pop hl
        ld (PLY_AKYst_Channel3_PtTrack + 1),hl

        ld (PLY_AKYst_PtLinker + 1),sp

        ;Resets the RegisterBlocks of the channels.
        ld a,1
        ;ld (PLY_AKYst_Channel1_WaitBeforeNextRegisterBlock + 1),a              ;No need, the test is skipped below, because always 1.
        ld (PLY_AKYst_Channel2_WaitBeforeNextRegisterBlock + 1),a
        ld (PLY_AKYst_Channel3_WaitBeforeNextRegisterBlock + 1),a
        jr PLY_AKYst_Channel1_RegisterBlock_Finished                            ;Skips the test for channel 1.
PLY_AKYst_PatternFrameManagement_End:


;Reading the Track - channel 1.
;----------------------------------------
PLY_AKYst_Channel1_WaitBeforeNextRegisterBlock: ld a,1        ;Frames to wait before reading the next RegisterBlock. 0 = finished.
        dec a
        jr nz,PLY_AKYst_Channel1_RegisterBlock_NotFinished
PLY_AKYst_Channel1_RegisterBlock_Finished:
        ;This RegisterBlock is finished. Reads the next one from the Track.
        ;Obviously, starts at the initial state.
        ld a,PLY_AKYst_OPCODE_OR_A
        ld (PLY_AKYst_Channel1_RegisterBlockLineState_Opcode),a
dknr3 (void):
PLY_AKYst_Channel1_PtTrack: ld sp,0                   ;Points on the Track.
        dec sp                                  ;Only one byte is read. Compensate.
        pop af                                  ;Gets the duration.
        pop hl                                  ;Reads the RegisterBlock address.

        ld (PLY_AKYst_Channel1_PtTrack + 1),sp
        ld (PLY_AKYst_Channel1_PtRegisterBlock + 1),hl

        ;A is the duration of the block.
PLY_AKYst_Channel1_RegisterBlock_Process:
        ;Processes the RegisterBlock, whether it is the current one or a new one.
        ld (PLY_AKYst_Channel1_WaitBeforeNextRegisterBlock + 1),a



;Reading the Track - channel 2.
;----------------------------------------
PLY_AKYst_Channel2_WaitBeforeNextRegisterBlock: ld a,1        ;Frames to wait before reading the next RegisterBlock. 0 = finished.
        dec a
        jr nz,PLY_AKYst_Channel2_RegisterBlock_NotFinished
        ;This RegisterBlock is finished. Reads the next one from the Track.
        ;Obviously, starts at the initial state.
        ld a,PLY_AKYst_OPCODE_OR_A
        ld (PLY_AKYst_Channel2_RegisterBlockLineState_Opcode),a
dknr3 (void):
PLY_AKYst_Channel2_PtTrack: ld sp,0                   ;Points on the Track.
        dec sp                                  ;Only one byte is read. Compensate.
        pop af                                  ;Gets the duration (b1-7). b0 = silence block?
        pop hl                                  ;Reads the RegisterBlock address.

        ld (PLY_AKYst_Channel2_PtTrack + 1),sp
        ld (PLY_AKYst_Channel2_PtRegisterBlock + 1),hl
        ;A is the duration of the block.
PLY_AKYst_Channel2_RegisterBlock_Process:
        ;Processes the RegisterBlock, whether it is the current one or a new one.
        ld (PLY_AKYst_Channel2_WaitBeforeNextRegisterBlock + 1),a




;Reading the Track - channel 3.
;----------------------------------------
PLY_AKYst_Channel3_WaitBeforeNextRegisterBlock: ld a,1        ;Frames to wait before reading the next RegisterBlock. 0 = finished.
        dec a
        jr nz,PLY_AKYst_Channel3_RegisterBlock_NotFinished
        ;This RegisterBlock is finished. Reads the next one from the Track.
        ;Obviously, starts at the initial state.
        ld a,PLY_AKYst_OPCODE_OR_A
        ld (PLY_AKYst_Channel3_RegisterBlockLineState_Opcode),a
dknr3 (void):
PLY_AKYst_Channel3_PtTrack: ld sp,0                   ;Points on the Track.
        dec sp                                  ;Only one byte is read. Compensate.
        pop af                                  ;Gets the duration (b1-7). b0 = silence block?
        pop hl                                  ;Reads the RegisterBlock address.

        ld (PLY_AKYst_Channel3_PtTrack + 1),sp
        ld (PLY_AKYst_Channel3_PtRegisterBlock + 1),hl
        ;A is the duration of the block.
PLY_AKYst_Channel3_RegisterBlock_Process:
        ;Processes the RegisterBlock, whether it is the current one or a new one.
        ld (PLY_AKYst_Channel3_WaitBeforeNextRegisterBlock + 1),a











;Reading the RegisterBlock.
;----------------------------------------

;Reading the RegisterBlock - Channel 1
;----------------------------------------

dknr3 (void):   ld hl,0 * 256 + 8                       ;H = first frequency register, L = first volume register.
dknr3 (void):   ld de,#f4f6
dknr3 (void):   ld bc,#f690                             ;#90 used for both #80 for the PSG, and volume 16!
        
                ld a,#c0                                ;Used for PSG.
                out (c),a                               ;f6c0. Madram's trick requires to start with this. out (c),b works, but will activate K7's relay! Not clean.
        ex af,af'
        exx

        ;In B, R7 with default values: fully sound-open but noise-close.
        ;R7 has been shift twice to the left, it will be shifted back as the channels are treated.
dknr3 (void): ld bc,%11100000 * 256 + 255                     ;C is 255 to prevent the following LDIs to decrease B.

        ld sp,PLY_AKYst_RetTable_ReadRegisterBlock

dknr3 (void):
PLY_AKYst_Channel1_PtRegisterBlock: ld hl,0                   ;Points on the data of the RegisterBlock to read.
PLY_AKYst_Channel1_RegisterBlockLineState_Opcode: or a        ;"or a" if initial state, "scf" (#37) if non-initial state.
        jp PLY_AKYst_ReadRegisterBlock
;-----------------------------------
;Some alien code from the method above. Must be near because of the relative jump.
PLY_AKYst_Channel1_RegisterBlock_NotFinished:
                ld b,5                  ;27 cycles, including the jump.
                djnz $
                jr $ + 2
                jr PLY_AKYst_Channel1_RegisterBlock_Process
PLY_AKYst_Channel2_RegisterBlock_NotFinished:
                ld b,5                  ;27 cycles, including the jump.
                djnz $
                jr $ + 2
                jr PLY_AKYst_Channel2_RegisterBlock_Process
PLY_AKYst_Channel3_RegisterBlock_NotFinished:
                ld b,5                  ;27 cycles, including the jump.
                djnz $
                jr $ + 2
                jr PLY_AKYst_Channel3_RegisterBlock_Process
;-----------------------------------
PLY_AKYst_Channel1_RegisterBlock_Return:
        ld a,PLY_AKYst_OPCODE_SCF
        ld (PLY_AKYst_Channel1_RegisterBlockLineState_Opcode),a
        ld (PLY_AKYst_Channel1_PtRegisterBlock + 1),hl        ;This is new pointer on the RegisterBlock.



;Reading the RegisterBlock - Channel 2
;----------------------------------------

        ;Shifts the R7 for the next channels.
        srl b           ;Not RR, because we have to make sure the b6 is 0, else no more keyboard (on CPC)!
dknr3 (void):
PLY_AKYst_Channel2_PtRegisterBlock: ld hl,0                   ;Points on the data of the RegisterBlock to read.
PLY_AKYst_Channel2_RegisterBlockLineState_Opcode: or a        ;"or a" if initial state, "scf" (#37) if non-initial state.
        jp PLY_AKYst_ReadRegisterBlock
PLY_AKYst_Channel2_RegisterBlock_Return:
        ld a,PLY_AKYst_OPCODE_SCF
        ld (PLY_AKYst_Channel2_RegisterBlockLineState_Opcode),a
        ld (PLY_AKYst_Channel2_PtRegisterBlock + 1),hl        ;This is new pointer on the RegisterBlock.


;Reading the RegisterBlock - Channel 3
;----------------------------------------

        ;Shifts the R7 for the next channels.
        rr b            ;Safe to use RR, we don't care if b7 of R7 is 0 or 1.
dknr3 (void):
PLY_AKYst_Channel3_PtRegisterBlock: ld hl,0                   ;Points on the data of the RegisterBlock to read.
PLY_AKYst_Channel3_RegisterBlockLineState_Opcode: or a        ;"or a" if initial state, "scf" (#37) if non-initial state.
        jp PLY_AKYst_ReadRegisterBlock
PLY_AKYst_Channel3_RegisterBlock_Return:
        ld a,PLY_AKYst_OPCODE_SCF
        ld (PLY_AKYst_Channel3_RegisterBlockLineState_Opcode),a
        ld (PLY_AKYst_Channel3_PtRegisterBlock + 1),hl        ;This is new pointer on the RegisterBlock.

        ;Register 7 to A.
        ld a,b

;Almost all the channel specific registers have been sent. Now sends the remaining registers (6, 7, 11, 12, 13).

;Register 7. Note that managing register 7 before 6/11/12 is done on purpose (the 6/11/12 registers are filled using OUTI).
        exx

                inc h           ;Was 6, so now 7!

                ld b,d
                out (c),h       ;f400 + register.
                ld b,e
                out (c),0       ;f600.
                ld b,d
                out (c),a       ;f400 + value.
                ld b,e
                out (c),c       ;f680
                ex af,af'
                out (c),a       ;f6c0.
                ex af,af'

;Register 6
                dec h

                ld b,d
                out (c),h       ;f400 + register.
                ld b,e
                out (c),0       ;f600.

                ld hl,PLY_AKYst_PsgRegister6
                dec b           ; -1, not -2 because of OUTI does -1 before doing the out.
                outi            ;f400 + value
                ld b,e
                out (c),c       ;f680
                ex af,af'
                out (c),a       ;f6c0.
                ex af,af'

;Register 11
                ld a,11         ;Next regiser

                ld b,d
                out (c),a       ;f400 + register.
                ld b,e
                out (c),0       ;f600.
                dec b
                outi            ;f400 + value.
                ld b,e
                out (c),c       ;f680
                ex af,af'
                out (c),a       ;f6c0.
                ex af,af'

;Register 12
                inc a           ;Next regiser

                ld b,d
                out (c),a       ;f400 + register.
                ld b,e
                out (c),0       ;f600.
                dec b
                outi            ;f400 + value.
                ld b,e
                out (c),c       ;f680
                ex af,af'
                out (c),a       ;f6c0.
                ex af,af'



;Register 13
PLY_AKYst_PsgRegister13_Code
                ld a,(hl)
PLY_AKYst_PsgRegister13_Retrig cp 255                         ;If IsRetrig?, force the R13 to be triggered.
                jr nz,PLY_AKYst_PsgRegister13_Change
                        ld b,7                  ;30 cycles.
                        djnz $
                        nop
                jr PLY_AKYst_PsgRegister13_End
PLY_AKYst_PsgRegister13_Change:
                ld (PLY_AKYst_PsgRegister13_Retrig + 1),a

                ld b,d
                ld l,13
                out (c),l       ;f400 + register.
                ld b,e
                out (c),0       ;f600.
                ld b,d
                out (c),a       ;f400 + value.
                ld b,e
                out (c),c       ;f680
                ex af,af'
                out (c),a       ;f6c0.
                ex af,af'
PLY_AKYst_PsgRegister13_End:


dknr3 (void):
PLY_AKYst_Exit: ld sp,0
        ret








;Generic code interpreting the RegisterBlock
;IN:    HL = First byte.
;       Carry = 0 = initial state, 1 = non-initial state.
;----------------------------------------------------------------

PLY_AKYst_ReadRegisterBlock:
        ;Gets the first byte of the line. What type? Jump to the matching code thanks to the carry.
        ld a,(hl)
        inc hl
        jp c,PLY_AKYst_RRB_NonInitialState
        
                ;Compensate once and for all the loop for the NIS (not present here in the IS).
                ;ds PLY_AKYst_NOP_Loop, 0                                
        	ld d,8                     ;Waits for 35 cycles.
                dec d
                jr nz,$ - 1
                cp (hl)
        
        ;Not in the original code, but simplifies the stabilization.
        ld d,a                  ;A must be saved!        
        and %00000011
        add a,a
        add a,a
        ld e,a
        ld a,d                  ;Retrieves A, which is supposed to be shifted in the original code.
        rra
        rra
        ld d,0
        ld ix,PLY_AKYst_IS_JPTable
        add ix,de
        jp (ix)
PLY_AKYst_IS_JPTable:
        jp PLY_AKYst_RRB_IS_NoSoftwareNoHardware          ;%00
        nop
        jp PLY_AKYst_RRB_IS_SoftwareOnly                  ;%01
        nop
        jp PLY_AKYst_RRB_IS_HardwareOnly                  ;%10
        nop
        jp PLY_AKYst_RRB_IS_SoftwareAndHardware           ;%11
        

;Generic code interpreting the RegisterBlock - Initial state.
;----------------------------------------------------------------
;IN:    HL = Points after the first byte.
;       A = First byte, twice shifted to the right (type removed).
;       B = Register 7. All sounds are open (0) by default, all noises closed (1). The code must put ONLY bit 2 and 5 for sound and noise respectively. NOT any other bits!
;       C = May be used as a temp. BUT must NOT be 0, as ldi will decrease it, we do NOT want B to be decreased!!
;       DE = free to use.
;       IX = free to use (not used!).
;       IY = free to use (not used!).
;       SP = Do no use, used for the RET.

;       A' = free to use (not used).
;       DE' = f4f6
;       BC' = f680
;       L' = Volume register.
;       H' = LSB frequency register.

;OUT:   HL MUST point after the structure.
;       B = updated (ONLY bit 2 and 5).
;       L' = Volume register increased of 1 (*** IMPORTANT! The code MUST increase it, even if not using it! ***)
;       H' = LSB frequency register, increased of 2 (see above).
;       DE' = unmodified (f4f6)
;       BC' = unmodified (f680)

PLY_AKYst_RRB_NoiseChannelBit: equ 5          ;Bit to modify to set/reset the noise channel.
PLY_AKYst_RRB_SoundChannelBit: equ 2          ;Bit to modify to set/reset the sound channel.


PLY_AKYst_RRB_IS_NoSoftwareNoHardware:          ;50 cycles.

                ;ds PLY_AKYst_NOP_LongestInState - 50, 0         ;For all the IS/NIS subcodes to spend the same amount of time.
        	ld d,32                     ;Waits for 182 - 50 = 132 cycles.
                dec d
                jr nz,$ - 1
                cp (hl)
                nop

        ;No software no hardware.
        rra                     ;Noise?
        jr c,PLY_AKYst_RRB_NIS_NoSoftwareNoHardware_ReadNoise
                jr $ + 2                 ;Waits for 8 cycles
                jr $ + 2
                cp (hl)
        jr PLY_AKYst_RRB_NIS_NoSoftwareNoHardware_ReadNoise_End
PLY_AKYst_RRB_NIS_NoSoftwareNoHardware_ReadNoise:
        ;There is a noise. Reads it.
        ld de,PLY_AKYst_PsgRegister6
        ldi                     ;Safe for B, C is not 0. Preserves A.

        ;Opens the noise channel.
        res PLY_AKYst_RRB_NoiseChannelBit, b
PLY_AKYst_RRB_NIS_NoSoftwareNoHardware_ReadNoise_End:
        
PLY_AKYst_RRB_NIS_NoSoftwareNoHardware_ReadVolume:
        ;The volume is now in b0-b3.
        ;and %1111      ;No need, the bit 7 was 0.

        exx
                ;Sends the volume.
                ld b,d
                out (c),l       ;f400 + register.
                ld b,e
                out (c),0       ;f600.
                ld b,d
                out (c),a       ;f400 + value.
                ld b,e
                out (c),c       ;f680
                ex af,af'
                out (c),a       ;f6c0.
                ex af,af'

                inc l           ;Increases the volume register.
                inc h           ;Increases the frequency register.
                inc h
        exx

        ;Closes the sound channel.
        set PLY_AKYst_RRB_SoundChannelBit, b
        ret


;---------------------
PLY_AKYst_RRB_IS_HardwareOnly:                          ;79 cycles.

                ;ds PLY_AKYst_NOP_LongestInState - 79, 0         ;For all the IS/NIS subcodes to spend the same amount of time.
        	ld d,25                     ;Waits for 182 - 79 = 103 cycles.
                dec d
                jr nz,$ - 1
                cp (hl)

        ;Retrig?
        rra
        jr c,PLY_AKYst_RRB_IS_HO_Retrig
                jr $ + 2         ;Wait for 4 cycles.
                nop
        jr PLY_AKYst_RRB_IS_HO_AfterRetrig
PLY_AKYst_RRB_IS_HO_Retrig:
        set 7,a                         ;A value to make sure the retrig is performed, yet A can still be use.
        ld (PLY_AKYst_PsgRegister13_Retrig + 1),a
PLY_AKYst_RRB_IS_HO_AfterRetrig:

        ;Noise?
        rra
        jr c,PLY_AKYst_RRB_IS_HO_Noise
                jr $ + 2         ;Wait for 8 cycles.
                jr $ + 2
                cp (hl)
        jr PLY_AKYst_RRB_IS_HO_AfterNoise
PLY_AKYst_RRB_IS_HO_Noise        ;Reads the noise.
        ld de,PLY_AKYst_PsgRegister6
        ldi                     ;Safe for B, C is not 0. Preserves A.
        ;Opens the noise channel.
        res PLY_AKYst_RRB_NoiseChannelBit, b
PLY_AKYst_RRB_IS_HO_AfterNoise:

        ;The envelope.
        and %1111
        ld (PLY_AKYst_PsgRegister13),a

        ;Copies the hardware period.
        ld de,PLY_AKYst_PsgRegister11
        ldi
        ldi

        ;Closes the sound channel.
        set PLY_AKYst_RRB_SoundChannelBit, b

        exx
                ;Sets the hardware volume.
                ld b,d
                out (c),l       ;f400 + register.
                ld b,e
                out (c),0       ;f600.
                ld b,d
                out (c),c       ;f400 + value (volume to 16).
                ld b,e
                out (c),c       ;f680
                ex af,af'
                out (c),a       ;f6c0.
                ex af,af'

                inc l           ;Increases the volume register.
                inc h           ;Increases the frequency register (mandatory!).
                inc h
        exx
        ret


;---------------------
PLY_AKYst_RRB_IS_SoftwareOnly:                  ;112 cycles.

                ;ds PLY_AKYst_NOP_LongestInState - 112, 0         ;For all the IS/NIS subcodes to spend the same amount of time. 
        	ld d,17                     ;Waits for 182 - 112 = 70 cycles.
                dec d
                jr nz,$ - 1
                nop

        ;Software only. Structure: 0vvvvntt.
        ;Noise?
        rra
        jr c,PLY_AKYst_RRB_IS_SoftwareOnly_Noise
                jr $ + 2         ;Wait for 8 cycles.
                jr $ + 2
                cp (hl)
        jr PLY_AKYst_RRB_IS_SoftwareOnly_AfterNoise
PLY_AKYst_RRB_IS_SoftwareOnly_Noise:
        ;Noise. Reads it.
        ld de,PLY_AKYst_PsgRegister6
        ldi                     ;Safe for B, C is not 0. Preserves A.
        ;Opens the noise channel.
        res PLY_AKYst_RRB_NoiseChannelBit, b
PLY_AKYst_RRB_IS_SoftwareOnly_AfterNoise:

        ;Reads the volume (now b0-b3).
        ;Note: we do NOT peform a "and %1111" because we know the bit 7 of the original byte is 0, so the bit 4 is currently 0. Else the hardware volume would be on!
        exx
                ;Sends the volume.
                ld b,d
                out (c),l       ;f400 + register.
                ld b,e
                out (c),0       ;f600.
                ld b,d
                out (c),a       ;f400 + value.
                ld b,e
                out (c),c       ;f680
                ex af,af'
                out (c),a       ;f6c0.
                ex af,af'
                
                inc l           ;Increases the volume register.
        exx

        ;Reads the software period.
        ld a,(hl)
        inc hl
        exx
                ;Sends the LSB software frequency.
                ld b,d
                out (c),h       ;f400 + register.
                ld b,e
                out (c),0       ;f600.
                ld b,d
                out (c),a       ;f400 + value.
                ld b,e
                out (c),c       ;f680
                ex af,af'
                out (c),a       ;f6c0.
                ex af,af'

                inc h           ;Increases the frequency register.
        exx

        ld a,(hl)
        inc hl
        exx
                ;Sends the MSB software frequency.
                ld b,d
                out (c),h       ;f400 + register.
                ld b,e
                out (c),0       ;f600.
                ld b,d
                out (c),a       ;f400 + value.
                ld b,e
                out (c),c       ;f680
                ex af,af'
                out (c),a       ;f6c0.
                ex af,af'
                
                inc h           ;Increases the frequency register.
        exx

        ret





;---------------------
PLY_AKYst_RRB_IS_SoftwareAndHardware:                   ;139 cycles.
        
                ;ds PLY_AKYst_NOP_LongestInState - 139, 0         ;For all the IS/NIS subcodes to spend the same amount of time.
                ld d,10                     ;Waits for 182 - 139 = 43 cycles.
                dec d
                jr nz,$ - 1
                cp (hl)

        ;Retrig?
        rra
        jr c,PLY_AKYst_RRB_IS_SAH_Retrig
                jr $ + 2         ;Wait for 4 cycles.
                nop
        jr PLY_AKYst_RRB_IS_SAH_AfterRetrig
PLY_AKYst_RRB_IS_SAH_Retrig:
        set 7,a                         ;A value to make sure the retrig is performed, yet A can still be use.
        ld (PLY_AKYst_PsgRegister13_Retrig + 1),a
PLY_AKYst_RRB_IS_SAH_AfterRetrig:

        ;Noise?
        rra
        jr c,PLY_AKYst_RRB_IS_SAH_Noise
                jr $ + 2         ;Wait for 8 cycles.
                jr $ + 2
                cp (hl)
        jr PLY_AKYst_RRB_IS_SAH_AfterNoise
PLY_AKYst_RRB_IS_SAH_Noise:
        ;Reads the noise.
        ld de,PLY_AKYst_PsgRegister6
        ldi                     ;Safe for B, C is not 0. Preserves A.
        ;Opens the noise channel.
        res PLY_AKYst_RRB_NoiseChannelBit, b
PLY_AKYst_RRB_IS_SAH_AfterNoise:

        ;The envelope.
        and %1111
        ld (PLY_AKYst_PsgRegister13),a

        ;Reads the software period.
        ld a,(hl)
        inc hl
        exx
                ;Sends the LSB software frequency.
                ld b,d
                out (c),h       ;f400 + register.
                ld b,e
                out (c),0       ;f600.
                ld b,d
                out (c),a       ;f400 + value.
                ld b,e
                out (c),c       ;f680
                ex af,af'
                out (c),a       ;f6c0.
                ex af,af'
                
                inc h           ;Increases the frequency register.
        exx

        ld a,(hl)
        inc hl
        exx
                ;Sends the MSB software frequency.
                ld b,d
                out (c),h       ;f400 + register.
                ld b,e
                out (c),0       ;f600.
                ld b,d
                out (c),a       ;f400 + value.
                ld b,e
                out (c),c       ;f680
                ex af,af'
                out (c),a       ;f6c0.
                ex af,af'

                inc h           ;Increases the frequency register.

                ;Sets the hardware volume.
                ld b,d
                out (c),l       ;f400 + register.
                ld b,e
                out (c),0       ;f600.
                ld b,d
                out (c),c       ;f400 + value (volume to 16).
                ld b,e
                out (c),c       ;f680
                ex af,af'
                out (c),a       ;f6c0.
                ex af,af'

                inc l           ;Increases the volume register.
        exx

        ;Copies the hardware period.
        ld de,PLY_AKYst_PsgRegister11
        ldi
        ldi
        ret






;Generic code interpreting the RegisterBlock - Non initial state. See comment about the Initial state for the registers ins/outs.
;----------------------------------------------------------------
PLY_AKYst_RRB_NonInitialState:

        ;Not in the original code, but simplifies the stabilization.
        ld d,a                          ;A must be saved!
        and %00001111                   ;Keeps 4 bits to be able to detect the loop. (%1000)
        add a,a
        add a,a
        ld e,a

        ld a,d                          ;Retrieves A, which is supposed to be shifted in the original code.
        rra
        rra
        ld d,0
        ld ix,PLY_AKYst_NIS_JPTable
        add ix,de
        jp (ix)
        ;All these codes consider there is no loop, so have a "wait" at the beginning. Except the "loop" code in %1000, which manages the loop...
PLY_AKYst_NIS_JPTable:
        jp PLY_AKYst_RRB_NIS_NoSoftwareNoHardware          ;%0000
        nop
        jp PLY_AKYst_RRB_NIS_SoftwareOnly                  ;%0001
        nop
        jp PLY_AKYst_RRB_NIS_HardwareOnly                  ;%0010
        nop
        jp PLY_AKYst_RRB_NIS_SoftwareAndHardware           ;%0011
        nop

        jp PLY_AKYst_RRB_NIS_NoSoftwareNoHardware          ;%0100
        nop
        jp PLY_AKYst_RRB_NIS_SoftwareOnly                  ;%0101
        nop
        jp PLY_AKYst_RRB_NIS_HardwareOnly                  ;%0110
        nop
        jp PLY_AKYst_RRB_NIS_SoftwareAndHardware           ;%0111
        nop
        
        jp PLY_AKYst_RRB_NIS_ManageLoop                    ;%1000. Loop!
        nop
        jp PLY_AKYst_RRB_NIS_SoftwareOnly                  ;%1001
        nop
        jp PLY_AKYst_RRB_NIS_HardwareOnly                  ;%1010
        nop
        jp PLY_AKYst_RRB_NIS_SoftwareAndHardware           ;%1011
        nop
        
        jp PLY_AKYst_RRB_NIS_NoSoftwareNoHardware          ;%1100
        nop
        jp PLY_AKYst_RRB_NIS_SoftwareOnly                  ;%1101
        nop
        jp PLY_AKYst_RRB_NIS_HardwareOnly                  ;%1110
        nop
        jp PLY_AKYst_RRB_NIS_SoftwareAndHardware           ;%1111
        

PLY_AKYst_RRB_NIS_ManageLoop:
        ;Loops. Reads the next pointer to this RegisterBlock.
        ld a,(hl)
        inc hl
        ld h,(hl)
        ld l,a

        ;Makes another iteration to read the new data.
        ;Since we KNOW it is not an initial state (because no jump goes to an initial state), we can directly go to the right branching.
        ;Reads the first byte.
        ld a,(hl)
        inc hl
        
        ;Reads the next NIS state. We know there won't be any loop.
        ld d,a                          ;A must be saved!
        and %00000011                   ;Keeps 4 bits to be able to detect the loop. (%1000)
        add a,a
        add a,a
        ld e,a

        ld a,d                          ;Retrieves A, which is supposed to be shifted in the original code.
        rra
        rra
        ld d,0
        ld ix,PLY_AKYst_NIS_JPTable_NoLoop
        add ix,de
        jp (ix)
        ;This table jumps at each state, but AFTER the loop compensation.
PLY_AKYst_NIS_JPTable_NoLoop:
        jp PLY_AKYst_RRB_NIS_NoSoftwareNoHardware_Loop     ;%00
        nop
        jp PLY_AKYst_RRB_NIS_SoftwareOnly_Loop             ;%01
        nop
        jp PLY_AKYst_RRB_NIS_HardwareOnly_Loop             ;%10
        nop
        jp PLY_AKYst_RRB_NIS_SoftwareAndHardware_Loop      ;%11
        


PLY_AKYst_RRB_NIS_NoSoftwareNoHardware:                 ;60 + LoopCompensation cycles.
                ;Compensates the fact that there is no loop.
                ;ds PLY_AKYst_NOP_Loop, 0                                
        	ld d,8                     ;Waits for 35 cycles.
                dec d
                jr nz,$ - 1
                cp (hl)
PLY_AKYst_RRB_NIS_NoSoftwareNoHardware_Loop:            ;60 cycles.
        ;No software, no hardware.
        ;NO NEED to test the loop! It has been tested before. We can optimize from the original code.
        ld e,a                  ;Used below.

                ;ds PLY_AKYst_NOP_LongestInState - 60, 0         ;For all the IS/NIS subcodes to spend the same amount of time.
                ld d,30                     ;Waits for 182 - 60 = 122 cycles.
                dec d
                jr nz,$ - 1
                nop

        ;Closes the sound channel.
        set PLY_AKYst_RRB_SoundChannelBit, b

        ;Volume? bit 2 - 2.
        rra
        jr c,PLY_AKYst_RRB_NIS_Volume
                ld d,6                     ;Waits for 28 cycles.
                dec d
                jr nz,$ - 1
                cp (hl)
                nop
        jr PLY_AKYst_RRB_NIS_AfterVolume
PLY_AKYst_RRB_NIS_Volume:
        and %1111
        exx
                ;Sends the volume.
                ld b,d
                out (c),l       ;f400 + register.
                ld b,e
                out (c),0       ;f600.
                ld b,d
                out (c),a       ;f400 + value.
                ld b,e
                out (c),c       ;f680
                ex af,af'
                out (c),a       ;f6c0.
                ex af,af'
        exx
PLY_AKYst_RRB_NIS_AfterVolume:

        ;Sadly, have to lose a bit of CPU here, as this must be done in all cases.
        exx
                inc l           ;Next volume register.
                inc h           ;Next frequency registers.
                inc h
        exx

        ;Noise? Was on bit 7, but there has been two shifts. We can't use A, it may have been modified by the volume AND.
        bit 7 - 2, e
        jr nz,PLY_AKYst_RRB_NIS_Noise
                jr $ + 2         ;Wait for 11 cycles.
                jr $ + 2
                jr $ + 2
                cp (hl)
        ret
PLY_AKYst_RRB_NIS_Noise:
        ;Noise.
        ld a,(hl)
        ld (PLY_AKYst_PsgRegister6),a
        inc hl
        ;Opens the noise channel.
        res PLY_AKYst_RRB_NoiseChannelBit, b
        ret







;---------------------
PLY_AKYst_RRB_NIS_SoftwareOnly:
                ;Compensates the fact that there is no loop.
                ;ds PLY_AKYst_NOP_Loop, 0                                
                ld d,8                     ;Waits for 35 cycles.
                dec d
                jr nz,$ - 1
                cp (hl)
PLY_AKYst_RRB_NIS_SoftwareOnly_Loop:                    ;129 cycles.
        
                ;ds PLY_AKYst_NOP_LongestInState - 129, 0         ;For all the IS/NIS subcodes to spend the same amount of time.
                ld d,13                     ;Waits for 182 - 129 = 53 cycles.
                dec d
                jr nz,$ - 1
        
        ;Software only. Structure: mspnoise lsp v  v  v  v  (0  1).
        ld e,a
        ;Gets the volume (already shifted).
        and %1111
        exx
                ;Sends the volume.
                ld b,d
                out (c),l       ;f400 + register.
                ld b,e
                out (c),0       ;f600.
                ld b,d
                out (c),a       ;f400 + value.
                ld b,e
                out (c),c       ;f680
                ex af,af'
                out (c),a       ;f6c0.
                ex af,af'

                inc l           ;Increases the volume register.
        exx

        ;LSP? (Least Significant byte of Period). Was bit 6, but now shifted.
        bit 6 - 2, e
        jr nz,PLY_AKYst_RRB_NIS_SoftwareOnly_LSP
                ld d,7                     ;Waits for 30 cycles.
                dec d
                jr nz,$ - 1
                nop
        jr PLY_AKYst_RRB_NIS_SoftwareOnly_AfterLSP
PLY_AKYst_RRB_NIS_SoftwareOnly_LSP:
        ld a,(hl)
        inc hl
        exx
                ;Sends the LSB software frequency.
                ld b,d
                out (c),h       ;f400 + register.
                ld b,e
                out (c),0       ;f600.
                ld b,d
                out (c),a       ;f400 + value.
                ld b,e
                out (c),c       ;f680
                ex af,af'
                out (c),a       ;f6c0.
                ex af,af'

                ;H not incremented on purpose.
        exx
PLY_AKYst_RRB_NIS_SoftwareOnly_AfterLSP:

        ;MSP AND/OR (Noise and/or new Noise)? (Most Significant byte of Period).
        bit 7 - 2, e
        jr nz,PLY_AKYst_RRB_NIS_SoftwareOnly_MSPAndMaybeNoise
        ;Bit of loss of CPU, but has to be done in all cases.
        exx
                inc h
                inc h
        exx
                ld d,12                     ;Waits for 49 cycles.
                dec d
                jr nz,$ - 1
        ret
        
PLY_AKYst_RRB_NIS_SoftwareOnly_MSPAndMaybeNoise:   ;53 cycles.           
        ;MSP and noise?, in the next byte. in--pppp (i = isNoise? n = newNoise? p = MSB period).
        ld a,(hl)       ;Useless bits at the end, not a problem.
        inc hl
        exx
                ;Sends the MSB software frequency.
                inc h           ;Was not increased before.

                ld b,d
                out (c),h       ;f400 + register.
                ld b,e
                out (c),0       ;f600.
                ld b,d
                out (c),a       ;f400 + value.
                ld b,e
                out (c),c       ;f680
                ex af,af'
                out (c),a       ;f6c0.
                ex af,af'

                inc h           ;Increases the frequency register.
        exx
        
        rla     ;Carry is isNoise?
        jr c,PLY_AKYst_RRB_NIS_SoftwareOnly_NoisePresent
                ld d,3                     ;Waits for 15 cycles.
                dec d
                jr nz,$ - 1
                cp (hl)
        ret
PLY_AKYst_RRB_NIS_SoftwareOnly_NoisePresent:
        ;Opens the noise channel.
        res PLY_AKYst_RRB_NoiseChannelBit, b
       
        ;Is there a new noise value? If yes, gets the noise.
        rla
        jr c,PLY_AKYst_RRB_NIS_SoftwareOnly_Noise
                jr $ + 2         ;Wait for 9 cycles.
                jr $ + 2
                jr $ + 2
        ret
PLY_AKYst_RRB_NIS_SoftwareOnly_Noise:
        ;Gets the noise.
        ld de,PLY_AKYst_PsgRegister6
        ldi
        ret



;---------------------
PLY_AKYst_RRB_NIS_HardwareOnly:
                ;Compensates the fact that there is no loop.
                ;ds PLY_AKYst_NOP_Loop, 0                                
                ld d,8                     ;Waits for 35 cycles.
                dec d
                jr nz,$ - 1
                cp (hl)

PLY_AKYst_RRB_NIS_HardwareOnly_Loop:            ;102 cycles.

                ;ds PLY_AKYst_NOP_LongestInState - 102, 0         ;For all the IS/NIS subcodes to spend the same amount of time.
                ld d,19                     ;Waits for 182 - 102 = 80 cycles.
                dec d
                jr nz,$ - 1
                cp (hl)
                nop

        ;Gets the envelope (initially on b2-b4, but currently on b0-b2). It is on 3 bits, must be encoded on 4. Bit 0 must be 0.
        rla
        ld e,a
        and %1110
        ld (PLY_AKYst_PsgRegister13),a

        ;Closes the sound channel.
        set PLY_AKYst_RRB_SoundChannelBit, b

        ;Hardware volume.
        exx
                ld b,d
                out (c),l       ;f400 + register.
                ld b,e
                out (c),0       ;f600.
                ld b,d
                out (c),c       ;f400 + value (16, hardware volume).
                ld b,e
                out (c),c       ;f680
                ex af,af'
                out (c),a       ;f6c0.
                ex af,af'

                inc l           ;Increases the volume register.

                inc h           ;Increases the frequency register.
                inc h
        exx

        ld a,e

        ;LSB for hardware period? Currently on b6.
        rla
        rla
        jr c,PLY_AKYst_RRB_NIS_HardwareOnly_LSB
                jr $ + 2         ;Wait for 6 cycles.
                jr $ + 2
        jr PLY_AKYst_RRB_NIS_HardwareOnly_AfterLSB
PLY_AKYst_RRB_NIS_HardwareOnly_LSB:
        ld de,PLY_AKYst_PsgRegister11
        ldi
PLY_AKYst_RRB_NIS_HardwareOnly_AfterLSB:

        ;MSB for hardware period?
        rla
        jr c,PLY_AKYst_RRB_NIS_HardwareOnly_MSB
		jr $ + 2         ;Wait for 6 cycles.
                jr $ + 2
        jr PLY_AKYst_RRB_NIS_HardwareOnly_AfterMSB
PLY_AKYst_RRB_NIS_HardwareOnly_MSB:
        ld de,PLY_AKYst_PsgRegister12
        ldi
PLY_AKYst_RRB_NIS_HardwareOnly_AfterMSB:
        
        ;Noise or retrig?
        rla
        jp c,PLY_AKYst_RRB_NIS_Hardware_Shared_NoiseOrRetrig_AndStop          ;The retrig/noise code is shared.
                ld d,6                     ;Waits for 28 cycles.
                dec d
                jr nz,$ - 1
                cp (hl)
                nop
        ret



;---------------------
PLY_AKYst_RRB_NIS_SoftwareAndHardware:
        ;Compensates the fact that there is no loop.
                ;ds PLY_AKYst_NOP_Loop, 0                                
                ld d,8                     ;Waits for 35 cycles.
                dec d
                jr nz,$ - 1
                cp (hl)

PLY_AKYst_RRB_NIS_SoftwareAndHardware_Loop:             ;182 cycles.

                ;This is the longest! So nothing to wait.
                ;ds PLY_AKYst_NOP_LongestInState - 182, 0         ;For all the IS/NIS subcodes to spend the same amount of time.
        

        ;Hardware volume.
        exx
                ;Sends the volume.
                ld b,d
                out (c),l       ;f400 + register.
                ld b,e
                out (c),0       ;f600.
                ld b,d
                out (c),c       ;f400 + value (16 = hardware volume).
                ld b,e
                out (c),c       ;f680
                ex af,af'
                out (c),a       ;f6c0.
                ex af,af'

                inc l           ;Increases the volume register.
        exx

        ;LSB of hardware period?
        rra
        jr c,PLY_AKYst_RRB_NIS_SAHH_LSBH
		jr $ + 2         ;Wait for 6 cycles.
                jr $ + 2
        jr PLY_AKYst_RRB_NIS_SAHH_AfterLSBH
PLY_AKYst_RRB_NIS_SAHH_LSBH:
        ld de,PLY_AKYst_PsgRegister11
        ldi
PLY_AKYst_RRB_NIS_SAHH_AfterLSBH:

        ;MSB of hardware period?
        rra
        jr c,PLY_AKYst_RRB_NIS_SAHH_MSBH
                jr $ + 2         ;Wait for 6 cycles.
                jr $ + 2
        jr PLY_AKYst_RRB_NIS_SAHH_AfterMSBH
PLY_AKYst_RRB_NIS_SAHH_MSBH:
        ld de,PLY_AKYst_PsgRegister12
        ldi
PLY_AKYst_RRB_NIS_SAHH_AfterMSBH:
        
        ;LSB of software period?
        rra
        jr c,PLY_AKYst_RRB_NIS_SAHH_LSBS
                ld d,7                     ;Waits for 32 cycles.
                dec d
                jr nz,$ - 1
                cp (hl)
                nop
        jr PLY_AKYst_RRB_NIS_SAHH_AfterLSBS
PLY_AKYst_RRB_NIS_SAHH_LSBS:
        ld e,a
        ld a,(hl)
        inc hl
        exx
                ;Sends the LSB software frequency.
                ld b,d
                out (c),h       ;f400 + register.
                ld b,e
                out (c),0       ;f600.
                ld b,d
                out (c),a       ;f400 + value.
                ld b,e
                out (c),c       ;f680
                ex af,af'
                out (c),a       ;f6c0.
                ex af,af'

                ;H not increased on purpose.
        exx
        ld a,e
PLY_AKYst_RRB_NIS_SAHH_AfterLSBS:
       
        ;MSB of software period?
        rra
        jr c,PLY_AKYst_RRB_NIS_SAHH_MSBS
                ld d,8                     ;Waits for 34 cycles.
                dec d
                jr nz,$ - 1
                nop
        jr PLY_AKYst_RRB_NIS_SAHH_AfterMSBS
PLY_AKYst_RRB_NIS_SAHH_MSBS:
        ld e,a
        ld a,(hl)
        inc hl
        exx
                ;Sends the MSB software frequency.
                inc h

                ld b,d
                out (c),h       ;f400 + register.
                ld b,e
                out (c),0       ;f600.
                ld b,d
                out (c),a       ;f400 + value.
                ld b,e
                out (c),c       ;f680
                ex af,af'
                out (c),a       ;f6c0.
                ex af,af'

                dec h           ;Yup. Will be compensated below.
        exx
        ld a,e
PLY_AKYst_RRB_NIS_SAHH_AfterMSBS:
        ;A bit of loss of CPU, but this has to be done every time!
        exx
                inc h
                inc h
        exx

        ;New hardware envelope?
        rra
        jr c,PLY_AKYst_RRB_NIS_SAHH_Envelope
		jr $ + 2         ;Wait for 6 cycles.
                jr $ + 2
        jr PLY_AKYst_RRB_NIS_SAHH_AfterEnvelope
PLY_AKYst_RRB_NIS_SAHH_Envelope:
        ld de,PLY_AKYst_PsgRegister13
        ldi
PLY_AKYst_RRB_NIS_SAHH_AfterEnvelope:

        ;Retrig and/or noise?
        rra
        jr c,PLY_AKYst_RRB_NIS_Hardware_Shared_NoiseOrRetrig_AndStop
                ld d,6                     ;Waits for 29 cycles.
                dec d
                jr nz,$ - 1
                cp (hl)
                cp (hl)
        ret

        ;This code is shared with the HardwareOnly. It reads the Noise/Retrig byte, interprets it and exits.
        ;------------------------------------------
PLY_AKYst_RRB_NIS_Hardware_Shared_NoiseOrRetrig_AndStop:              ;31 cycles
        ;Noise or retrig. Reads the next byte.
        ld a,(hl)
        inc hl

        ;Retrig?
        rra
        jr c,PLY_AKYst_RRB_NIS_S_NOR_Retrig
                jr $ + 2         ;Wait for 4 cycles.
                nop
        jr PLY_AKYst_RRB_NIS_S_NOR_AfterRetrig
PLY_AKYst_RRB_NIS_S_NOR_Retrig:
        set 7,a                         ;A value to make sure the retrig is performed, yet A can still be use.
        ld (PLY_AKYst_PsgRegister13_Retrig + 1),a
PLY_AKYst_RRB_NIS_S_NOR_AfterRetrig:

        ;Noise? If no, nothing more to do.
        rra
        jr c,PLY_AKYst_RRB_NIS_S_NOR_Noise
                jr $ + 2         ;Wait for 11 cycles.
                jr $ + 2
                jr $ + 2
		cp (hl)
        ret
PLY_AKYst_RRB_NIS_S_NOR_Noise:
        
        ;Noise. Opens the noise channel.
        res PLY_AKYst_RRB_NoiseChannelBit, b
        ;Is there a new noise value? If yes, gets the noise.
        rra
        jr c,PLY_AKYst_RRB_NIS_S_NOR_SetNoise
                jr $ + 2         ;Waits for 5 cycles.
                cp (hl)
        ret
PLY_AKYst_RRB_NIS_S_NOR_SetNoise:
        ;Sets the noise.
        ld (PLY_AKYst_PsgRegister6),a
        ret


;Some stored PSG registers.
dkbs (void):
PLY_AKYst_PsgRegister6: db 0
PLY_AKYst_PsgRegister11: db 0
PLY_AKYst_PsgRegister12: db 0
PLY_AKYst_PsgRegister13: db 0
dkbe (void):

;RET table for the Read RegisterBlock code to know where to return.
PLY_AKYst_RetTable_ReadRegisterBlock:
dkps (void):
        dw PLY_AKYst_Channel1_RegisterBlock_Return
        dw PLY_AKYst_Channel2_RegisterBlock_Return
        dw PLY_AKYst_Channel3_RegisterBlock_Return
dkpe (void):