<!--
@file workflow_optimization.md
@description GitHub Actions workflow optimization prompt for CI/CD efficiency
@author AI Evolution Engine <ai-evolution@engine.dev>
@created 2025-07-12
@lastModified 2025-07-12
@version 1.0.0

@relatedIssues 
  - #TBD: GitHub Actions workflow efficiency improvements

@relatedEvolutions
  - v1.0.0: Initial periodic prompt implementation

@dependencies
  - AI Evolution Engine: >=0.4.3

@changelog
  - 2025-07-12: Initial creation of workflow optimization prompt - AEE

@usage Executed monthly via GitHub Actions workflow for CI/CD maintenance
@notes Part of the periodic AI prompts system for repository evolution
-->

# Workflow Optimization Prompt

## Objective
Refine GitHub Actions workflows for efficiency, reliability, and clarity while ensuring they support self-evolution capabilities.

## AI Instructions

You are a CI/CD expert specializing in GitHub Actions optimization, DevOps best practices, and automation efficiency. Your task is to analyze and optimize all GitHub Actions workflows in this repository for maximum efficiency and reliability.

### Scope of Workflow Analysis

#### 1. Existing Workflows
- **All .github/workflows/*.yml files**: Comprehensive analysis of workflow definitions
- **Workflow Dependencies**: Inter-workflow dependencies and triggers
- **Action Usage**: Review of third-party actions and their versions
- **Resource Usage**: CPU, memory, and execution time analysis
- **Failure Patterns**: Historical failure analysis and reliability assessment

#### 2. Optimization Areas
- **Execution Time**: Reduce overall workflow runtime
- **Resource Efficiency**: Optimize compute resource usage
- **Caching Strategies**: Implement effective caching for dependencies and builds
- **Parallelization**: Execute independent steps in parallel
- **Error Handling**: Improve error detection and recovery mechanisms

#### 3. Self-Evolution Support
- **AI Prompt Execution**: Ensure workflows can execute AI evolution prompts
- **PR Creation**: Automated pull request creation for evolution changes
- **Result Processing**: Handle AI evolution outputs and apply changes
- **Feedback Loops**: Implement feedback mechanisms for evolution success

### Workflow Optimization Strategies

#### 1. Performance Optimization
- **Cache Implementation**: Cache dependencies, build artifacts, and tool installations
- **Matrix Builds**: Use matrix strategies for parallel execution where appropriate
- **Step Optimization**: Combine related steps to reduce overhead
- **Conditional Execution**: Skip unnecessary steps based on change detection
- **Resource Allocation**: Optimize runner selection for workload requirements

#### 2. Reliability Improvements
- **Retry Mechanisms**: Add retry logic for flaky operations
- **Error Handling**: Implement comprehensive error handling and recovery
- **Timeout Management**: Set appropriate timeouts for all operations
- **Health Checks**: Add validation steps for critical operations
- **Rollback Capabilities**: Implement rollback mechanisms for failed deployments

#### 3. Clarity and Maintainability
- **Consistent Naming**: Use clear, descriptive names for workflows and steps
- **Documentation**: Add comprehensive comments and descriptions
- **Environment Management**: Standardize environment variable usage
- **Secret Management**: Implement secure secret handling practices
- **Workflow Organization**: Organize workflows logically with clear purposes

#### 4. Security Enhancements
- **Permission Management**: Implement least privilege access principles
- **Secret Scanning**: Prevent secret exposure in logs and outputs
- **Dependency Security**: Use trusted actions and pin versions
- **Environment Isolation**: Ensure proper environment separation
- **Audit Logging**: Implement comprehensive audit logging

### Self-Evolution Workflow Requirements

#### 1. Periodic Prompt Execution
- **Scheduled Triggers**: Cron-based scheduling for periodic prompts
- **Manual Triggers**: On-demand execution of specific prompts
- **Conditional Execution**: Execute based on repository state and conditions
- **Prompt Selection**: Dynamic selection of appropriate prompts to run

#### 2. AI Integration
- **Context Collection**: Gather repository context for AI processing
- **Prompt Processing**: Execute AI prompts with appropriate context
- **Output Validation**: Validate AI outputs before applying changes
- **Change Application**: Apply validated changes to repository

#### 3. Quality Assurance
- **Test Execution**: Run tests after applying AI changes
- **Validation Checks**: Perform comprehensive validation of changes
- **Rollback Triggers**: Automatic rollback on validation failures
- **Success Metrics**: Track evolution success rates and outcomes

### Testing and Validation

#### 1. Workflow Testing
- **Local Testing**: Test workflows locally before deployment
- **Staging Environment**: Test in staging environment
- **Incremental Rollout**: Deploy workflow changes incrementally
- **Monitoring**: Monitor workflow performance and reliability

#### 2. Evolution Testing
- **Dry Run Mode**: Test evolution changes without applying them
- **Sandbox Testing**: Test in isolated environments
- **Change Validation**: Validate changes before merging
- **Regression Testing**: Prevent regression in evolution capabilities

### Output Requirements

Generate a JSON response with the following structure:

```json
{
  "file_changes": [
    {
      "path": ".github/workflows/workflow_name.yml",
      "action": "update",
      "content": "optimized workflow content",
      "optimizations": ["list of specific optimizations applied"]
    }
  ],
  "test_files": [
    {
      "path": "tests/workflows/test_workflow.ext",
      "action": "create",
      "content": "workflow test content",
      "validation_scenarios": ["scenarios being tested"]
    }
  ],
  "impact_assessment": {
    "runtime_reduction": "percentage or time savings",
    "reliability_improvement": "failure rate reduction",
    "resource_efficiency": "compute resource savings",
    "maintainability_score": "workflow maintainability assessment"
  },
  "changelog_entry": {
    "date": "YYYY-MM-DD",
    "version": "current version",
    "type": "workflows",
    "description": "Optimized GitHub Actions workflows for efficiency and reliability"
  },
  "metrics": {
    "workflows_optimized": 0,
    "execution_time_reduction_percent": 0.0,
    "cache_hit_rate_improvement": 0.0,
    "failure_rate_reduction_percent": 0.0,
    "parallel_steps_added": 0,
    "security_improvements": 0,
    "self_evolution_capabilities_enhanced": 0
  }
}
```

### Best Practices Implementation
- **GitHub Actions Best Practices**: Follow official recommendations
- **Security Best Practices**: Implement security-first approach
- **Performance Best Practices**: Optimize for speed and efficiency
- **Maintainability Best Practices**: Ensure workflows are easy to maintain
- **Documentation Best Practices**: Comprehensive documentation and comments

### Success Criteria
- Reduced workflow execution time while maintaining functionality
- Improved reliability with lower failure rates
- Enhanced security posture and secret management
- Better maintainability and documentation
- Robust self-evolution capabilities
