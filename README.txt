O-R-G inc.
June 25, 2020

--

takes any number of .wav files in /_make/*.wav, converts to 16-bit, then runs processing script to generate spectrogram of audio written to .mp4 in spectrogram/out/*.mp4

+ requires java, see:

    * https://www.digitalocean.com/community/tutorials/how-to-install-java-with-apt-on-ubuntu-18-04

+ requires processing, available here

	* https://processing.org/download/

+ requires processing-java command line tool (included) which should be installed here: 

    > cp processing-java /usr/local/bin/
    > chmod +x /usr/local/bin/processing-java

+ requires ffmpeg, available via apt-get

    > sudo apt update
    > sudo apt install ffmpeg

+ after installs, logout and login

+ this package runs via a bash script. run like so:

    > ./_make/__make.sh

++ running processing on a *nix server ++

1. install java 8 on the server (openjdk-8-jre-headless, openjdk-8-jdk-headless)
   not java 11 as in the tutorial here: 

        * https://www.digitalocean.com/community/tutorials/how-to-install-java-with-apt-on-ubuntu-18-04
   
   (didn't install Oracle JDK be cause it won't allow repeating the same step in the tutorail for 8)

2. install processing simply uncompress the tar file to /processing following: 

    * https://youtu.be/S1Nf9mP-h8Q) 

3. use the processing-java tool that comes with the downloaded processing package. in __make.sh, change 'processing-java' to '/processing/processing-java'.
   (error was "Could not find or load main class processing.mode.java.Commander", cause the variable $APP_DIR in processing-java is /usr/local/bin/, where the folder 'mode' doesn't exist.)

4. change all the paths locating to songworks/ in .pde files.

5. download minim and VideoExport libraries and put them in ~/sketchbook/libraries
   ** VideoExport should be downloaded here instead of the GitHub page. **

    * https://funprogramming.org/VideoExport-for-Processing/ 

6. cd to bash script directory

    > cd ~/sketchbook/songworks/_make

7. export DISPLAY=:1
    (sets up a virtual display for processing output)

6. run bash script

    > ./__make.sh

