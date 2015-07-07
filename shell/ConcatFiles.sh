#!/bin/bash

#
# Dump multiple files to one text file.
# By: X. Chen 3/11/2015
#

cd my_dir;  # go to target file directory.

# define file list.
arr=(README.md manage.py my_dir/*.py);

# 1) get table of contents.
echo Table of Contents;
echo;
ct=0;  # keep a counter of file.
for i in ${arr[@]};
do
    ct=$(($ct + 1));
    echo == File $ct: "$i";  # print file name and its counter.
done

# 2) get file content.
ct=0;  # keep a counter of file.
for i in ${arr[@]};
do
    ct=$(($ct + 1));
    echo;
    echo == File $ct: "$i" ==;  # print file name and its counter.
    echo;
    cat "$i";
done
