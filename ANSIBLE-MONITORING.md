# Ansible Monitoring and Debugging Guide

## Enhanced Configuration

The `ansible.cfg` in this repo includes comprehensive monitoring and debugging features.

## Available Monitoring Tools

### 1. Real-Time Progress Display

**Standard run:**
```bash
ansible-playbook ansible/playbooks/sanitize-and-publish-gitlab.yml \
  -e "content_dir=/home/jbyrd/drift-management"
```

Shows:
- ✅ Task completion status
- ⏱️ Stage timing (automatically tracked)
- 📋 Progress through 5 stages
- 🎯 Current task name with stage prefix

### 2. Verbose Output Levels

```bash
# Level 1: Show task results
ansible-playbook playbook.yml -v

# Level 2: Show task inputs and results
ansible-playbook playbook.yml -vv

# Level 3: Show connection debugging
ansible-playbook playbook.yml -vvv

# Level 4: Show everything (API calls, SSH)
ansible-playbook playbook.yml -vvvv
```

### 3. Execution Log

**Automatic logging enabled:**
```bash
# View real-time log (in another terminal)
tail -f ansible-execution.log

# Search log for errors
grep -i error ansible-execution.log

# Search log for specific task
grep "TASK \[gitlab_repo_manager" ansible-execution.log
```

### 4. Task Timing Reports

**Automatically enabled callbacks:**
- `profile_tasks` - Shows duration of each task
- `profile_roles` - Shows duration of each role
- `timer` - Shows total playbook execution time

**Example output:**
```
PLAY RECAP *************************************************************
localhost                  : ok=25   changed=3    unreachable=0    failed=0

Sunday 29 October 2025  14:30:45 -0400 (0:00:01.234)       0:00:45.678 ******
===============================================================================
gitlab_repo_manager : Create GitLab repository via API -------- 12.34s
content_sanitizer : Scan files for sensitive patterns ---------- 8.45s
gitlab_repo_manager : Test GitLab API authentication ----------- 2.12s
```

### 5. Step-Through Mode

```bash
# Pause before each task
ansible-playbook playbook.yml --step
# Options: (c)ontinue, (s)kip, (a)bort
```

### 6. List Tasks (Preview)

```bash
# See all tasks that will run
ansible-playbook playbook.yml --list-tasks

# See tasks with specific tags
ansible-playbook playbook.yml --list-tasks --tags publish
```

### 7. Start at Specific Task

```bash
# Resume from where you left off
ansible-playbook playbook.yml \
  --start-at-task="STAGE 3/5: Include GitLab publishing"
```

### 8. Syntax Check

```bash
# Validate playbook syntax without running
ansible-playbook playbook.yml --syntax-check

# Dry run (check mode)
ansible-playbook playbook.yml --check
```

## Advanced Monitoring

### Real-Time Monitoring Dashboard

```bash
# Terminal 1: Run playbook
cd /home/jbyrd/drift-management
ansible-playbook ansible/playbooks/sanitize-and-publish-gitlab.yml \
  -e "content_dir=/home/jbyrd/drift-management" \
  -vv

# Terminal 2: Monitor log
tail -f ansible-execution.log | grep --color=always -E "TASK|PLAY|changed|ok|failed"

# Terminal 3: Watch system resources
watch -n 1 'ps aux | grep ansible'
```

### Debug Specific Roles

```bash
# Run only sanitization stage
ansible-playbook playbook.yml --tags sanitize -vv

# Run only GitLab publishing
ansible-playbook playbook.yml --tags publish -vv

# Skip sanitization (testing only)
ansible-playbook playbook.yml --skip-tags sanitize
```

### Performance Analysis

```bash
# After playbook completes, analyze log
echo "=== Slowest Tasks ==="
grep "ok:" ansible-execution.log | tail -10

echo "=== Failed Tasks ==="
grep "fatal:" ansible-execution.log

echo "=== Task Timing ==="
grep -E "^\w+ \d+ \w+ \d+ .*s$" ansible-execution.log
```

## Troubleshooting Workflow

### When Playbook Gets Stuck

1. **Check current stage:**
   ```bash
   tail ansible-execution.log
   ```

2. **Run with verbosity:**
   ```bash
   ansible-playbook playbook.yml -vvv
   ```

3. **Identify stuck task:**
   ```bash
   # In another terminal
   ps aux | grep ansible
   lsof -p $(pgrep -f ansible-playbook)
   ```

4. **Resume from last good task:**
   ```bash
   ansible-playbook playbook.yml --start-at-task="<task name>"
   ```

### Common Issues

**Timeout:**
```yaml
# Tasks have 30s timeout (configured in ansible.cfg)
# Override per-task:
- name: Long-running task
  ansible.builtin.command: slow-command
  timeout: 300  # 5 minutes
```

**Connection Issues:**
```bash
# Test connectivity first
ansible localhost -m ping
```

**Variable Issues:**
```bash
# Debug variables
ansible-playbook playbook.yml --extra-vars "ansible_verbosity=2"
```

## Best Practices

### 1. Always Use Stage Prefixes
```yaml
- name: "STAGE 2/5: Descriptive task name"
```

### 2. Track Duration for Long Operations
```yaml
- name: Record start time
  set_fact:
    task_start: "{{ ansible_date_time.epoch }}"

- name: Long operation
  # ... task ...

- name: Calculate duration
  set_fact:
    task_duration: "{{ ansible_date_time.epoch | int - task_start | int }}"
```

### 3. Add Progress Messages
```yaml
- name: Show progress
  debug:
    msg: "Processing file {{ item }} ({{ ansible_loop.index }}/{{ ansible_loop.length }})"
  loop: "{{ files }}"
  loop_control:
    extended: yes
```

### 4. Use Tags for Selective Execution
```yaml
tags: [sanitize, validate, publish, always]
```

### 5. Enable Diff for File Changes
```yaml
# Already enabled globally in ansible.cfg
# Shows before/after for file modifications
```

## Monitoring Checklist

Before running any playbook:
- [ ] Check `ansible-execution.log` doesn't have old errors
- [ ] Verify VPN connection (for Red Hat playbooks)
- [ ] Check disk space (logs can grow)
- [ ] Have second terminal ready for log monitoring

During execution:
- [ ] Watch stage progress
- [ ] Monitor timing (stages should complete in <60s each)
- [ ] Check for warnings
- [ ] Verify expected "changed" count

After execution:
- [ ] Review execution log
- [ ] Check timing report
- [ ] Verify all stages completed
- [ ] Review sanitization report (if applicable)

## Log Rotation

```bash
# Keep logs organized
mkdir -p logs
mv ansible-execution.log logs/ansible-$(date +%Y%m%d-%H%M%S).log

# Or set in ansible.cfg:
# log_path = logs/ansible-%(date)s.log
```

## Integration with CI/CD

```bash
# Machine-readable output for automation
ansible-playbook playbook.yml \
  --extra-vars "@vars.yml" \
  --tags publish \
  -vv \
  2>&1 | tee build.log
```

---

**Pro Tip:** Open 3 terminals when running playbooks:
1. **Playbook execution** with `-vv`
2. **Log monitoring** with `tail -f ansible-execution.log`
3. **Quick commands** for troubleshooting

