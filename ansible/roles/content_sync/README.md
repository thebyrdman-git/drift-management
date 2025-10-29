# Content Sync Role

Scans for `.sync-config.yml` files and executes syncs based on configuration.

## Description

This role provides automated content synchronization based on metadata files (`.sync-config.yml`) placed in content directories.

## How It Works

1. Scans specified paths for `.sync-config.yml` files
2. Parses each configuration
3. Executes syncs based on destination type (rsync, git, etc.)
4. Generates summary report

## Variables

```yaml
# Paths to scan for sync configs
content_scan_paths:
  - /home/{{ ansible_user_id }}

# Backup directory
backup_dir: /home/{{ ansible_user_id }}/backups

# Generate sync report
generate_report: true

# Verbose output
verbose_output: false
```

## Example .sync-config.yml

```yaml
category: ai-tools
description: "AI infrastructure tools"
sync_enabled: true

sync_destinations:
  - type: rsync
    target: miraclemax.local:/opt/ai-infrastructure
    interval: 15min
    enabled: true
    delete: false
  
  - type: git
    target: github:thebyrdman-git/ai-infrastructure
    branch: main
    interval: manual
    enabled: false

exclude_patterns:
  - "*.pyc"
  - "__pycache__"
  - ".git"

backup_before_sync: true
```

## Usage

```yaml
- hosts: localhost
  roles:
    - content_sync
```

## Supported Sync Types

- **rsync**: Remote sync via SSH
- **git**: Git push to remote repository
- **manual**: No automatic sync (manual trigger only)

## Tags

- `scan`: Only scan for configs
- `sync`: Execute syncs
- `report`: Generate report only

