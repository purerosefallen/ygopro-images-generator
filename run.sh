#!/bin/bash

#export PROCESS_COUNT=$(grep -c processor /proc/cpuinfo)
export PROCESS_COUNT=$2

#cd ygopro-database
#git fetch origin master
#git reset --hard FETCH_HEAD

echo "Fetching datas."

cd images
git fetch origin master
git reset --hard FETCH_HEAD

#cd ../pics
#git fetch origin master
#git reset --hard FETCH_HEAD
cd ..

#cd ./YGOTCGOCGHQPics/
#git fetch origin master
#git reset --hard FETCH_HEAD
#cd ..

wget -O ./ygopro-database/locales/en-US/cards.cdb https://github.com/shadowfox87/ygopro2/raw/master/cdb/cards.cdb

#rm -rf pics/*
#cp -rf ./YGOTCGOCGHQPics/*.png ./pics/
#mogrify -format jpg ./pics/*.png
#rename 's/png/jpg/g' ./pics/*.png

#echo '{}' > ./records.json 

echo "Generating mse files."
rm -rf ./mse-sets/ 
ruby --external-encoding=utf-8 generate.rb en-US

echo "Generating images."
pm2 list
ls ./mse-sets/ | xargs -I {} -P $PROCESS_COUNT ./mse.sh {}

echo "Pushing to GitHub."
cd images
git add .
git commit -m "Auto generate"
git push -f origin master
cd ..
