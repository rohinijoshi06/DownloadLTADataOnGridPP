#!/bin/bash
/bin/hostname
/bin/date
/bin/ls -la
printenv

echo user=rohinijoshi> $HOME/.wgetrc
echo password=Astroniskew1 >> $HOME/.wgetrc
for value in {0..2}
do
	num=$((10#$1*3))
	index=$(($num + $value))
	# This script will have each parametric job extract a unique line (file) and print it into singleFile.txt 
	./stripFilename $index 
	# Do this magic to extract a concise file name
	fullfile=$(cat singleFile.txt)
	echo "$fullfile"
	# Basically gets everything from the last / in the path till the end
	filename="${fullfile##*/}"
	# For some reason there is a carriage return at the end of file name - remove it
	filename="${filename%?}"
	echo "$filename"
	# Change where in the file catalog you want the files to be uploaded
	lfn="/skatelescope.eu/user/r/rohini.joshi/GOODSN581359/L581367/"
	# Does the file exist on the catalog? If it does, stop. There is probably a better way to do this...
	dirac-dms-lfn-metadata $lfn$filename | grep "No such file" &> /dev/null
	if [ $? -ne 0 ]; then
	        echo "FILE EXISTS" 
		continue
	else
        	echo DOWNLOADING... 
	fi
	# Each job downloads one file
	wget -ci singleFile.txt
	ls -lrth
	
	# Since the only *.MS*.tar file will be the data that was just downloaded by the parametric job, rename it
	mv *.MS*.tar $filename
	
	echo $lfn$filename
	# Upload to file catalog
	dirac-dms-add-file -ddd "$lfn$filename" "$filename" UKI-NORTHGRID-MAN-HEP-disk
	# Delete file now uploaded to DFC to make way for the next one
	rm $filename
	rm singleFile.txt
	# Check if the file really does exist onthe DFC
	dirac-dms-lfn-metadata $lfn$filename | grep "No such file" &> /dev/null
        if [ $? -ne 0 ]; then
                echo "FILE EXISTS YAY" 
        else
                echo "DFC IS A LIAR"
        fi
done
