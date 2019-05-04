#!/bin/bash

export PROCESS_COUNT=$(grep -c processor /proc/cpuinfo)
export MSE_PATH=./mse-sets/$1

echo "Generating $MSE_PATH."

export PROCESS_ID=$1-$RANDOM

export TMP_PATH=/tmp/$PROCESS_ID

rm -rf $TMP_PATH
mkdir -p $TMP_PATH
7z x -y -o$TMP_PATH $MSE_PATH > /dev/null

export GENERATE_COUNT=$(ls $TMP_PATH/*.jpg | wc -l)

echo "$GENERATE_COUNT images found."

mkdir -p  $TMP_PATH/images

echo "Generating images of $MSE_PATH."

pm2 start ./MagicSetEditor/mse.com --interpreter wine --name $PROCESS_ID -- --export $MSE_PATH $TMP_PATH/images/{card.gamecode}.png

CURRENT_COUNT=0
while (($CURRENT_COUNT != $GENERATE_COUNT))
do
    CURRENT_COUNT=$(ls $TMP_PATH/images | wc -l)
done

pm2 delete $PROCESS_ID

echo "Resizing images of $MSE_PATH."

ls $TMP_PATH/images/ | sed -e "s/\.png$//" | xargs -I {} -P $PROCESS_COUNT convert $TMP_PATH/images/{}.png -resize 322x433! $PWD/images/picture/card/{}.jpg
rm -rf $TMP_PATH

echo "Finished generating $MSE_PATH."
