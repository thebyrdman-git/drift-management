# GitLab Repository Manager Role

Ansible role for creating and managing GitLab repositories with enforced Red Hat internal standards.

## Features

- ✅ **API-Based**: Uses GitLab REST API (no CLI dependency)
- ✅ **Opinionated Standards**: Enforces Red Hat naming, visibility, and configuration
- ✅ **Security First**: Token-based authentication, no hardcoded credentials
- ✅ **Idempotent**: Safe to run multiple times
- ✅ **Validation**: Checks naming conventions, topics, descriptions

## Requirements

### GitLab Personal Access Token

**Create token**: https://gitlab.cee.redhat.com/-/profile/personal_access_tokens

**Required Scopes**:
- `api` - Full API access
- `write_repository` - Push code

**Store token securely**:

```bash
# Option 1: Environment variable
export GITLAB_TOKEN="glpat-xxxxxxxxxxxxxxxxxxxx"

# Option 2: Secure file
mkdir -p ~/.config/pai/secrets
echo "glpat-xxxxxxxxxxxxxxxxxxxx" > ~/.config/pai/secrets/gitlab-token
chmod 600 ~/.config/pai/secrets/gitlab-token
```

## Role Variables

### Required Variables

```yaml
repo_name: "my-project"                    # Repository name (lowercase-with-dashes)
repo_description: "Project description"    # Minimum 10 characters
repo_topics:                               # Minimum 3 topics
  - ansible
  - automation
  - redhat-internal
```

### Optional Variables

```yaml
# GitLab instance
gitlab_api_url: "https://gitlab.cee.redhat.com/api/v4"

# Repository visibility
repo_visibility: internal  # public|internal|private (default: internal)

# Branch protection
branch_protection_enabled: true
protected_branch: main
allow_force_pushes: false

# Merge settings
merge_method: "squash"
remove_source_branch_after_merge: true

# Authentication
gitlab_token_env: "GITLAB_TOKEN"
gitlab_token_file: "~/.config/pai/secrets/gitlab-token"
```

## Usage Examples

### Basic Repository Creation

```yaml
- name: Create GitLab repository
  ansible.builtin.include_role:
    name: gitlab_repo_manager
  vars:
    repo_name: "my-project"
    repo_description: "My awesome Red Hat project"
    repo_topics:
      - ansible
      - automation
      - tam-tools
```

### Full Configuration

```yaml
- name: Create and configure GitLab repository
  ansible.builtin.include_role:
    name: gitlab_repo_manager
  vars:
    repo_name: "drift-management"
    repo_description: "Multi-system content synchronization"
    repo_visibility: internal
    repo_topics:
      - ansible
      - drift-management
      - automation
      - content-sync
    branch_protection_enabled: true
    protected_branch: main
```

### Playbook Integration

```yaml
---
- name: Publish to Red Hat GitLab
  hosts: localhost
  gather_facts: false
  
  roles:
    - role: gitlab_repo_manager
      vars:
        repo_name: "{{ project_name }}"
        repo_description: "{{ project_description }}"
        repo_topics: "{{ project_topics.split(',') | map('trim') | list }}"
```

## Enforced Standards

### Repository Naming

- ✅ Lowercase letters and numbers only
- ✅ Hyphens allowed (not at start/end)
- ✅ Examples: `drift-management`, `tam-tools`, `ansible-playbooks`
- ❌ Invalid: `MyProject`, `project_name`, `-project`, `project-`

### Topics

- ✅ Minimum 3 topics required
- ✅ Maximum 10 topics
- ✅ Auto-adds: `redhat-internal`

### Description

- ✅ Minimum 10 characters
- ✅ Clear, descriptive summary

### Visibility

- ✅ Default: `internal` (Red Hat policy)
- ✅ Options: `public`, `internal`, `private`

### Branch Protection

- ✅ Main branch protected by default
- ✅ Force pushes disabled
- ✅ Maintainer access required

## API Authentication Flow

1. **Load Token**: Check environment variable → Check file
2. **Validate**: Test authentication with `/user` endpoint
3. **Display User**: Show authenticated username
4. **Proceed**: Use token for all API operations

## Return Values

After successful execution, the following facts are available:

```yaml
gitlab_repo_id: 123456                                           # Repository ID
gitlab_repo_url: "https://gitlab.cee.redhat.com/jbyrd/project"  # Web URL
gitlab_repo_ssh: "git@gitlab.cee.redhat.com:jbyrd/project.git"  # SSH clone URL
gitlab_repo_https: "https://gitlab.cee.redhat.com/jbyrd/project.git"  # HTTPS clone URL
```

## Error Handling

### Missing Token

```
FAILED! => GitLab API token not found!

Set token via:
1. Environment variable: export GITLAB_TOKEN="glpat-..."
2. File: ~/.config/pai/secrets/gitlab-token

Get token from: https://gitlab.cee.redhat.com/-/profile/personal_access_tokens
Required scopes: api, write_repository
```

### Invalid Naming

```
FAILED! => Repository name must follow Red Hat standards:
• Lowercase letters and numbers only
• Hyphens allowed (not at start/end)
• Example: drift-management, tam-tools, ansible-playbooks

Invalid name: MyProject
```

### Insufficient Topics

```
FAILED! => Topics required: 3-10
Current: 2
```

## Security Considerations

- ✅ **No Hardcoded Tokens**: Always use environment or secure file
- ✅ **Token Scope**: Only `api` and `write_repository` needed
- ✅ **File Permissions**: Token file should be `600` (read/write owner only)
- ✅ **No Logging**: API token never appears in logs (`no_log: true`)
- ✅ **HTTPS Only**: All API calls use TLS encryption

## Dependencies

None. Uses Ansible built-in modules only:
- `ansible.builtin.uri` - API calls
- `ansible.builtin.set_fact` - Variable management
- `ansible.builtin.assert` - Validation

## License

Red Hat Internal Use

## Author

Jimmy Byrd (jbyrd@redhat.com)

---

**Remember**: This role enforces opinionated standards for consistency across Red Hat projects. If you need flexibility, discuss with the team before overriding defaults.

