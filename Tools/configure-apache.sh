#!/bin/sh

userDir=.
configFile=$userDir/$USER.conf
head="<Directory \"/Users/$USER/Sites/\">"
if [ -f $configFile ]
then
	echo "Config file $configFile already exists."
else
	echo "Create config file $configFile."
	echo $head > $configFile
	echo "    Options Indexes MultiViews" >> $configFile
    echo "    AllowOverride None" >> $configFile
    echo "    Order allow,deny" >> $configFile
    echo "    Allow from all" >> $configFile
    echo "</Directory>" >> $configFile
fi
