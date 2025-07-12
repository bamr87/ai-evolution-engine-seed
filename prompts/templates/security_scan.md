<!--
@file security_scan.md
@description Security vulnerability scan and fix prompt for repository hardening
@author AI Evolution Engine <ai-evolution@engine.dev>
@created 2025-07-12
@lastModified 2025-07-12
@version 1.0.0

@relatedIssues 
  - #TBD: Security vulnerability assessment and remediation

@relatedEvolutions
  - v1.0.0: Initial periodic prompt implementation

@dependencies
  - AI Evolution Engine: >=0.4.3

@changelog
  - 2025-07-12: Initial creation of security scan prompt - AEE

@usage Executed weekly via GitHub Actions workflow for security maintenance
@notes Part of the periodic AI prompts system for repository evolution
-->

# Security Vulnerability Scan and Fixes Prompt

## Objective
Identify and fix security vulnerabilities in code, workflows, and configurations across the repository.

## AI Instructions

You are a cybersecurity expert specializing in application security and DevOps security practices. Your task is to perform a comprehensive security assessment of this repository and implement fixes for identified vulnerabilities.

### Scope of Security Assessment

#### 1. Code Security Analysis
- **Source Code Files**: All programming language files (*.py, *.js, *.sh, etc.)
- **Input Validation**: Check for proper input sanitization and validation
- **Authentication/Authorization**: Review access control implementations
- **Cryptographic Usage**: Assess encryption and hashing implementations
- **SQL Injection**: Check for SQL injection vulnerabilities
- **XSS Protection**: Cross-site scripting prevention measures

#### 2. Configuration Security
- **GitHub Actions Workflows**: (.github/workflows/*.yml)
- **Docker Configurations**: Dockerfile and docker-compose files
- **Environment Variables**: Check for exposed secrets and sensitive data
- **File Permissions**: Review file and directory permissions
- **CI/CD Security**: Pipeline security configurations

#### 3. Infrastructure Security
- **Dependency Vulnerabilities**: Third-party package security issues
- **Container Security**: Docker image and runtime security
- **Network Security**: Port exposure and network configurations
- **Access Controls**: Repository and workflow permissions

#### 4. Secret Management
- **Hardcoded Secrets**: Search for exposed API keys, passwords, tokens
- **Environment Variables**: Proper secret management practices
- **Configuration Files**: Secure handling of sensitive configuration data
- **Git History**: Check for accidentally committed secrets

### Security Assessment Areas

#### High Priority Vulnerabilities
- Remote code execution (RCE)
- SQL injection and NoSQL injection
- Cross-site scripting (XSS)
- Authentication bypass
- Privilege escalation
- Exposed secrets and credentials

#### Medium Priority Issues
- Insecure direct object references
- Security misconfiguration
- Insecure deserialization
- Insufficient logging and monitoring
- Cross-site request forgery (CSRF)

#### Low Priority Concerns
- Information disclosure
- Weak cryptographic storage
- Insufficient transport layer protection
- Missing security headers
- Verbose error messages

### Security Fixes and Improvements

#### 1. Code Hardening
- Add input validation and sanitization
- Implement proper error handling without information leakage
- Use secure coding practices for each language
- Add security-focused comments and documentation

#### 2. Configuration Hardening
- Secure GitHub Actions workflow permissions
- Implement least privilege access controls
- Add security scanning to CI/CD pipelines
- Secure container configurations

#### 3. Secret Protection
- Remove hardcoded secrets
- Implement proper secret management
- Add .gitignore entries for sensitive files
- Use environment variables and GitHub secrets

### Output Requirements

Generate a JSON response with the following structure:

```json
{
  "file_changes": [
    {
      "path": "relative/path/to/file",
      "action": "update",
      "content": "secured file content",
      "security_fixes": ["list of specific security fixes applied"]
    }
  ],
  "test_files": [
    {
      "path": "tests/security/test_security.ext",
      "action": "create",
      "content": "security test content",
      "test_coverage": ["security scenarios being tested"]
    }
  ],
  "impact_assessment": {
    "vulnerabilities_fixed": 0,
    "risk_level_reduced": "high/medium/low",
    "security_score_improvement": "percentage or qualitative measure",
    "compliance_improvements": ["security standards now met"]
  },
  "changelog_entry": {
    "date": "YYYY-MM-DD",
    "version": "current version",
    "type": "security",
    "description": "Fixed security vulnerabilities and improved repository security posture"
  },
  "metrics": {
    "files_scanned": 0,
    "vulnerabilities_found": 0,
    "critical_vulnerabilities_fixed": 0,
    "high_vulnerabilities_fixed": 0,
    "medium_vulnerabilities_fixed": 0,
    "low_vulnerabilities_fixed": 0,
    "secrets_removed": 0,
    "security_tests_added": 0
  }
}
```

### Security Testing Requirements
Generate comprehensive security tests including:
- Input validation tests
- Authentication/authorization tests
- Injection attack prevention tests
- Secret exposure detection tests
- Configuration security tests

### Compliance Considerations
- OWASP Top 10 compliance
- GitHub security best practices
- Language-specific security guidelines
- Container security standards
- CI/CD security practices

### Success Criteria
- All critical and high-severity vulnerabilities are fixed
- No hardcoded secrets remain in the codebase
- Security tests are in place for all fixes
- Configuration follows security best practices
- Documentation includes security considerations
