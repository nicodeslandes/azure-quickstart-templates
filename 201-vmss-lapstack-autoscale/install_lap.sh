#!/bin/bash

# work out the packages required for Apache and PHP depending on the
# current Ubuntu release
if [ `lsb_release -rs` == "16.04" ]; then
  packages=(apache2 php libapache2-mod-php)
else
  packages=(apache2 php5)
fi

# install Apache and PHP (in a loop because a lot of installs happen
# on VM init, so won't be able to grab the dpkg lock immediately)
until apt-get -y update && apt-get -y install ${packages[@]}
do
  echo "Try again"
  sleep 2
done


# write some PHP; these scripts are downloaded beforehand as fileUris
cp index.php /var/www/html/
cp do_work.php /var/www/html/
chown www-data:www-data /var/www/html/*
rm /var/www/html/index.html
# restart Apache
apachectl restart
