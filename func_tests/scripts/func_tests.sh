#!/bin/bash


# Build a project if needed
if [ "$1" == "-bld" ] || ["$2" == "-bld" ]; then
  cd ../..
  ./build_release.sh
  chmod +x main.exe
  cd func_tests/scripts
fi

if [ "$1" == "-s" ] || [ "$2" == "-s" ]; then
  str_flag="-s"
else
  str_flag=""
fi

# Positive cases
pos_ok_count=0
poses=$(find ../data -type f -name "pos*in*" | sort)
#pos_test_amount=$($poses| wc -l)
pos_test_amount=$(wc -l <<< "$poses")
pos_test_amount=$(sed "s/ //g" <<< "$pos_test_amount")

for input_file in $poses; do
  output_file="$(echo "$input_file" | sed "s/in/out/g")"
  printf "input file to pos_case: %s\n" "$input_file"
  printf "output file to pos_case: %s\n" "$output_file"


  ./pos_case.sh "$input_file" "$output_file" "$str_flag"
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

  ./neg_case.sh "$input_file" "$output_file" "$str_flag"
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






