# Terminal + SSH Lab: Part 3 — Challenge: Access and Triage a New Box

[*(back to home)*](https://github.com/codepath/opencyber-terminal-lab)

Lab Parts:

0. [Setup: Get into the shell](./lab_part0.md)
1. [Learn: Get on a Box with a Key and Get Oriented](./lab_part1.md)
2. [Apply: SSH In and Investigate a Box](./lab_part2.md)
3. [Challenge: Access and Triage a New Box](./lab_part3.md) (✅ You are here!)

## Part 3 | Challenge: Access and Triage a New Box

**Estimated Time:** 45 minutes

**Environment:** Our provided Docker container (see [Part 0](./lab_part0.md) for setup instructions)

**Tools Needed:** everything from Parts 1–2 (`ssh`, `ls`/`cd`/`cat`/`grep`/`find`/`mkdir`/`mv`/`rm`/`tree`)

**[Back to home](https://github.com/codepath/opencyber-terminal-lab)**

## Overview

This is where you work **without the step-by-step.** You've been given access to a *second* server — the `deploy` box — a different mess with a different threat. You'll do the same jobs you already practiced in Parts 1 and 2, but this time no commands are handed to you: you get onto the box with your key, orient, triage, and find the threat on your own.

There is no answer key from here on. That's the point — this challenge is how you (and we) find out whether the skills stuck. You check your own work by whether the attack works (your key gets you in) and whether your result matches what the box's handoff note asks for.

> [!NOTE]
> This is a lab. The "servers" are accounts inside your own container reached over `localhost`; nothing here touches a real machine or the internet.

## Instructions

### Step 1: Get onto the new box with your key

You were handed a second key in `~/keys/` for the `deploy` box. Use it the same way you used the `webadmin` key in Parts 1–2 — no password.

- [ ] From your workstation, log into the `deploy` server with the **deploy** key. (You built this exact command shape twice already; the key file and the username are different this time.)
- [ ] The `deploy` box, like `webadmin`, accepts keys only — so getting a shell **proves** your key worked. On login it drops a flag file. Read it and keep the flag line for your turn-in:

  ```bash
  cat ~/ssh_login_success.txt
  ```

🎯 **Checkpoint 3.1**: You logged into the `deploy` box with its key (no password) and captured the login flag.

### Step 2: Investigate and triage the box

Everything from here happens on the `deploy` box. It comes with a handoff note, exactly like the last one — but this note tells you the *goal*, not the keystrokes.

- [ ] Read the handoff note first (`README-FIRST.txt`). It describes the target layout and the security task.
- [ ] **Orient before you touch anything.** Look around — including hidden files. Read the human-written files so you understand the box before you change it.
- [ ] **Triage it to match the target layout** in the handoff: build the folders it asks for, sort the loose files in, fix the one file whose name is wrong, and remove the junk the note says doesn't belong. Remember the golden rule from Part 2: **read before you delete.**

> [!WARNING]
> Same hazard as Part 2, now without a spotter: `rm` is permanent and `sudo rm -rf` on the wrong path can wreck the box. Read a file before you delete it, and double-check the path before you press Enter. (In this lab a broken box is survivable — reset by typing `exit` **twice** (once out of the `deploy` box to your `student` workstation, once more out of the container) and re-running the image. A real machine is not.)

🎯 **Checkpoint 3.2**: Your `deploy` home layout matches the target in `README-FIRST.txt`. Run `tree` and compare — if it matches, this part's done. (A hidden leftover won't show in `tree` and isn't in the target layout — like Part 2's `.todo`, leaving it is fine.)

### Step 3: Find the threat

The handoff warned that one file on this box isn't what it claims to be. Prove it.

- [ ] **Identify the malicious file** by reading the scripts on the box. One of them does something no legitimate helper script would do — decide which, based on what it actually does.
- [ ] **Tie it to the evidence** using the pivot from Part 2: the file talks to an address; take that one indicator and search the whole box for it to see everywhere it appears — including the logs. When a script's address *also* turns up in `logs/`, that correlation is your confirmation you've found the right one.
- [ ] **Record your findings** in a file called `findings.txt`: the malicious file's name, and the indicator that appears in both the file and the logs. Create and write it the same way you made `incident-notes.txt` in Part 2 — `touch findings.txt`, then `echo "..." >> findings.txt` (or open it with `nano`). Then remove the malicious file.

🎯 **Checkpoint 3.3**: your `findings.txt` names the malicious file and the address that links it to the logs, and the file is gone.

### Step 4: Set up your own key from scratch (optional stretch)

So far you've *used* keys someone handed you. This stretch is the other side of the job — what an admin does when granting a new person access. On the `deploy` box:

- [ ] Generate a fresh key pair: `ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519 -N ""`
- [ ] Add its **public** half to this box's trust list: `cat ~/.ssh/id_ed25519.pub >> ~/.ssh/authorized_keys`, then `chmod 600 ~/.ssh/authorized_keys`
- [ ] From your workstation, confirm you can now log in with your *new* key.

You'll have generated a key, authorized it, and used it — the full lifecycle. (Guard the private key: it never leaves the box it logs in *from*. Sharing it loses the whole game.)

## You're done when

- your key got you onto the `deploy` box — the login wrote `~/ssh_login_success.txt`;
- your `tree` matches the layout in the box's handoff note; and
- your `findings.txt` names the malicious file and the address that ties it to the logs.

The first two you can confirm on the spot (the flag printed; your `tree` matches). For the third, your confidence comes from the evidence itself: the file you flagged talks to an address that *also* shows up in the logs. Once you've committed to your answer, write down, in a few sentences (no single right answer): **how did the attacker get onto this box, what was the malicious file doing, and what one change would you make to keep them out next time?**

**One last thing — confirm your answer.** Now that you've reasoned it out and committed, this box has a self-check you can run:

```bash
check-finding <the-file-you-flagged>
```

It tells you straight away whether you found the right malicious file — it never reveals the answer, it only confirms yours. Run it *after* you've done the thinking, not as a shortcut around it: working out *why* a file is malicious is the whole skill here.

### Tips for Success

- **`Permission denied (publickey)`?** SSH tried and your key wasn't accepted. Check three things: you passed the right key with `-i` (the **deploy** key for the deploy box), you used the right username (`deploy@localhost`), and the key file isn't world-readable — SSH silently refuses a key that others can read. `chmod 600 ~/keys/deploy_key` fixes the permissions.
- **`Identity file ... not accessible: No such file or directory`?** Your `~/keys/` only exists on your **workstation** (the `student` account). If you're already logged into a server, that path isn't there — type `exit` to return to your workstation first, then run the `ssh` command.
- **Deleted the wrong thing?** There's no undo. Reset to a clean box by typing `exit` **twice** — first to leave the `deploy` box (back to your `student` workstation), then again to leave the container — and re-run the image, then start the triage over.
- **Leverage AI tools:** if you know *what* you want to do but not the exact command or flag, ask an AI assistant — then make sure you understand each piece before you run it, especially anything with `rm`.
