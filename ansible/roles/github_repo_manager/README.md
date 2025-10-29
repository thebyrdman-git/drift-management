# GitHub Repository Manager

**Opinionated GitHub repository creation and management with enforced best practices.**

## Philosophy

This role makes decisions for you. It enforces consistent practices across all repositories:

- ✅ Repository names MUST be lowercase-with-dashes
- ✅ Every repo MUST have a description (min 10 chars)
- ✅ Every repo MUST have 3-10 topics
- ✅ Main branch is ALWAYS 'main', never 'master'
- ✅ Force pushes to main are DISABLED
- ✅ Branch deletion is DISABLED
- ✅ Squash merges ONLY (no merge commits)
- ✅ Branches auto-delete after merge
- ✅ Wiki and Projects DISABLED (use README and Issues)

## Why Opinionated?

**Consistency > Flexibility**. Every repository follows the same standards, making them:
- Easier to navigate
- Easier to contribute to
- Professional and predictable
- Following GitHub best practices

## Usage

```yaml
- hosts: localhost
  roles:
    - role: github_repo_manager
      vars:
        repo_name: my-awesome-project
        repo_description: "Complete description of what this does"
        repo_visibility: public
        repo_topics:
          - ansible
          - automation
          - devops
        repo_source_dir: /home/user/my-project
```

## Required Variables

```yaml
repo_name: string          # Must be lowercase-with-dashes
repo_description: string   # Min 10 characters
repo_topics: list         # 3-10 topics required
```

## Optional Variables

```yaml
repo_visibility: public|private    # Default: public
repo_source_dir: path             # If creating from existing code
github_org: string                # If creating in an org
```

## Standards Enforced

### Repository Naming
- ✅ **GOOD:** `drift-management`, `tam-tools`, `ai-infrastructure`
- ❌ **BAD:** `DriftManagement`, `tam_tools`, `AI-Infrastructure`

### Description
- ✅ **GOOD:** "Multi-system content synchronization with metadata-driven configuration"
- ❌ **BAD:** "My project" (too short, not descriptive)

### Topics
- ✅ **GOOD:** `[ansible, drift-management, automation, devops, multi-system]`
- ❌ **BAD:** `[code]` (too few, not descriptive)

### Branch Strategy
- Main branch: `main` (enforced, never `master`)
- Feature branches: `feature/description`
- Bug fixes: `fix/description`
- Delete branches after merge (automatic)

### Merge Strategy
- Squash merge ONLY (creates clean history)
- No merge commits (keeps history linear)
- No rebase merge (prefer squash)

## What Gets Created

1. GitHub repository
2. Branch protection on main
3. Topics/tags
4. Repository settings
5. Default labels
6. README validation

## Requirements

- GitHub CLI (`gh`) installed
- Authenticated: `gh auth login`
- Git configured locally

## Examples

### Create Public Repository

```yaml
- name: Create public repo with standards
  include_role:
    name: github_repo_manager
  vars:
    repo_name: my-new-project
    repo_description: "Amazing project that does amazing things"
    repo_topics:
      - python
      - automation
      - cli-tool
```

### Create Private Repository

```yaml
- name: Create private repo
  include_role:
    name: github_repo_manager
  vars:
    repo_name: secret-project
    repo_description: "Internal tooling for company use"
    repo_visibility: private
    repo_topics:
      - internal
      - tooling
      - automation
```

### Create from Existing Code

```yaml
- name: Publish existing project
  include_role:
    name: github_repo_manager
  vars:
    repo_name: existing-project
    repo_description: "Project that already exists locally"
    repo_source_dir: /home/user/projects/existing-project
    repo_topics:
      - nodejs
      - web
      - api
```

## Integration with drift-management

This role is used by the `publish-to-github.yml` playbook for consistent repository creation.

## Customization

Don't like the defaults? Fork and change `defaults/main.yml`. But remember:
**Consistency is more valuable than personal preference.**

