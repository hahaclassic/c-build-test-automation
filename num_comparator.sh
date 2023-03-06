#!/bin/bash
echo "comparing!"
if [ -n "$3" ]; then
  flag_verbose="-v"
else
  flag_verbose=""
fi

print_debugging()
{
  # print_debugging "text to echo" "file to cat"
  if [ -n "$flag_verbose" ] && [ -n "$2" ]; then
    printf "%s\n" "$1"
    cat "$2"
  elif [ -n "$flag_verbose" ] && [ -z "$2" ]; then
    printf "%s\n" "$1"

  fi
  #printf "\n"
}


output_mode=""
regex="^[+-]?[0-9]+[.]?[0-9]+([e][+-]?[0-9]+)?$"
file_1=$1
file_2=$2

cat "$1"
cat "$2"

touch /tmp/buffer_1
touch /tmp/buffer_2

while IFS= read -r line
do
  for word in $line; do
    if [[ $word =~ $regex ]]; then
      echo "$word"
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

print_debugging "Buffer No.1: " "/tmp/buffer_1"

echo "buffs:"
cat /tmp/buffer_1
echo "@@@"
cat /tmp/buffer_2

if cmp -s /tmp/buffer_1 /tmp/buffer_2; then
  rm /tmp/buffer_1 /tmp/buffer_2
  exit 0
else
  rm /tmp/buffer_1 /tmp/buffer_2
  exit 1
fi

