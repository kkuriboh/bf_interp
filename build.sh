#!/bin/bash

nasm -f elf64 interp.asm
ld interp.o -o interp
