#!/bin/bash

# songworks
# process *.wav in folder to 16-bit
# generate spectrogram
# crop and output .mp4

# convert audio to 16-bit wav
for f in *.wav 
    do
        echo $f >> __list.txt
        ffmpeg -i "$f" -acodec pcm_s16le -ar 16000 _"$f"
    done

# get absolute path
PATH_TO=$(pwd)

# run processing for *.wav
# crop resulting mov
# ? generate animated .gif ** todo **
for f in _*.wav
    do 
        echo "Processing ******** '$f'"
        cp "$f" ../data/in.wav
        # pjava ../spectrogram/.
	# get file name
	filename=$(basename -- "$f")
	# keep file extension
	extension="${filename##*.}"
	# remove file extension
	filename="${filename%.*}"
	# remove '_' at the begining
	filename="${filename//_/$''}"
        /processing/processing-java --sketch=$PATH_TO/../spectrogram --run
        ffmpeg -i $PATH_TO/../spectrogram/out/in-spectrogram.mp4 -filter:v "crop=100:100:0:0" $PATH_TO/../spectrogram/out/"$filename".mp4
	# move example.mp4 to media/
	mv $PATH_TO/../spectrogram/out/"$filename".mp4 /var/www/html/media/
	# move example.wav to media/original-audio/
	mv $filename.$extension /var/www/html/media/original-audio/
	# remove _example.wav
	rm $f
        rm ../spectrogram/out/in-spectrogram.mp4
done
# cleanup 
rm __list.txt
# rm _*.wav
# open -a "/System/Applications/Quicktime Player.app" ../spectrogram/out/*.mp4
echo "done."

exit
