#!/bin/bash

string="Result:"

file_1=$1
file_2=$2
touch /tmp/buffer_1
touch /tmp/buffer_2


flag=false
while read -r line
do

	if [ "$flag" = "true" ]; then
		echo "$line" >> /tmp/buffer_1
	else
		for word in $line; do
			if [[ $word =~ $string ]]; then
				(sed -n -e "s/^.*\(Result:.*\)/\1/p" <<< "$line") > /tmp/buffer_1
				flag=true
				break
			fi
		done
	fi
done < "$file_1"

flag=false
while read -r line
do

	if [ "$flag" = "true" ]; then
		echo "$line" >> /tmp/buffer_2
	else
		for word in $line; do
			if [[ $word =~ $string ]]; then
				(sed -n -e "s/^.*\(Result:.*\)/\1/p" <<< "$line") > /tmp/buffer_2
				flag=true
				break
			fi
		done
	fi
done < "$file_2"

if cmp -s /tmp/buffer_1 /tmp/buffer_2; then
  rm /tmp/buffer_1 /tmp/buffer_2

  exit 0
else
  rm /tmp/buffer_1 /tmp/buffer_2

  exit 1
fi

