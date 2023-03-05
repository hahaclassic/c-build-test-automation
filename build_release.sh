#!/bin/bash

# Compiling
if gcc -std=c99 -Wall -Werror -Wpedantic -Wextra -Wfloat-conversion -Wfloat-equal -Wvla -c main.c; then
  echo "[OK] - successful release compilation."
else
  echo "[ERR] - unable to release compile main.c"
  exit 1
fi

# Linking
if gcc -o main.exe main.o; then
  echo "[OK] - successful release linking."
  exit 0
else
    echo "[ERR] - unable to release link main.o"
    exit 1
fi

