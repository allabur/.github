# Prompt Files Recommendations Configuration

This file provides example configuration for automatic prompt suggestions in VS Code based on file context.

## How to Use

Copy the configuration below into your VS Code `settings.json` under the `"chat.promptFilesRecommendations"` key.

## Configuration

```jsonc
"chat.promptFilesRecommendations": {
  // Python files - suggest documentation and testing prompts
  "**/*.py": [
    "prompts/document-function.prompt.md",
    "prompts/generate-pytest.prompt.md",
    "prompts/optimize-code.prompt.md"
  ],

  // Jupyter notebooks - suggest data analysis and LaTeX prompts
  "**/*.ipynb": [
    "prompts/analyze-dataframe.prompt.md",
    "prompts/create-latex-table.prompt.md",
    "prompts/document-function.prompt.md"
  ],

  // Test files - suggest test generation
  "**/test_*.py": [
    "prompts/generate-pytest.prompt.md"
  ],
  "**/tests/**/*.py": [
    "prompts/generate-pytest.prompt.md"
  ],

  // LaTeX files - suggest table creation
  "**/*.tex": [
    "prompts/create-latex-table.prompt.md"
  ],

  // Git commit context - suggest commit review
  ".git/COMMIT_EDITMSG": [
    "prompts/review-commit.prompt.md"
  ],

  // Data files - suggest DataFrame analysis
  "**/*.csv": [
    "prompts/analyze-dataframe.prompt.md",
    "prompts/create-latex-table.prompt.md"
  ],
  "**/*.xlsx": [
    "prompts/analyze-dataframe.prompt.md",
    "prompts/create-latex-table.prompt.md"
  ],
  "**/*.parquet": [
    "prompts/analyze-dataframe.prompt.md"
  ],

  // Prompt engineering files - suggest safety review
  "**/*.prompt.md": [
    "prompts/ai-prompt-engineering-safety-review.prompt.md"
  ],
  "**/*.chatmode.md": [
    "prompts/ai-prompt-engineering-safety-review.prompt.md"
  ]
}
```

## How It Works

When you open a file matching one of these patterns, VS Code will automatically suggest the associated prompts in the Copilot Chat interface. You can then invoke them with `/` commands.

## Customization Tips

1. **Add more patterns**: Match specific project directories or file naming conventions
2. **Adjust priority**: Put most-used prompts first in each array
3. **Context-specific**: Create different prompts for different project phases
4. **Combine with instructions**: Prompts work alongside your `.instructions.md` files

## Example Usage Scenarios

### Scenario 1: Working on a Python function

1. Open `src/analysis/stats.py`
2. Copilot suggests: `document-function`, `generate-pytest`, `optimize-code`
3. Select function → `/document-function` → Get NumPy-style docstring
4. Switch to test file → `/generate-pytest` → Get comprehensive tests

### Scenario 2: Analyzing data in Jupyter

1. Open `notebooks/exploratory-analysis.ipynb`
2. Copilot suggests: `analyze-dataframe`, `create-latex-table`
3. Select DataFrame cell → `/analyze-dataframe` → Get quality assessment
4. Select results → `/create-latex-table` → Get LaTeX table for paper

### Scenario 3: Committing changes

1. Stage changes with `git add`
2. Run `git commit` (opens COMMIT_EDITMSG)
3. Copilot suggests: `review-commit`
4. `/review-commit` → Get conventional commit message

## Integration with Your Setup

Based on your current configuration, you already have:

- ✅ Prompt files enabled: `"chat.promptFiles": true`
- ✅ Custom locations: OneDrive prompts directory
- ✅ MCP server for awesome-copilot prompts

This configuration will work seamlessly with your existing setup and provide context-aware prompt suggestions.

## Note for Multi-Location Setup

If you have prompts in multiple locations (OneDrive + .github), you can reference them using:

- Absolute paths: `/Users/allabur/Library/CloudStorage/OneDrive-UPV/.../prompt.md`
- Relative to workspace: `.github/prompts/prompt.md`
- VS Code will search all configured `promptFilesLocations`
