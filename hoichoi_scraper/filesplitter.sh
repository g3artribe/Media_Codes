#!/bin/bash
FILES="/Users/sam/Downloads/JL50.mkv"
clear

for f in $FILES
do
  echo "Processing $f file..."
  echo "How long is the first part? (XX:XX:XX)"
  read part1
  echo "Name.ext for part 1?"
  read n1
  echo "When does the second part start? (XX:XX:XX)"
  read part2
  echo "Name.ext for part 2?"
  read n2

  avconv -i "$f" -vcodec copy -acodec copy -t $part1 "$FILES/processed/$n1"
  avconv -i "$f" -vcodec copy -acodec copy -ss $part2 "$FILES/processed/$n2"

  clear
done

NEWFILES="$FILES/processed/*.mp4"

echo "Remove input files?"
select yn in "Yes" "No";
  do
    case $yn in
      Yes)
        for h in $FILES
          do
            echo "Deleting $h..."
            rm "$h"
          done;
        break;;

      No)
        exit;;
    esac
  done
