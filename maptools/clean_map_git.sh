#!/bin/bash

#MAPROOT='../../maps/'
MAPROOT="../maps/"
MAPFILES=(
	$MAPROOT"fernflower.dmm"
	$MAPROOT"efficiency.dmm"

)
for MAPFILE in "${MAPFILES[@]}"
do
	echo "Processing $MAPFILE..."
	git show HEAD:$MAPFILE > tmp.dmm
	java -jar MapPatcher.jar -clean tmp.dmm $MAPFILE $MAPFILE
	#dos2unix -U '../../maps/'$MAPFILE
	rm tmp.dmm
	echo "----------------------"
	continue
done
