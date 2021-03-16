SERVICE="__make.sh"
SERVICE_PID=$(pgrep -x "$SERVICE")
APP_LOCATION="/var/www/app/songwork-app"
_MAKE_LOCATION="$APP_LOCATION/_make"
LIST_FILE="$_MAKE_LOCATION/__list.txt"
MAKE_FILE="$_MAKE_LOCATION/__make.sh"
ISNORMAL_FILE="$_MAKE_LOCATION/isNormal.txt"
ISNORMAL="TRUE"

echo "\n"
echo "[maintenace starts] "
whoami
date

if pgrep -x "$SERVICE" >/dev/null
then
    if test -f "$LIST_FILE"
	then
	    echo "[O] __make.sh is running and __list.txt exists."
	else 
		ISNORMAL="FALSE"
		echo "[error] __make.sh is running but __list.txt doesnt exist."
		echo "        Killing process $SERVICE_PID ..."
		kill -9 "$SERVICE_PID"
		echo "        Removing .mp4 in spectrogram/out/ ..."
		rm -rf /var/www/app/songwork-app/spectrogram/out/*.mp4
		echo "        Removing *wav* in data/ ..."
	    rm -rf /var/www/app/songwork-app/data/*wav*
	    # echo "        Executing __make.sh again ..."
	    #cd "$_MAKE_LOCATION"
	    # bash "$MAKE_FILE" 1>>debug.log 2>&1 &
	    # runuser -l reinfurt -c './__make.sh 1>>debug.log 2>&1 &'
	    # php submit-response.php
	fi
else
    if test -f "$LIST_FILE"
	then
		ISNORMAL="FALSE"
	    echo "[error] __make.sh is not running but __list.txt exists."
	    # cd "$_MAKE_LOCATION"
	    echo "        Removing __list.txt ..."
	    rm -rf "$LIST_FILE"
	    echo "        Removing .mp4 in spectrogram/out/ ..."
		rm -rf /var/www/app/songwork-app/spectrogram/out/*.mp4
		echo "        Removing *wav* in data/ ..."
	    rm -rf /var/www/app/songwork-app/data/*wav*
	    # echo "        Executing __make.sh again ..."
	    #cd "$_MAKE_LOCATION"
	    # bash "$MAKE_FILE" 1>>debug.log 2>&1 &
	    # bash ./__make.sh 1>>debug.log 2>&1 &
	    # runuser -l reinfurt -c './__make.sh 1>>debug.log 2>&1 &'
	    # php submit-response.php
	else 
		echo "[O] __make.sh is not running and __list.txt doesnt exist."
	fi
fi

rm -rf "$ISNORMAL_FILE"
if [ "$ISNORMAL" = "FALSE" ]
then
	echo "FALSE" >> "$ISNORMAL_FILE"
else
	rm -rf "$ISNORMAL_FILE"
	echo "TRUE" >> "$ISNORMAL_FILE"
fi

