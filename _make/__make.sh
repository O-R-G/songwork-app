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
echo $PATH_TO
        cp "$f" ../data/in.wav
        # pjava ../spectrogram/.
        /processing/processing-java --sketch=$PATH_TO/../spectrogram --run
        ffmpeg -i $PATH_TO/../spectrogram/out/in-spectrogram.mp4 -filter:v "crop=720:720:0:720" $PATH_TO/../spectrogram/out/"$f".mp4
        rm ../spectrogram/out/in-spectrogram.mp4
done

# cleanup 
rm __list.txt
rm _*.wav
# open -a "/System/Applications/Quicktime Player.app" ../spectrogram/out/*.mp4
echo "done."

exit
