---
description: "Pull request titles and descriptions formatting"
---

# Pull Request Instructions

## PR Title Format

Use the same format as commit messages:

```
<type>[optional scope]: <description>
```

## PR Description Template

```markdown
## Description

Brief description of the changes made.

## Type of Change

- [ ] Bug fix (non-breaking change which fixes an issue)
- [ ] New feature (non-breaking change which adds functionality)
- [ ] Breaking change (fix or feature that would cause existing functionality to not work as expected)
- [ ] Documentation update
- [ ] Performance improvement
- [ ] Code refactoring

## Related Issues

- Closes #[issue_number]
- Fixes #[issue_number]
- Related to #[issue_number]

## Changes Made

- List of specific changes
- Use bullet points for clarity
- Include any architectural decisions

## Testing

- [ ] Unit tests added/updated
- [ ] Integration tests added/updated
- [ ] Manual testing completed
- [ ] All tests passing

## Screenshots (if applicable)

Include screenshots or GIFs for UI changes.

## Checklist

- [ ] My code follows the style guidelines of this project
- [ ] I have performed a self-review of my own code
- [ ] I have commented my code, particularly in hard-to-understand areas
- [ ] I have made corresponding changes to the documentation
- [ ] My changes generate no new warnings
- [ ] I have added tests that prove my fix is effective or that my feature works
- [ ] New and existing unit tests pass locally with my changes
- [ ] Any dependent changes have been merged and published

## Deployment Notes

Any special considerations for deployment or configuration changes.

## Breaking Changes

Detail any breaking changes and migration steps if applicable.
```

## PR Guidelines

- Keep PRs focused and as small as possible
- Use clear, descriptive titles
- Provide comprehensive descriptions
- Include relevant context and motivation
- Link related issues and documentation
- Request specific reviewers when needed
- Respond to feedback promptly and constructively
- Ensure CI/CD checks pass before requesting review

## Review Process

- At least one approval required for merging
- Address all reviewer comments before merging
- Squash commits if appropriate to maintain clean history
- Delete feature branch after merging
- Update project documentation if needed
