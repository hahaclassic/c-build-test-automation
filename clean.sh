#!/bin/bash

echo "All files in current directory except *.c, *.h, *.sh and *.txt will be deleted. Sure? [y/n]: "
read -r users_choice

if [ "$users_choice" == "y" ]; then
  find . -maxdepth 1 -type f ! \( -name "*.sh" -o -name "*.txt" -o -name "*.c" -o -name "*.h" \) -delete

  echo "Directory now is clear!"
  exit 0
elif [ "$users_choice" == "n" ]; then
  echo "Clearing cancelled."
  exit 0
else
  echo "Input error."
  exit 1
fi

