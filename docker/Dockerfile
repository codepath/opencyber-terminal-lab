# docker/Dockerfile — opencyber-terminal-lab (CYB101 U2)
# Terminal fundamentals + SSH KEY AUTH as the through-line: the learner uses handed-out
# keys to SSH (passwordless) into two simulated servers — webadmin (Part 2 practice box)
# and deploy (Part 3 challenge box) — then investigates/triages each. Generating and
# installing your own keys + hardening a box to key-only is the optional stretch.
FROM ubuntu:22.04
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      bash coreutils less nano vim-tiny ca-certificates wget unzip sudo \
      cowsay tree \
      git openssl openssh-client openssh-server && \
    rm -rf /var/lib/apt/lists/*
# cowsay installs to /usr/games — put it on PATH for all users
ENV PATH="/usr/games:${PATH}"

# sshd: key-based auth only (passwords disabled), so a successful ssh PROVES a key worked —
# which is what makes the per-box login flag trustworthy.
RUN mkdir -p /var/run/sshd && \
    printf '\n# --- terminal-lab: key-based auth only ---\nPasswordAuthentication no\nPubkeyAuthentication yes\nChallengeResponseAuthentication no\n' \
      >> /etc/ssh/sshd_config

# --- Accounts ---------------------------------------------------------------
# student : the workstation the learner starts on (holds the handed-out keys)
# webadmin: Part 2 practice server (ssh in with a key, then investigate)
# deploy  : Part 3 challenge server (ssh in unaided, then triage)
RUN useradd -m -s /bin/bash student  && echo 'student:student' | chpasswd && usermod -aG sudo student && \
    useradd -m -s /bin/bash webadmin && \
    useradd -m -s /bin/bash deploy

# --- SSH keys: generate at build; hand student the private keys; install the public keys ---
# The learner logs in with:  ssh -i ~/keys/<key> <user>@localhost   (no password)
RUN mkdir -p /home/student/keys && \
    ssh-keygen -t ed25519 -N '' -C 'webadmin-access' -f /home/student/keys/webadmin_key && \
    ssh-keygen -t ed25519 -N '' -C 'deploy-access'   -f /home/student/keys/deploy_key && \
    install -d -m 700 /home/webadmin/.ssh && \
    install -d -m 700 /home/deploy/.ssh && \
    cp /home/student/keys/webadmin_key.pub /home/webadmin/.ssh/authorized_keys && \
    cp /home/student/keys/deploy_key.pub   /home/deploy/.ssh/authorized_keys && \
    chmod 600 /home/webadmin/.ssh/authorized_keys /home/deploy/.ssh/authorized_keys && \
    chown -R webadmin:webadmin /home/webadmin/.ssh && \
    chown -R deploy:deploy     /home/deploy/.ssh && \
    chown -R student:student   /home/student/keys && \
    chmod 600 /home/student/keys/webadmin_key /home/student/keys/deploy_key

# Auto-accept the localhost host key on first connect so the learner isn't stopped by a
# yes/no prompt (the key is what we're teaching, not host-key trust).
RUN install -d -m 700 /home/student/.ssh && \
    printf 'Host localhost\n    StrictHostKeyChecking accept-new\n' > /home/student/.ssh/config && \
    chown -R student:student /home/student/.ssh && chmod 600 /home/student/.ssh/config

# --- Box contents (each home = that "server") -------------------------------
COPY --chown=student:student   docker/files/student/  /home/student/
COPY --chown=webadmin:webadmin docker/files/webadmin/ /home/webadmin/
COPY --chown=deploy:deploy     docker/files/deploy/   /home/deploy/

# Drop a flag on a key-based SSH login (per target box; guarded off the local su - student).
COPY --chmod=644 docker/ssh-login-flag.sh /etc/profile.d/zz-ssh-login-flag.sh

# Part 3 self-check: `check-finding <file>` hashes the student's guess against the stored
# answer and tells them if they found the right malicious file (the answer is only a hash,
# so it's not readable in the repo). On PATH so it works from any box.
COPY --chmod=755 docker/check-finding.sh /usr/local/bin/check-finding

# NOTE: entrypoint runs as root to start sshd, then drops to the student shell.
COPY --chmod=755 docker/entrypoint.sh /usr/local/bin/entrypoint.sh
WORKDIR /home/student
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["bash"]
