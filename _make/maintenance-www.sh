APP_LOCATION="/var/www/app/songwork-app"
_MAKE_LOCATION="$APP_LOCATION/_make"
MAKE_FILE="$_MAKE_LOCATION/__make.sh"
ISNORMAL_FILE="$_MAKE_LOCATION/isNormal.txt"

echo "\n"
echo "[maintenace starts] "
whoami
date
cd "$_MAKE_LOCATION"

ISNORMAL=$(<"$ISNORMAL_FILE")
echo "$ISNORMAL";\

if [ "$ISNORMAL" = "FALSE" ] 
then
	echo "        Executing __make.sh again ..."
    ./__make.sh 1>>debug.log 2>&1 &
else
	echo "        Everything is good"
fi
