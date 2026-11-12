# disk_check.sh

A small Bash script that shows how much disk space your computer has and how much is free. If less than 20 GB is free, it prints a warning. Otherwise it tells you there's plenty of space.

It works on macOS and Linux.

## How to run it

```bash
chmod +x disk_check.sh
./disk_check.sh
```

Example output:

```
Disk Space Check
----------------
Total disk size:228 GB
Free space:     86 GB
Good news: you have plenty of space.
```

On macOS it checks the `/System/Volumes/Data` volume, which is where your files live. On Linux it checks the root filesystem (`/`).

## How it was tested

- **macOS:** run locally, with the numbers compared against `df -h`.
- **Linux:** run on Ubuntu in GitHub Actions CI (`.github/workflows/check.yml`). On every push and pull request, CI runs `shellcheck` on the script and then runs the script itself.

## A bug CI helped find

The first version only worked on macOS. It used `df -g` on `/System/Volumes/Data`, and on Ubuntu that path doesn't exist and `-g` isn't a valid option. So the script got no numbers back. It printed blank values for total and free space and then said "plenty of space". It also exited successfully, so the CI build passed even though the output was wrong.

The fix:

- Check `/System/Volumes/Data` only if it exists, and use `/` otherwise.
- Use `df -Pk`, which gives the same output format on macOS and Linux, and convert KB to GB in the script.
- Make sure the values are whole numbers before using them. If they aren't, print an error and exit with a failure code, so CI fails instead of passing quietly.

## Current limitations

- It only checks one volume (the main data volume on macOS, `/` on Linux). Other disks and partitions are ignored.
- Sizes are rounded down to whole GB. They're counted in units of 1024 MB, so they can look smaller than what Finder or a disk manufacturer reports.
- The 20 GB warning threshold is hard-coded.
- A low-space warning doesn't change the exit code, so other scripts can't detect it.
- CI only runs on Ubuntu. macOS has only been tested by hand.

## Credits

Written with Claude Code, and reviewed and tested by Rob Johnston.
