#!/bin/bash

print_usage()
{
  printf "Usage: ./make_data.sh\n [-r] -- rebuild release version\n [-a] -- automate output\n"
}

flag_auto=""
flag_rebuild=""

while getopts "ar" flag; do
  case "$flag" in
  a) flag_auto="true" ;;
  r) flag_rebuild="true" ;;
  *) print_usage
    exit 1
    ;;
  esac
done

if [ -n "$flag_rebuild" ]; then
    ./build_release.sh
    chmod +x main.exe
fi

data_folder="./func_tests/data"
readme_main="./func_tests/data/readme.md"
readme_ok="./func_tests/data/readme_ok.md"
readme_err="./func_tests/data/readme_err.md"

if [ ! -d "$data_folder" ]; then
  mkdir func_tests/data
fi

if [ ! -f "$readme_main" ]; then
  touch func_tests/data/readme.md
fi

if [ ! -f "$readme_ok" ]; then
  touch func_tests/data/readme_ok.md
  echo "# Positive cases:" > "$readme_ok"
fi

if [ ! -f "$readme_err" ]; then
  touch func_tests/data/readme_err.md
  echo "# Negative cases: " > "$readme_err"
fi


flag=true
while [ "$flag" != "false" ]; do
  printf "Choose option:\n[pos] - Create positive data-pair\n[neg] - Create negative data-pair\n[q] - Quit.\n"
  read -p "Choice [pos/neg/q]? : " userChoice

  if [ "$userChoice" == "q" ]; then
    cat "$readme_ok" > "$readme_main"
    cat "$readme_err" >> "$readme_main"
    cp "$readme_main" .
    flag="false"
    exit 0
  fi

  if [ "$userChoice" == "pos" ]; then
    count_old=$(find func_tests/data -type f -name "pos*in.txt" | wc -l)
    count_old=$(sed "s/ //g" <<< "$count_old")
    count=$((count_old + 1))
    file_prefix="pos_"
    data_status="positive"
    readme_file="$readme_ok"

  elif [ "$userChoice" == "neg" ]; then
    count_old=$(find func_tests/data -type f -name "neg*in.txt" | wc -l)
    count_old=$(sed "s/ //g" <<< "$count_old")
    count=$((count_old + 1))
    file_prefix="neg_"
    data_status="negative"
    readme_file="$readme_err"
  fi

  # Make data
  if [ "$count" -lt 10 ]; then
    count="0${count}"
  fi

  file_in="./func_tests/data/${file_prefix}${count}_in.txt"
  file_out="./func_tests/data/${file_prefix}${count}_out.txt"
  touch "$file_in"
  touch "$file_out"

  read -p "Write a description for your ${count} ${data_status} test case: " description
  echo "### Test ${count}: [${description}]" >> "$readme_file"

  read -p "Write input data for your ${count} ${data_status} test case: " data
  echo "$data" > "$file_in"
  echo "- In : ${data}" >> "$readme_file"

  # Output data from executing
  if [ -n "$flag_auto" ]; then
  exe_file="./main.exe"
  $exe_file < "$file_in" > "$file_out"
  out_data=$(cat "$file_out")
  echo "Output for your input : ${out_data}"
  echo "- Out : ${out_data}" >> "$readme_file"

  # Output data manually
  else
    read -p "Write output data for your ${count} ${data_status} test case: " out_data
    printf "%s\n" "$out_data" > "$file_out"
    echo "- Out : ${out_data}" >> "$readme_file"
  fi

done
