#!/bin/bash

#export PROCESS_COUNT=$(grep -c processor /proc/cpuinfo)
#export PROCESS_COUNT=$1

#cd ygopro-database
#git fetch origin master
#git reset --hard FETCH_HEAD

echo "Fetching datas."

cd images
git fetch origin master
git reset --hard FETCH_HEAD

cd ..

#cd ./YGOArtworks/
#git fetch origin master
#git reset --hard FETCH_HEAD
#cd ..

#Get cdbs
wget -O ./ygopro-database/locales/en-US/tmp/ https://github.com/szefo09/updateYGOPro2/raw/master/cards.cdb
wget -O ./ygopro-database/locales/en-US/tmp/ https://github.com/szefo09/updateYGOPro2/raw/master/official.cdb
wget -O ./ygopro-database/locales/en-US/tmp/ https://github.com/szefo09/updateYGOPro2/raw/master/prerelease.cdb

#merge cdbs
sqlite ./ygopro-database/locales/en-US/tmp/cards.cdb .dump | sqlite3 ./ygopro-database/locales/en-US/cards.cdb
sqlite ./ygopro-database/locales/en-US/tmp/official.cdb .dump | sqlite3 ./ygopro-database/locales/en-US/cards.cdb
sqlite ./ygopro-database/locales/en-US/tmp/prerelease.cdb .dump | sqlite3 ./ygopro-database/locales/en-US/cards.cdb


#echo '{}' > ./records.json 

echo "Generating mse files."
rm -rf ./mse-sets/ 
ruby --external-encoding=utf-8 generate.rb en-US

echo "Generating images."
pm2 list
ls ./mse-sets/ | xargs -I {} ./mse.sh {}

echo "Pushing to GitHub."
cd images
git add .
git commit -m "Auto generate"
git push -f origin master
cd ..
