<!--
@file docs/guides/documentation-organization.md
@description Guide for maintaining proper documentation organization and validation
@author AI Evolution Engine <ai@evolution-engine.org>
@created 2025-07-12
@lastModified 2025-07-12
@version 1.0.0

@relatedIssues 
  - Documentation organization standardization
  - AI prompt cycle validation automation

@relatedEvolutions
  - v1.0.0: Initial documentation organization guide

@dependencies
  - validate-docs-organization.sh: Validation script
  - post-ai-validation.sh: Post-AI cycle runner

@changelog
  - 2025-07-12: Initial creation with validation workflow - AEE

@usage Referenced by copilot instructions and development workflows
@notes Essential reading for maintaining repository organization
-->

# Documentation Organization Guide

This guide explains the documentation organization rules and validation workflow implemented in the AI Evolution Engine repository.

## Documentation Organization Rules

### Core Principles

1. **README.md Files**: Every directory MUST contain a README.md file that comprehensively documents its contents and purpose
2. **CHANGELOG.md**: Only allowed at the repository root for version tracking
3. **All Other Markdown Files**: Must reside in the `docs/` directory with proper subdirectory organization

### Directory Structure

```
repository/
├── README.md                    ✅ Allowed (main project documentation)
├── CHANGELOG.md                 ✅ Allowed (repository root only)
├── docs/                        📁 All other markdown content goes here
│   ├── README.md               ✅ Documents the docs directory
│   ├── guides/                 📁 User guides and tutorials
│   │   ├── README.md          ✅ Documents guides directory
│   │   └── *.md               📄 Guide content
│   ├── api/                    📁 API documentation
│   │   ├── README.md          ✅ Documents API directory
│   │   └── *.md               📄 API references
│   ├── architecture/           📁 System design documents
│   │   ├── README.md          ✅ Documents architecture directory
│   │   └── *.md               📄 Architecture content
│   ├── evolution/              📁 Evolution and change tracking
│   │   ├── README.md          ✅ Documents evolution directory
│   │   └── *.md               📄 Evolution content
│   └── reports/                📁 Analysis and reports
│       ├── README.md          ✅ Documents reports directory
│       └── *.md               📄 Report content
├── src/                        📁 Source code
│   └── README.md               ✅ Required in every directory
├── scripts/                    📁 Utility scripts
│   └── README.md               ✅ Required in every directory
└── any-other-directory/        📁 Any directory
    └── README.md               ✅ Required in every directory
```

## Validation Workflow

### Automated Validation

The repository includes two validation scripts:

1. **`validate-docs-organization.sh`**: Core validation script that checks:
   - All non-README markdown files are in `docs/` directory
   - Every directory contains a README.md file
   - Proper docs subdirectory structure

2. **`post-ai-validation.sh`**: Post-AI prompt cycle runner that:
   - Executes the documentation validation
   - Provides clear pass/fail results
   - Integrates with AI workflow processes

### Running Validation

#### Manual Validation
```bash
# Run the full documentation organization validation
./scripts/validate-docs-organization.sh

# Run the post-AI validation workflow
./scripts/post-ai-validation.sh
```

#### Automated Integration
The validation should be run:
- After every AI prompt cycle
- Before committing changes
- As part of CI/CD pipelines
- During regular maintenance cycles

### Validation Output

The validation script provides:

✅ **Success Messages**: When all rules are satisfied
❌ **Error Messages**: Specific issues that must be fixed
⚠️ **Warning Messages**: Non-critical issues for attention
📁 **File Suggestions**: Recommended moves for misplaced files
📂 **Directory Actions**: Required README.md file creation

### Example Validation Output

```
🔍 Validating Documentation Organization
==========================================

1. Checking for misplaced markdown files...
❌ ERROR: Markdown file found outside docs/: MIGRATION_GUIDE.md

📁 Files that should be moved to docs/:
  - MIGRATION_GUIDE.md

2. Checking for missing README.md files...
❌ ERROR: Missing README.md in directory: src/lib/core

📂 Directories missing README.md:
  - src/lib/core/

Required actions:
1. Move the following files to docs/ subdirectories:
   mv MIGRATION_GUIDE.md docs/guides/MIGRATION_GUIDE.md

2. Create README.md files in the following directories:
   touch src/lib/core/README.md
```

## Fixing Validation Issues

### Moving Misplaced Files

When the validation script finds misplaced markdown files, it suggests appropriate `docs/` subdirectories:

- **Guides and tutorials** → `docs/guides/`
- **API references** → `docs/api/`
- **Architecture documents** → `docs/architecture/`
- **Evolution tracking** → `docs/evolution/`
- **Reports and analysis** → `docs/reports/`
- **Other content** → `docs/misc/`

### Creating Missing README Files

For directories missing README.md files:

1. Create the file: `touch directory/README.md`
2. Add proper file header (see copilot instructions)
3. Document the directory's purpose and contents
4. Include links to related directories/resources
5. Provide usage examples where applicable

### README.md Content Standards

Every README.md file should include:

```markdown
# Directory Name

Brief description of the directory's purpose.

## Contents

- **File 1**: Description of what this file does
- **File 2**: Description of what this file does
- **Subdirectory/**: Description of subdirectory purpose

## Purpose

Detailed explanation of why this directory exists and how it fits into the overall project structure.

## Usage

Examples of how to use or interact with the contents of this directory.

## Integration

How this directory relates to other parts of the system.
```

## Benefits of This Organization

### For AI Development
- **Clear Context**: README files provide comprehensive context for AI-assisted development
- **Structured Learning**: AI can better understand project organization and relationships
- **Reduced Confusion**: Consistent structure eliminates ambiguity about file purposes

### For Human Developers
- **Easy Navigation**: Logical organization makes finding information straightforward
- **Self-Documenting**: Every directory explains its own purpose and contents
- **Maintainability**: Clear structure makes maintenance and updates easier

### For Project Health
- **Quality Assurance**: Automated validation ensures consistency over time
- **Documentation Debt Prevention**: Prevents accumulation of undocumented code
- **Onboarding Efficiency**: New contributors can quickly understand project structure

## Best Practices

### When Creating New Content

1. **Start with README**: Create or update README.md before adding new files
2. **Plan Organization**: Determine appropriate `docs/` subdirectory for new documentation
3. **Cross-Reference**: Link related documentation files together
4. **Validate Early**: Run validation frequently during development

### When Refactoring

1. **Update Documentation First**: Modify README files before moving code
2. **Maintain Links**: Update cross-references when moving files
3. **Validate Changes**: Run validation after any organizational changes
4. **Test Integration**: Ensure changes don't break workflows or tools

### For Long-term Maintenance

1. **Regular Audits**: Periodically review and update README files
2. **Automation Integration**: Include validation in CI/CD pipelines
3. **Team Training**: Ensure all contributors understand the organization rules
4. **Continuous Improvement**: Refine organization based on usage patterns

## Troubleshooting

### Common Issues

**Issue**: Validation fails with many misplaced files
**Solution**: Use the suggested `mv` commands from validation output

**Issue**: Some directories don't need README files (e.g., empty build directories)
**Solution**: The validation script automatically skips empty directories and common build folders

**Issue**: File headers are missing or incorrect
**Solution**: Refer to the file header standards in copilot instructions

### Getting Help

1. Run `./scripts/validate-docs-organization.sh` for detailed error messages
2. Check the copilot instructions for file header standards
3. Review existing README.md files for examples
4. Use the post-AI validation script for comprehensive checks

## Integration with AI Workflows

This documentation organization is specifically designed to enhance AI-assisted development:

### AI Context Optimization
- README files serve as primary context sources for AI understanding
- Consistent structure helps AI navigate and comprehend project organization
- Clear documentation enables more accurate AI suggestions and modifications

### Workflow Integration
- Post-AI validation ensures AI changes maintain organizational standards
- Validation feedback helps refine AI interactions for better results
- Automated checks prevent organizational drift over multiple AI cycles

### Continuous Improvement
- Validation results inform improvements to AI prompts and instructions
- Organizational patterns emerge from successful AI interactions
- Documentation evolves to better support AI-assisted development workflows
