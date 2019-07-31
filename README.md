# Mintrack

A very small bash script that writes parameters (=tasks) into a hidden textfile in your home folder.

## Install

The installer will place the file in your homefolder as: `~/bin/track`. Furthermore it will create the file `~/.mintrack` in which your tasks are written.

1. Download the latest release here: [Mintrack latest release](https://github.com/LeaveAirykson/mintrack/archive/master.zip).
2. Execute the script with the install option: `./mintrack.sh -i`.
3. **Done!**

## Options
|Option|Desc|
|---|---|
|`track [task]`|This will write the `[task]` prepended by the current date inside `~/.mintrack`.|
|`track -i`|This install Mintrack as a command in `~/bin/track`.|
|`track -u`|This will try to update Mintrack.|
|`track -h`|This will show the help and the available options.|
|`track -l`|This will list all entries from `~/.mintrack`.|
|`track -e`|This will empty the file `~/.mintrack`.|
|`track -d [MM-DD-YYY] [task]`|Track the task with a different date.|
|`track -r`|This will remove mintrack by deleting `~/.mintrack` and `~/bin/track`.|

### Examples
```bash
# Track a task directly
track WSRelease1.2.3

# For longer tasks use quotes
track "I worked 6h on the WSRelease1.2.3"

# Omit any option to show option prompt
track
```