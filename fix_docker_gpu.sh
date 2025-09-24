#!/bin/bash
# fix_docker_gpu.sh - safely fix Docker cgroup issues for GPU containers

set -e

DAEMON_JSON="/etc/docker/daemon.json"
BACKUP_JSON="/etc/docker/daemon.json.bak"

echo "=== Step 1: Install jq if not present ==="
if ! command -v jq &> /dev/null; then
    echo "jq not found, installing..."
    sudo apt-get update
    sudo apt-get install -y jq
else
    echo "jq already installed."
fi

echo "=== Step 2: Backup current daemon.json ==="
if [ -f "$DAEMON_JSON" ]; then
    sudo cp "$DAEMON_JSON" "$BACKUP_JSON"
    echo "Backup saved to $BACKUP_JSON"
else
    echo "No existing daemon.json found, creating a new one..."
    echo "{}" | sudo tee "$DAEMON_JSON" > /dev/null
fi

echo "=== Step 3: Validate current daemon.json ==="
if ! sudo jq '.' "$DAEMON_JSON" > /dev/null 2>&1; then
    echo "ERROR: $DAEMON_JSON is not valid JSON! Restoring backup..."
    if [ -f "$BACKUP_JSON" ]; then
        sudo cp "$BACKUP_JSON" "$DAEMON_JSON"
    else
        echo "{}" | sudo tee "$DAEMON_JSON" > /dev/null
    fi
    exit 1
fi

echo "=== Step 4: Add cgroupfs exec-opts if not present ==="
if ! grep -q '"exec-opts"' "$DAEMON_JSON"; then
    tmpfile=$(mktemp)
    sudo jq '. + {"exec-opts":["native.cgroupdriver=cgroupfs"]}' "$DAEMON_JSON" > "$tmpfile"
    sudo mv "$tmpfile" "$DAEMON_JSON"
    echo "Added exec-opts to daemon.json"
else
    echo "exec-opts already present, skipping."
fi

echo "=== Step 5: Reload systemd daemon and restart Docker ==="
sudo systemctl daemon-reload
sudo systemctl restart docker

echo "=== Step 6: Verify Docker cgroup driver ==="
docker info | grep "Cgroup Driver"

echo "✅ Docker and GPU setup completed successfully!"
