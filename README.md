# Terminal & SSH Lab

This is the README documentation for the Terminal & SSH Lab, produced and maintained by [CodePath.org](https://codepath.org).

## Quick Start

Want to jump into the lab? Navigate to the [Part 0 Instructions](./instructions/lab_part0.md) to get started!

## About this Lab

<img src="https://i.imgur.com/fpfv531.png" style="width: 75%; min-width: 350px;" alt="Screenshot of provided Docker Container printing welcome message for Terminal & SSH Lab"></img>

The Terminal & SSH Lab is designed to give you hands-on fluency with the Linux command line and the keys that secure remote access to it. You'll navigate and inspect a real filesystem from the shell, use an SSH key to log into a server with no password, and triage an unfamiliar machine — spotting what's out of place and putting it back in order. As a stretch, you'll generate your own key pair and lock a box down to key-only login. This is the foundation that every later hands-on unit builds on.

### Learning Objectives

- Navigate and inspect a Linux filesystem from the command line (`pwd`, `ls`, `cd`, `cat`, `tree`)
- Use a provided SSH key to log into a server with no password (`ssh -i <key> user@host`)
- Triage an unfamiliar machine — spot what's out of place and tie indicators together with `grep` and `find`
- Use administrator rights and file deletion deliberately — knowing when `sudo` is warranted and how to run `rm` without wrecking the box
- *(Stretch)* Generate your own SSH key pair and configure a box for key-only login

### Lab Activities

0. [Setup: Get into the shell](./instructions/lab_part0.md)
1. [Learn: Get on a Box with a Key and Get Oriented](./instructions/lab_part1.md)
2. [Apply: SSH In and Investigate a Box](./instructions/lab_part2.md)
3. [Challenge: Access and Triage a New Box](./instructions/lab_part3.md)

## Technical Details

### Provided Tools

In the provided Docker container, you will find all the necessary tools and dependencies pre-installed. This includes:

- `bash` - a Unix shell and command language (this is how you will interact with the container)
- Core utilities (`ls`, `cd`, `cat`, `pwd`, `whoami`, `id`) - for navigating and inspecting the filesystem
- `grep`, `find`, and `tree` - for searching a box and understanding its structure
- `sudo` and `apt` - administrator rights and package management
- `ssh` - an OpenSSH client, plus a local server (`sshd`) you'll key into

The lab is ephemeral by design — each run is a clean box, so you can experiment freely.
