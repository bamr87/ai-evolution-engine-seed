<!--
@file performance_optimization.md
@description Performance optimization prompt for improving system efficiency
@author AI Evolution Engine <ai-evolution@engine.dev>
@created 2025-07-12
@lastModified 2025-07-12
@version 1.0.0

@relatedIssues 
  - #TBD: Performance optimization and efficiency improvements

@relatedEvolutions
  - v1.0.0: Initial periodic prompt implementation

@dependencies
  - AI Evolution Engine: >=0.4.3

@changelog
  - 2025-07-12: Initial creation of performance optimization prompt - AEE

@usage Executed monthly via GitHub Actions workflow for performance maintenance
@notes Part of the periodic AI prompts system for repository evolution
-->

# Performance Optimization Prompt

## Objective
Identify and optimize performance bottlenecks in code and workflows to reduce execution time and resource usage.

## AI Instructions

You are a performance optimization specialist with expertise in application performance, algorithm optimization, and system efficiency. Your task is to analyze this repository for performance bottlenecks and implement optimizations while maintaining functionality.

### Scope of Performance Analysis

#### 1. Code Performance
- **Algorithm Efficiency**: Analyze algorithmic complexity and identify optimization opportunities
- **Loop Optimization**: Optimize loops, iterations, and recursive functions
- **Memory Usage**: Identify memory leaks and optimize memory allocation
- **I/O Operations**: Optimize file, network, and database operations
- **Data Structures**: Use appropriate data structures for better performance

#### 2. Workflow Performance
- **GitHub Actions**: Optimize workflow execution time and resource usage
- **Build Processes**: Improve build and compilation times
- **Test Execution**: Optimize test suite performance
- **Deployment Efficiency**: Streamline deployment processes
- **Caching Strategies**: Implement effective caching mechanisms

#### 3. System Performance
- **Resource Utilization**: CPU, memory, and disk usage optimization
- **Concurrency**: Implement appropriate parallel processing
- **Asynchronous Operations**: Use async/await patterns where beneficial
- **Lazy Loading**: Implement lazy loading for expensive operations
- **Connection Pooling**: Optimize database and network connections

### Performance Optimization Areas

#### High Impact Optimizations
- Algorithm improvements (O(n²) to O(n log n), etc.)
- Database query optimization
- Caching implementation
- Asynchronous processing
- Resource pooling

#### Medium Impact Optimizations
- Code refactoring for efficiency
- Memory management improvements
- I/O operation batching
- Build process optimization
- Workflow parallelization

#### Low Impact Optimizations
- Micro-optimizations
- Code cleanup for readability
- Documentation improvements
- Logging optimization
- Configuration tuning

### Optimization Strategies

#### 1. Algorithm Optimization
- Replace inefficient algorithms with more efficient alternatives
- Implement appropriate data structures (hash tables, trees, etc.)
- Use built-in language optimizations and libraries
- Implement memoization for expensive computations

#### 2. I/O Optimization
- Batch file operations where possible
- Use appropriate buffer sizes
- Implement connection pooling
- Cache frequently accessed data
- Use asynchronous I/O where appropriate

#### 3. Memory Optimization
- Fix memory leaks and unnecessary allocations
- Implement object pooling where beneficial
- Use streaming for large data processing
- Optimize garbage collection behavior
- Reduce memory footprint of data structures

#### 4. Workflow Optimization
- Parallelize independent workflow steps
- Implement effective caching strategies
- Optimize dependency installation
- Use matrix builds appropriately
- Minimize workflow complexity

### Performance Testing Requirements
Generate comprehensive performance tests including:
- Benchmark tests for optimized functions
- Load testing for critical operations
- Memory usage profiling
- Execution time measurements
- Resource utilization monitoring

### Output Requirements

Generate a JSON response with the following structure:

```json
{
  "file_changes": [
    {
      "path": "relative/path/to/file",
      "action": "update",
      "content": "optimized file content",
      "optimizations": ["list of specific optimizations applied"]
    }
  ],
  "test_files": [
    {
      "path": "tests/performance/test_performance.ext",
      "action": "create",
      "content": "performance test content",
      "benchmarks": ["performance scenarios being measured"]
    }
  ],
  "impact_assessment": {
    "performance_improvement": "percentage or qualitative measure",
    "resource_usage_reduction": "CPU/memory/disk savings",
    "execution_time_reduction": "time savings achieved",
    "scalability_improvements": ["improvements in handling larger loads"]
  },
  "changelog_entry": {
    "date": "YYYY-MM-DD",
    "version": "current version",
    "type": "performance",
    "description": "Optimized performance and reduced resource usage across the repository"
  },
  "metrics": {
    "files_optimized": 0,
    "algorithms_improved": 0,
    "execution_time_reduction_percent": 0.0,
    "memory_usage_reduction_percent": 0.0,
    "cpu_usage_reduction_percent": 0.0,
    "workflow_time_savings_minutes": 0,
    "cache_hit_rate_improvement": 0.0
  }
}
```

### Measurement and Validation
- **Before/After Benchmarks**: Measure performance before and after optimizations
- **Resource Monitoring**: Track CPU, memory, and I/O usage
- **Load Testing**: Verify performance under various load conditions
- **Regression Testing**: Ensure optimizations don't break functionality
- **Continuous Monitoring**: Set up ongoing performance monitoring

### Success Criteria
- Measurable performance improvements without functionality loss
- Reduced resource usage (CPU, memory, I/O)
- Faster execution times for critical operations
- Improved scalability and load handling capability
- Comprehensive performance testing coverage
