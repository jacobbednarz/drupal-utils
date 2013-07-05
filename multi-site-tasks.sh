#!/usr/bin/env bash
#
# Run mutliple commands within the multisite environments.
#
# Usage:
#   ./multiple-site-tasks.sh
#
# Author: Jacob Bednarz <jacob_bednarz@flightcentre.com>

# Get all Drupal sites
sites=`find ../docroot/sites -maxdepth 1 -type d -print | grep -v '/all$' | grep -v '/default$' | grep -v '\.$'`

echo "Choose the commande to execute : "
echo "[ 1 ] Run DB updates"
echo "[ 2 ] Put sites offline"
echo "[ 3 ] Put sites online"
echo "[ 4 ] Clear all caches"
echo "[ 5 ] Clear CSS and JavaScript caches"
echo "[ 6 ] Clear another specific cache"
echo "[ 7 ] Install specific module"
echo "[ 8 ] Disable specific module"
echo "[ 9 ] Find the status of a module on a site"
read choice

if [ $choice -gt 6 ] ; then
  echo -n "Extension (module/theme) name? "
  read ext
fi

# For each site, execute the command
for site in $sites
do
  echo ----------
  echo $site
  cd $site
  if [ $choice -eq 1 ] ; then
    drush updatedb
  elif [ $choice -eq 2 ] ; then
    drush vset --always-set maintenance_mode 1
  elif [ $choice -eq 3 ] ; then
    drush vset --always-set maintenance_mode 0
  elif [ $choice -eq 4 ] ; then
    drush cc all
  elif [ $choice -eq 5 ] ; then
    drush cc css+js
  elif [ $choice -eq 6 ] ; then
    drush cc
  elif [ $choice -eq 7 ] ; then
    drush pm-enable -y $ext
  elif [ $choice -eq 8 ] ; then
    drush pm-disable -y $ext  
  elif [ $choice -eq 9 ] ; then
    drush pm-list | grep "$ext"
  fi
  cd ../
done
