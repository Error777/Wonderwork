set MAPFILE_FR=fernflower_1.4.1.dmm
set MAPFILE_TGO=tgstation_2.0.7.dmm
set MAPFILE_TG=tgstation_2.1.0.dmm
set MAPFILE_OLD=oldstation.dmm
set MAPFILE_SB=spacebattle.dmm

java -jar MapPatcher.jar -clean ../maps/%MAPFILE_FR%.backup ../maps/%MAPFILE_FR% ../maps/%MAPFILE_FR%
java -jar MapPatcher.jar -clean ../maps/%MAPFILE_TGO%.backup ../maps/%MAPFILE_TGO% ../maps/%MAPFILE_TGO%
java -jar MapPatcher.jar -clean ../maps/%MAPFILE_TG%.backup ../maps/%MAPFILE_TG% ../maps/%MAPFILE_TG%
java -jar MapPatcher.jar -clean ../maps/%MAPFILE_OLD%.backup ../maps/%MAPFILE_OLD% ../maps/%MAPFILE_OLD%
java -jar MapPatcher.jar -clean ../maps/%MAPFILE_SB%.backup ../maps/%MAPFILE_SB% ../maps/%MAPFILE_SB%

pause
