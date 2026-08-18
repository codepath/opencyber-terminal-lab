#!/usr/bin/env bash
set -e

g='\033[0;32m'; n='\033[0m'

# Start local sshd so the learner can ssh into the webadmin / deploy servers (needs root).
# Generate host keys if the image doesn't already have them (idempotent).
ssh-keygen -A >/dev/null 2>&1 || true
/usr/sbin/sshd 2>/dev/null || service ssh start >/dev/null 2>&1 || true

echo
echo -e "   __   __   __   ___ "
echo -e "  /  \` /  \ |  \ |__  "
echo -e "  \__, \__/ |__/ |___ "
echo -e "   __       ___       "
echo -e "  |__)  /\   |   |__|  "
echo -e "  |    /--\  |   |  |  "
echo -e "        __   __   ___  "
echo -e "  ${g}\|/  ${n}/  \ |__) / _   "
echo -e "  ${g}/|\  ${n}\__/ |  \ \__/  "
echo
echo -e "Welcome to the ${g}Terminal + SSH Lab${n} environment!"
echo
echo "GETTING STARTED:"
echo -e " ${g}*${n} You're on your workstation as the 'student' user — everything runs right here."
echo -e " ${g}*${n} Your access keys are in ~/keys/. Use one to log into a lab server, no password:"
echo -e "     ${g}ssh -i ~/keys/webadmin_key webadmin@localhost${n}"
echo -e " ${g}*${n} Look around your workstation first with 'ls -l' and 'tree'."
echo -e " ${g}*${n} Follow along with the instructions at:"
echo -e "\thttps://github.com/codepath/opencyber-terminal-lab"
echo

# Drop into the student account for the rest of the lab.
exec su - student
