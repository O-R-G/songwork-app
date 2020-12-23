#!/bin/bash

# songworks
# process *.wav in folder to 16-bit
# generate spectrogram
# crop and output .mp4
# /var/www/app/songworks





if [ ! -f __list.txt ]
then
    # convert audio to 16-bit wav
    audio_count=`ls -1 0* 2>/dev/null | wc -l`
    while [ $audio_count != 0 ]
    do
        shopt -s nullglob
        for f in 0*
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
            
            rm "$f"

            # only deal with one audio file at a time 
            break
        done
        

        # get absolute path
        PATH_TO=$(pwd)
        # live site path
        SITE_PATH="/var/www/html" 
        # local site path
        # SITE_PATH="/Library/WebServer/Documents/songwork.local"
        # run processing for *.wav
        # crop resulting mov
        # ? generate animated .gif ** todo **
        echo "Processing ******** '_$f'"

        # audiofilename=$1

        cp _"$filename".wav ../data/"$filename".wav
        # get audio duration before moving it
        audio_duration=$(ffmpeg -i _"$filename".wav 2>&1 | grep "Duration"| cut -d ' ' -f 4 | sed s/,// | sed 's@\..*@@g' | awk '{ split($1, A, ":"); split(A[3], B, "."); print 3600*A[1] + 60*A[2] + B[1] }')
        # move example.wav to media/audio/
        mv _"$filename".wav "$SITE_PATH"/media/audio/"$filename".wav

        /opt/processing/processing-java --sketch="$PATH_TO"/../spectrogram --run "$filename"
        ffmpeg -i "$PATH_TO"/../spectrogram/out/"$filename"-spectrogram.mp4 -filter:v "crop=360:360:0:280" $PATH_TO/../spectrogram/out/"$filename".mp4
        # 280 = 960 / 1.5 - 360

        if [ "$audio_duration" -gt 12 ]
        then
            thumbnail_clip=12
        else
            thumbnail_clip="$audio_duration"
        fi
        ffmpeg -i "$PATH_TO"/../spectrogram/out/"$filename".mp4 -vframes 1 -an -s 360x360 -ss "$thumbnail_clip" "$SITE_PATH"/media/placeholder/"$filename".png
        # move example.mp4 to media/
        mv $PATH_TO/../spectrogram/out/"$filename".mp4 "$SITE_PATH"/media/--"$filename".mp4
        rm ../spectrogram/out/"$filename"-spectrogram.mp4
        # done
        php "$SITE_PATH"/views/submit-finish.php
        # cleanup 
        rm ../data/"$filename".wav ../data/"$filename".wav.txt
        # get ready for another loop
        shopt -u nullglob
        audio_count=`ls -1 0* 2>/dev/null | wc -l`
    done
    # open -a "/System/Applications/Quicktime Player.app" ../spectrogram/out/*.mp4
    rm __list.txt
    echo "done."
else
    echo "processing is running...\n"
fi
exit
