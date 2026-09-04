# .github

Default community health files and reusable GitHub Actions workflows for repositories under the allabur account.

## Contents

### Community Health Files

- **CODEOWNERS**: Default code ownership
- **PULL_REQUEST_TEMPLATE.md**: Standardized PR format
- **ISSUE_TEMPLATE/**: Bug reports, feature requests, refactoring
- **labels.yml**: Consistent label definitions

### Workflows

- **workflows/labels.yml**: Syncs `labels.yml` to the repo
- **workflows/release.yml**: Semantic versioning releases from main
- **workflows/pre-release.yml**: RC releases from develop
- **dependabot.yml**: Automated dependency updates

### Scripts

- **scripts/migrate-to-uv.sh**: Migrate projects from conda/mamba/pip/Poetry to uv
- **scripts/setup-dev.sh**: Development environment bootstrap

### Guidelines

- **docs/guidelines/**: Coding, testing, commit, and configuration standards referenced from `CLAUDE.md`

## Integration

These defaults apply automatically to any repository under the `allabur` account that doesn't provide its own version.

## Resources

- [GitHub default community health files](https://docs.github.com/en/communities/setting-up-your-project-for-healthy-contributions/creating-a-default-community-health-file)
- [Conventional Commits](https://www.conventionalcommits.org/)
- [uv Documentation](https://docs.astral.sh/uv/)
