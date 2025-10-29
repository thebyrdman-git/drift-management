# Red Hat GitLab Setup Instructions

## Security Validation ✅

Content has been sanitized and validated safe for Red Hat internal GitLab:

- **Files Scanned**: 39
- **Critical Findings**: 0
- **High Severity**: 0
- **Status**: Safe to publish

See sanitization report: `/tmp/sanitization-report.txt`

## Create Repository

**Bot token limitation**: The Taminator bot token is project-specific and cannot create new repos.

### Manual Creation Steps

1. **Visit**: https://gitlab.cee.redhat.com/projects/new

2. **Configure**:
   - **Project name**: drift-management
   - **Project URL**: jbyrd/drift-management
   - **Visibility Level**: Internal (Red Hat only)
   - **Project description**: Multi-system content synchronization with metadata-driven configuration
   - **Initialize with README**: ❌ Uncheck (we have content)

3. **Add Topics** (after creation):
   - ansible
   - drift-management
   - automation
   - content-sync
   - devops
   - redhat-internal

4. **Push Content**:
   ```bash
   cd /home/jbyrd/drift-management
   git push gitlab main
   ```

5. **Verify**:
   - Repository: https://gitlab.cee.redhat.com/jbyrd/drift-management
   - All files present
   - README displays correctly

## Automated Publishing (Future)

Once created, future updates can use:

```bash
cd /home/jbyrd/drift-management
ansible-playbook ansible/playbooks/sanitize-and-publish-gitlab.yml \
  -e "content_dir=/home/jbyrd/drift-management"
```

This will:
1. ✅ Scan for sensitive data
2. ✅ Validate security compliance
3. ✅ Check VPN connectivity
4. ✅ Push to GitLab (if repo exists)

## Security Standards Enforced

### Blocked Content (Critical)
- API keys and tokens
- Passwords and secrets
- GitHub/GitLab personal access tokens

### Flagged for Review (High)
- Personal email addresses
- Personal usernames
- Personal server names

### Monitored (Medium/Low)
- Customer/confidential references
- Private IP addresses

All checks must pass before push is allowed.

