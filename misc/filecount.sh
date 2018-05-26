#!/bin/sh
find . -type d | while read folder; do
find $folder -maxdepth 1 -type f | wc -l | awk -v folder="$folder" '{printf("%-30s\t%-10s\n", folder, $0)}'
done | sort -n -k2 | awk 'BEGIN{printf("%-30s\t%-10s\n", "Folder", "Filecount")}{print $0}'
