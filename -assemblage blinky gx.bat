C:
cd C:\Users\Utilisateur\Documents\BlinkyGX4000_vers3.0\
rasm contenu_cartouche\map_tiles\maptile_decors.asm -ob contenu_cartouche\map_tiles\decors.prg
rasm contenu_cartouche\map_tiles\maptile_decors2.asm -ob contenu_cartouche\map_tiles\decors2.prg
rasm contenu_cartouche\map_tiles\maptile_decors3.asm -ob contenu_cartouche\map_tiles\decors3.prg
rasm contenu_cartouche\map_tiles\maptile_decors4.asm -ob contenu_cartouche\map_tiles\decors4.prg
rasm contenu_cartouche\map_tiles\maptile_decors5.asm -ob contenu_cartouche\map_tiles\decors5.prg
rasm contenu_cartouche\map_tiles\maptile_decors6.asm -ob contenu_cartouche\map_tiles\decors6.prg
rasm table_ennemis.asm -ob contenu_cartouche\tables\table_ennemis.prg
rasm	sample.asm _ob sample.bin


rasm creation_cartouche_blinky.asm -sw -sq -o ./blinkygx
C:\Users\Utilisateur\Documents\BlinkyGX4000_vers3.0\WinAPE20B2\WinApe.exe  /sym:blinkygx.sym blinkygx.cpr
cmd 
   

