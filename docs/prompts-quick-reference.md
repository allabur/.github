# Quick Reference: Copilot Prompts

## 🚀 Available Prompts

| Command               | Use Case                  | Best For                                 |
| --------------------- | ------------------------- | ---------------------------------------- |
| `/analyze-dataframe`  | Data quality & statistics | DataFrames, missing values, outliers     |
| `/document-function`  | Generate docstrings       | Python functions needing documentation   |
| `/generate-pytest`    | Create tests              | Functions/classes needing test coverage  |
| `/create-latex-table` | Format tables             | Academic papers, professional tables     |
| `/optimize-code`      | Performance tuning        | Slow code, bottlenecks, efficiency       |
| `/review-commit`      | Commit messages           | Staged git changes, conventional commits |
| `/ai-safety-review`   | Prompt engineering        | Review AI prompts for safety/bias        |

## 📋 Common Workflows

### 1. Data Analysis in Jupyter

```
1. Load data → Select DataFrame
2. /analyze-dataframe → Get quality report
3. Fix issues based on recommendations
4. /create-latex-table → Export for paper
```

### 2. Writing Python Functions

```
1. Write function logic
2. /document-function → Add NumPy docstring
3. /generate-pytest → Create tests
4. /optimize-code → If performance issues
```

### 3. Git Workflow

```
1. Make changes → git add
2. /review-commit → Generate commit message
3. Review & adjust
4. Commit with generated message
```

## 🎯 Context-Aware Suggestions

When you open these files, prompts are auto-suggested:

| File Type      | Suggested Prompts                                 |
| -------------- | ------------------------------------------------- |
| `*.py`         | document-function, generate-pytest, optimize-code |
| `*.ipynb`      | analyze-dataframe, create-latex-table             |
| `test_*.py`    | generate-pytest                                   |
| `*.tex`        | create-latex-table                                |
| `*.csv/*.xlsx` | analyze-dataframe, create-latex-table             |
| `*.prompt.md`  | ai-safety-review                                  |

## 💡 Pro Tips

1. **Select before invoking**: Select relevant code/data before using prompt
2. **Iterate**: Prompts can be reused multiple times with different selections
3. **Combine**: Use multiple prompts in sequence (document → test → optimize)
4. **Customize**: Edit prompts in `.github/prompts/` for your specific needs
5. **Share**: Prompts in this repo apply to all your projects automatically

## 🔧 Quick Setup

### Enable in VS Code Settings

```jsonc
{
  "chat.promptFiles": true,
  "chat.promptFilesLocations": {
    "/path/to/.github/prompts": true
  }
}
```

### Add Auto-Suggestions

Copy configuration from `docs/prompt-recommendations-config.md` to your `settings.json`.

## 📚 Learn More

- Full documentation: `docs/prompt-recommendations-config.md`
- Create custom prompts: `prompts/*.prompt.md` (use existing as templates)
- Instruction files: `instructions/*.instructions.md` (coding standards)
- Chat modes: `chatmodes/*.chatmode.md` (AI personas)
