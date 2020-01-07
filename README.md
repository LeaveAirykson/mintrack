# Mintrack

A very small bash script that writes parameters (=tasks) into a hidden textfile in your home folder.

## Install

Before you install Mintrack, make sure the folder `~/bin/` exists.

```bash
curl -LJ -H 'Cache-Control: no-cache' https://raw.githubusercontent.com/LeaveAirykson/mintrack/master/mintrack.sh > ~/bin/track
```

## Options
|Option|Desc|
|---|---|
|`track [task]`|This will write the `[task]` prepended by the current date inside `~/.mintrack`.|
|`track -u`|Update Mintrack.|
|`track -h`|Show help and the available options.|
|`track -a`|List all entries from `~/.mintrack`.|
|`track -l`|List the current entry from `~/.mintrack`.|
|`track -e`|Empty the file `~/.mintrack`.|
|`track -d [MM-DD-YYY] [task]`|Track the task with a different date.|
|`track -r`|Uninstall mintrack by deleting `~/.mintrack` and `~/bin/track`.|

### Examples
```bash
# Track a task directly
track WSRelease1.2.3

# For longer tasks use quotes
track "I worked 6h on the WSRelease1.2.3"

# Omit any option to show option prompt
track
```