#!/bin/sh

if [ -z "$1" ]
  then
    echo "Input Ext:"
    read ext
  else
    ext=$1
fi

for i in *.$ext; do
  cdec=`ffprobe -v error -select_streams v:0 -show_entries stream=codec_name -of default=noprint_wrappers=1:nokey=1 "$i"`
  echo "$i $cdec"
   if [ "$cdec" != "h264" ]
    then
      ffmpeg -i "$i" -c:v libx264 -c:a aac "${i%.*}_conv.mp4"
    else
      if [[ ${i: -4} != .mp4 ]]
        then
          ffmpeg -i "$i" -codec copy "${i%.*}.mp4"
      fi
   fi
done
