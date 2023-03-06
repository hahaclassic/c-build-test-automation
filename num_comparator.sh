#!/bin/bash

regex="^[+-]?[0-9]+[.]?[0-9]+([e][+-]?[0-9]+)?$"
file_1=$1
file_2=$2

echo "inputs:"
cat "$file_1"
echo "###"
cat "$file_2"


touch /tmp/buffer_1
touch /tmp/buffer_2

while IFS= read -r line
do
  for word in $line; do
    echo "hook"
    if [[ $word =~ $regex ]]; then
      echo "$word" >> /tmp/buffer_1
    fi
  done
done < "$file_1"

while IFS= read -r line
do
  for word in $line; do
    if [[ $word =~ $regex ]]; then
      echo "$word" >> /tmp/buffer_2
    fi
  done
done < "$file_2"

echo "buffs"
cat /tmp/buffer_1
echo " "
cat /tmp/buffer_2

if cmp -s /tmp/buffer_1 /tmp/buffer_2; then
  rm /tmp/buffer_1 /tmp/buffer_2
  exit 0
else
  rm /tmp/buffer_1 /tmp/buffer_2
  exit 1
fi

