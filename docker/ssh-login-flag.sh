# terminal-lab: confirm a key-based SSH login, per target box.
#
# Sourced by /etc/profile on every login shell. sshd here accepts KEYS ONLY
# (password auth disabled), so reaching a login shell over SSH proves a key
# worked. The SSH_CONNECTION guard stops this firing for the entrypoint's local
# `su - student`. The deploy flag is stored gzip+base64 so the plaintext is not
# in the public repo (obscurity, not crypto); it is decoded here at login time.
if [ -n "$SSH_CONNECTION" ]; then
  case "$(id -un)" in
    webadmin)
      echo
      echo "Key-based login to the webadmin server confirmed — you're in."
      echo
      ;;
    deploy)
      printf '%s' "H4sIAAAAAAAAAz3OQQ6CMBCF4T2neAcQFrowLokRTXQHHqDQkTY0HdIpYm8vonE3yfx5+a6U8lYJadT1BY576yFT1xFp0kWWNcYKWn7BKFmTUYnMHDTUFA35aDsVLXtoK6p1pDcQxvIBe5cwq4TICKQ6k8XPlhhyDssx22iQeAoYKBWoiazvsTYP6whj4CfJv/gpv8IFMKy86lae84WVl/fmkh+q3XFb7k/ZG+eO2nrWAAAA" | base64 -d | gunzip > "$HOME/ssh_login_success.txt" 2>/dev/null
      echo
      echo "Key-based login to the deploy box confirmed. Flag written to ~/ssh_login_success.txt"
      echo
      ;;
  esac
fi
