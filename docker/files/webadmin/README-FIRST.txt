HANDOFF NOTES - read me first
=============================

The person who used this box before you left in a hurry, and they left their
files in a mess. Your job is to orient yourself (figure out what is here), then
triage it (put things in order and clean up the junk).

When you are done, your home directory should look like this:

  ~/
  |-- README-FIRST.txt        (this file - leave it here)
  |-- incident-notes.txt      (you will create this)
  |-- documents/
  |   |-- meeting-notes.txt
  |   `-- q3-report.txt
  |-- images/
  |   |-- headshot.jpg
  |   `-- logo.png            (currently mislabeled - see below)
  `-- logs/
      |-- access.log
      `-- auth.log

To get there you will need to:
  - make the documents/ and images/ folders (mkdir)
  - move the loose document and image files into them (mv)
  - rename logo.png.bak to logo.png (mv)
  - delete the tmp/ junk folder and everything in it (rm)
  - create an incident-notes.txt file to record anything suspicious (touch)

One more thing: the previous user thought the box might have been tampered with.
There are a couple of files here that look out of place. Read everything before
you delete anything, and write down what you find.
