#!/bin/sh
# healthcheck.sh — quick local status check for the deploy box (runs on demand)
df -h / | tail -1
systemctl is-active nginx 2>/dev/null || echo "nginx: not running"
echo "healthcheck ok"
