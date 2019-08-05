#!/bin/bash

#export PROCESS_COUNT=$(grep -c processor /proc/cpuinfo)
#export PROCESS_COUNT=$1

echo "Fetching datas."

cd ./images
git fetch origin master
git reset --hard FETCH_HEAD

#cd ../ygopro-database
#git fetch origin master
#git reset --hard FETCH_HEAD

cd ../cdb/
git fetch origin master
git reset --hard FETCH_HEAD

cd ..

#cd ./YGOArtworks/
#git fetch origin master
#git reset --hard FETCH_HEAD
#cd ..


#merge cdbs
echo "Generating database."
rm -rf ./ygopro-database/locales/en-US/cards.cdb
ls ./cdb/*.cdb | xargs -I {} sqlite3 {} .dump | sqlite3 ./ygopro-database/locales/en-US/cards.cdb
 
#echo '{}' > ./records.json 

echo "Generating mse files."
rm -rf ./mse-sets/ 
ruby --external-encoding=utf-8 generate.rb en-US

echo "Generating images."
#pm2 list
ls ./mse-sets/ | xargs -I {} ./mse.sh {}

echo "Pushing to GitHub."
cd images
git add .
git commit -m "Auto generate"
git push -f origin master
cd ..
