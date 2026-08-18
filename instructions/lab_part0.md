# Terminal + SSH Lab: Part 0 — Setup

[*(back to home)*](https://github.com/codepath/opencyber-terminal-lab)

Lab Parts:

0. [Setup: Get into the shell](./lab_part0.md) (✅ You are here!)
1. [Learn: Get on a Box with a Key and Get Oriented](./lab_part1.md)
2. [Apply: SSH In and Investigate a Box](./lab_part2.md)
3. [Challenge: Access and Triage a New Box](./lab_part3.md)

## Part 0 | Setup: Get into the shell

**Estimated Time:** 10 minutes

**Environment:** Your own computer (Docker) → the lab container's Linux shell

**Tools Needed:** Docker

## Overview

Set up the disposable Linux sandbox for this lab. You'll run a single Docker image and land directly in a shell as the `student` user on your **workstation** — no VM, no cloud account. From that workstation you'll use SSH keys to log into two practice **servers** and work on them. Everything happens inside the container, so you can experiment freely without touching your real computer. *(Heads up on a term you'll see throughout: a **"box"** is just casual security slang for any computer or server you're working on — it's where the lab parts get names like "Get on a Box.")*

## What you'll learn

By the end of the whole lab, you'll be able to:

- Navigate and inspect a Linux filesystem from the command line (`pwd`, `ls`, `cd`, `cat`, `tree`).
- **Use a provided SSH key to log into a server with no password** (`ssh -i <key> user@host`) — the core skill of this lab.
- Triage an unfamiliar machine: spot what's out of place, tie indicators together with `grep`, and sort the mess into order.
- Use administrator rights and deletion deliberately — when `sudo` is warranted, and how to run `rm` without wrecking the box.
- *(Stretch)* Generate your own SSH key pair and lock a box down to key-only login.

## Instructions

### Step 1: Install and start Docker

- [ ] Make sure you have Docker installed and running on your computer.
  - **Mac**: [Download Docker Desktop for Mac](https://docs.docker.com/desktop/install/mac-install/)
  - **Windows**: [Download Docker Desktop for Windows](https://docs.docker.com/desktop/install/windows-install/)
  - **Linux**: [Install Docker Engine](https://docs.docker.com/engine/install/) (or [Docker Desktop for Linux](https://docs.docker.com/desktop/install/linux/))
  - Once installed, open Docker Desktop (Mac/Windows) and confirm it is running before continuing.

- [ ] Open a terminal on your computer:
  - **Mac**: Open **Terminal** (search "Terminal" in Spotlight with ⌘+Space)
  - **Windows**: Open **Command Prompt** or **PowerShell** (search either in the Start menu)
  - **Linux**: Open your system's terminal emulator

### Step 2: Run the lab container

- [ ] Run the container with the standard command:

  ```bash
  docker run -it --rm ghcr.io/codepath/opencyber-terminal-lab:latest
  ```

  The `-it` flags give you an interactive terminal; `--rm` cleans the container up when you exit.

- [ ] Confirm you see the welcome banner and a shell prompt. It looks like this:

  ```text
  Welcome to the Terminal + SSH Lab environment!

  GETTING STARTED:
   * You're on your workstation as the 'student' user — everything runs right here.
   * Your access keys are in ~/keys/. Use one to log into a lab server, no password:
       ssh -i ~/keys/webadmin_key webadmin@localhost
   * Look around your workstation first with 'ls -l' and 'tree'.
   * Follow along with the instructions at:
          https://github.com/codepath/opencyber-terminal-lab

  To run a command as administrator (user "root"), use "sudo <command>".
  See "man sudo_root" for details.

  student@a1b2c3d4e5f6:~$
  ```

The `student@...:~$` prompt means you are now logged in as the `student` user, inside the container, in your home directory. Behind the scenes the container also started a local SSH server — that's what lets you log into the practice servers starting in Part 1.

> [!NOTE]
> **Your work is disposable.** Each run of the image is a clean box; when you exit, everything resets. That's on purpose — the SSH keys you're handed are generated fresh with the image, so there's nothing to carry over between runs.

> [!TIP]
> **Prefer to build it yourself?** Instead of pulling the published image, you can build it locally from this repository:
>
> ```bash
> git clone https://github.com/codepath/opencyber-terminal-lab.git
> cd opencyber-terminal-lab
> make run     # builds the image, then runs it
> ```

🎯 **Checkpoint 0.1**: You are at a shell prompt inside the container as `student`.

Once you have a prompt, [**proceed to Part 1**](./lab_part1.md).
