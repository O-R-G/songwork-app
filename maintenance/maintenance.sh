SERVICE="__make.sh"
SERVICE_PID=$(pgrep -x "$SERVICE")
LIST_FILE="/var/www/app/songwork-app/_make/__list.txt"
MAKE_FILE="/var/www/app/songwork-app/_make/__make.sh"

if pgrep -x "$SERVICE" >/dev/null
then
    if test -f "$LIST_FILE"
	then
	    echo "__make.sh is running and __list.txt exists."
	else 
		echo "!!error!! __make.sh is running but __list.txt doesnt exist."
		kill -9 "$SERVICE_PID"
	fi
else
    if test -f "$LIST_FILE"
	then
	    echo "!!error!! __make.sh is not running but __list.txt exists."
	    rm -rf "$LIST_FILE"
	    bash "$MAKE_FILE"
	else 
		echo "__make.sh is not running and __list.txt doesnt exist."
	fi
fi
