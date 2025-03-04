#! /bin/bash
clear
echo '-----------------------------------'
echo pushing version "$1" to main branch
echo '-----------------------------------'
git add .
git commit -a -m "$1"
git push
