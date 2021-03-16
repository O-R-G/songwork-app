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
		# __make.sh is running but __list.txt doesnt exist
		ISNORMAL="FALSE"
		echo "[error] __make.sh is running but __list.txt doesnt exist."
		echo "        Killing process $SERVICE_PID ..."
		kill -9 "$SERVICE_PID"
		echo "        Removing .mp4 in spectrogram/out/ ..."
		rm -rf /var/www/app/songwork-app/spectrogram/out/*.mp4
		echo "        Removing *wav* in data/ ..."
	    rm -rf /var/www/app/songwork-app/data/*wav*
	fi
else
    if test -f "$LIST_FILE"
	then
		# __make.sh is not running but __list.txt exists
		ISNORMAL="FALSE"
	    echo "[error] __make.sh is not running but __list.txt exists."
	    echo "        Removing __list.txt ..."
	    rm -rf "$LIST_FILE"
	    echo "        Removing .mp4 in spectrogram/out/ ..."
		rm -rf /var/www/app/songwork-app/spectrogram/out/*.mp4
		echo "        Removing *wav* in data/ ..."
	    rm -rf /var/www/app/songwork-app/data/*wav*
	else 
		echo "[O] __make.sh is not running and __list.txt doesnt exist."
	fi
fi

# write isNormal.txt depending on $ISNORMAL
rm -rf "$ISNORMAL_FILE"
if [ "$ISNORMAL" = "FALSE" ]
then
	echo "FALSE" >> "$ISNORMAL_FILE"
else
	echo "TRUE" >> "$ISNORMAL_FILE"
fi

