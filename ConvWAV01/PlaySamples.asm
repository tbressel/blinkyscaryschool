        ORG     #A500
;
; Jouer un sample sur 1,2 ou 4 bit à 11Khz
; HL = adresse du sample,
; DE = longueur du sample
;
PlaySample:
	LD	H,(IX+1)
	LD	L,(IX+0)
        LD      A,(HL)                  ; Vérifier en-tête "SPL" ok
        INC     HL
        CP      'S'
        RET     NZ
        LD      A,(HL)
        INC     HL
        CP      'P'
        RET     NZ
        LD      A,(HL)
        INC     HL
        CP      'L'
        RET     NZ
        LD      A,(HL)                  ; Vérifier nbre de bits échantillon
        INC     HL
        LD      DE,PlaySample1Bit
        CP      '1'
        JR      Z,PlaySampleSet
        LD      DE,PlaySample2Bits
        CP      '2'
        JR      Z,PlaySampleSet
        LD      DE,PlaySample4Bits
        CP      '4'
        RET     NZ
PlaySampleSet:
        LD      (PlaySampleRout+1),DE
        LD      E,(HL)                  ; Récupère longueur échantillon
        INC     HL
        LD      D,(HL)
        INC     HL
        DI
        LD      A,2
        LD      C,0
        CALL    WriteRegPsg
        LD      A,3
        LD      C,0
        CALL    WriteRegPsg
        LD      A,7
        LD      C,#3D                   ; Activer seulement deuxième canal son
        CALL    WriteRegPsg
PlaySampleRout:
        CALL    0
        INC     HL
        DEC     DE
        LD      A,D
        OR      E
        JR      NZ,PlaySampleRout
        LD      C,D
        LD      A,9
        CALL    WriteRegPsg
        EI
        RET
;
; Routine jouer sample sur 1 bit
;
PlaySample1Bit:
        LD      B,8
PlaySample1B3:
        PUSH    BC
        RLC     (HL)
        LD      A,9                     ; Volume du canal
        LD      C,15                    ; Volume maxi
        JR      C,PlaySample1B4
        LD      C,0                     ; Volume mini
PlaySample1B4:
        CALL    WriteRegPsg
        LD      B,4
PlaySample1B5:
        DJNZ    PlaySample1B5
        POP     BC
        DJNZ    PlaySample1B3
        RET
;
; Routine jouer sample sur 2 bits
;
PlaySample2Bits:
        LD      A,4
PlaySample2Bits2:
        PUSH    AF
        RLC     (HL)
        RLC     (HL)
        LD      A,(HL)
        RLCA
        RLCA
        AND     #0F
        LD      C,A
        LD      A,9
        CALL    WriteRegPsg
        LD      B,2
PlaySample2Bits3:
        DJNZ    PlaySample2Bits3
        POP     AF
        DEC     A
        JR      NZ,PlaySample2Bits2
        RET
;
; Routine jouer sample sur 4 bits
;
PlaySample4Bits:
        LD      A,(HL)
        RRC     A
        RRC     A
        RRC     A
        RRC     A
        AND     #0F
        LD      C,A
        LD      A,9
        CALL    WriteRegPsg
        LD      B,4
PlaySample4Bits2:
        DJNZ    PlaySample4Bits2
        LD      A,(HL)
        AND     #0F
        LD      C,A
        RRC     A
        RRC     A
        RRC     A
        RRC     A
        LD      A,9
        CALL    WriteRegPsg
        LD      B,4
PlaySample4Bits3:
        DJNZ    PlaySample4Bits3
        RET

;
; Ecriture d'un registre du PSG
; A = numéro de registre
; C = valeur
;
WriteRegPsg:
        LD      B,#F4
        OUT     (C),A
        LD      B,#F6
        IN      A,(C)
        OR      #C0
        OUT     (C),A
        AND     #3F
        OUT     (C),A
        LD      B,#F4
        OUT     (C),C
        LD      B,#F6
        LD      C,A
        OR      #80
        OUT     (C),A
        OUT     (C),C
        RET

BufSaveRegPsg:
        DS      14                  ; Buffer sauvegarde regs. du PSG
