# Getting Started with Drift Management

## Installation

### 1. Clone the Repository

```bash
cd ~
git clone https://github.com/thebyrdman-git/drift-management.git
cd drift-management
```

### 2. Run Install Script

```bash
./install.sh
```

This will:
- Install Ansible if needed
- Create necessary directories
- Install CLI tools to `~/.local/bin/`
- Verify dependencies

### 3. Setup Automated Syncing

```bash
content-sync setup
```

This installs systemd timers for automatic syncing every 15 minutes.

## Your First Sync

### 1. Create a .sync-config.yml

```bash
cd ~/my-project
cat > .sync-config.yml << 'EOF'
category: my-project
description: "My awesome project"
sync_enabled: true

sync_destinations:
  - type: rsync
    target: server.example.com:/opt/my-project
    interval: 15min
    enabled: true

exclude_patterns:
  - "*.pyc"
  - ".git"
  - "node_modules"
EOF
```

### 2. Run a Manual Sync

```bash
content-sync run --dry-run    # See what would be synced
content-sync run              # Actually sync
```

### 3. Verify It Worked

```bash
sync-verify                   # Check last sync report
```

## Common Workflows

### Check What's Being Synced

```bash
content-sync status
```

### Check for Drift

```bash
drift-status
```

### Sync Specific Category

```bash
content-sync run --category my-project
```

### View Timer Status

```bash
systemctl --user status content-sync.timer
```

## Next Steps

- [Sync Config Reference](SYNC-CONFIG-REFERENCE.md) - Complete configuration options
- [Troubleshooting](TROUBLESHOOTING.md) - Common issues and solutions
- [Examples](../examples/) - Real-world configuration examples

## Requirements

- Linux with systemd
- Ansible 2.9+
- Python 3.6+
- SSH access to remote systems (for rsync)
- Git (for git-based syncing)

## Uninstall

```bash
# Stop and disable timer
systemctl --user stop content-sync.timer
systemctl --user disable content-sync.timer

# Remove files
rm -rf ~/drift-management
rm ~/.local/bin/content-sync
rm ~/.local/bin/drift-status
rm ~/.local/bin/sync-verify
```

