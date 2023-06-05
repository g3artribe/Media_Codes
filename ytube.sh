#!/bin/sh



if [ -z "$1" ]
  then
    echo "Input URL:"
    read url
  else
    url=$1
fi


yt-dlp $1 -f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/mp4' -o '%(title)s.%(ext)s'
