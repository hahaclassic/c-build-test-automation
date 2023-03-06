#!/bin/bash

# Works when main.exe file is already created in the root folder

input_data=$1
output_data=$2

if [ -z "$input_data" -o -z "$output_data" ]; then
  echo "[ERR] I/O data-pair doesn't exist."
  exit 1
else

  if [ -n "$3" ]; then
    comparator="../.././str_comparator.sh"
  else
    comparator="../.././num_comparator.sh"
  fi

  if [ -n "$4" ]; then
    flag_verbose="-v"
  else
    flag_verbose=""
  fi

  test_num=$(echo "$input_data" | grep -o -E "[0-9]+")
  touch ../data/buffer_out.txt
  buffer="../data/buffer_out.txt"
  exe_file="../../main.exe"

  $exe_file < "$input_data" > "$buffer"
  $comparator "$output_data" "$buffer" "$flag_verbose"
  return_code="$?"

  if [ "$return_code" == "0" ]; then
    echo "Positive test ${test_num} : PASS"
    exit 0
  else
    echo "Positive test ${test_num} : FAIL"
    exit 1
  fi
fi

