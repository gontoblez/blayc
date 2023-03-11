# Blay-C - bash cmus player (yea, awful, ik)
pronounced Blay-see

- [Introduction](#introduction)
- [Installation](#installation)
- [Recommended Usage](#recommended-usage)
- [Troubleshooting](#troubleshooting)


## Introduction
Blay-C is a bash script that queries song/music and playes it using [cmus](https://cmus.github.io/).
Blay-C does **NOT** play music by itslef, it uses cmus to play them. Blay-C is just a
search engine for your music.

## Installation

First off, dependencies:
```
sed
cmus
cmus-remote
```

To install:
```language
$ git clone https://github.com/gontoblez/blayc.git
$ chmod +x blayc 
$ mv blayc $HOME/.local/bin
```
Make sure `$HOME/.local/bin` is in your `$PATH`.

Don't forget to open the script and set the `music` variable to where you store your
music. If you don't do that, it's going to default to `$HOME/Music`.

## Recommended Usage
#### Launching the Script
Make a keybinding that opens a terminal window with the script running. This makes
it easier to switch between different songs, instead of going to the terminal and 
running the script manually.

For example, if you're running [i3wm](https://i3wm.org/) along with the 
[Kitty](https://sw.kovidgoyal.net/kitty/) terminal emulator, you can add this to your
i3wm `config`:
```i3-config
bindsym $mod+o exec kitty --class=blayc --title="Blay-C" -e bash -c blayc

for_window [class=blayc] floating enable
for_window [class=blayc] resize set 700 150
for_window [class=blayc] move position 610 465
```
#### Naming Music Files
Music files (not the metadata) shouldn't have spaces in them. The words should be 
merged together (you can do camel-case if you want to).

For example, a song named "Sing Sang Sung" should be present in your filesystem as
`SingSangSung.[extension]`. 

Note: I will try to change this in the future so it doesn't
require the user to write song names in a specific format.

## Troubleshooting

### Song not found

Blay-C runs into this error for a couple of different reasons:

1. The song you searched for is not present in the directory `blayc` searched in. Make
sure that the song is present in the directory `blayc` is searching in.

2. You made a typo while setting the `music` variable, check that.

3. Make sure that you named the song according to the [Naming Music Files](#naming-music-files) 
section.

If all these don't work, please submit an issue with the steps on how to replicate the
error.

### cmus isn't Installed

If you have a Debian-based or an Arch-based system, `blayc` will try installing `cmus` if it detects
that it's not downloaded. Otherwise, if you don't have `cmus` installed, well, you will
have to [install cmus](https://cmus.github.io/#documentation).

