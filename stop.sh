#! /bin/bash

ls pids/* >/dev/null 2>&1 || exit 0

cat pids/* |xargs kill
rm pids/*

exit 0;
