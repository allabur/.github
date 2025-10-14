# Copilot Prompts

Reusable, task-specific prompts for GitHub Copilot Chat. Invoke with `/` command (e.g., `/analyze-dataframe`).

## Available Prompts

### Data Analysis & Science

#### [analyze-dataframe.prompt.md](analyze-dataframe.prompt.md)

**Command**: `/analyze-dataframe`

Comprehensive DataFrame analysis providing:

- Data overview (shape, types, memory)
- Quality assessment (missing values, duplicates, outliers)
- Statistical summary (distributions, correlations)
- Data issues and red flags
- Actionable cleaning recommendations with code

**Best for**: Exploratory data analysis, data quality checks, cleaning pipelines

---

#### [create-latex-table.prompt.md](create-latex-table.prompt.md)

**Command**: `/create-latex-table`

Convert data into professional LaTeX tables with:

- Booktabs formatting (publication-ready)
- Proper column alignment
- Number formatting (siunitx)
- Caption and labels
- Support for multirow/multicolumn

**Best for**: Academic papers, research reports, statistical tables

---

### Python Development

#### [document-function.prompt.md](document-function.prompt.md)

**Command**: `/document-function`

Generate NumPy-style docstrings including:

- Summary and extended description
- Parameters with types
- Returns with types
- Raises (exceptions)
- Examples (typical and edge cases)
- Notes (performance, algorithms)

**Best for**: Documenting functions, classes, maintaining code clarity

---

#### [generate-pytest.prompt.md](generate-pytest.prompt.md)

**Command**: `/generate-pytest`

Create comprehensive pytest tests with:

- AAA pattern (Arrange-Act-Assert)
- Happy path tests
- Edge case coverage
- Error case handling
- Fixtures and parametrization
- Clear naming conventions

**Best for**: TDD, increasing test coverage, regression testing

---

#### [optimize-code.prompt.md](optimize-code.prompt.md)

**Command**: `/optimize-code`

Performance optimization including:

- Bottleneck identification
- Algorithmic improvements
- Vectorization strategies
- Profiling guidance
- Expected speedup estimates
- Trade-off analysis

**Best for**: Slow code, performance-critical sections, scaling issues

---

### Git & Version Control

#### [review-commit.prompt.md](review-commit.prompt.md)

**Command**: `/review-commit`

Review staged changes and generate:

- Conventional commit messages
- Type selection (feat/fix/docs/etc.)
- Detailed body with context
- Issue references
- Breaking change flags
- Split recommendations

**Best for**: Git commits, maintaining clean history, conventional commits

---

### AI & Prompt Engineering

#### [ai-prompt-engineering-safety-review.prompt.md](ai-prompt-engineering-safety-review.prompt.md)

**Command**: `/ai-safety-review`

Comprehensive prompt safety review:

- Safety assessment (harmful content, misinformation)
- Bias detection (gender, racial, cultural)
- Security analysis (data exposure, injection)
- Effectiveness evaluation
- Best practices compliance
- Improvement recommendations

**Best for**: Reviewing AI prompts, ensuring responsible AI usage

---

## Usage

### Basic Usage

1. Open file or select code
2. Open Copilot Chat (Cmd+I or Ctrl+I)
3. Type `/` to see available prompts
4. Select prompt or type full command
5. Review and apply suggestions

### Context-Aware Suggestions

Prompts are automatically suggested based on file type:

- **Python files** → document-function, generate-pytest, optimize-code
- **Jupyter notebooks** → analyze-dataframe, create-latex-table
- **Test files** → generate-pytest
- **LaTeX files** → create-latex-table
- **Data files (CSV/Excel)** → analyze-dataframe, create-latex-table

Configure in `settings.json`:

```jsonc
"chat.promptFilesRecommendations": {
  "**/*.py": ["prompts/document-function.prompt.md"],
  "**/*.ipynb": ["prompts/analyze-dataframe.prompt.md"]
}
```

See [docs/prompt-recommendations-config.md](../docs/prompt-recommendations-config.md) for full configuration.

## Common Workflows

### Data Analysis Workflow

```
1. Load data
2. /analyze-dataframe → Identify issues
3. Apply cleaning recommendations
4. /create-latex-table → Export results
```

### Python Development Workflow

```
1. Write function
2. /document-function → Add docstring
3. /generate-pytest → Create tests
4. /optimize-code → If needed
```

### Git Commit Workflow

```
1. git add <files>
2. /review-commit → Generate message
3. Review and adjust
4. git commit -F message.txt
```

## Creating Custom Prompts

### Template Structure

```markdown
---
description: "Brief description of what the prompt does"
mode: "agent" # optional: for autonomous agent behavior
---

# Prompt Title

You are an expert in [domain]. [Define the task].

## Requirements

- Requirement 1
- Requirement 2

## Output Format

[Expected format]

## Guidelines

- Guideline 1
- Guideline 2
```

### Best Practices

- ✅ Use clear, specific instructions
- ✅ Provide examples of expected output
- ✅ Include edge cases and constraints
- ✅ Specify output format
- ✅ Test with various inputs
- ❌ Don't make prompts too generic
- ❌ Don't assume context without specifying

### Example: Custom Prompt

```markdown
---
description: "Generate SQL query from natural language"
---

# Generate SQL Query

You are a SQL expert. Convert natural language descriptions into optimized SQL queries.

## Requirements

- Use PostgreSQL syntax
- Include proper JOINs
- Add WHERE clauses for filtering
- Use CTEs for complex queries
- Include comments

## Output Format

\`\`\`sql
-- Query description
SELECT ...
FROM ...
WHERE ...
\`\`\`
```

## Integration

### With Instructions

Prompts work alongside `.instructions.md` files:

- **Instructions**: Continuous guidance applied automatically
- **Prompts**: On-demand, task-specific assistance

### With Chat Modes

Combine prompts with chat modes for specialized contexts:

- Activate chat mode (e.g., `4.1-Beast.chatmode.md`)
- Use prompts within that mode
- Mode provides context, prompts provide structure

### With MCP Servers

Access additional prompts from MCP servers:

- awesome-copilot server provides community prompts
- Use `/mcp` commands for extended functionality

## Troubleshooting

### Prompt Not Appearing

- Check `"chat.promptFiles": true` in settings
- Verify path in `"chat.promptFilesLocations"`
- Ensure file has `.prompt.md` extension
- Reload VS Code window

### Prompt Not Working as Expected

- Review prompt structure and formatting
- Check for clear instructions
- Add more specific examples
- Test with different inputs

### Performance Issues

- Keep prompts focused and concise
- Avoid extremely long prompts
- Use mode: 'agent' sparingly

## Resources

- [Quick Reference](../docs/prompts-quick-reference.md)
- [Configuration Guide](../docs/prompt-recommendations-config.md)
- [Copilot Instructions](../copilot-instructions.md)
- [VS Code Prompt Files Docs](https://aka.ms/vscode-instructions-docs)

## Contributing

To add a new prompt:

1. Create `<name>.prompt.md` in this directory
2. Follow the template structure
3. Test thoroughly
4. Update this README
5. Add to prompt recommendations config
6. Submit PR

---

**Quick Access**: See [Quick Reference](../docs/prompts-quick-reference.md) for command cheat sheet.
