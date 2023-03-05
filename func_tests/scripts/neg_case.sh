#!/bin/bash

# Works when main.exe file is already created in the root folder

input_data=$1
output_data=$2

if [ -z "$input_data" -o -z "$output_data" ]; then
  echo "[ERR] I/O data-pair doesn't exist."
  exit 1
else
    test_num=$(echo "$input_data" | grep -o -E "[0-9]+")
    touch ../data/buffer_out.txt
    buffer="../data/buffer_out.txt"
    exe_file="../../main.exe"
    comparator="../.././num_comparator.sh"

    $exe_file < "$input_data" > "$buffer"
    return_code_exe="$?"

    $comparator "$output_data" "$buffer"
    return_code_diff="$?"

    if [[ "$return_code_exe" != "0" ]]; then
      if [ "$return_code_diff" == "0" ]; then
        echo "Negative test ${test_num} : PASS"
        exit 0
      else
        echo "Negative test ${test_num} : FAIL (Different output data)"
        exit 1
      fi
    else
      echo "Negative test ${test_num} : FAIL (Zero return code)"
      exit 1
    fi
fi
