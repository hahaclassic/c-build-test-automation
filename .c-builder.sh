#!/bin/bash

cbuild()
{
source_path="/Users/nikita/Programming/clabs/testing_scripts/"
destination="$1"


cd ~/
cp Programming/clabs/testing_scripts/*sh "$destination"
cp -r Programming/clabs/testing_scripts/func_tests "$destination"
}

