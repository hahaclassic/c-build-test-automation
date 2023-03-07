#!/bin/bash

find . -maxdepth 1 -type f ! \( -name "*.md" -o -name "*.sh" -o -name "*.txt" -o -name "*.c" -o -name "*.h" -o -name "*gitignore" \) -delete
