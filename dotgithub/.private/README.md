# VS Code Copilot Customization Templates

This repository contains comprehensive templates for customizing GitHub Copilot in Visual Studio Code according to professional best practices.

## 📁 Directory Structure

```
vscode/
├── instructions/                     # Custom instruction files
│   ├── general-coding.instructions.md        # General coding best practices
│   ├── python-coding.instructions.md         # Python-specific guidelines
│   ├── javascript-typescript.instructions.md # JS/TS coding standards
│   ├── test-generation.instructions.md       # Test writing guidelines
│   ├── code-review.instructions.md           # Code review focus areas
│   ├── commit-messages.instructions.md       # Commit message standards
│   └── pull-request.instructions.md          # PR formatting guidelines
├── prompts/                         # Reusable prompt files
│   ├── create-react-form.prompt.md          # React component generation
│   ├── security-review-api.prompt.md        # API security analysis
│   ├── generate-unit-tests.prompt.md        # Test generation
│   ├── create-rest-api.prompt.md            # REST API scaffolding
│   └── performance-optimization.prompt.md   # Performance analysis
├── copilot-instructions.md          # Global Copilot instructions
├── settings-template.json           # VS Code settings configuration
└── README.md                        # This documentation
```

## 🚀 Quick Setup

### 1. Copy Settings to VS Code
Copy the contents of `settings-template.json` to your VS Code user settings:
- Open VS Code Settings (Ctrl+Shift+P → "Preferences: Open User Settings (JSON)")
- Merge the settings from `settings-template.json` with your existing settings

### 2. Verify Absolute Paths
Ensure all file paths in the settings point to the correct locations on your system:
```json
"chat.instructionsFilesLocations": [
  "c:\\Users\\alber\\OneDrive - UPV\\3_resources\\software\\vscode\\instructions"
],
"chat.promptFilesLocations": [
  "c:\\Users\\alber\\OneDrive - UPV\\3_resources\\software\\vscode\\prompts"
]
```

### 3. Enable Features
The following features will be enabled:
- ✅ Custom instruction files
- ✅ Prompt files
- ✅ Code generation instructions
- ✅ Test generation instructions
- ✅ Code review instructions
- ✅ Commit message instructions
- ✅ Pull request instructions

## 📋 Instruction Files

### General Coding (`general-coding.instructions.md`)
- **Scope**: All files (`applyTo: "**"`)
- **Content**: Universal coding best practices, documentation standards, error handling, security guidelines

### Python Coding (`python-coding.instructions.md`)
- **Scope**: Python files (`applyTo: "**/*.py"`)
- **Content**: PEP 8 compliance, type hints, modern Python practices, data structures usage

### JavaScript/TypeScript (`javascript-typescript.instructions.md`)
- **Scope**: JS/TS files (`applyTo: "**/*.{js,ts,jsx,tsx}"`)
- **Content**: Modern ES6+ syntax, TypeScript best practices, React patterns

### Test Generation (`test-generation.instructions.md`)
- **Scope**: Test files (`applyTo: "**/*.{test,spec}.{js,ts,py}"`)
- **Content**: AAA pattern, test coverage, mocking strategies, framework-specific practices

### Code Review (`code-review.instructions.md`)
- **Scope**: All files (`applyTo: "**"`)
- **Content**: Security review, performance considerations, architecture validation

### Commit Messages (`commit-messages.instructions.md`)
- **Scope**: All files (`applyTo: "**"`)
- **Content**: Conventional Commits format, semantic commit types, message structure

### Pull Requests (`pull-request.instructions.md`)
- **Scope**: All files (`applyTo: "**"`)
- **Content**: PR templates, description formatting, review process guidelines

## 🎯 Prompt Files

### Create React Form (`create-react-form.prompt.md`)
- **Mode**: Agent with VS Code tools
- **Purpose**: Generate complete React form components with validation
- **Features**: TypeScript, validation, accessibility, testing, Storybook

### Security Review API (`security-review-api.prompt.md`)
- **Mode**: Agent with VS Code and terminal tools
- **Purpose**: Comprehensive security analysis of REST APIs
- **Features**: OWASP Top 10, authentication review, vulnerability scanning

### Generate Unit Tests (`generate-unit-tests.prompt.md`)
- **Mode**: Agent with VS Code and terminal tools
- **Purpose**: Create comprehensive test suites for existing code
- **Features**: Framework detection, coverage analysis, mock generation

### Create REST API (`create-rest-api.prompt.md`)
- **Mode**: Agent with VS Code tools
- **Purpose**: Scaffold complete REST APIs with CRUD operations
- **Features**: Framework flexibility, security, documentation, testing

### Performance Optimization (`performance-optimization.prompt.md`)
- **Mode**: Agent with VS Code and terminal tools
- **Purpose**: Analyze and optimize code performance
- **Features**: Profiling, benchmarking, optimization recommendations

## ⚙️ Configuration Settings

### Copilot Settings
- **Code Generation**: Uses instruction files for context-aware generation
- **Test Generation**: Includes specific testing guidelines and edge cases
- **Code Review**: Focuses on security, performance, and maintainability
- **Commit Messages**: Enforces conventional commit format
- **Pull Requests**: Uses comprehensive PR templates

### Editor Enhancements
- **Format on Save**: Automatic code formatting
- **Code Actions**: Auto-fix and organize imports
- **Language-Specific**: Tailored settings for Python, JavaScript, TypeScript
- **File Associations**: Proper syntax highlighting for instruction and prompt files

### Development Experience
- **Git Integration**: Auto-fetch, commit signing
- **File Nesting**: Organized file explorer
- **Search Configuration**: Optimized for development workflows
- **Terminal Integration**: Windows Command Prompt default

## 🎨 Usage Examples

### Using Instruction Files
Instruction files are automatically applied based on their `applyTo` patterns:
```markdown
---
description: "Python-specific coding guidelines"
applyTo: "**/*.py"
---
```

### Running Prompt Files
1. **Command Palette**: `Ctrl+Shift+P` → "Chat: Run Prompt"
2. **Chat Input**: Type `/create-react-form` in chat
3. **Editor Button**: Open prompt file and click play button

### Manual Context Attachment
- **Instructions**: Chat view → "Add Context" → "Instructions"
- **Prompts**: Use `/prompt-name` syntax in chat input

## 🔧 Customization

### Adding New Instructions
1. Create new `.instructions.md` file in the instructions folder
2. Add front matter with `description` and `applyTo` patterns
3. Update `settings-template.json` to reference the new file

### Creating Custom Prompts
1. Create new `.prompt.md` file in the prompts folder
2. Add front matter with `mode`, `tools`, and `description`
3. Use variables like `${input:variableName:placeholder}` for dynamic content

### Modifying Settings
Update the settings JSON with additional configurations:
- Language-specific formatters
- Custom file associations
- Additional instruction file locations
- New Copilot instruction categories

## 📚 Best Practices

### Instruction Files
- Keep instructions concise and specific
- Use clear, actionable language
- Avoid external references
- Test with different file types
- Version control changes

### Prompt Files
- Use descriptive variable names
- Include comprehensive requirements
- Reference instruction files for context
- Test with various inputs
- Document expected outputs

### Settings Management
- Use absolute paths for reliability
- Backup settings before changes
- Test configuration incrementally
- Document custom modifications
- Share team configurations

## 🔄 Maintenance

### Regular Updates
- Review and update instruction files quarterly
- Test prompt files with new VS Code versions
- Update settings for new Copilot features
- Gather team feedback and improve templates

### Version Control
- Track changes to instruction and prompt files
- Use semantic versioning for major updates
- Document breaking changes
- Maintain backwards compatibility when possible

## 🤝 Contributing

### Adding New Templates
1. Follow existing file naming conventions
2. Include comprehensive documentation
3. Test with various scenarios
4. Update this README with new additions

### Improvements
- Submit issues for bugs or enhancement requests
- Provide specific use cases for new features
- Include examples and test cases
- Follow the established coding standards

## 📖 References

- [VS Code Copilot Customization Documentation](https://code.visualstudio.com/docs/copilot/copilot-customization)
- [Conventional Commits Specification](https://www.conventionalcommits.org/)
- [GitHub Copilot Best Practices](https://docs.github.com/en/copilot)
- [VS Code Settings Reference](https://code.visualstudio.com/docs/getstarted/settings)

---

**Last Updated**: June 2025  
**Version**: 1.0  
**Compatibility**: VS Code 1.85+, GitHub Copilot Extension
