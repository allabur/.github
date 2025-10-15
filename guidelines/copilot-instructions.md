# GitHub Copilot Instructions for git-flow-next

This document provides GitHub Copilot with essential context for working with git-flow-next. For comprehensive development information, refer to [CLAUDE.md](../CLAUDE.md) which contains complete architectural details, coding guidelines, and development commands.

## Quick Reference

git-flow-next is a modern Go implementation of git-flow with these key characteristics:

- **Unified topic branch architecture** - Single command structure for all branch types
- **Configuration-driven workflows** - Behavior defined via Git config  
- **Three-layer configuration precedence** - Defaults → Git config → CLI flags (always win)
- **Pragmatic development philosophy** - Anti-over-engineering, explicit over implicit

## Essential Patterns

### Development Commands
```bash
# Building and testing (see CLAUDE.md for complete reference)
go build -o git-flow main.go              # Build local binary
go test ./...                             # Run all tests  
./scripts/build.sh                        # Multi-platform build
```

### Version Updates
When updating version information, ensure both locations are updated:
- `version/version.go` - Core version constant used by the application
- `cmd/version.go` - Version variable used by the version command

Both files must have matching version numbers to maintain consistency.

### Command Structure (Universal Pattern)
```go
// Layer 1: Cobra Command Handler
RunE: func(cmd *cobra.Command, args []string) error {
    // Parse flags, call command wrapper
    CommandName(branchType, name, param1, param2)
    return nil
}

// Layer 2: Command Wrapper - Handle errors and exit codes
func CommandName(params...) {
    if err := executeCommand(params...); err != nil {
        // Convert to exit code and exit
    }
}

// Layer 3: Execute Function - Business logic only
func executeCommand(params...) error {
    // Load config ONCE at start, pass to all functions
    cfg, err := config.LoadConfig()
    // Implementation logic
    return nil
}
```

### Configuration Loading Pattern
```go
// CRITICAL: Load once at start, pass everywhere
cfg, err := config.LoadConfig()
if err != nil {
    return &errors.GitError{Operation: "load configuration", Err: err}
}
// Pass cfg to all helper functions
```

### Error Handling Pattern
```go
// Custom structured errors with exit codes
if err := git.BranchExists(branchName); err != nil {
    return &errors.BranchNotFoundError{BranchName: branchName}
}

// Git operation wrapping
if err := git.Checkout(branchName); err != nil {
    return &errors.GitError{
        Operation: fmt.Sprintf("checkout branch '%s'", branchName),
        Err:       err,
    }
}
```

## Key Files and Locations

### Core Implementation
- `cmd/` - All CLI commands using Cobra framework
- `internal/config/` - Configuration management and branch definitions  
- `internal/git/` - Git command wrappers with error handling
- `internal/errors/` - Custom error types with exit codes
- `internal/mergestate/` - Multi-step operation state persistence

### Documentation (Complete Reference)
- **[CLAUDE.md](../CLAUDE.md)** - Complete development guide and architecture
- **[ARCHITECTURE.md](../ARCHITECTURE.md)** - Technical architecture deep dive
- **[CODING_GUIDELINES.md](../CODING_GUIDELINES.md)** - Detailed coding standards
- **[CONFIGURATION.md](../CONFIGURATION.md)** - Configuration system reference

### Testing
- `test/` - Test files mirroring source structure
- `testutil/` - Git repository helpers and test utilities

## Mandatory Development Requirements

When making changes, you **MUST always**:

1. **Create/adjust tests** for new functionality
2. **Run all tests**: `go test ./...`
3. **Update relevant documentation** (.md files for user-facing changes)

## Branch Types and Configuration

### Base Branches (Long-living)
```go
// main (root branch)
gitflow.branch.main.type=base
gitflow.branch.main.parent=""

// develop (child of main, auto-updates)  
gitflow.branch.develop.type=base
gitflow.branch.develop.parent=main
gitflow.branch.develop.autoUpdate=true
```

### Topic Branches (Short-living)  
```go
// feature branches
gitflow.branch.feature.type=topic
gitflow.branch.feature.parent=develop
gitflow.branch.feature.prefix="feature/"
gitflow.branch.feature.upstreamStrategy=merge
gitflow.branch.feature.downstreamStrategy=rebase
```

## Critical Implementation Notes

1. **Three-layer configuration**: Branch defaults → Git config → CLI flags (always win)
2. **Load config once**: At command start, pass to all functions  
3. **Use Git wrappers**: Never call git directly, use `internal/git` package
4. **Structured errors**: Return specific error types with exit codes
5. **State persistence**: Save state for multi-step operations that can be interrupted

## Integration Points

- **git-flow-avh compatibility** - Import existing configurations
- **Tower integration** - Git Tower GUI uses same config system
- **CI/CD pipelines** - Webhook-triggered deployments based on branch patterns

---

**For complete architectural details, coding guidelines, testing practices, and configuration examples, see [CLAUDE.md](../CLAUDE.md)**