O-R-G inc.
June 25, 2020

--

takes any number of .wav files in /_make/*.wav, converts to 16-bit, 
then runs processing script to generate spectrogram of audio
written to .mp4 in spectrogram/out/*.mp4

+ requires java, see:

    * https://www.digitalocean.com/community/tutorials/how-to-install-java-with-apt-on-ubuntu-18-04

+ requires processing, available here

	* https://processing.org/download/

+ requires processing-java command line tool (included) 
  which should be installed here: 

    > cp processing-java /usr/local/bin/
    > chmod +x /usr/local/bin/processing-java

+ requires ffmpeg, available via apt-get

    > sudo apt update
    > sudo apt install ffmpeg

+ after installs, logout and login to update env vars

+ this package runs via a bash script. run like so:

    > ./_make/__make.sh

