#!/bin/bash

# songworks
# process *.wav in folder to 16-bit
# generate spectrogram
# crop and output .mp4
# /var/www/app/songworks





if [ ! -f __list.txt ]
then
    # convert audio to 16-bit wav
    audio_count=`ls -1 *.wav *.mp3 *.aiff *.m4a 2>/dev/null | wc -l`
    while [ $audio_count != 0 ]
    do
        shopt -s nullglob
        for f in 0*.wav 0*.mp3 0*.aiff 0*.m4a
        do
            echo "$f" >> __list.txt
            echo "$f"
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

            # only deal with one audio file at a time 
            break
        done
        

        # get absolute path
        PATH_TO=$(pwd)
        # run processing for *.wav
        # crop resulting mov
        # ? generate animated .gif ** todo **
        echo "Processing ******** '_$f'"

        audiofilename=$1

        cp _"$filename".wav ../data/"$filename".wav
        # move example.wav to media/audio/
        mv _"$filename".wav /var/www/html/media/audio/"$audiofilename".wav

        /opt/processing/processing-java --sketch="$PATH_TO"/../spectrogram --run "$filename"
        ffmpeg -i "$PATH_TO"/../spectrogram/out/"$filename"-spectrogram.mp4 -filter:v "crop=360:360:0:280" $PATH_TO/../spectrogram/out/"$filename".mp4
        # 280 = 960 / 1.5 - 360
        ffmpeg -i "$PATH_TO"/../spectrogram/out/"$filename".mp4 -vframes 1 -an -s 360x360 -ss 6 /var/www/html/media/placeholder/"$filename".png
        # move example.mp4 to media/
        mv $PATH_TO/../spectrogram/out/"$filename".mp4 /var/www/html/media/--"$filename".mp4
        rm ../spectrogram/out/"$filename"-spectrogram.mp4
        # done
        php /var/www/html/views/submit-finish.php
        # cleanup 
        rm ../data/"$filename".wav ../data/"$filename".wav.txt
        # get ready for another loop
        shopt -u nullglob
        audio_count=`ls -1 *.wav *.mp3 *.aiff *.m4a 2>/dev/null | wc -l`
    done
    # open -a "/System/Applications/Quicktime Player.app" ../spectrogram/out/*.mp4
    rm __list.txt
    echo "done."
else
    echo "processing is running...\n"
fi
exit
