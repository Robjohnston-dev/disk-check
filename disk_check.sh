#!/bin/bash
# disk_check.sh - shows how much free disk space this Mac has

echo "Disk Space Check"
echo "----------------"

disk_line=$(df -g /System/Volumes/Data | tail -n 1)

total_gb=$(echo "$disk_line" | awk '{print $2}')
free_gb=$(echo "$disk_line" | awk '{print $4}')

echo "Total disk size: ${total_gb} GB"
echo "Free space:      ${free_gb} GB"

if [ "$free_gb" -lt 20 ]; then
    echo "Warning: you're running low on space. Consider deleting some files."
else
    echo "Good news: you have plenty of space."
fi
