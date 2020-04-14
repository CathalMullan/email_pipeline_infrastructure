#!/usr/bin/env bash

# cd to current folder
cd "$(dirname "${0}")" || exit

time ./X_stack_delete.sh
time ./X_stack_create.sh
