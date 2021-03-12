SERVICE="__make.sh"
SERVICE_PID=$(pgrep -x "$SERVICE")
LIST_FILE="/var/www/app/songwork-app/_make/__list.txt"
MAKE_FILE="/var/www/app/songwork-app/_make/__make.sh"
MAINTENANCE_LOCATION=$(pwd)
_MAKE_LOCATION="/var/www/app/songwork-app/_make"
echo "\n"
echo "[maintenace starts] "
whoami
date
cd "$_MAKE_LOCATION"
pwd
if "$RUNAGAIN_MAKE"
then
	echo "        Executing __make.sh again ..."
    # cd "$_MAKE_LOCATION"
    # bash "$MAKE_FILE" 1>>debug.log 2>&1 &
    ./__make.sh 1>>debug.log 2>&1 &
    RUNAGAIN_MAKE=0
fi