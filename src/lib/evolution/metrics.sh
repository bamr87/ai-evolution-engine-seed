#!/bin/bash
# Evolution metrics management library
# Handles metrics collection, analysis, and reporting for AI Evolution Engine
# Version: 0.3.6-seed

# Source dependencies
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../core/logger.sh"

# Default metrics file
readonly DEFAULT_METRICS_FILE="metrics/evolution-metrics.json"
readonly METRICS_BACKUP_DIR="metrics-backups"

# Initialize metrics system
init_metrics() {
    local metrics_file="${1:-$DEFAULT_METRICS_FILE}"
    
    # Create backup directory
    mkdir -p "$METRICS_BACKUP_DIR"
    
    # Initialize metrics file if it doesn't exist
    if [[ ! -f "$metrics_file" ]]; then
        log_info "Initializing evolution metrics..."
        create_default_metrics "$metrics_file"
    else
        log_info "Loading existing evolution metrics..."
        validate_metrics "$metrics_file"
    fi
}

# Create default metrics structure
create_default_metrics() {
    local metrics_file="$1"
    
    cat > "$metrics_file" << EOF
{
  "metadata": {
    "version": "1.0.0",
    "initialized_at": "$(date -Iseconds)",
    "last_updated": "$(date -Iseconds)",
    "seed_version": "1.0.0-modular"
  },
  "evolution": {
    "total_cycles": 0,
    "successful_cycles": 0,
    "failed_cycles": 0,
    "current_generation": 1,
    "last_evolution": null,
    "evolution_types": {}
  },
  "growth": {
    "total_growths": 0,
    "successful_growths": 0,
    "failed_growths": 0,
    "growth_modes": {},
    "last_growth": null
  },
  "testing": {
    "total_test_runs": 0,
    "total_tests_executed": 0,
    "total_tests_passed": 0,
    "total_tests_failed": 0,
    "test_success_rate": 0.0,
    "test_frameworks_used": [],
    "last_test_run": null
  },
  "quality": {
    "code_quality_score": 0.0,
    "test_coverage": 0.0,
    "documentation_completeness": 0.0,
    "security_score": 0.0,
    "performance_score": 0.0
  },
  "ai_insights": {
    "total_ai_interactions": 0,
    "successful_ai_suggestions": 0,
    "implemented_suggestions": 0,
    "ai_effectiveness_score": 0.0,
    "most_effective_prompts": []
  },
  "repository": {
    "total_commits": 0,
    "total_files": 0,
    "lines_of_code": 0,
    "languages_detected": [],
    "last_analysis": null
  }
}
EOF
    
    log_success "Created default metrics file: $metrics_file"
}

# Validate metrics file structure
validate_metrics() {
    local metrics_file="$1"
    
    if ! jq empty "$metrics_file" >/dev/null 2>&1; then
        log_error "Invalid JSON in metrics file: $metrics_file"
        return 1
    fi
    
    # Check for required sections
    local required_sections=("metadata" "evolution" "growth" "testing" "quality" "ai_insights" "repository")
    for section in "${required_sections[@]}"; do
        if ! jq -e ".$section" "$metrics_file" >/dev/null 2>&1; then
            log_warn "Missing section in metrics: $section"
        fi
    done
    
    log_success "Metrics validation passed"
    return 0
}

# Backup metrics before modification
backup_metrics() {
    local metrics_file="${1:-$DEFAULT_METRICS_FILE}"
    local backup_name="metrics-backup-$(date +%Y%m%d-%H%M%S).json"
    local backup_path="$METRICS_BACKUP_DIR/$backup_name"
    
    if [[ -f "$metrics_file" ]]; then
        cp "$metrics_file" "$backup_path"
        log_debug "Metrics backed up to: $backup_path"
    fi
}

# Update evolution metrics
update_evolution_metrics() {
    local metrics_file="${1:-$DEFAULT_METRICS_FILE}"
    local evolution_type="$2"
    local success="${3:-true}"
    local additional_data="${4:-{}}"
    
    backup_metrics "$metrics_file"
    
    log_info "Updating evolution metrics for type: $evolution_type"
    
    # Update evolution counters
    local temp_file=$(mktemp)
    jq --arg evolution_type "$evolution_type" \
       --arg success "$success" \
       --arg timestamp "$(date -Iseconds)" \
       --argjson additional "$additional_data" \
       '
       .metadata.last_updated = $timestamp |
       .evolution.total_cycles += 1 |
       (.evolution.successful_cycles += (if $success == "true" then 1 else 0 end)) |
       (.evolution.failed_cycles += (if $success == "false" then 1 else 0 end)) |
       .evolution.current_generation += 1 |
       .evolution.last_evolution = {
         "type": $evolution_type,
         "timestamp": $timestamp,
         "success": ($success == "true"),
         "data": $additional
       } |
       .evolution.evolution_types[$evolution_type] = (
         .evolution.evolution_types[$evolution_type] // {"count": 0, "successes": 0}
       ) |
       .evolution.evolution_types[$evolution_type].count += 1 |
       (.evolution.evolution_types[$evolution_type].successes += (if $success == "true" then 1 else 0 end))
       ' "$metrics_file" > "$temp_file"
    
    mv "$temp_file" "$metrics_file"
    log_success "Evolution metrics updated"
}

# Update growth metrics
update_growth_metrics() {
    local metrics_file="${1:-$DEFAULT_METRICS_FILE}"
    local growth_mode="$2"
    local success="${3:-true}"
    local cycle="${4:-0}"
    local additional_data="${5:-{}}"
    
    backup_metrics "$metrics_file"
    
    log_info "Updating growth metrics for mode: $growth_mode"
    
    local temp_file=$(mktemp)
    jq --arg growth_mode "$growth_mode" \
       --arg success "$success" \
       --arg cycle "$cycle" \
       --arg timestamp "$(date -Iseconds)" \
       --argjson additional "$additional_data" \
       '
       .metadata.last_updated = $timestamp |
       .growth.total_growths += 1 |
       (.growth.successful_growths += (if $success == "true" then 1 else 0 end)) |
       (.growth.failed_growths += (if $success == "false" then 1 else 0 end)) |
       .growth.last_growth = {
         "mode": $growth_mode,
         "cycle": ($cycle | tonumber),
         "timestamp": $timestamp,
         "success": ($success == "true"),
         "data": $additional
       } |
       .growth.growth_modes[$growth_mode] = (
         .growth.growth_modes[$growth_mode] // {"count": 0, "successes": 0}
       ) |
       .growth.growth_modes[$growth_mode].count += 1 |
       (.growth.growth_modes[$growth_mode].successes += (if $success == "true" then 1 else 0 end))
       ' "$metrics_file" > "$temp_file"
    
    mv "$temp_file" "$metrics_file"
    log_success "Growth metrics updated"
}

# Update testing metrics
update_testing_metrics() {
    local metrics_file="${1:-$DEFAULT_METRICS_FILE}"
    local tests_run="$2"
    local tests_passed="$3"
    local tests_failed="$4"
    local test_framework="${5:-unknown}"
    
    backup_metrics "$metrics_file"
    
    log_info "Updating testing metrics: $tests_passed/$tests_run passed"
    
    local success_rate=0
    if [[ $tests_run -gt 0 ]]; then
        success_rate=$(echo "scale=4; $tests_passed / $tests_run" | bc -l)
    fi
    
    local temp_file=$(mktemp)
    jq --arg tests_run "$tests_run" \
       --arg tests_passed "$tests_passed" \
       --arg tests_failed "$tests_failed" \
       --arg success_rate "$success_rate" \
       --arg framework "$test_framework" \
       --arg timestamp "$(date -Iseconds)" \
       '
       .metadata.last_updated = $timestamp |
       .testing.total_test_runs += 1 |
       .testing.total_tests_executed += ($tests_run | tonumber) |
       .testing.total_tests_passed += ($tests_passed | tonumber) |
       .testing.total_tests_failed += ($tests_failed | tonumber) |
       .testing.test_success_rate = (
         if .testing.total_tests_executed > 0 
         then (.testing.total_tests_passed / .testing.total_tests_executed)
         else 0
       ) |
       .testing.last_test_run = {
         "timestamp": $timestamp,
         "tests_run": ($tests_run | tonumber),
         "tests_passed": ($tests_passed | tonumber),
         "tests_failed": ($tests_failed | tonumber),
         "success_rate": ($success_rate | tonumber),
         "framework": $framework
       } |
       (if (.testing.test_frameworks_used | contains([$framework]) | not) 
        then .testing.test_frameworks_used += [$framework] 
        else . end)
       ' "$metrics_file" > "$temp_file"
    
    mv "$temp_file" "$metrics_file"
    log_success "Testing metrics updated"
}

# Update AI insights metrics
update_ai_metrics() {
    local metrics_file="${1:-$DEFAULT_METRICS_FILE}"
    local ai_interaction_success="${2:-true}"
    local suggestion_implemented="${3:-false}"
    local prompt_text="${4:-}"
    local effectiveness_score="${5:-0.5}"
    
    backup_metrics "$metrics_file"
    
    log_info "Updating AI insights metrics"
    
    local temp_file=$(mktemp)
    jq --arg success "$ai_interaction_success" \
       --arg implemented "$suggestion_implemented" \
       --arg prompt "$prompt_text" \
       --arg score "$effectiveness_score" \
       --arg timestamp "$(date -Iseconds)" \
       '
       .metadata.last_updated = $timestamp |
       .ai_insights.total_ai_interactions += 1 |
       (.ai_insights.successful_ai_suggestions += (if $success == "true" then 1 else 0 end)) |
       (.ai_insights.implemented_suggestions += (if $implemented == "true" then 1 else 0 end)) |
       .ai_insights.ai_effectiveness_score = (
         (.ai_insights.ai_effectiveness_score + ($score | tonumber)) / 2
       ) |
       (if ($prompt != "" and ($score | tonumber) > 0.7)
        then .ai_insights.most_effective_prompts += [{
          "prompt": $prompt,
          "score": ($score | tonumber),
          "timestamp": $timestamp
        }]
        else . end) |
       (.ai_insights.most_effective_prompts = .ai_insights.most_effective_prompts | sort_by(.score) | reverse | .[0:10])
       ' "$metrics_file" > "$temp_file"
    
    mv "$temp_file" "$metrics_file"
    log_success "AI insights metrics updated"
}

# Analyze repository and update metrics
analyze_repository() {
    local metrics_file="${1:-$DEFAULT_METRICS_FILE}"
    local repo_dir="${2:-.}"
    
    log_info "Analyzing repository structure and updating metrics..."
    
    # Count files and lines of code
    local total_files=0
    local lines_of_code=0
    local languages=()
    
    # Count files (excluding common ignored patterns)
    total_files=$(find "$repo_dir" -type f \
        ! -path "*/.*" \
        ! -path "*/node_modules/*" \
        ! -path "*/_site/*" \
        ! -path "*/logs/*" \
        ! -path "*/test-results/*" \
        | wc -l | tr -d ' ')
    
    # Count lines of code for common source files
    lines_of_code=$(find "$repo_dir" -type f \
        \( -name "*.sh" -o -name "*.py" -o -name "*.js" -o -name "*.ts" -o -name "*.yml" -o -name "*.yaml" -o -name "*.json" -o -name "*.md" \) \
        ! -path "*/.*" \
        ! -path "*/node_modules/*" \
        ! -path "*/_site/*" \
        -exec wc -l {} + 2>/dev/null | tail -1 | awk '{print $1}' || echo 0)
    
    # Detect languages
    if command -v file >/dev/null 2>&1; then
        mapfile -t languages < <(find "$repo_dir" -type f \
            ! -path "*/.*" \
            ! -path "*/node_modules/*" \
            -exec file {} \; 2>/dev/null | \
            grep -E "(shell|Python|JavaScript|JSON|YAML)" | \
            sed -E 's/.*: .*(shell|Python|JavaScript|JSON|YAML).*/\1/' | \
            sort -u)
    fi
    
    # Count commits
    local total_commits=0
    if [[ -d "$repo_dir/.git" ]]; then
        total_commits=$(cd "$repo_dir" && git rev-list --count HEAD 2>/dev/null || echo 0)
    fi
    
    backup_metrics "$metrics_file"
    
    local temp_file=$(mktemp)
    jq --arg total_files "$total_files" \
       --arg lines_of_code "$lines_of_code" \
       --arg total_commits "$total_commits" \
       --argjson languages "$(printf '%s\n' "${languages[@]}" | jq -R . | jq -s .)" \
       --arg timestamp "$(date -Iseconds)" \
       '
       .metadata.last_updated = $timestamp |
       .repository.total_files = ($total_files | tonumber) |
       .repository.lines_of_code = ($lines_of_code | tonumber) |
       .repository.total_commits = ($total_commits | tonumber) |
       .repository.languages_detected = $languages |
       .repository.last_analysis = $timestamp
       ' "$metrics_file" > "$temp_file"
    
    mv "$temp_file" "$metrics_file"
    log_success "Repository analysis completed"
}

# Generate metrics report
generate_metrics_report() {
    local metrics_file="${1:-$DEFAULT_METRICS_FILE}"
    local output_format="${2:-markdown}"
    local output_file="${3:-}"
    
    if [[ ! -f "$metrics_file" ]]; then
        log_error "Metrics file not found: $metrics_file"
        return 1
    fi
    
    case "$output_format" in
        "json")
            if [[ -n "$output_file" ]]; then
                cp "$metrics_file" "$output_file"
                log_success "JSON report saved to: $output_file"
            else
                cat "$metrics_file"
            fi
            ;;
        "markdown")
            generate_markdown_metrics_report "$metrics_file" "$output_file"
            ;;
        "summary")
            generate_summary_metrics_report "$metrics_file"
            ;;
        *)
            log_error "Unknown report format: $output_format"
            return 1
            ;;
    esac
}

# Generate markdown metrics report
generate_markdown_metrics_report() {
    local metrics_file="$1"
    local output_file="$2"
    
    local content
    content=$(cat << 'EOF'
# 🌱 AI Evolution Engine Metrics Report

**Generated:** {{TIMESTAMP}}  
**Repository:** {{REPO_NAME}}  
**Version:** {{VERSION}}

## 📊 Evolution Overview

| Metric | Value |
|--------|-------|
| Total Evolution Cycles | {{TOTAL_CYCLES}} |
| Successful Cycles | {{SUCCESSFUL_CYCLES}} |
| Current Generation | {{CURRENT_GENERATION}} |
| Success Rate | {{EVOLUTION_SUCCESS_RATE}}% |

## 🌿 Growth Metrics

| Metric | Value |
|--------|-------|
| Total Growth Cycles | {{TOTAL_GROWTHS}} |
| Successful Growths | {{SUCCESSFUL_GROWTHS}} |
| Growth Success Rate | {{GROWTH_SUCCESS_RATE}}% |

## 🧪 Testing Metrics

| Metric | Value |
|--------|-------|
| Total Test Runs | {{TOTAL_TEST_RUNS}} |
| Tests Executed | {{TOTAL_TESTS_EXECUTED}} |
| Tests Passed | {{TOTAL_TESTS_PASSED}} |
| Test Success Rate | {{TEST_SUCCESS_RATE}}% |

## 🤖 AI Insights

| Metric | Value |
|--------|-------|
| AI Interactions | {{TOTAL_AI_INTERACTIONS}} |
| Successful Suggestions | {{SUCCESSFUL_AI_SUGGESTIONS}} |
| Implemented Suggestions | {{IMPLEMENTED_SUGGESTIONS}} |
| AI Effectiveness Score | {{AI_EFFECTIVENESS_SCORE}} |

## 📁 Repository Statistics

| Metric | Value |
|--------|-------|
| Total Files | {{TOTAL_FILES}} |
| Lines of Code | {{LINES_OF_CODE}} |
| Total Commits | {{TOTAL_COMMITS}} |
| Languages | {{LANGUAGES}} |

## 📈 Quality Scores

| Metric | Score |
|--------|-------|
| Code Quality | {{CODE_QUALITY_SCORE}} |
| Test Coverage | {{TEST_COVERAGE}} |
| Documentation | {{DOCUMENTATION_COMPLETENESS}} |
| Security | {{SECURITY_SCORE}} |
| Performance | {{PERFORMANCE_SCORE}} |

---

*Generated by AI Evolution Engine v1.0.0*
EOF
)
    
    # Extract values from metrics file and replace placeholders
    local timestamp=$(date)
    local repo_name=$(basename "$(pwd)")
    local version=$(jq -r '.metadata.version // "unknown"' "$metrics_file")
    local total_cycles=$(jq -r '.evolution.total_cycles // 0' "$metrics_file")
    local successful_cycles=$(jq -r '.evolution.successful_cycles // 0' "$metrics_file")
    local current_generation=$(jq -r '.evolution.current_generation // 1' "$metrics_file")
    local total_growths=$(jq -r '.growth.total_growths // 0' "$metrics_file")
    local successful_growths=$(jq -r '.growth.successful_growths // 0' "$metrics_file")
    local total_test_runs=$(jq -r '.testing.total_test_runs // 0' "$metrics_file")
    local total_tests_executed=$(jq -r '.testing.total_tests_executed // 0' "$metrics_file")
    local total_tests_passed=$(jq -r '.testing.total_tests_passed // 0' "$metrics_file")
    local test_success_rate=$(jq -r '.testing.test_success_rate // 0' "$metrics_file")
    local total_ai_interactions=$(jq -r '.ai_insights.total_ai_interactions // 0' "$metrics_file")
    local successful_ai_suggestions=$(jq -r '.ai_insights.successful_ai_suggestions // 0' "$metrics_file")
    local implemented_suggestions=$(jq -r '.ai_insights.implemented_suggestions // 0' "$metrics_file")
    local ai_effectiveness_score=$(jq -r '.ai_insights.ai_effectiveness_score // 0' "$metrics_file")
    local total_files=$(jq -r '.repository.total_files // 0' "$metrics_file")
    local lines_of_code=$(jq -r '.repository.lines_of_code // 0' "$metrics_file")
    local total_commits=$(jq -r '.repository.total_commits // 0' "$metrics_file")
    local languages=$(jq -r '.repository.languages_detected | join(", ") // "Unknown"' "$metrics_file")
    local code_quality_score=$(jq -r '.quality.code_quality_score // 0' "$metrics_file")
    local test_coverage=$(jq -r '.quality.test_coverage // 0' "$metrics_file")
    local documentation_completeness=$(jq -r '.quality.documentation_completeness // 0' "$metrics_file")
    local security_score=$(jq -r '.quality.security_score // 0' "$metrics_file")
    local performance_score=$(jq -r '.quality.performance_score // 0' "$metrics_file")
    
    # Calculate success rates
    local evolution_success_rate=0
    if [[ $total_cycles -gt 0 ]]; then
        evolution_success_rate=$(echo "scale=1; $successful_cycles * 100 / $total_cycles" | bc -l)
    fi
    
    local growth_success_rate=0
    if [[ $total_growths -gt 0 ]]; then
        growth_success_rate=$(echo "scale=1; $successful_growths * 100 / $total_growths" | bc -l)
    fi
    
    # Replace placeholders
    content=${content//\{\{TIMESTAMP\}\}/$timestamp}
    content=${content//\{\{REPO_NAME\}\}/$repo_name}
    content=${content//\{\{VERSION\}\}/$version}
    content=${content//\{\{TOTAL_CYCLES\}\}/$total_cycles}
    content=${content//\{\{SUCCESSFUL_CYCLES\}\}/$successful_cycles}
    content=${content//\{\{CURRENT_GENERATION\}\}/$current_generation}
    content=${content//\{\{EVOLUTION_SUCCESS_RATE\}\}/$evolution_success_rate}
    content=${content//\{\{TOTAL_GROWTHS\}\}/$total_growths}
    content=${content//\{\{SUCCESSFUL_GROWTHS\}\}/$successful_growths}
    content=${content//\{\{GROWTH_SUCCESS_RATE\}\}/$growth_success_rate}
    content=${content//\{\{TOTAL_TEST_RUNS\}\}/$total_test_runs}
    content=${content//\{\{TOTAL_TESTS_EXECUTED\}\}/$total_tests_executed}
    content=${content//\{\{TOTAL_TESTS_PASSED\}\}/$total_tests_passed}
    content=${content//\{\{TEST_SUCCESS_RATE\}\}/$test_success_rate}
    content=${content//\{\{TOTAL_AI_INTERACTIONS\}\}/$total_ai_interactions}
    content=${content//\{\{SUCCESSFUL_AI_SUGGESTIONS\}\}/$successful_ai_suggestions}
    content=${content//\{\{IMPLEMENTED_SUGGESTIONS\}\}/$implemented_suggestions}
    content=${content//\{\{AI_EFFECTIVENESS_SCORE\}\}/$ai_effectiveness_score}
    content=${content//\{\{TOTAL_FILES\}\}/$total_files}
    content=${content//\{\{LINES_OF_CODE\}\}/$lines_of_code}
    content=${content//\{\{TOTAL_COMMITS\}\}/$total_commits}
    content=${content//\{\{LANGUAGES\}\}/$languages}
    content=${content//\{\{CODE_QUALITY_SCORE\}\}/$code_quality_score}
    content=${content//\{\{TEST_COVERAGE\}\}/$test_coverage}
    content=${content//\{\{DOCUMENTATION_COMPLETENESS\}\}/$documentation_completeness}
    content=${content//\{\{SECURITY_SCORE\}\}/$security_score}
    content=${content//\{\{PERFORMANCE_SCORE\}\}/$performance_score}
    
    if [[ -n "$output_file" ]]; then
        echo "$content" > "$output_file"
        log_success "Markdown report saved to: $output_file"
    else
        echo "$content"
    fi
}

# Generate summary metrics report
generate_summary_metrics_report() {
    local metrics_file="$1"
    
    local total_cycles=$(jq -r '.evolution.total_cycles // 0' "$metrics_file")
    local successful_cycles=$(jq -r '.evolution.successful_cycles // 0' "$metrics_file")
    local current_generation=$(jq -r '.evolution.current_generation // 1' "$metrics_file")
    local test_success_rate=$(jq -r '.testing.test_success_rate // 0' "$metrics_file")
    local ai_effectiveness_score=$(jq -r '.ai_insights.ai_effectiveness_score // 0' "$metrics_file")
    
    cat << EOF
🌱 AI Evolution Engine Summary
==============================
Generation: $current_generation
Evolution Cycles: $successful_cycles/$total_cycles
Test Success Rate: $(echo "scale=1; $test_success_rate * 100" | bc -l)%
AI Effectiveness: $(echo "scale=1; $ai_effectiveness_score * 100" | bc -l)%
Last Updated: $(jq -r '.metadata.last_updated // "unknown"' "$metrics_file")
EOF
}

# Get specific metric value
get_metric() {
    local metrics_file="${1:-$DEFAULT_METRICS_FILE}"
    local metric_path="$2"
    
    if [[ ! -f "$metrics_file" ]]; then
        log_error "Metrics file not found: $metrics_file"
        return 1
    fi
    
    jq -r "$metric_path // \"not found\"" "$metrics_file"
}
