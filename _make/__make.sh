#!/bin/bash

# songworks
# process *.wav in folder to 16-bit
# generate spectrogram
# crop and output .mp4
# /var/www/app/songworks

# convert audio to 16-bit wav
shopt -s nullglob
for f in 0*.wav 0*.mp3 0*.aiff 0*.m4a
    do
        echo $f >> __list.txt
        # get file name
        filename=$(basename -- "$f")
        # keep file extension
        extension="${filename##*.}"
        # remove file extension
        filename="${filename%.*}"

        if [ $extension != "wav" ]
        then
            echo 'converting non wav file'
            ffmpeg -i "$f" "$filename".wav
            ffmpeg -i "$filename".wav -acodec pcm_s16le -ar 16000 _"$filename".wav
            rm "$filename".wav
        else
            ffmpeg -i "$f" -acodec pcm_s16le -ar 16000 _"$f"
        fi
        
        rm $f
    done

# get absolute path
PATH_TO=$(pwd)
# run processing for *.wav
# crop resulting mov
# ? generate animated .gif ** todo **
# for f in _*.wav
#     do 
        echo "Processing ******** '$f'"
	    # get file name
        #filename=$(basename -- "$f")
        # keep file extension
        #extension="${filename##*.}"
        # remove file extension
        #filename="${filename%.*}"
        # remove '_' at the begining
        #filename="${filename//_/$''}"

        cp _"$filename".wav ../data/"$filename".wav
        # move example.wav to media/audio/
        mv _"$filename".wav /var/www/html/media/audio/"$filename".wav
        # pjava ../spectrogram/.
        /opt/processing/processing-java --sketch=$PATH_TO/../spectrogram --run "$filename"
        ffmpeg -i $PATH_TO/../spectrogram/out/"$filename"-spectrogram.mp4 -filter:v "crop=360:360:0:280" $PATH_TO/../spectrogram/out/"$filename".mp4
        # 280 = 960 / 1.5 - 360
    	ffmpeg -i $PATH_TO/../spectrogram/out/"$filename".mp4 -vframes 1 -an -s 360x360 -ss 6 /var/www/html/media/placeholder/"$filename".png
    	# move example.mp4 to media/
    	# mv $PATH_TO/../spectrogram/out/"$filename".mp4 /var/www/html/media/--"$filename".mp4
    	
    	# remove _example.wav
    	# rm $f
        rm ../spectrogram/out/"$filename"-spectrogram.mp4
# done
php /var/www/html/views/submit-finish.php
# cleanup 
rm __list.txt
# rm _*.wav
# open -a "/System/Applications/Quicktime Player.app" ../spectrogram/out/*.mp4
echo "done."

exit
