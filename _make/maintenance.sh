SERVICE="__make.sh"
SERVICE_PID=$(pgrep -x "$SERVICE")
LIST_FILE="/var/www/app/songwork-app/_make/__list.txt"
MAKE_FILE="/var/www/app/songwork-app/_make/__make.sh"
MAINTENANCE_LOCATION=$(pwd)
_MAKE_LOCATION="/var/www/app/songwork-app/_make"
echo "\n"
echo "[maintenace starts] "
date
cd "$_MAKE_LOCATION"
pwd

if pgrep -x "$SERVICE" >/dev/null
then
    if test -f "$LIST_FILE"
	then
	    echo "[O] __make.sh is running and __list.txt exists."
	else 
		echo "[error] __make.sh is running but __list.txt doesnt exist."
		# cd "$_MAKE_LOCATION"
		echo "        Killing process $SERVICE_PID ..."
		kill -9 "$SERVICE_PID"
		echo "        Removing .mp4 in spectrogram/out/ ..."
		rm -rf /var/www/app/songwork-app/spectrogram/out/*.mp4
		echo "        Removing *wav* in data/ ..."
	    rm -rf /var/www/app/songwork-app/data/*wav*
	    echo "        Executing __make.sh again ..."
	    #cd "$_MAKE_LOCATION"
	    # bash "$MAKE_FILE" 1>>debug.log 2>&1 &
	    runuser -l www-data -c './__make.sh 1>>debug.log 2>&1 &'
	fi
else
    if test -f "$LIST_FILE"
	then
	    echo "[error] __make.sh is not running but __list.txt exists."
	    # cd "$_MAKE_LOCATION"
	    echo "        Removing __list.txt ..."
	    rm -rf "$LIST_FILE"
	    echo "        Removing .mp4 in spectrogram/out/ ..."
		rm -rf /var/www/app/songwork-app/spectrogram/out/*.mp4
		echo "        Removing *wav* in data/ ..."
	    rm -rf /var/www/app/songwork-app/data/*wav*
	    echo "        Executing __make.sh again ..."
	    #cd "$_MAKE_LOCATION"
	    # bash "$MAKE_FILE" 1>>debug.log 2>&1 &
	    # bash ./__make.sh 1>>debug.log 2>&1 &
	    runuser -l www-data -c './__make.sh 1>>debug.log 2>&1 &'
	else 
		echo "[O] __make.sh is not running and __list.txt doesnt exist."
	fi
fi
