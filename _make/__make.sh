#!/bin/bash

# songworks
# process *.wav in folder to 16-bit
# generate spectrogram
# crop and output .mp4
# /var/www/app/songworks

# convert audio to 16-bit wav
ls

for f in 0*.wav 0*.mp3
    do
        echo $f >> __list.txt
        ffmpeg -i "$f" -acodec pcm_s16le -ar 16000 _"$f"
        rm $f
    done

# get absolute path
PATH_TO=$(pwd)
# run processing for *.wav
# crop resulting mov
# ? generate animated .gif ** todo **
for f in _*.wav _*.mp3
    do 
        echo "Processing ******** '$f'"
	# get file name
        filename=$(basename -- "$f")
        # keep file extension
        extension="${filename##*.}"
        # remove file extension
        filename="${filename%.*}"
        # remove '_' at the begining
        filename="${filename//_/$''}"
        if [ filename == "mp3" ]
        then
            ffmpeg -i "$f" _"$filename".wav
            cp _"$filename".wav ../data/in.wav
        else
            cp "$f" ../data/in.wav
        fi
        # pjava ../spectrogram/.
        /opt/processing/processing-java --sketch=$PATH_TO/../spectrogram --run
        ffmpeg -i $PATH_TO/../spectrogram/out/in-spectrogram.mp4 -filter:v "crop=360:360:0:280" $PATH_TO/../spectrogram/out/"$filename".mp4
        # 280 = 960 / 1.5 - 360
	ffmpeg -i $PATH_TO/../spectrogram/out/"$filename".mp4 -vframes 1 -an -s 360x360 -ss 6 /var/www/html/media/placeholder/"$filename".png
	# move example.mp4 to media/
	mv $PATH_TO/../spectrogram/out/"$filename".mp4 /var/www/html/media/--"$filename".mp4
	# move example.wav to media/audio/
	mv $filename.$extension /var/www/html/media/audio/
	# remove _example.wav
	rm $f
    rm ../spectrogram/out/in-spectrogram.mp4
done
php /var/www/html/views/upload-finish.php
# cleanup 
rm __list.txt
# rm _*.wav
# open -a "/System/Applications/Quicktime Player.app" ../spectrogram/out/*.mp4
echo "done."

exit
