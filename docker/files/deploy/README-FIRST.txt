HANDOFF - contractor offboarding
================================

This box belonged to a contractor who has left. Their files are a mess, and IT
thinks the box may have been tampered with before they went.

You've done this before (Part 2) - but this time there is NO step-by-step. Use
the same approach you already practiced: orient first (look before you touch),
then triage (organize and clean up), and document anything suspicious BEFORE you
delete it.

When you're done, your home directory should look like this:

  ~/
  |-- README-FIRST.txt        (leave it here)
  |-- ssh_login_success.txt   (your login flag - the box dropped it for you; leave it)
  |-- findings.txt            (you create this - what you found)
  |-- reports/
  |   |-- roadmap.txt
  |   `-- sales-q4.txt
  |-- scripts/
  |   `-- ...                 (the real helper scripts - you sort them in here; see "Scripts")
  `-- logs/
      |-- access.log
      `-- auth.log

Clean up: there is a junk "cache" folder that does not belong in the final layout.

Scripts: several loose scripts are lying around the box. Most are ordinary helpers
that belong together in scripts/ - but one of them is not a helper at all. You'll
have to READ them to tell which is which: move the real helpers into scripts/ (one
is also mislabeled with the wrong extension - fix it as you go), and handle the odd
one out as your security finding below.

Security: identify the script that does not belong by what it actually does when it
runs, then find the indicator (an address it talks to) that also shows up in the
logs. Write the malicious file's name and that indicator into findings.txt, then
remove it.

No command list this time. You already know the moves - this is the challenge.
