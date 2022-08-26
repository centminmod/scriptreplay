[script/scriptreplay](https://www.redhat.com/sysadmin/record-terminal-script-scriptreplay) wrapper script. Which saves the resulting recorded files as gzip compressed `cmds.gz` and `time.txt.gz` files to save disk space and allows replaying of the saved compressed files.

# Usage

* rec - enter your SESSION_NAME
* play - pass the full paths to where the `cmds.gz` and `time.txt.gz` files are saved
* list - list all previously saved `cmds.gz` and `time.txt.gz` files

```
./script-record.sh

Usage:

./script-record.sh rec SESSION_NAME
./script-record.sh play /path/to/cmds.gz /path/to/time.txt.gz
./script-record.sh play /path/to/cmds.gz /path/to/time.txt.gz 2
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
/root/.script/2022-08-25/2022-08-25_23-01-40-cmds1/cmds.gz
/root/.script/2022-08-25/2022-08-25_23-01-40-cmds1/time.txt.gz
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

Proper scriptreply passing the previously saved `cmds.gz` and `time.txt.gz` files:

```
./script-record.sh play /root/.script/2022-08-25/2022-08-25_22-44-10-cmds1/cmds.gz /root/.script/2022-08-25/2022-08-25_22-44-10-cmds1/time.txt.gz
```

# Replay Speed

Pass a 3rd argument for playback speed i.e. 2x speed

```
./script-record.sh play /root/.script/2022-08-25/2022-08-25_22-44-10-cmds1/cmds.gz /root/.script/2022-08-25/2022-08-25_22-44-10-cmds1/time.txt.gz 2
```

# list saved files

```
./script-record.sh list
saved files listing:

/root/.script
└── /root/.script/2022-08-25
    ├── /root/.script/2022-08-25/2022-08-25_22-44-10-cmds1
    │   ├── /root/.script/2022-08-25/2022-08-25_22-44-10-cmds1/cmds.gz
    │   └── /root/.script/2022-08-25/2022-08-25_22-44-10-cmds1/time.txt.gz
    └── /root/.script/2022-08-25/2022-08-25_23-01-40-cmds1
        ├── /root/.script/2022-08-25/2022-08-25_23-01-40-cmds1/cmds.gz
        └── /root/.script/2022-08-25/2022-08-25_23-01-40-cmds1/time.txt.gz

3 directories, 4 files
```