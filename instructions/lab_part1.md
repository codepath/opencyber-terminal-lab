# Terminal + SSH Lab: Part 1 — Learn: Get on a Box with a Key and Get Oriented

[*(back to home)*](https://github.com/codepath/opencyber-terminal-lab)

Lab Parts:

0. [Setup: Get into the shell](./lab_part0.md)
1. [Learn: Get on a Box with a Key and Get Oriented](./lab_part1.md) (✅ You are here!)
2. [Apply: SSH In and Investigate a Box](./lab_part2.md)
3. [Challenge: Access and Triage a New Box](./lab_part3.md)

## Part 1 | Learn: Get on a Box with a Key and Get Oriented

**Estimated Time:** 45 minutes

**Environment:** Our provided Docker container (see [Part 0](./lab_part0.md) for setup instructions)

**Tools Needed:** `whoami`, `id`, `pwd`, `ls`, `cd`, `cat`, `sudo`, `apt`, `tree`, `grep`, `find`, `ssh` (already installed for you)

**[Back to home](https://github.com/codepath/opencyber-terminal-lab)**

## Overview

In security work you're constantly handed **a box** — a machine you have to get onto, look around, and understand before you touch anything. This part builds that habit in two tracks: first the everyday moves for getting oriented on a Linux machine (who you are, where you are, how to read and search files), and then the skill at the heart of this lab — **using an SSH key to log into a server with no password.** You'll put all of it to work investigating a box in Part 2 and a brand-new one, on your own, in Part 3.

The line you type commands at is called the **prompt**. In this lab it looks like:

```text
student@a1b2c3d4e5f6:~$
```

That already tells you a lot: you are the user `student`, on a machine named `a1b2c3d4e5f6` (yours will differ), and `~` is shorthand for your **home directory**. You type a command after the `$` and press Enter to run it. Right now you're on your own **workstation** — the machine you start from. The lab servers are elsewhere, and you'll reach them with SSH in Step 4.

## Instructions

> [!TIP]
> **Two habits that help all lab long.** (1) If your screen gets cluttered and you can't tell where one command's output ends and the next begins, run `clear` to wipe it clean. (2) Every command comes with a manual — read it with `man <command>` (try `man ls`; press `q` to quit), or browse them online at [manpages.ubuntu.com](https://manpages.ubuntu.com). Learning to read the docs for yourself is one of the most valuable Linux skills there is.

### Step 1: Who am I, and where? (`whoami`, `id`, `pwd`, `ls`, `cd`)

The first thing you do on an unfamiliar box is establish two things: **who you are** on it (what you're allowed to do) and **where you are** (your location in the filesystem).

- [ ] Who are you? Run `whoami` — it prints your username:

  ```bash
  whoami
  ```

  It says `student`. That's the account you're operating as.

- [ ] What are you allowed to do? `id` shows your user, your groups, and whether you have admin rights:

  ```bash
  id
  ```

  <details>
  <summary>✅ Check your result</summary>

  Something like `uid=1000(student) gid=1000(student) groups=1000(student),27(sudo)`. The part that matters for security work is the group list: being in the **`sudo`** group means this account *can* elevate to administrator when it needs to (you'll use that in Step 2). On a real box, the first thing an attacker checks after landing is exactly this — "what can this account do?"

  </details>

- [ ] Where are you standing? `pwd` ("print working directory") prints your current directory:

  ```bash
  pwd
  ```

  <details>
  <summary>✅ Check your result</summary>

  `/home/student` — your home directory, the same place `~` points to.

  </details>

- [ ] What's here? List the current directory with `ls`, then check what you got:

  ```bash
  ls
  ```

  <details>
  <summary>✅ Check your result</summary>

  `README.txt  keys  notes` — an orientation file, the folder holding your SSH access keys, and a few of your own files to poke around in.

  </details>

- [ ] List again with more detail using `ls -l` (a "long" listing showing permissions, owner, size, and date). The `-l` is a **flag** — an option that changes how a command behaves; you'll use flags constantly:

  ```bash
  ls -l
  ```

- [ ] Read the orientation file with `cat` (it prints a file's contents to the screen):

  ```bash
  cat README.txt
  ```

  It explains what each item in your home directory is for. Read it now.

- [ ] Move into a directory with `cd` ("change directory"), then confirm where you landed. `..` always means "the directory above this one," so `cd ..` walks back up:

  ```bash
  cd notes
  pwd
  cd ..
  pwd
  ```

  <details>
  <summary>✅ Check your result</summary>

  `cd notes` then `pwd` shows `/home/student/notes`; `cd ..` then `pwd` puts you back at `/home/student`.

  </details>

> [!TIP]
> `cd` with no arguments always takes you home (`~`), no matter where you are. If you ever feel lost, type `cd` and press Enter, then `pwd` to reset your bearings.

🎯 **Checkpoint 1.1**: You can say who you are, what you're allowed to do, where you are, and move around.

### Step 2: Installing and running programs (`sudo` / `apt`)

On Linux you install software from the command line with a **package manager**. On Ubuntu that's `apt` — think of it like the App Store or Play Store on a phone, but driven from the terminal. Installing software is a system-wide change, so it requires administrator ("root") permissions — you get those by putting `sudo` in front of a command. Heads-up: when `sudo` asks for a password in this lab, it's `student`.

- [ ] Try to install the `tree` program **without** `sudo` and watch it fail:

  ```bash
  apt install tree
  ```

  ```text
  E: Could not open lock file /var/lib/dpkg/lock-frontend - open (13: Permission denied)
  E: Unable to acquire the dpkg frontend lock (/var/lib/dpkg/lock-frontend), are you root?
  ```

  Regular users aren't allowed to change system software. The error even spells out the fix by asking "are you root?"

- [ ] Now run it with `sudo` in front. You'll be asked for a password — it's `student`:

  ```bash
  sudo apt install tree
  ```

  ```text
  [sudo] password for student:
  ...
  tree is already the newest version (2.0.2-1).
  ```

  `tree` is already installed in this image (so the lab works even without internet), so `apt` simply reports it's up to date. The point is the pattern: **`sudo <command>` runs that command as an administrator.**

> [!NOTE]
> `sudo` stands for "superuser do." Use it only when a task genuinely needs admin rights — installing software, editing system files, starting system services. Most day-to-day commands don't need it, and getting in the habit of *not* reaching for it is good security hygiene.

- [ ] Now use `tree` to see the layout of your home directory at a glance. It draws the directory as a branching diagram — much faster than `cd`-ing into every folder:

  ```bash
  tree ~
  ```

  <details>
  <summary>✅ Check your result</summary>

  ```text
  /home/student
  |-- README.txt
  |-- keys
  |   |-- deploy_key
  |   |-- deploy_key.pub
  |   |-- webadmin_key
  |   `-- webadmin_key.pub
  `-- notes
      |-- scratch.txt
      `-- todo.txt
  ```

  Those `keys` are your SSH access keys — you'll use them in Step 4.

  </details>

🎯 **Checkpoint 1.2**: You've run `apt` with `sudo` and visualized a directory with `tree`.

### Step 3: Reading and searching (`grep`, `find`)

When you investigate a box you rarely know exactly where the important thing is. Two commands do the heavy lifting: **`grep`** searches *inside* files for a piece of text, and **`find`** locates files by name. These are the workhorses of the next two parts, so meet them now on your own `notes/` folder.

- [ ] `grep` finds text inside files. `-r` searches every file in a folder ("recursive") and `-n` shows the line number of each match. Search your `notes` for the word `ssh`:

  ```bash
  grep -rn "ssh" notes
  ```

  <details>
  <summary>✅ Check your result</summary>

  A hit in `notes/todo.txt` — the line reminding you to practice SSHing into a server with a key. This is the core investigative move in miniature: pick a term, `grep` for it, and see *everywhere* it appears. You'll use this exact pivot to tie a breach together in Part 2.

  </details>

- [ ] `find` locates files by name instead of by content. Find every `.txt` file anywhere under `notes` (the `*` is a wildcard meaning "anything"):

  ```bash
  find notes -name "*.txt"
  ```

  <details>
  <summary>✅ Check your result</summary>

  `notes/todo.txt` and `notes/scratch.txt` (in whatever order — `find` doesn't sort its output). `find` is how you locate files on a box when you don't already know the path — indispensable once a system has thousands of files.

  </details>

🎯 **Checkpoint 1.3**: You can search *inside* files with `grep` and *locate* files with `find`.

### Step 4: Get onto a server with an SSH key

Everything so far happened on your own workstation. The real job is getting onto *other* machines — **servers** — and the standard way is **SSH** (`ssh user@server`). Normally SSH asks for a password, but passwords can be guessed, phished, or reused. The safer way, and the one this lab is about, is an **SSH key**.

A key is a pair of files: a **private key** you keep secret, and a **public key** you can hand out. A server that has your public key in its list of trusted keys will let in whoever holds the matching private key — **no password typed, nothing to steal off the wire.** The `webadmin` server has been set up to accept keys *only* — no password will get you in.

You've been handed keys for the two lab servers in `~/keys/`; `webadmin` trusts your `webadmin_key`.

- [ ] First, see what happens **without** a key — try a plain login:

  ```bash
  ssh webadmin@localhost
  ```

  (If it asks you to trust the host the first time, type `yes`.) You're turned away at once:

  ```text
  webadmin@localhost: Permission denied (publickey).
  ```

  The server only accepts keys, and you didn't offer one. That's the whole point of key-only login: no key, no entry — there's no password to guess.

- [ ] Now log in **with** your key. The `-i` ("identity") flag tells `ssh` which private key to use:

  ```bash
  ssh -i ~/keys/webadmin_key webadmin@localhost
  ```

  Read that command: use the key `~/keys/webadmin_key` to log in as user `webadmin` on the server `localhost`. (In this lab the "server" is the same container reached over `localhost`, which keeps everything self-contained — but the command is identical to reaching a real server across the internet.)

- [ ] Notice what did **not** happen this time: no password prompt, no rejection. The key did the work. You should see:

  ```text
  Key-based login to the webadmin server confirmed — you're in.
  ```

- [ ] Confirm you really are on a different machine now — check who you are, and get the lay of the land with `tree`:

  ```bash
  whoami
  tree
  ```

  <details>
  <summary>✅ Check your result</summary>

  `whoami` now says **`webadmin`**, not `student` — you've hopped from your workstation onto the server. `tree` shows the box's files at a glance (a `README-FIRST.txt`, a `logs/` folder, and more) — the mess you'll investigate in Part 2.

  </details>

- [ ] Return to your own workstation when you're done looking around:

  ```bash
  exit
  ```

  `whoami` will say `student` again — you're back home. `exit` always closes the current SSH session and drops you back where you came from.

🎯 **Checkpoint 1.4**: You saw a key-less login get refused, then logged into `webadmin` with your key — no password — and came back with `exit`.

You can now get onto a box (with a key), get oriented, and search it. In [Part 2](./lab_part2.md), you'll SSH back into the `webadmin` server and put `ls`, `cat`, `grep`, `find`, and `tree` to work investigating the mess someone left on it.
