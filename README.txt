O-R-G inc.
June 25, 2020

--

takes any number of .wav files in /_make/*.wav, converts to 16-bit, then runs processing script to generate spectrogram of audio written to .mp4 in spectrogram/out/*.mp4

+ requires java, see:

    * https://www.digitalocean.com/community/tutorials/how-to-install-java-with-apt-on-ubuntu-18-04

+ requires processing, available here

	* https://processing.org/download/

+ requires processing-java command line tool (included) which should be installed here: 

    > cp processing-java /opt/processing/
    > chmod +x /opt/processing/processing-java

+ install processing libraries
  1. After running a sketch once, a directory "sketchbook" will be created at a relative path "../../../sketchbook".
  2. Download minim and VideoExport libraries:
    http://code.compartmental.net/minim/
    https://funprogramming.org/VideoExport-for-Processing/ (!!Don't download VideoExport on its github page)
  3. Put them in sketchbook/libraries.
    
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

5. add the working user to group www-data

    > useradd -g www-data $username

6. change the owner/group of these files/directories to www-data:www-data

    * all the .txt and .pde in songwork-app/
    * /opt/jdk/jdk1.8.0_<version>/
    * /opt/processing-<version>/
    * /var/www/html/media/

7. download minim and VideoExport libraries and put them in sketchbook/libraries
   ** VideoExport should be downloaded here instead of the GitHub page. **

    * https://funprogramming.org/VideoExport-for-Processing/ 

8. envvar
    > sudo nano /etc/apache2/envvars
    
    add
      export HOME="/var/www/app/songwork-app"
      export JAVA_HOME="/opt/jdk/jdk1.8.0_<version>"

    > sudo systemctl restart apache2

9. cd to bash script directory

    > cd /path/to/sonwork-app/_make

10. export DISPLAY=:1
    (sets up a virtual display for processing output)

11. run bash script

    > ./__make.sh

+ running java without $DISPLAY (if the DISPLAY-relevant error pops up)
https://github.com/processing/processing/wiki/Running-without-a-Display
(using option 2 of the tutorial above)

1. sudo apt-get install xvfb libxrender1 libxtst6 libxi6

2. sudo Xvfb :1 -screen 0 1024x768x24 </dev/null &

3. export DISPLAY=":1"

--

upload queue workflow

1. After a file is submitted, it will be moved to _make/ and __make.sh is called.

2. __make.sh checks if there's a file named "__list.txt"* in make/.
    true   ->  there's another file that is being processed now. exit.
    false  ->  Go to 3.

3. Run a while loop to check if there's audio file in make/ by the variable $audio_count.
    true   ->  Go to 4.
    false  ->  all the audio files are processed. rm __list.txt. exit.

4. Create/edit __list.txt. Process the audio and move it out of make/. Update $audio_count. Bo back to 3.

* __list.txt is for __make.sh to check if there's a process running when it is called. If __list.txt exists, that means there's already a process running thus __make.sh can leave it and exit. Else __make.sh will start a process and create a __list.txt. 

--
