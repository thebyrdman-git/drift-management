# Drift Management

Multi-system content synchronization with metadata-driven configuration.

## Overview

Drift Management provides automated content synchronization between systems using metadata files (`.sync-config.yml`) to declare sync requirements.

## Features

- ✅ **Metadata-based sync** - Each directory declares its own sync needs
- ✅ **Multiple sync methods** - rsync, git push, manual
- ✅ **Automated scheduling** - systemd timers (every 15 minutes)
- ✅ **Drift detection** - Compare local vs remote content
- ✅ **Self-contained** - Bootstrap-friendly, portable
- ✅ **Ansible-powered** - Idempotent, auditable, version-controlled

## Quick Start

```bash
# Clone this repository
cd ~
git clone https://github.com/thebyrdman-git/drift-management.git
cd drift-management

# Run install script
./install.sh

# Setup automated syncing
content-sync setup

# Check status
content-sync status
```

## How It Works

### 1. Content declares sync needs

```yaml
# ~/ai-infrastructure/.sync-config.yml
category: ai-tools
description: "AI infrastructure and tooling"
sync_enabled: true

sync_destinations:
  - type: rsync
    target: miraclemax.local:/opt/ai-infrastructure
    interval: 15min
    enabled: true

exclude_patterns:
  - "*.pyc"
  - ".git"
```

### 2. Drift management executes syncs

```bash
# Run all syncs manually
content-sync run

# Or automated via systemd timer (every 15 min)
systemctl --user status content-sync.timer
```

### 3. Check drift and status

```bash
# Check for drift
drift-status

# Verify last sync
sync-verify
```

## Commands

### content-sync

Main CLI tool for content synchronization.

```bash
content-sync run                          # Sync all content
content-sync run --category ai-tools      # Sync specific category
content-sync run --dry-run                # Show what would sync
content-sync status                       # Show sync status
content-sync setup                        # Setup automated syncing
```

### drift-status

Check for drift between local and remote content.

```bash
drift-status                              # Check all content for drift
```

### sync-verify

Verify last sync completed successfully.

```bash
sync-verify                               # Show last sync report
```

## Directory Structure

```
drift-management/
├── ansible/
│   ├── roles/
│   │   ├── content_sync/        # Core sync role
│   │   ├── drift_detect/        # Drift detection
│   │   └── sync_scheduler/      # Systemd timer setup
│   └── playbooks/
│       ├── sync-all-content.yml
│       ├── drift-report.yml
│       ├── setup-drift-management.yml
│       └── separate-ai-infrastructure.yml
├── bin/
│   ├── content-sync            # Main CLI
│   ├── drift-status            # Drift checker
│   └── sync-verify             # Sync verifier
├── docs/
│   ├── GETTING-STARTED.md
│   └── SYNC-CONFIG-REFERENCE.md
├── examples/
│   └── .sync-config.yml.example
├── install.sh                  # One-command setup
└── README.md
```

## Configuration Reference

See [docs/SYNC-CONFIG-REFERENCE.md](docs/SYNC-CONFIG-REFERENCE.md) for complete `.sync-config.yml` documentation.

## Use Cases

### Multi-System Development

Sync code between laptop and server automatically.

### Configuration Management

Keep configurations synchronized across systems.

### Backup Automation

Regularly sync important directories to remote systems.

### AI Infrastructure

Separate example: `ansible/playbooks/separate-ai-infrastructure.yml`

## Requirements

- Ansible 2.9+
- Python 3.6+
- SSH access to remote systems
- systemd (for automated scheduling)

## Installation

See [docs/GETTING-STARTED.md](docs/GETTING-STARTED.md) for detailed installation instructions.

## License

MIT License - see LICENSE file

## Author

Jimmy Byrd (jbyrd@redhat.com)  
Red Hat Technical Account Manager

## Contributing

Contributions welcome! This is designed to be a generic, reusable drift management system.

---

*Clean separation of concerns: content declares needs, drift-management handles execution.*

