O-R-G inc.
July 14, 2020

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



++ running processing on a *nix server (ubuntu 20.4.6) ++

1. install java 8 on the server. use Oracle Java 8, not OpenJDK or 
another version. though it's suggested to use the java that comes with 
Processing package, installed from Oracle directly: 

    * https://www.oracle.com/java/technologies/javase-server-jre8-downloads.html. 

    Download Linux x64 on the page.

    * https://stackoverflow.com/questions/55920389/e-package-oracle-java8-installer-has-no-installation-candidate

    do not use java 11 as in the tutorial here: 

    * https://www.digitalocean.com/community/tutorials/how-to-install-java-with-apt-on-ubuntu-18-04
   
    scp the downloaded file to the server

    uncompress the file and mv it to /opt/jdk/. mkdir if necessary, it will be 

        /opt/jdk/jdk1.8.0_<version>

    > sudo add-apt-repository ppa:webupd8team/java

    > sudo update-alternatives --install /usr/bin/java java /opt/jdk/jdk1.8.0_<version>/bin/java 100

    > sudo update-alternatives --install /usr/bin/javac javac /opt/jdk/jdk1.8.0_<version>/bin/javac 100

    > sudo update-alternatives --config java
    (pick the one we installed as the default java)

    > sudo nano /etc/environment/
    
    add
            
    JAVA_HOME="/opt/jdk/jdk1.8.0_<version>"
    _JAVA_OPTIONS="-XX:ParallelGCThreads=2"

    (_JAVA_OPTIONS is to reduce the memory it uses)
    
    > source /etc/environment/
    
    test the java version with
        
    > java -version
    > javac -version

2. install processing simply uncompress the tar file to /opt/ following: 

    * https://youtu.be/S1Nf9mP-h8Q) 

    /opt/processing

2. execute processing-java with 

    > /opt/processing-<version>/processing-java. 

    (don't copy it to /usr/local/bin/ in the bash code)

3. update location of processing-java tool in __make.sh

    > sudo nano /var/www/app/songwork-app/__make.sh
    
    /processing/processing-java

4. update all the paths locating to songworks/ in .pde files

5. download minim and VideoExport libraries and put them in ~/sketchbook/libraries
   
    after running a sketch once a directory "sketchbook" will be created 
    with a relative path "../../../sketchbook". So it is added under 
    /var/www/ in our case.
    
    download minim and VideoExport libraries and install in 
    
    /var/www/sketchbook/libraries

    VideoExport should be downloaded here instead of the GitHub page:*

    * https://funprogramming.org/VideoExport-for-Processing/ 

6. install ffmpeg
    
    > sudo apt update
    > sudo apt install ffmpeg 

7. permissions and environment vars

    > sudo chown -R www-data:www-data opt/jdk/jdk1.8.0_<version>/
    > sudo chown -R www-data:www-data /opt/processing-<version>/
    > sudo chown -R www-data:www-data /var/www/app/songwork-app
    > sudo chown -R www-data:www-data /var/www/html/media/ 

    > sudo nano /etc/apache2/envvars
            
    export HOME="/var/www/app/songwork-app"
    export JAVA_HOME="/opt/jdk/jdk1.8.0_<version>"

    > sudo systemctl restart apache2

8. running java in headless mode

    don't really know but probably option 2 in this tutorial: 

    * https://github.com/processing/processing/wiki/Running-without-a-Display

    > sudo apt-get install xvfb libxrender1 libxtst6 libxi6
    > sudo Xvfb :1 -screen 0 1024x768x24 </dev/null & export DISPLAY=":1"

    export DISPLAY=:1 sets up a virtual display for processing output

9. run bash script

    > ./__make.sh
