[script/scriptreplay](https://www.redhat.com/sysadmin/record-terminal-script-scriptreplay) wrapper script which allows you to record your SSH terminal commands and session and replay them. The resulting recorded plain text typescript based files are saved as gzip compressed `cmds.gz` and `time.txt.gz` files to save disk space and allows replaying of the saved compressed files via this wrapper script.

This wrapper script uses `script` and `scriptreplay` commands.

```
script --help

Usage:
 script [options] [file]

Make a typescript of a terminal session.

Options:
 -a, --append                  append the output
 -c, --command <command>       run command rather than interactive shell
 -e, --return                  return exit code of the child process
 -f, --flush                   run flush after each write
     --force                   use output file even when it is a link
 -q, --quiet                   be quiet
 -t[<file>], --timing[=<file>] output timing data to stderr or to FILE
 -h, --help                    display this help
 -V, --version                 display version

For more details see script(1).
```

```
scriptreplay --help

Usage:
 scriptreplay [-t] timingfile [typescript] [divisor]

Play back terminal typescripts, using timing information.

Options:
 -t, --timing <file>     script timing output file
 -s, --typescript <file> script terminal session output file
 -d, --divisor <num>     speed up or slow down execution with time divisor
 -m, --maxdelay <num>    wait at most this many seconds between updates
 -h, --help              display this help
 -V, --version           display version

For more details see scriptreplay(1).
```

# Installation

You can download the `script-record.sh` script and make it executable and run it that way. Or save it a globally executable command:

```
curl -sL https://github.com/centminmod/scriptreplay/raw/master/script-record.sh -o /usr/local/bin/script-record
chmod +x /usr/local/bin/script-record
```
```
script-record 

Usage:

/usr/local/bin/script-record rec SESSION_NAME
/usr/local/bin/script-record play /path/to/cmds.gz /path/to/time.txt.gz
/usr/local/bin/script-record play /path/to/cmds.gz /path/to/time.txt.gz 2
/usr/local/bin/script-record list
```

# Update

Updating globally executable command is the same installation:

```
curl -sL https://github.com/centminmod/scriptreplay/raw/master/script-record.sh -o /usr/local/bin/script-record
chmod +x /usr/local/bin/script-record
```

# Usage

* rec - enter your SESSION_NAME. If you do not pass a session name, the script will automatically name the session as `session`.
* play - pass the full paths to where the `cmds.gz` and `time.txt.gz` files are saved. You can optionally pass a 3rd arugument for playback speed i.e. pass `2` for [2x playback speed](#replay-speed).
* play-nogz - pass the full paths to where the uncompressed non-gzip `cmds` and `time.txt` files are saved. You can optionally pass a 3rd arugument for playback speed i.e. pass `2` for [2x playback speed](#replay-speed).
* list - list all previously saved `cmds.gz` and `time.txt.gz` files.

```
./script-record.sh

Usage:

./script-record.sh rec SESSION_NAME
./script-record.sh play /path/to/cmds.gz /path/to/time.txt.gz
./script-record.sh play /path/to/cmds.gz /path/to/time.txt.gz 2
./script-record.sh play-nogz /path/to/cmds /path/to/time.txt
./script-record.sh play-nogz /path/to/cmds /path/to/time.txt 2
./script-record.sh list
```

# script record SSH commands

record a SSH session named `cmds` which will be saved to date and timestamped directory like `/root/.script/2022-08-25/2022-08-25_23-01-40-cmds1`. If you do not pass a session name, the script will automatically name the session as `session` i.e. `/root/.script/2022-08-25/2022-08-25_23-01-40-session`.

```
./script-record.sh rec cmds1
 your_ssh_commands
```
To exit and save the recorded session, type `exit` command which will output the where the `cmds.gz` and `time.txt.gz` files are saved and used for scriptreplay playback:

```
exit

files saved:
/root/.script/2022-08-25/2022-08-25_23-01-40-cmds1/cmds.gz
/root/.script/2022-08-25/2022-08-25_23-01-40-cmds1/time.txt.gz

to replay 1x speed:
./script-record play /root/.script/2022-08-25/2022-08-25_23-01-40-cmds1/cmds.gz /root/.script/2022-08-25/2022-08-25_23-01-40-cmds1/time.txt.gz

to replay 2x speed:
./script-record play /root/.script/2022-08-25/2022-08-25_23-01-40-cmds1/cmds.gz /root/.script/2022-08-25/2022-08-25_23-01-40-cmds1/time.txt.gz 2
```

# scriptreplay replay SSH commands

Running scriptreplay via play argument when you incorrectly leave out the script saved `cmds.gz` and `time.txt.gz` previously recorded files will also list all previously saved files for easier viewing.

```
./script-record.sh play

error: required file path(s) to cmds.gz or time.txt.gz do not exist

existing files detected:
/root/.script
└── /root/.script/2022-08-25
    └── /root/.script/2022-08-25/2022-08-25_22-44-10-cmds1
        ├── /root/.script/2022-08-25/2022-08-25_22-44-10-cmds1/cmds.gz
        └── /root/.script/2022-08-25/2022-08-25_22-44-10-cmds1/time.txt.gz

2 directories, 2 files


Usage:

./script-record.sh rec SESSION_NAME
./script-record.sh play /path/to/cmds.gz /path/to/time.txt.gz
```

# Replay

Proper scriptreplay passing the previously saved `cmds.gz` and `time.txt.gz` files:

```
./script-record.sh play /root/.script/2022-08-25/2022-08-25_23-42-06-cmds1/cmds.gz /root/.script/2022-08-25/2022-08-25_23-42-06-cmds1/time.txt.gz
```

# Replay Speed

Pass a 3rd argument for playback speed i.e. 2x speed

```
./script-record.sh play /root/.script/2022-08-25/2022-08-25_23-42-06-cmds1/cmds.gz /root/.script/2022-08-25/2022-08-25_23-42-06-cmds1/time.txt.gz 2
```

![scriptreplay playback](/images/script-record-playback-01.gif)

# list saved files

```
./script-record.sh list
saved files listing:

/root/.script
└── /root/.script/2022-08-25
    ├── /root/.script/2022-08-25/2022-08-25_22-44-10-cmds1
    │   ├── /root/.script/2022-08-25/2022-08-25_22-44-10-cmds1/cmds.gz
    │   └── /root/.script/2022-08-25/2022-08-25_22-44-10-cmds1/time.txt.gz
    ├── /root/.script/2022-08-25/2022-08-25_23-01-40-cmds1
    │   ├── /root/.script/2022-08-25/2022-08-25_23-01-40-cmds1/cmds.gz
    │   └── /root/.script/2022-08-25/2022-08-25_23-01-40-cmds1/time.txt.gz
    ├── /root/.script/2022-08-25/2022-08-25_23-40-10-cmds1
    │   ├── /root/.script/2022-08-25/2022-08-25_23-40-10-cmds1/cmds.gz
    │   └── /root/.script/2022-08-25/2022-08-25_23-40-10-cmds1/time.txt.gz
    └── /root/.script/2022-08-25/2022-08-25_23-42-06-cmds1
        ├── /root/.script/2022-08-25/2022-08-25_23-42-06-cmds1/cmds.gz
        └── /root/.script/2022-08-25/2022-08-25_23-42-06-cmds1/time.txt.gz

5 directories, 8 files
```