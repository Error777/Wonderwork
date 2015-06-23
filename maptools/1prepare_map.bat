set MAPFILE_FR=fernflower_1.4.1.dmm
set MAPFILE_TGO=tgstation_2.0.7.dmm
set MAPFILE_TG=tgstation_2.1.0.dmm
set MAPFILE_OLD=oldstation.dmm
set MAPFILE_SB=spacebattle.dmm

cd ../maps
copy %MAPFILE_FR% %MAPFILE_FR%.backup
copy %MAPFILE_TGO% %MAPFILE_TGO%.backup
copy %MAPFILE_TG% %MAPFILE_TG%.backup
copy %MAPFILE_OLD% %MAPFILE_OLD%.backup
copy %MAPFILE_SB% %MAPFILE_SB%.backup

pause
