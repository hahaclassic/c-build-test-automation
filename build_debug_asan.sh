#!/bin/bash

# Compiling
if gcc -std=c99 -fsanitize=address -fno-omit-frame-pointer -g3 -O0 -c main.c; then
  echo "[OK] - successful debug compilation with ADDRESS sanitizer."
else
  echo "[ERR] - unable to debug compile main.c with ADDRESS sanitizer."
  exit 1
fi

# Linking
if gcc -o main.exe main.o -fsanitize=address -fno-omit-frame-pointer; then
  echo "[OK] - successful debug linking with ADDRESS sanitizer."
  exit 0
else
    echo "[ERR] - unable to debug link main.o with ADDRESS sanitizer."
    exit 1
fi