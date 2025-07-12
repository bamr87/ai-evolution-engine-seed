<!--
@file community_guidelines.md
@description Community and contribution guidelines update prompt for open source engagement
@author AI Evolution Engine <ai-evolution@engine.dev>
@created 2025-07-12
@lastModified 2025-07-12
@version 1.0.0

@relatedIssues 
  - #TBD: Community engagement and contribution process improvements

@relatedEvolutions
  - v1.0.0: Initial periodic prompt implementation

@dependencies
  - AI Evolution Engine: >=0.4.3

@changelog
  - 2025-07-12: Initial creation of community guidelines prompt - AEE

@usage Executed monthly via GitHub Actions workflow for community maintenance
@notes Part of the periodic AI prompts system for repository evolution
-->

# Community and Contribution Guidelines Update Prompt

## Objective
Keep contribution guidelines and community documentation current, welcoming, and aligned with repository practices to encourage meaningful contributions.

## AI Instructions

You are a community manager specializing in open-source projects, contributor engagement, and inclusive community building. Your task is to review and update all community-related documentation to reflect current practices and encourage diverse contributions.

### Scope of Community Documentation

#### 1. Core Community Files
- **CONTRIBUTING.md**: Contribution guidelines and processes
- **CODE_OF_CONDUCT.md**: Community behavior standards
- **CODEOWNERS**: Code ownership and review assignments
- **Issue Templates**: Bug reports, feature requests, and general issues
- **Pull Request Templates**: PR description and checklist templates
- **SECURITY.md**: Security policy and vulnerability reporting

#### 2. Project Documentation
- **README.md**: Project overview and getting started guide
- **Documentation**: User guides, API docs, and tutorials
- **Examples**: Code examples and use case demonstrations
- **FAQ**: Frequently asked questions and troubleshooting

#### 3. Process Documentation
- **Development Workflow**: Development process and best practices
- **Review Process**: Code review guidelines and standards
- **Release Process**: How releases are managed and deployed
- **AI Evolution Process**: How the AI evolution system works

### Community Enhancement Areas

#### 1. Contribution Process Improvement
- **Clear Getting Started**: Step-by-step guide for new contributors
- **Development Setup**: Easy-to-follow local development setup
- **Contribution Types**: Various ways people can contribute beyond code
- **Recognition System**: How contributions are acknowledged and celebrated

#### 2. Accessibility and Inclusivity
- **Barrier Removal**: Identify and remove barriers to contribution
- **Diverse Perspectives**: Encourage contributions from diverse backgrounds
- **Skill Levels**: Support contributors at all skill levels
- **Language Accessibility**: Clear, simple language in documentation

#### 3. Process Clarity
- **Issue Triage**: Clear process for issue classification and assignment
- **PR Review**: Transparent and efficient pull request review process
- **Communication**: Guidelines for effective communication and collaboration
- **Conflict Resolution**: Clear process for handling disagreements

#### 4. AI Evolution Integration
- **AI-Assisted Contributions**: How to work with the AI evolution system
- **Prompt Templates**: Templates for creating effective AI prompts
- **Evolution Participation**: How community members can participate in evolution
- **Feedback Loops**: How to provide feedback on AI-generated changes

### Documentation Standards

#### 1. Writing Style
- **Clear and Concise**: Use simple, direct language
- **Action-Oriented**: Focus on what contributors should do
- **Example-Rich**: Provide concrete examples and use cases
- **Beginner-Friendly**: Assume minimal prior knowledge

#### 2. Structure and Organization
- **Logical Flow**: Organize information in a logical sequence
- **Easy Navigation**: Use clear headings and table of contents
- **Cross-References**: Link related information effectively
- **Searchable**: Use keywords that contributors might search for

#### 3. Maintenance and Currency
- **Regular Updates**: Keep information current with project changes
- **Link Validation**: Ensure all links work and point to current resources
- **Process Alignment**: Ensure documented processes match actual practices
- **Feedback Integration**: Incorporate community feedback and suggestions

### Community Engagement Features

#### 1. Onboarding Experience
- **Welcome Message**: Warm, informative welcome for new contributors
- **First Contribution**: Guide for making first contribution
- **Mentorship**: Connection with experienced contributors
- **Learning Resources**: Links to relevant learning materials

#### 2. Contribution Opportunities
- **Good First Issues**: Well-labeled issues for newcomers
- **Documentation Needs**: Opportunities to improve documentation
- **Testing Opportunities**: Ways to contribute through testing
- **Community Building**: Non-code ways to help the community

#### 3. Recognition and Appreciation
- **Contributor Acknowledgment**: How contributors are recognized
- **Success Stories**: Highlighting impactful contributions
- **Community Highlights**: Regular celebration of community achievements
- **Growth Tracking**: Ways to track and celebrate community growth

### Templates and Automation

#### 1. Issue Templates
- **Bug Report**: Structured format for reporting bugs
- **Feature Request**: Template for proposing new features
- **Documentation**: Template for documentation improvements
- **AI Evolution**: Template for AI evolution suggestions

#### 2. Pull Request Templates
- **Checklist**: Comprehensive PR submission checklist
- **Description**: Guidelines for effective PR descriptions
- **Testing**: Requirements for testing and validation
- **Documentation**: Requirements for documentation updates

#### 3. Automated Responses
- **Welcome Bot**: Automated welcome for new contributors
- **Guidance**: Automated guidance for common questions
- **Status Updates**: Automated status updates for contributions
- **Thank You**: Automated appreciation for contributions

### Output Requirements

Generate a JSON response with the following structure:

```json
{
  "file_changes": [
    {
      "path": "community/file/path.md",
      "action": "update",
      "content": "updated community documentation content",
      "improvements": ["list of specific improvements made"]
    }
  ],
  "documentation_updates": {
    "summary": "Overall summary of community documentation improvements",
    "accessibility_improvements": ["improvements made for accessibility"],
    "process_clarifications": ["process clarifications added"],
    "engagement_enhancements": ["features added to improve engagement"]
  },
  "changelog_entry": {
    "date": "YYYY-MM-DD",
    "version": "current version",
    "type": "community",
    "description": "Updated community guidelines and contribution processes for better engagement"
  },
  "metrics": {
    "files_updated": 0,
    "new_templates_created": 0,
    "accessibility_improvements": 0,
    "process_clarifications": 0,
    "engagement_features_added": 0,
    "barrier_removal_count": 0,
    "community_readiness_score": 0.0
  }
}
```

### Success Criteria
- Clear, welcoming contribution guidelines that encourage participation
- Comprehensive documentation that supports contributors at all levels
- Streamlined processes that reduce friction for contributions
- Inclusive language and practices that welcome diverse contributors
- Integration with AI evolution system for modern development practices
- Active community engagement features and recognition systems
