#!/bin/bash
# Written with Claude Code, tested by Rob
# disk_check.sh - shows how much free disk space this computer has (macOS and Linux)

echo "Disk Space Check"
echo "----------------"

# On modern macOS, user data lives on a separate volume. Elsewhere, check the root filesystem.
if [ -d /System/Volumes/Data ]; then
    target=/System/Volumes/Data
else
    target=/
fi

# -P gives the same POSIX output format on macOS and Linux; -k reports sizes in 1 KB blocks.
disk_line=$(df -Pk "$target" | tail -n 1)

total_kb=$(echo "$disk_line" | awk '{print $2}')
free_kb=$(echo "$disk_line" | awk '{print $4}')

# Make sure we actually got whole numbers before doing any maths with them.
# If not, fail loudly so CI notices instead of reporting "plenty of space".
for value in "$total_kb" "$free_kb"; do
    case "$value" in
        '' | *[!0-9]*)
            echo "Error: could not read disk space numbers for ${target}." >&2
            echo "df output was: ${disk_line}" >&2
            exit 1
            ;;
    esac
done

total_gb=$((total_kb / 1024 / 1024))
free_gb=$((free_kb / 1024 / 1024))

echo "Total disk size: ${total_gb} GB"
echo "Free space:      ${free_gb} GB"

if [ "$free_gb" -lt 20 ]; then
    echo "Warning: you're running low on space. Consider deleting some files."
else
    echo "Good news: you have plenty of space."
fi
