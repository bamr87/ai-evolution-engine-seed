<!--
@file scripts/analysis/README.md
@description Repository analysis and health monitoring scripts
@author AI Evolution Engine Team <team@ai-evolution-engine.org>
@created 2025-07-12
@lastModified 2025-07-12
@version 1.0.0

@relatedIssues 
  - #documentation-cleanup: Comprehensive README coverage for all directories
  - #repository-health: Health analysis and monitoring capabilities

@relatedEvolutions
  - v1.0.0: Initial creation during comprehensive documentation update

@dependencies
  - bash: >=4.0 for script execution
  - jq: for JSON data processing
  - Analysis library modules: src/lib/analysis/

@changelog
  - 2025-07-12: Initial creation with comprehensive documentation - AEE

@usage Repository health analysis, metrics collection, and monitoring tools
@notes Provides comprehensive analysis capabilities for repository health and evolution tracking
-->

# Analysis Scripts

This directory contains scripts for repository analysis, health monitoring, and metrics collection that support the AI Evolution Engine's decision-making and quality assurance processes.

## Purpose

The analysis scripts provide:
- **Repository Health Analysis**: Comprehensive health checks and quality assessment
- **Evolution Metrics**: Collection and analysis of evolution cycle performance
- **Prerequisite Validation**: Environment and dependency checking
- **Context Collection**: Repository state gathering for AI processing
- **Error Analysis**: Workflow error collection and analysis

## Scripts Overview

### Health Analysis

| Script | Purpose | Usage |
|--------|---------|-------|
| `analyze-repository-health.sh` | Comprehensive repository health analysis | `./analyze-repository-health.sh [options]` |
| `analyze-repository-health-simple.sh` | Simple health check for quick validation | `./analyze-repository-health-simple.sh` |

### Prerequisites and Environment

| Script | Purpose | Usage |
|--------|---------|-------|
| `check-prereqs.sh` | Validates environment setup for workflows | `./check-prereqs.sh [mode] [verbose]` |

### Context and Metrics

| Script | Purpose | Usage |
|--------|---------|-------|
| `collect-context.sh` | Collects repository context for AI evolution | `./collect-context.sh [output-file]` |
| `collect-evolution-metrics.sh` | Collects and updates evolution metrics | `./collect-evolution-metrics.sh` |
| `collect-workflow-errors.sh` | Collects and aggregates workflow errors | `./collect-workflow-errors.sh [days]` |

## Key Features

### Repository Health Analysis

**Comprehensive Health Checks:**
- Code quality assessment and metrics
- Security vulnerability scanning
- Performance bottleneck identification
- Documentation completeness analysis
- Test coverage evaluation
- Dependency health and security

**Health Scoring:**
- Overall repository health score
- Category-specific metrics (security, quality, performance)
- Trend analysis and historical comparison
- Actionable improvement recommendations

### Metrics Collection

**Evolution Metrics:**
- Evolution cycle success rates
- Performance improvements tracking
- Change impact assessment
- Quality score progression

**Repository Metrics:**
- File change frequency analysis
- Contributor activity patterns
- Test execution statistics
- Build and deployment metrics

### Environment Validation

**Prerequisite Checking:**
- Required tool availability
- Version compatibility validation
- Permission and access verification
- Configuration completeness check

## Usage Examples

### Basic Health Analysis

```bash
# Comprehensive repository health check
./analysis/analyze-repository-health.sh

# Quick health validation
./analysis/analyze-repository-health-simple.sh

# Health analysis with verbose output
./analysis/analyze-repository-health.sh --verbose --output-format json
```

### Metrics Collection

```bash
# Collect current evolution metrics
./analysis/collect-evolution-metrics.sh

# Collect repository context for AI processing
./analysis/collect-context.sh context-output.json

# Analyze workflow errors from last 7 days
./analysis/collect-workflow-errors.sh 7
```

### Environment Validation

```bash
# Check prerequisites for adaptive mode
./analysis/check-prereqs.sh adaptive true

# Quick prerequisite validation
./analysis/check-prereqs.sh conservative false

# Detailed environment check
./analysis/check-prereqs.sh experimental true
```

## Output Formats

### Health Analysis Reports

**JSON Format:**
```json
{
  "overall_score": 85,
  "categories": {
    "code_quality": 88,
    "security": 92,
    "performance": 78,
    "documentation": 85,
    "testing": 90
  },
  "recommendations": [
    {
      "category": "performance",
      "priority": "medium",
      "description": "Optimize database queries in user module"
    }
  ],
  "timestamp": "2025-07-12T14:30:00Z"
}
```

**Markdown Format:**
```markdown
# Repository Health Report

## Overall Score: 85/100

### Category Scores
- Code Quality: 88/100
- Security: 92/100
- Performance: 78/100
- Documentation: 85/100
- Testing: 90/100

### Recommendations
1. **Performance (Medium Priority)**: Optimize database queries
2. **Documentation (Low Priority)**: Add API documentation
```

### Context Collection

**Repository Context:**
```json
{
  "repository": {
    "name": "ai-evolution-engine-seed",
    "files": 157,
    "size": "2.4MB",
    "languages": ["Shell", "JavaScript", "Markdown"]
  },
  "recent_changes": [...],
  "health_metrics": {...},
  "evolution_history": [...]
}
```

## Integration with Evolution Engine

The analysis scripts integrate with:
- [Core Evolution Scripts](../core/README.md) - Health-based evolution decisions
- [Evolution Engine](../../src/lib/evolution/) - Metrics-driven evolution strategies
- [Testing Framework](../../tests/README.md) - Quality validation and assessment
- [Daily Evolution](../../.github/workflows/README.md) - Automated health monitoring

## Monitoring and Alerting

### Health Monitoring

**Continuous Monitoring:**
- Daily health score tracking
- Trend analysis and alerts
- Automatic issue detection
- Performance regression identification

**Alert Conditions:**
- Health score drops below threshold
- Security vulnerabilities detected
- Critical performance degradation
- Test coverage decline

### Metrics Dashboard

**Key Metrics:**
- Repository health trends
- Evolution success rates
- Performance improvements
- Quality score progression

## Configuration

### Health Thresholds

```bash
# Environment variables for health thresholds
export HEALTH_THRESHOLD_CRITICAL=60
export HEALTH_THRESHOLD_WARNING=75
export HEALTH_THRESHOLD_GOOD=85

# Category-specific thresholds
export SECURITY_THRESHOLD=90
export PERFORMANCE_THRESHOLD=80
export QUALITY_THRESHOLD=85
```

### Analysis Configuration

```yaml
# .analysis-config.yml
health_analysis:
  enabled: true
  frequency: daily
  thresholds:
    critical: 60
    warning: 75
    good: 85
  
categories:
  security:
    weight: 30
    threshold: 90
  performance:
    weight: 25
    threshold: 80
  quality:
    weight: 25
    threshold: 85
  documentation:
    weight: 10
    threshold: 75
  testing:
    weight: 10
    threshold: 80
```

## Best Practices

### Analysis Execution
1. **Run health checks regularly** to track trends
2. **Monitor critical thresholds** for immediate action
3. **Analyze metrics over time** for pattern identification
4. **Use verbose output** for detailed troubleshooting

### Performance Optimization
1. **Cache analysis results** when appropriate
2. **Run parallel analysis** for large repositories
3. **Use incremental analysis** for frequent checks
4. **Optimize data collection** for efficiency

## Future Enhancements

- [ ] **Machine Learning Analysis**: AI-powered pattern recognition and prediction
- [ ] **Real-time Monitoring**: Live dashboard with real-time health metrics
- [ ] **Custom Metrics**: User-defined health metrics and thresholds
- [ ] **Integration APIs**: RESTful APIs for external monitoring systems
- [ ] **Automated Remediation**: Self-healing capabilities for common issues
- [ ] **Comparative Analysis**: Cross-repository health comparison
- [ ] **Predictive Analytics**: Forecasting of potential issues and improvements

## Related Documentation

- [Repository Health Guide](../../docs/guides/repository-health.md) - Detailed health analysis documentation
- [Metrics and Analytics](../../docs/guides/metrics.md) - Understanding evolution metrics
- [Monitoring Setup](../../docs/guides/monitoring.md) - Setting up continuous monitoring
- [Troubleshooting Guide](../../docs/guides/troubleshooting.md) - Common analysis issues and solutions