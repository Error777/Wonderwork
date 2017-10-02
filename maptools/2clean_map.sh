export MAPFILE_TG=tgstation.dmm
export MAPFILE_EFF=efficiency.dmm

java -jar MapPatcher.jar -clean ../maps/$MAPFILE_FR.backup ../maps/$MAPFILE_FR ../maps/$MAPFILE_FR
java -jar MapPatcher.jar -clean ../maps/$MAPFILE_EFF.backup ../maps/$MAPFILE_EFF ../maps/$MAPFILE_EFF

read -n1 -r -p "Press any key to continue..." key
