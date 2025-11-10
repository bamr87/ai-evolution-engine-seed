# Repository Context for Periodic Evolution

## Execution Information
- Prompt: doc_harmonization
- Execution Mode: scheduled
- Dry Run: true
- Timestamp: 2025-07-12 18:58:53 UTC

## Repository State
- Current Branch: copilot/fix-2b18bb9e-b1f5-4d79-9ead-827f65aadcb7
- Latest Commit: 56f31f0 Initial plan
- Working Directory Status: 5 files modified

## Recent Activity
56f31f0 Initial plan
976a36b feat: Add periodic AI evolution prompts and automation scripts

## Repository Health
Repository health analysis unavailable

## Prompt Template Content

<!--
@file doc_harmonization.md
@description Documentation harmonization prompt for consistent styling and formatting
@author AI Evolution Engine <ai-evolution@engine.dev>
@created 2025-07-12
@lastModified 2025-07-12
@version 1.0.0

@relatedIssues 
  - #TBD: Documentation consistency improvements

@relatedEvolutions
  - v1.0.0: Initial periodic prompt implementation

@dependencies
  - AI Evolution Engine: >=0.4.3

@changelog
  - 2025-07-12: Initial creation of documentation harmonization prompt - AEE

@usage Executed weekly via GitHub Actions workflow for documentation maintenance
@notes Part of the periodic AI prompts system for repository evolution
-->

# Documentation Harmonization Prompt

## Objective
Review and standardize all documentation for consistent styling, syntax, keywords, and frontmatter across the repository.

## AI Instructions

You are an expert technical writer specializing in documentation consistency. Your task is to review all Markdown files in this repository and harmonize them for consistency while preserving their original meaning and content value.

### Scope of Review
- All Markdown files in the repository (README.md, docs/*, *.md files)
- Documentation styling and formatting
- Syntax consistency across files
- Keyword standardization
- Frontmatter consistency

### Harmonization Tasks

#### 1. Styling Consistency
- **Heading Levels**: Ensure consistent heading hierarchy and formatting
- **List Formatting**: Standardize bullet points, numbered lists, and indentation
- **Code Blocks**: Consistent syntax highlighting and formatting
- **Tables**: Uniform table formatting and alignment
- **Links**: Consistent link formatting (inline vs. reference style)

#### 2. Syntax Standardization
- **Verb Tense**: Maintain consistent tense throughout documentation
- **Sentence Structure**: Ensure clear, readable sentence construction
- **Terminology**: Standardize technical terms and project-specific vocabulary
- **Voice**: Maintain consistent voice (active vs. passive)

#### 3. Keyword Standardization
- Standardize terms like 'evolution' vs. 'update', 'seed' vs. 'template'
- Ensure consistent capitalization of project names and technical terms
- Maintain unified glossary of terms across all documentation

#### 4. Frontmatter Enhancement
- Add YAML frontmatter to files that lack it
- Standardize frontmatter fields: title, description, date, version, tags
- Ensure consistent date formatting and version numbering
- Add appropriate metadata for better organization

### Quality Requirements
- **Preserve Content Meaning**: Do not alter the core information or intent
- **DRY Principle**: Eliminate duplicate information across files
- **KISS Principle**: Maintain simplicity and clarity
- **Accessibility**: Ensure documentation is accessible to diverse audiences
- **SEO Optimization**: Use appropriate headers and metadata for discoverability

### Output Requirements

Generate a JSON response with the following structure:

```json
{
  "file_changes": [
    {
      "path": "relative/path/to/file.md",
      "action": "update",
      "content": "updated file content with harmonized formatting",
      "summary": "Brief description of changes made"
    }
  ],
  "documentation_updates": {
    "summary": "Overall summary of harmonization changes",
    "files_updated": 0,
    "consistency_improvements": [
      "List of specific consistency improvements made"
    ]
  },
  "impact_assessment": {
    "readability_score": "improved/maintained/degraded",
    "consistency_score": "percentage or qualitative measure",
    "seo_improvements": ["list of SEO enhancements"],
    "accessibility_improvements": ["list of accessibility enhancements"]
  },
  "changelog_entry": {
    "date": "YYYY-MM-DD",
    "version": "current version",
    "type": "documentation",
    "description": "Harmonized documentation styling and consistency across repository"
  },
  "metrics": {
    "files_processed": 0,
    "files_updated": 0,
    "consistency_score": 0.0,
    "style_violations_fixed": 0,
    "frontmatter_additions": 0
  }
}
```

### Success Criteria
- All documentation follows consistent formatting standards
- Frontmatter is present and standardized across files
- Technical terminology is used consistently
- Documentation is more accessible and SEO-friendly
- No loss of original content meaning or value
