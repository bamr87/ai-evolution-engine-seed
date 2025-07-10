#!/bin/bash
#
# @file src/lib/analysis/health.sh
# @description Repository health analysis and reporting
# @author IT-Journey Team <team@it-journey.org>
# @created 2025-07-05
# @lastModified 2025-07-05
# @version 2.0.0
#
# @relatedIssues 
#   - Refactor scripts to be modular with well-structured library
#
# @relatedEvolutions
#   - v2.0.0: Complete modular health analysis system
#
# @dependencies
#   - bash: >=4.0
#   - core/logger.sh: Logging functions
#   - core/utils.sh: Utility functions
#   - evolution/git.sh: Git operations
#
# @changelog
#   - 2025-07-05: Initial creation of health analysis module - ITJ
#
# @usage require_module "analysis/health"; health_analyze_repository
# @notes Provides comprehensive repository health metrics and analysis
#

# Source dependencies if not already loaded
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if ! declare -F log_info >/dev/null 2>&1; then
    source "$SCRIPT_DIR/../core/logger.sh"
fi

readonly HEALTH_MODULE_VERSION="2.0.0"

# Check bash version for compatibility
BASH_VERSION_MAJOR=$(bash --version | head -1 | grep -oE '[0-9]+\.[0-9]+' | cut -d. -f1)

# Health analysis state - compatible with bash 3.2+
if [[ "${BASH_VERSION_MAJOR:-3}" -ge 4 ]]; then
    # Modern bash (4+) with associative arrays
    declare -A HEALTH_METRICS=()
    declare -A HEALTH_SCORES=()
    declare -A HEALTH_CATEGORIES=(
        [code_quality]=25
        [documentation]=20
        [testing]=20
        [security]=15
        [maintenance]=10
        [evolution]=10
    )
    HEALTH_USE_ARRAYS=true
else
    # Legacy bash (3.2+) with simple variables
    HEALTH_METRICS_LIST=""
    HEALTH_SCORES_LIST=""
    HEALTH_USE_ARRAYS=false
fi

HEALTH_OVERALL_SCORE=0
HEALTH_ANALYSIS_TIMESTAMP=""
)

# Initialize health analysis
# Returns:
#   0: success
health_init() {
    log_info "Initializing repository health analysis v$HEALTH_MODULE_VERSION"
    
    HEALTH_ANALYSIS_TIMESTAMP=$(date -u +%Y-%m-%dT%H:%M:%SZ)
    
    # Clear previous results
    HEALTH_METRICS=()
    HEALTH_SCORES=()
    HEALTH_OVERALL_SCORE=0
    
    return 0
}

# Analyze code quality
# Returns:
#   0: success
#   1: failure
health_analyze_code_quality() {
    log_info "Analyzing code quality"
    
    local score=0
    local total_checks=0
    
    # Check for common code quality indicators
    
    # 1. Check for shell script linting
    if command -v shellcheck >/dev/null 2>&1; then
        local shellcheck_issues=0
        while IFS= read -r -d '' file; do
            if ! shellcheck "$file" >/dev/null 2>&1; then
                ((shellcheck_issues++))
            fi
            ((total_checks++))
        done < <(find . -name "*.sh" -type f -print0 2>/dev/null)
        
        if [[ $total_checks -gt 0 ]]; then
            local shellcheck_score=$((100 * (total_checks - shellcheck_issues) / total_checks))
            score=$((score + shellcheck_score))
            HEALTH_METRICS[shellcheck_score]=$shellcheck_score
            HEALTH_METRICS[shellcheck_issues]=$shellcheck_issues
            HEALTH_METRICS[shell_files_checked]=$total_checks
        fi
    fi
    
    # 2. Check for consistent file structure
    local structure_score=100
    local required_files=("README.md" "LICENSE" ".gitignore")
    for file in "${required_files[@]}"; do
        if [[ ! -f "$file" ]]; then
            structure_score=$((structure_score - 20))
        fi
    done
    score=$((score + structure_score))
    HEALTH_METRICS[file_structure_score]=$structure_score
    
    # 3. Check for code documentation
    local documented_functions=0
    local total_functions=0
    
    while IFS= read -r -d '' file; do
        local file_functions
        file_functions=$(grep -c "^[[:space:]]*function\|^[[:space:]]*[a-zA-Z_][a-zA-Z0-9_]*[[:space:]]*(" "$file" 2>/dev/null || echo "0")
        local file_documented
        file_documented=$(grep -c "# Args:\|# Returns:\|# Description:" "$file" 2>/dev/null || echo "0")
        
        total_functions=$((total_functions + file_functions))
        documented_functions=$((documented_functions + file_documented))
    done < <(find . -name "*.sh" -type f -print0 2>/dev/null)
    
    if [[ $total_functions -gt 0 ]]; then
        local documentation_score=$((100 * documented_functions / total_functions))
        score=$((score + documentation_score))
        HEALTH_METRICS[documentation_score]=$documentation_score
        HEALTH_METRICS[documented_functions]=$documented_functions
        HEALTH_METRICS[total_functions]=$total_functions
    fi
    
    # Calculate average score
    local checks_performed=3
    if [[ $checks_performed -gt 0 ]]; then
        HEALTH_SCORES[code_quality]=$((score / checks_performed))
    else
        HEALTH_SCORES[code_quality]=0
    fi
    
    log_debug "Code quality score: ${HEALTH_SCORES[code_quality]}"
    return 0
}

# Analyze documentation quality
# Returns:
#   0: success
health_analyze_documentation() {
    log_info "Analyzing documentation quality"
    
    local score=0
    local total_checks=0
    
    # 1. Check README.md quality
    if [[ -f "README.md" ]]; then
        local readme_score=0
        local readme_content
        readme_content=$(cat "README.md")
        
        # Check for essential sections
        if echo "$readme_content" | grep -qi "installation\|setup"; then
            readme_score=$((readme_score + 20))
        fi
        if echo "$readme_content" | grep -qi "usage\|getting started"; then
            readme_score=$((readme_score + 20))
        fi
        if echo "$readme_content" | grep -qi "contributing\|contribution"; then
            readme_score=$((readme_score + 20))
        fi
        if echo "$readme_content" | grep -qi "license"; then
            readme_score=$((readme_score + 20))
        fi
        if echo "$readme_content" | grep -qi "example\|demo"; then
            readme_score=$((readme_score + 20))
        fi
        
        score=$((score + readme_score))
        HEALTH_METRICS[readme_score]=$readme_score
        ((total_checks++))
    fi
    
    # 2. Check for additional documentation files
    local doc_files=0
    local doc_patterns=("docs/" "CHANGELOG.md" "CONTRIBUTING.md" "CODE_OF_CONDUCT.md")
    for pattern in "${doc_patterns[@]}"; do
        if [[ -e "$pattern" ]]; then
            ((doc_files++))
        fi
    done
    
    local doc_coverage=$((doc_files * 25)) # Max 100 for all 4 patterns
    score=$((score + doc_coverage))
    HEALTH_METRICS[documentation_files]=$doc_files
    HEALTH_METRICS[documentation_coverage]=$doc_coverage
    ((total_checks++))
    
    # 3. Check for inline documentation
    local commented_lines=0
    local total_lines=0
    
    while IFS= read -r -d '' file; do
        local file_lines
        file_lines=$(wc -l < "$file" 2>/dev/null || echo "0")
        local file_comments
        file_comments=$(grep -c "^[[:space:]]*#" "$file" 2>/dev/null || echo "0")
        
        total_lines=$((total_lines + file_lines))
        commented_lines=$((commented_lines + file_comments))
    done < <(find . -name "*.sh" -type f -print0 2>/dev/null)
    
    if [[ $total_lines -gt 0 ]]; then
        local comment_ratio=$((100 * commented_lines / total_lines))
        score=$((score + comment_ratio))
        HEALTH_METRICS[comment_ratio]=$comment_ratio
        HEALTH_METRICS[commented_lines]=$commented_lines
        HEALTH_METRICS[total_code_lines]=$total_lines
        ((total_checks++))
    fi
    
    # Calculate average score
    if [[ $total_checks -gt 0 ]]; then
        HEALTH_SCORES[documentation]=$((score / total_checks))
    else
        HEALTH_SCORES[documentation]=0
    fi
    
    log_debug "Documentation score: ${HEALTH_SCORES[documentation]}"
    return 0
}

# Analyze testing coverage
# Returns:
#   0: success
health_analyze_testing() {
    log_info "Analyzing testing coverage"
    
    local score=0
    
    # 1. Check for test directory structure
    local test_structure_score=0
    if [[ -d "tests" ]] || [[ -d "test" ]]; then
        test_structure_score=50
    fi
    score=$((score + test_structure_score))
    HEALTH_METRICS[test_structure_score]=$test_structure_score
    
    # 2. Check for test files
    local test_files=0
    test_files=$(find . -name "*test*.sh" -o -name "*_test.sh" -o -name "test_*.sh" | wc -l)
    local test_coverage_score=0
    if [[ $test_files -gt 0 ]]; then
        test_coverage_score=$((test_files * 10)) # 10 points per test file, max 50
        if [[ $test_coverage_score -gt 50 ]]; then
            test_coverage_score=50
        fi
    fi
    score=$((score + test_coverage_score))
    HEALTH_METRICS[test_files]=$test_files
    HEALTH_METRICS[test_coverage_score]=$test_coverage_score
    
    HEALTH_SCORES[testing]=$score
    log_debug "Testing score: ${HEALTH_SCORES[testing]}"
    return 0
}

# Analyze security posture
# Returns:
#   0: success
health_analyze_security() {
    log_info "Analyzing security posture"
    
    local score=100 # Start with perfect score and deduct for issues
    
    # 1. Check for exposed secrets
    local secret_patterns=("password" "secret" "token" "api_key" "private_key")
    local exposed_secrets=0
    
    for pattern in "${secret_patterns[@]}"; do
        if grep -r -i "$pattern" . --exclude-dir=.git --exclude-dir=logs 2>/dev/null | grep -v "test\|example\|template" | head -1 >/dev/null; then
            ((exposed_secrets++))
            score=$((score - 20))
        fi
    done
    
    HEALTH_METRICS[exposed_secrets]=$exposed_secrets
    
    # 2. Check for .gitignore coverage
    local gitignore_score=0
    if [[ -f ".gitignore" ]]; then
        local gitignore_content
        gitignore_content=$(cat ".gitignore")
        local important_patterns=("*.log" "*.tmp" ".env" "secrets" "node_modules")
        local covered_patterns=0
        
        for pattern in "${important_patterns[@]}"; do
            if echo "$gitignore_content" | grep -q "$pattern"; then
                ((covered_patterns++))
            fi
        done
        
        gitignore_score=$((covered_patterns * 10)) # 10 points per pattern
    fi
    
    HEALTH_METRICS[gitignore_score]=$gitignore_score
    
    # 3. Check for hardcoded URLs and IPs
    local hardcoded_issues=0
    if grep -r "http://\|https://\|[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}" . --exclude-dir=.git --exclude-dir=logs 2>/dev/null | grep -v "example\|test\|localhost\|127.0.0.1" | head -1 >/dev/null; then
        hardcoded_issues=1
        score=$((score - 15))
    fi
    
    HEALTH_METRICS[hardcoded_issues]=$hardcoded_issues
    
    HEALTH_SCORES[security]=$score
    log_debug "Security score: ${HEALTH_SCORES[security]}"
    return 0
}

# Analyze maintenance indicators
# Returns:
#   0: success
health_analyze_maintenance() {
    log_info "Analyzing maintenance indicators"
    
    local score=0
    
    # 1. Check git commit frequency
    local recent_commits=0
    if command -v git >/dev/null 2>&1 && git rev-parse --git-dir >/dev/null 2>&1; then
        recent_commits=$(git log --since="30 days ago" --oneline 2>/dev/null | wc -l)
    fi
    
    local commit_score=0
    if [[ $recent_commits -gt 10 ]]; then
        commit_score=100
    elif [[ $recent_commits -gt 5 ]]; then
        commit_score=75
    elif [[ $recent_commits -gt 0 ]]; then
        commit_score=50
    fi
    
    score=$((score + commit_score))
    HEALTH_METRICS[recent_commits]=$recent_commits
    HEALTH_METRICS[commit_score]=$commit_score
    
    # 2. Check for TODO/FIXME markers
    local todo_count=0
    todo_count=$(grep -r -i "todo\|fixme\|hack\|xxx" . --exclude-dir=.git --exclude-dir=logs 2>/dev/null | wc -l)
    
    local todo_score=100
    if [[ $todo_count -gt 20 ]]; then
        todo_score=0
    elif [[ $todo_count -gt 10 ]]; then
        todo_score=50
    elif [[ $todo_count -gt 5 ]]; then
        todo_score=75
    fi
    
    score=$((score + todo_score))
    HEALTH_METRICS[todo_count]=$todo_count
    HEALTH_METRICS[todo_score]=$todo_score
    
    HEALTH_SCORES[maintenance]=$((score / 2)) # Average of the two checks
    log_debug "Maintenance score: ${HEALTH_SCORES[maintenance]}"
    return 0
}

# Analyze evolution readiness
# Returns:
#   0: success
health_analyze_evolution() {
    log_info "Analyzing evolution readiness"
    
    local score=0
    
    # 1. Check for evolution infrastructure
    local evolution_files=(".seed.md" "evolution-metrics.json" ".github/workflows/ai_evolver.yml")
    local evolution_score=0
    
    for file in "${evolution_files[@]}"; do
        if [[ -f "$file" ]]; then
            evolution_score=$((evolution_score + 33))
        fi
    done
    
    score=$((score + evolution_score))
    HEALTH_METRICS[evolution_infrastructure_score]=$evolution_score
    
    # 2. Check for modular structure
    local modular_score=0
    if [[ -d "src/lib" ]]; then
        modular_score=50
        local lib_modules
        lib_modules=$(find src/lib -name "*.sh" 2>/dev/null | wc -l)
        if [[ $lib_modules -gt 5 ]]; then
            modular_score=100
        elif [[ $lib_modules -gt 2 ]]; then
            modular_score=75
        fi
    fi
    
    score=$((score + modular_score))
    HEALTH_METRICS[modular_score]=$modular_score
    
    HEALTH_SCORES[evolution]=$((score / 2)) # Average of the two checks
    log_debug "Evolution score: ${HEALTH_SCORES[evolution]}"
    return 0
}

# Calculate overall health score
# Returns:
#   0: success
health_calculate_overall_score() {
    log_info "Calculating overall health score"
    
    local total_weighted_score=0
    local total_weight=0
    
    for category in "${!HEALTH_CATEGORIES[@]}"; do
        local weight=${HEALTH_CATEGORIES[$category]}
        local score=${HEALTH_SCORES[$category]:-0}
        
        total_weighted_score=$((total_weighted_score + (score * weight)))
        total_weight=$((total_weight + weight))
    done
    
    if [[ $total_weight -gt 0 ]]; then
        HEALTH_OVERALL_SCORE=$((total_weighted_score / total_weight))
    else
        HEALTH_OVERALL_SCORE=0
    fi
    
    HEALTH_METRICS[overall_score]=$HEALTH_OVERALL_SCORE
    log_info "Overall health score: $HEALTH_OVERALL_SCORE"
    
    return 0
}

# Generate health report
# Args:
#   $1: output_format (optional: json, markdown, text)
#   $2: output_file (optional)
# Returns:
#   0: success
health_generate_report() {
    local output_format="${1:-json}"
    local output_file="${2:-}"
    
    log_info "Generating health report ($output_format)"
    
    local report=""
    
    case "$output_format" in
        "json")
            report=$(health_generate_json_report)
            ;;
        "markdown")
            report=$(health_generate_markdown_report)
            ;;
        "text")
            report=$(health_generate_text_report)
            ;;
        *)
            log_error "Unsupported output format: $output_format"
            return 1
            ;;
    esac
    
    if [[ -n "$output_file" ]]; then
        echo "$report" > "$output_file"
        log_info "Health report saved to: $output_file"
    else
        echo "$report"
    fi
    
    return 0
}

# Generate JSON health report
# Returns:
#   0: success (prints JSON)
health_generate_json_report() {
    cat << EOF
{
    "timestamp": "$HEALTH_ANALYSIS_TIMESTAMP",
    "overall_score": $HEALTH_OVERALL_SCORE,
    "scores": {
$(for category in "${!HEALTH_SCORES[@]}"; do
    echo "        \"$category\": ${HEALTH_SCORES[$category]},"
done | sed '$ s/,$//')
    },
    "metrics": {
$(for metric in "${!HEALTH_METRICS[@]}"; do
    echo "        \"$metric\": ${HEALTH_METRICS[$metric]},"
done | sed '$ s/,$//')
    },
    "categories": {
$(for category in "${!HEALTH_CATEGORIES[@]}"; do
    echo "        \"$category\": ${HEALTH_CATEGORIES[$category]},"
done | sed '$ s/,$//')
    }
}
EOF
}

# Generate Markdown health report
# Returns:
#   0: success (prints Markdown)
health_generate_markdown_report() {
    cat << EOF
# 🩺 Repository Health Report

**Generated:** $HEALTH_ANALYSIS_TIMESTAMP  
**Overall Score:** $HEALTH_OVERALL_SCORE/100

## Category Scores

| Category | Score | Weight | Status |
|----------|--------|--------|--------|
$(for category in "${!HEALTH_CATEGORIES[@]}"; do
    local score=${HEALTH_SCORES[$category]:-0}
    local weight=${HEALTH_CATEGORIES[$category]}
    local status="❌ Poor"
    if [[ $score -ge 80 ]]; then
        status="✅ Excellent"
    elif [[ $score -ge 60 ]]; then
        status="⚠️ Good"
    elif [[ $score -ge 40 ]]; then
        status="🔶 Fair"
    fi
    echo "| $category | $score | $weight% | $status |"
done)

## Detailed Metrics

$(for metric in "${!HEALTH_METRICS[@]}"; do
    echo "- **$metric**: ${HEALTH_METRICS[$metric]}"
done)

## Health Status

EOF

    if [[ $HEALTH_OVERALL_SCORE -ge 80 ]]; then
        echo "🟢 **HEALTHY** - Repository is in excellent condition"
    elif [[ $HEALTH_OVERALL_SCORE -ge 60 ]]; then
        echo "🟡 **MODERATE** - Repository has some areas for improvement"
    elif [[ $HEALTH_OVERALL_SCORE -ge 40 ]]; then
        echo "🟠 **NEEDS ATTENTION** - Repository requires significant improvements"
    else
        echo "🔴 **CRITICAL** - Repository needs immediate attention"
    fi
}

# Generate text health report
# Returns:
#   0: success (prints text)
health_generate_text_report() {
    cat << EOF
Repository Health Report
========================

Generated: $HEALTH_ANALYSIS_TIMESTAMP
Overall Score: $HEALTH_OVERALL_SCORE/100

Category Scores:
$(for category in "${!HEALTH_SCORES[@]}"; do
    local score=${HEALTH_SCORES[$category]}
    printf "  %-15s %3d/100\n" "$category:" "$score"
done)

Detailed Metrics:
$(for metric in "${!HEALTH_METRICS[@]}"; do
    printf "  %-25s %s\n" "$metric:" "${HEALTH_METRICS[$metric]}"
done)
EOF
}

# Run complete health analysis
# Args:
#   $1: output_format (optional: json, markdown, text)
#   $2: output_file (optional)
# Returns:
#   0: success
#   1: failure
health_analyze_repository() {
    local output_format="${1:-json}"
    local output_file="${2:-}"
    
    log_info "Starting comprehensive repository health analysis"
    
    health_init || return 1
    
    health_analyze_code_quality || log_warn "Code quality analysis failed"
    health_analyze_documentation || log_warn "Documentation analysis failed"
    health_analyze_testing || log_warn "Testing analysis failed"
    health_analyze_security || log_warn "Security analysis failed"
    health_analyze_maintenance || log_warn "Maintenance analysis failed"
    health_analyze_evolution || log_warn "Evolution analysis failed"
    
    health_calculate_overall_score
    
    health_generate_report "$output_format" "$output_file"
    
    log_info "Health analysis completed with score: $HEALTH_OVERALL_SCORE/100"
    return 0
}

log_debug "Health analysis module loaded (v$HEALTH_MODULE_VERSION)"
