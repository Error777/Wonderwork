#!/bin/bash

#MAPROOT='../../_maps/map_files/'
MAPROOT="../maps/"
MAPFILES=(
	$MAPROOT"fernflower_1.4.1.dmm"
	$MAPROOT"tgstation_2.0.7.dmm"
	$MAPROOT"tgstation_2.1.0.dmm"
	$MAPROOT"oldstation.dmm"
	$MAPROOT"spacebattle.dmm"
)
for MAPFILE in "${MAPFILES[@]}"
do
	echo "Processing $MAPFILE..."
	git show HEAD:$MAPFILE > tmp.dmm
	java -jar MapPatcher.jar -clean tmp.dmm $MAPFILE $MAPFILE
	#dos2unix -U '../../_maps/map_files/'$MAPFILE
	rm tmp.dmm
	echo "----------------------"
	continue
done