#!/bin/bash

echo "All files in current directory except *.c, *.h, *.sh and *.txt will be deleted."
files_to_delete=$(find . -maxdepth 1 -type f ! \( -name "*.md" -o -name "*.sh" -o -name "*.txt" -o -name "*.c" -o -name "*.h" -o -name "*gitignore" \))
printf "\nFiles that will be deleted: \n%s\nSure? [y/n] :" "$files_to_delete"
read -r users_choice

if [ "$users_choice" == "y" ]; then
  ./clean.sh
  echo "Directory now is clear!"
  exit 0
elif [ "$users_choice" == "n" ]; then
  echo "Clearing cancelled."
  exit 0
else
  echo "Input error."
  exit 1
fi
