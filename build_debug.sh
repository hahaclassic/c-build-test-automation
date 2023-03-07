#!/bin/bash

# Compiling
if gcc -std=c99 -O0 -g3 -c main.c; then
  echo "[OK] - successful debug compilation."
else
  echo "[ERR] - unable to debug compile main.c"
  exit 1
fi

# Linking
if gcc -o main.exe main.o; then
  echo "[OK] - successful debug linking."
  exit 0
else
    echo "[ERR] - unable to debug link main.o"
    exit 1
fi