set MAPFILE_FR=fernflower.dmm
set MAPFILE_EFF=efficiency.dmm

java -jar MapPatcher.jar -clean ../maps/%MAPFILE_FR%.backup ../maps/%MAPFILE_FR% ../maps/%MAPFILE_FR%
java -jar MapPatcher.jar -clean ../maps/%MAPFILE_EFF%.backup ../maps/%MAPFILE_EFF% ../maps/%MAPFILE_EFF%

pause
