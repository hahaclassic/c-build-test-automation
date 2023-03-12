#!/bin/bash

cbuild()
{
source_path="/Users/nikita/Programming/clabs/testing_scripts/"
destination="$1"


#cd ~/
cp Programming/clabs/testing_scripts/*sh "$destination"

if [[ -d "Programming/clabs/testing_scripts/func_tests/" ]]; then
  cp -r Programming/clabs/testing_scripts/func_tests/scripts "$destination"
else
  cp -r Programming/clabs/testing_scripts/func_tests/ "$destination"
fi
}



