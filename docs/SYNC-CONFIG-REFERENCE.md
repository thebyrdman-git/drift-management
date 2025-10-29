# .sync-config.yml Reference

Complete reference for `.sync-config.yml` configuration files.

## Basic Structure

```yaml
category: string              # Required: Category name
description: string           # Optional: Description
sync_enabled: boolean         # Required: Enable/disable sync

sync_destinations:            # Required: List of sync targets
  - type: string             # Required: rsync, git, manual
    target: string           # Required: Destination
    interval: string         # Optional: 15min, hourly, daily, manual
    enabled: boolean         # Optional: Enable this destination
    
exclude_patterns:            # Optional: Patterns to exclude
  - string

backup_before_sync: boolean  # Optional: Create backup before sync
```

## Sync Types

### rsync

Sync via SSH using rsync.

```yaml
sync_destinations:
  - type: rsync
    target: hostname.example.com:/path/to/destination
    interval: 15min
    enabled: true
    delete: false           # Delete files not in source
```

### git

Push to Git repository.

```yaml
sync_destinations:
  - type: git
    target: origin          # Git remote name
    branch: main           # Branch to push
    interval: manual       # Usually manual for git
    enabled: true
```

### manual

No automatic sync (manual trigger only).

```yaml
sync_destinations:
  - type: manual
    target: description-of-manual-process
    interval: manual
    enabled: false
```

## Complete Example

```yaml
---
category: ai-infrastructure
description: "AI tools and model configurations"
sync_enabled: true

sync_destinations:
  # Automated rsync to production server
  - type: rsync
    target: miraclemax.local:/opt/ai-infrastructure
    interval: 15min
    enabled: true
    delete: false
  
  # Manual git push to GitHub
  - type: git
    target: github
    branch: main
    interval: manual
    enabled: false
  
  # Backup to NAS (disabled)
  - type: rsync
    target: nas.local:/backups/ai-infrastructure
    interval: daily
    enabled: false

exclude_patterns:
  - "*.pyc"
  - "__pycache__"
  - ".git"
  - "*.log"
  - ".DS_Store"
  - "node_modules"

backup_before_sync: true
```

## Field Descriptions

### category (required)
Unique identifier for this content. Used for filtering and reporting.

### description (optional)
Human-readable description of what this content is.

### sync_enabled (required)
Master switch. Set to `false` to completely disable syncing for this directory.

### sync_destinations (required)
List of places to sync this content. Can have multiple destinations.

### type (required)
Sync method: `rsync`, `git`, or `manual`.

### target (required)
Where to sync to. Format depends on type:
- rsync: `hostname:/path` or `/local/path`
- git: remote name (e.g., `origin`, `github`)
- manual: description string

### interval (optional)
How often to sync: `15min`, `hourly`, `daily`, `manual`. Default: `15min`

### enabled (optional)
Enable/disable this specific destination. Default: `true`

### delete (optional, rsync only)
Delete files in destination not in source. Default: `false`. Use carefully!

### branch (optional, git only)
Git branch to push to. Default: current branch

### exclude_patterns (optional)
List of patterns to exclude from sync. Uses rsync exclusion syntax.

### backup_before_sync (optional)
Create timestamped backup before syncing. Default: `false`

## Best Practices

1. **Start with `sync_enabled: false`** - Test your config first
2. **Use `--dry-run`** - See what would be synced before doing it
3. **Be careful with `delete: true`** - Can cause data loss
4. **Exclude build artifacts** - Don't sync `.pyc`, `node_modules`, etc.
5. **Test SSH access first** - Ensure you can SSH to the target
6. **Use descriptive categories** - Makes filtering and reporting easier
7. **Document manual processes** - Even if `type: manual`

## Testing Your Config

```bash
# Syntax check
cat .sync-config.yml | python3 -c "import yaml, sys; yaml.safe_load(sys.stdin)"

# Dry run
content-sync run --dry-run --category your-category

# Actual sync
content-sync run --category your-category
```

## Troubleshooting

See [TROUBLESHOOTING.md](TROUBLESHOOTING.md) for common issues.

