#!/bin/bash

print_usage()
{
  printf "Usage: ./func_tests.sh [-b] -- rebuild release main.c version\n [-s] -- use string comparator\n [-v] -- verbose mode\n"
}
flag_rebuild=""
flag_strcomp=""
flag_verbose=""

while getopts "bsv" flag; do
  case "${flag}" in
    b) flag_rebuild="true" ;;
    s) flag_strcomp="true" ;;
    v) flag_verbose="true" ;;
    *) print_usage
        exit 1
        ;;
  esac
done

# Build a project if needed
if [ -n "$flag_rebuild" ]; then
  cd ../..
  ./build_release.sh
  chmod +x main.exe
  cd func_tests/scripts
fi

# Positive cases
pos_ok_count=0
poses=$(find ../data -type f -name "pos*in*" | sort)
#pos_test_amount=$($poses| wc -l)
pos_test_amount=$(wc -l <<< "$poses")
pos_test_amount=$(sed "s/ //g" <<< "$pos_test_amount")

for input_file in $poses; do
  output_file="$(echo "$input_file" | sed "s/in/out/g")"

  ./pos_case.sh "$input_file" "$output_file" "$flag_strcomp" "$flag_verbose"
  return_code="$?"
  if [ "$return_code" == "0" ]; then
    pos_ok_count=$((pos_ok_count + 1))
  fi
done

echo " "

# Negative cases
neg_ok_count=0
negs=$(find ../data -type f -name "neg*in*" | sort)
#neg_test_amount=$("$negs" | wc -l)
neg_test_amount=$(wc -l <<< "$negs")

neg_test_amount=$(sed "s/ //g" <<< "$neg_test_amount")


for input_file in $negs; do
  output_file="$(echo "$input_file" | sed "s/in/out/g")"

  ./neg_case.sh "$input_file" "$output_file" "$flag_strcomp" "$flag_verbose"
  return_code="$?"
  if [ "$return_code" == "0" ]; then
    neg_ok_count=$((neg_ok_count + 1))
  fi
done

echo " "
echo "############################"
echo "Statistics: "
echo "Positive tests: ${pos_ok_count} out of ${pos_test_amount}"
echo "Negative tests: ${neg_ok_count} out of ${neg_test_amount}"
echo "############################"






