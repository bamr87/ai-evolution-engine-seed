<!--
@file logs/README.md
@description Directory index for system logs and metrics
@author IT-Journey Team <team@it-journey.org>
@created 2025-07-12
@lastModified 2025-07-12
@version 1.0.0

@relatedIssues 
  - #documentation-cleanup: Organize repository documentation structure

@relatedEvolutions
  - v1.0.0: Initial creation during documentation cleanup

@dependencies
  - JSON processing tools for metrics analysis

@changelog
  - 2025-07-12: Initial creation during repository cleanup - ITJ

@usage Contains system logs and evolution metrics
@notes Files in this directory are typically auto-generated
-->

# Logs Directory

This directory contains system logs, evolution metrics, and operational data generated during AI Evolution Engine operations.

## Directory Contents

### Metrics Files
- `evolution-metrics.json` - Evolution cycle performance metrics and analytics
- `test-metrics.json` - Test execution metrics and performance data

## Purpose

The logs directory serves as a central location for:
- **Evolution Metrics**: Performance data from evolution cycles
- **Test Results**: Aggregated test execution data and metrics
- **System Logs**: Operational logs from various system components
- **Analytics Data**: Data for analysis and reporting purposes

## File Types

### JSON Metrics Files
- **Structured data** for machine processing
- **Timestamped entries** for chronological analysis
- **Performance metrics** including execution times and success rates
- **Statistical data** for trend analysis

### Log Files
- **Execution logs** from scripts and processes
- **Error logs** for debugging and troubleshooting
- **Debug output** from development and testing

## Usage Guidelines

1. **Read-only Access**: Log files should not be manually edited
2. **Automated Generation**: Most files are created by system processes
3. **Temporary Nature**: Some logs may be rotated or cleaned up automatically
4. **Analysis Tools**: Use appropriate tools for JSON processing and log analysis

## Analysis and Monitoring

### JSON Metrics Analysis

**Query evolution metrics:**
```bash
# View latest evolution metrics
jq '.latest_metrics' logs/evolution-metrics.json

# Calculate average execution time
jq '.execution_times[] | .duration' logs/evolution-metrics.json | awk '{sum+=$1; count++} END {print sum/count}'

# Find failed evolution cycles
jq '.evolution_cycles[] | select(.status == "failed")' logs/evolution-metrics.json
```

**Test metrics analysis:**
```bash
# View test success rates
jq '.test_suites[].success_rate' logs/test-metrics.json

# Find slowest tests
jq '.test_executions[] | select(.duration > 30)' logs/test-metrics.json
```

### Log Monitoring

**Real-time monitoring:**
```bash
# Monitor active logs
tail -f logs/*.log

# Watch for errors
grep -i "error\|fail" logs/*.log | tail -f

# Monitor JSON metrics changes
watch -n 5 'jq ".last_updated" logs/evolution-metrics.json'
```

## Maintenance

- **Automatic Cleanup**: Some logs may be automatically rotated
- **Size Management**: Large log files may need periodic cleanup
- **Backup Considerations**: Important metrics should be backed up
- **Privacy**: Ensure logs don't contain sensitive information

## Future Enhancements

- [ ] **Real-time Dashboard**: Web-based monitoring interface for live metrics
- [ ] **Log Aggregation**: Centralized logging with advanced search capabilities
- [ ] **Alerting System**: Automated alerts for error conditions and threshold breaches
- [ ] **Performance Analytics**: Advanced analytics for performance trend analysis
- [ ] **Log Compression**: Automatic compression of older log files
- [ ] **Export Capabilities**: Export metrics to external monitoring systems
- [ ] **Anomaly Detection**: AI-powered detection of unusual patterns in logs
- [ ] **Historical Analysis**: Long-term trend analysis and reporting

## Integration with Evolution Engine

The logs directory integrates with:
- [Evolution Metrics System](../scripts/update/update-evolution-metrics.sh) - Automated metrics collection
- [Testing Framework](../tests/README.md) - Test execution logging and metrics
- [Monitoring Scripts](../scripts/analysis/) - Health analysis and reporting
- [Documentation System](../docs/README.md) - Evolution tracking and documentation

## Related Documentation

- [Main Repository README](../README.md) - Project overview and monitoring features
- [Evolution Metrics Guide](../docs/evolution/metrics.md) - Detailed metrics documentation
- [Testing Documentation](../tests/README.md) - Test logging and artifact management
- [Troubleshooting Guide](../docs/guides/troubleshooting.md) - Log-based debugging techniques