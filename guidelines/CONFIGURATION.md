# Configuration Reference

This document provides a comprehensive reference for all git-flow-next configuration options. All configuration is stored in Git configuration using the `gitflow.*` key namespace.

## Configuration Overview

git-flow-next uses a hierarchical configuration system with **three levels of precedence**:

1. **Branch Type Configuration** (`gitflow.branch.*`) - Default behavior for branch types
2. **Command-Specific Overrides** (`gitflow.<branchtype>.*`) - Override defaults for specific commands  
3. **Command-Line Arguments** - **Highest priority** - always override configuration

## Core System Configuration

### System Settings

| Key | Description | Default | Example |
|-----|-------------|---------|---------|
| `gitflow.version` | Internal version marker for compatibility | `1.0` | `1.0` |
| `gitflow.initialized` | Marks repository as git-flow initialized | `false` | `true` |
| `gitflow.origin` | Remote name to use for operations | `origin` | `upstream` |
| `gitflow.remote` | Alias for `gitflow.origin` | `origin` | `upstream` |

## Branch Type Configuration

Branch type configuration defines the default behavior for each branch type using the pattern:
`gitflow.branch.<branchname>.<property>`

### Universal Branch Properties

All branch types (both base and topic) support these properties:

| Property | Description | Values | Default |
|----------|-------------|--------|---------|
| `type` | Branch type classification | `base`, `topic` | Required |
| `parent` | Parent branch for this branch type | Branch name | Varies by type |
| `startPoint` | Default branch to start from | Branch name | Same as parent |
| `upstreamStrategy` | Strategy when merging TO parent | `merge`, `rebase`, `squash` | `merge` |
| `downstreamStrategy` | Strategy when updating FROM parent | `merge`, `rebase` | `merge` |
| `autoUpdate` | Auto-update from parent on finish | `true`, `false` | `false` |

### Topic Branch Additional Properties

Topic branches support additional properties:

| Property | Description | Values | Default |
|----------|-------------|--------|---------|
| `prefix` | Branch name prefix | String ending in `/` | `<type>/` |
| `tag` | Create tags on finish | `true`, `false` | `false` |
| `tagprefix` | Prefix for created tags | String | `""` |
| `deleteRemote` | Delete remote branch by default | `true`, `false` | `false` |

### Default Branch Types

#### Base Branches

```bash
# Main branch (production releases)
gitflow.branch.main.type=base
gitflow.branch.main.parent=             # No parent (root)
gitflow.branch.main.upstreamStrategy=merge
gitflow.branch.main.downstreamStrategy=merge
gitflow.branch.main.autoUpdate=false

# Develop branch (integration)  
gitflow.branch.develop.type=base
gitflow.branch.develop.parent=main
gitflow.branch.develop.startPoint=main
gitflow.branch.develop.upstreamStrategy=merge
gitflow.branch.develop.downstreamStrategy=merge
gitflow.branch.develop.autoUpdate=true    # Auto-updates from main
```

#### Topic Branches

```bash
# Feature branches
gitflow.branch.feature.type=topic
gitflow.branch.feature.parent=develop
gitflow.branch.feature.startPoint=develop
gitflow.branch.feature.prefix=feature/
gitflow.branch.feature.upstreamStrategy=merge
gitflow.branch.feature.downstreamStrategy=rebase
gitflow.branch.feature.tag=false
gitflow.branch.feature.autoUpdate=false

# Release branches
gitflow.branch.release.type=topic
gitflow.branch.release.parent=main
gitflow.branch.release.startPoint=develop
gitflow.branch.release.prefix=release/
gitflow.branch.release.upstreamStrategy=merge
gitflow.branch.release.downstreamStrategy=merge
gitflow.branch.release.tag=true
gitflow.branch.release.tagprefix=v
gitflow.branch.release.autoUpdate=false

# Hotfix branches  
gitflow.branch.hotfix.type=topic
gitflow.branch.hotfix.parent=main
gitflow.branch.hotfix.startPoint=main
gitflow.branch.hotfix.prefix=hotfix/
gitflow.branch.hotfix.upstreamStrategy=merge
gitflow.branch.hotfix.downstreamStrategy=merge
gitflow.branch.hotfix.tag=true
gitflow.branch.hotfix.tagprefix=v
gitflow.branch.hotfix.autoUpdate=false
```

#### Custom Branch Types

You can define custom branch types by setting the appropriate configuration:

```bash
# Example: Support branches
gitflow.branch.support.type=topic
gitflow.branch.support.parent=main
gitflow.branch.support.startPoint=main
gitflow.branch.support.prefix=support/
gitflow.branch.support.tag=true
gitflow.branch.support.tagprefix=support-
```

## Command-Specific Configuration

Command-specific configuration overrides branch defaults using the pattern:
`gitflow.<branchtype>.<command>.<option>`

### Finish Command Options

The finish command supports per-branch-type configuration:

| Option | Description | Values | Default |
|--------|-------------|--------|---------|
| `merge` | Override merge strategy | `merge`, `rebase`, `squash` | From branch config |
| `notag` | Disable tag creation | `true`, `false` | Opposite of branch `tag` |
| `sign` | Sign created tags | `true`, `false` | `false` |
| `signingkey` | GPG key for signing | Key ID | Git default |
| `messagefile` | File containing tag message | File path | None |
| `keep` | Keep branch after finish | `true`, `false` | `false` |
| `keepremote` | Keep remote branch | `true`, `false` | `false` |
| `keeplocal` | Keep local branch | `true`, `false` | `false` |
| `force-delete` | Force delete branch | `true`, `false` | `false` |
| `fetch` | Fetch before operation | `true`, `false` | `false` |

#### Examples

```bash
# Override feature finish to use rebase
gitflow.feature.finish.merge=rebase

# Disable tags for feature branches
gitflow.feature.finish.notag=true

# Sign all release tags
gitflow.release.finish.sign=true
gitflow.release.finish.signingkey=ABC123DEF

# Keep hotfix branches locally after finish
gitflow.hotfix.finish.keeplocal=true
```

### Update Command Options

| Option | Description | Values | Default |
|--------|-------------|--------|---------|
| `downstreamStrategy` | Override update strategy | `merge`, `rebase` | From branch config |

#### Examples

```bash
# Force rebase for feature updates
gitflow.feature.downstreamStrategy=rebase

# Use merge for release updates
gitflow.release.downstreamStrategy=merge
```

## Configuration Precedence

git-flow-next follows a strict three-layer precedence hierarchy:

### Layer 1: Branch Configuration (Lowest Priority)
Default behavior from `gitflow.branch.<branchtype>.*` settings
```bash
gitflow.branch.release.tag=true
```

### Layer 2: Command-Specific Overrides (Medium Priority)
Command-specific settings from `gitflow.<branchtype>.<command>.*`
```bash
gitflow.release.finish.notag=true  # Overrides branch default
```

### Layer 3: Command-Line Arguments (Highest Priority)
Command-line flags **always win**
```bash
git flow release finish v1.0 --tag  # Overrides all config
```

## Legacy Compatibility

### Git-Flow-AVH Compatibility

git-flow-next automatically imports configuration from git-flow-avh installations:

| AVH Key | git-flow-next Equivalent | Description |
|---------|--------------------------|-------------|
| `gitflow.branch.master` | `gitflow.branch.main` | Main branch name |
| `gitflow.branch.develop` | `gitflow.branch.develop` | Develop branch name |
| `gitflow.prefix.feature` | `gitflow.branch.feature.prefix` | Feature prefix |
| `gitflow.prefix.release` | `gitflow.branch.release.prefix` | Release prefix |
| `gitflow.prefix.hotfix` | `gitflow.branch.hotfix.prefix` | Hotfix prefix |
| `gitflow.prefix.support` | `gitflow.branch.support.prefix` | Support prefix |
| `gitflow.prefix.versiontag` | `gitflow.branch.*.tagprefix` | Tag prefix |

### Migration from git-flow-avh

1. **Automatic Import**: Run `git flow init` to automatically import existing configuration
2. **Manual Migration**: Use the mapping table above to convert AVH config to git-flow-next format
3. **Verification**: Run `git flow overview` to verify imported configuration

## Configuration Examples

### Simple GitHub Flow

```bash
# Minimal configuration - feature branches only
git config gitflow.branch.main.type base
git config gitflow.branch.feature.type topic
git config gitflow.branch.feature.parent main
git config gitflow.branch.feature.prefix feature/
```

### Traditional Git-Flow

```bash
# Full git-flow with main, develop, and all topic types
git config gitflow.branch.main.type base
git config gitflow.branch.develop.type base
git config gitflow.branch.develop.parent main
git config gitflow.branch.develop.autoUpdate true

git config gitflow.branch.feature.type topic
git config gitflow.branch.feature.parent develop
git config gitflow.branch.feature.prefix feature/

git config gitflow.branch.release.type topic
git config gitflow.branch.release.parent main
git config gitflow.branch.release.startPoint develop
git config gitflow.branch.release.tag true
git config gitflow.branch.release.tagprefix v

git config gitflow.branch.hotfix.type topic
git config gitflow.branch.hotfix.parent main
git config gitflow.branch.hotfix.tag true
git config gitflow.branch.hotfix.tagprefix v
```

### Custom Workflow

```bash
# Custom branch types with specific merge strategies
git config gitflow.branch.bugfix.type topic
git config gitflow.branch.bugfix.parent develop
git config gitflow.branch.bugfix.prefix bugfix/
git config gitflow.branch.bugfix.upstreamStrategy squash

# Custom finish behavior
git config gitflow.bugfix.finish.notag true
git config gitflow.bugfix.finish.keep true
```

## Configuration Management

### Viewing Configuration

```bash
# View all git-flow configuration
git config --get-regexp '^gitflow\.'

# View branch-specific configuration
git config --get-regexp '^gitflow\.branch\.feature\.'

# View command-specific configuration  
git config --get-regexp '^gitflow\.feature\.finish\.'
```

### Setting Configuration

```bash
# Set branch type configuration
git config gitflow.branch.feature.upstreamStrategy rebase

# Set command-specific configuration
git config gitflow.feature.finish.merge squash

# Set global configuration (all repositories)
git config --global gitflow.feature.finish.notag true
```

### Removing Configuration

```bash
# Remove specific setting
git config --unset gitflow.feature.finish.merge

# Remove all git-flow configuration (reset)
git config --remove-section gitflow
```

## Best Practices

1. **Start with defaults** - Use `git flow init --defaults` for standard configuration
2. **Customize gradually** - Override only what you need to change
3. **Document team conventions** - Use consistent configuration across team repositories
4. **Use command precedence** - Rely on command-line flags for one-off operations
5. **Test configuration** - Use `git flow overview` to verify your setup
6. **Backup configuration** - Export configuration before major changes:
   ```bash
   git config --get-regexp '^gitflow\.' > gitflow-backup.txt
   ```