defw #0700+%111000 ; ALL channels ON
defw 0,8,0,9,0,10  ; ALL volumes to ZERO
include 'ahou216-3.raw' ; generated DMA list
defw #0700+%111111 ; channel OFF
defw #4020   