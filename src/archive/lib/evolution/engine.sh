#!/bin/bash
#
# @file src/lib/evolution/engine.sh
# @description Core evolution engine for AI-powered repository development
# @author IT-Journey Team <team@it-journey.org>
# @created 2025-07-05
# @lastModified 2025-07-05
# @version 2.0.0
#
# @relatedIssues 
#   - Refactor scripts to be modular with well-structured library
#
# @relatedEvolutions
#   - v2.0.0: Complete modular evolution engine
#
# @dependencies
#   - bash: >=4.0
#   - core/logger.sh: Logging functions
#   - core/config.sh: Configuration management
#   - evolution/git.sh: Git operations
#   - evolution/metrics.sh: Metrics tracking
#
# @changelog
#   - 2025-07-05: Initial creation of modular evolution engine - ITJ
#
# @usage require_module "evolution/engine"; evolution_run_cycle
# @notes Central orchestrator for all evolution processes
#

# Prevent multiple imports
[[ "${__EVOLUTION_ENGINE_LOADED:-}" == "true" ]] && return 0
readonly __EVOLUTION_ENGINE_LOADED=true

# Source dependencies if not already loaded
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if ! declare -F log_info >/dev/null 2>&1; then
    source "$SCRIPT_DIR/../core/logger.sh"
fi

readonly EVOLUTION_ENGINE_VERSION="2.0.0"

# Evolution engine state
EVOLUTION_ACTIVE=false
EVOLUTION_CYCLE=0
EVOLUTION_GENERATION=1
EVOLUTION_TYPE=""
EVOLUTION_INTENSITY=""
EVOLUTION_MODE=""
EVOLUTION_PROMPT=""
declare -A EVOLUTION_CONTEXT=()
declare -A EVOLUTION_RESULTS=()

# Evolution types and their configurations
declare -A EVOLUTION_TYPES=(
    [consistency]="Focus on code consistency, formatting, and style improvements"
    [error_fixing]="Identify and fix bugs, errors, and potential issues"
    [documentation]="Improve documentation, comments, and code clarity"
    [code_quality]="Enhance code quality, performance, and maintainability"
    [security_updates]="Address security vulnerabilities and best practices"
    [feature_enhancement]="Add new features or enhance existing functionality"
    [refactoring]="Restructure code for better organization and efficiency"
    [testing]="Improve test coverage and test quality"
    [optimization]="Optimize performance and resource usage"
    [custom]="Custom evolution based on specific requirements"
)

# Evolution intensities and their impacts
declare -A EVOLUTION_INTENSITIES=(
    [minimal]="Small, safe changes with minimal risk"
    [moderate]="Balanced changes with moderate complexity"
    [comprehensive]="Extensive changes with higher complexity"
    [experimental]="Cutting-edge changes with experimental features"
)

# Growth modes and their characteristics
declare -A GROWTH_MODES=(
    [conservative]="Prioritize stability and proven patterns"
    [adaptive]="Balance innovation with stability"
    [experimental]="Embrace new technologies and patterns"
    [aggressive]="Push boundaries with advanced implementations"
)

# Initialize evolution engine
# Args:
#   $1: config_file (optional)
# Returns:
#   0: success
#   1: failure
evolution_init() {
    local config_file="${1:-evolution.yml}"
    
    log_info "Initializing Evolution Engine v$EVOLUTION_ENGINE_VERSION"
    
    # Load configuration if available
    if require_module "core/config" && [[ -f "$config_file" ]]; then
        if ! load_config "$config_file"; then
            log_warn "Failed to load config, using defaults"
        fi
    fi
    
    # Load required modules
    require_module "evolution/git" || {
        log_error "Failed to load git module"
        return 1
    }
    
    require_module "evolution/metrics" || {
        log_error "Failed to load metrics module"
        return 1
    }
    
    # Initialize metrics system
    if ! init_metrics; then
        log_warn "Failed to initialize metrics system"
    fi
    
    # Set default values from config or use built-in defaults
    EVOLUTION_TYPE=$(get_config "evolution.type" "consistency")
    EVOLUTION_INTENSITY=$(get_config "evolution.intensity" "minimal")
    EVOLUTION_MODE=$(get_config "evolution.growth_mode" "adaptive")
    
    log_success "Evolution Engine initialized"
    log_info "  Type: $EVOLUTION_TYPE"
    log_info "  Intensity: $EVOLUTION_INTENSITY"
    log_info "  Mode: $EVOLUTION_MODE"
    
    return 0
}

# Validate evolution parameters
# Args:
#   $1: evolution_type
#   $2: intensity
#   $3: mode
# Returns:
#   0: valid parameters
#   1: invalid parameters
evolution_validate_params() {
    local evo_type="$1"
    local intensity="$2"
    local mode="$3"
    
    # Validate evolution type
    if [[ -z "${EVOLUTION_TYPES[$evo_type]:-}" ]]; then
        log_error "Invalid evolution type: $evo_type"
        log_info "Available types: ${!EVOLUTION_TYPES[*]}"
        return 1
    fi
    
    # Validate intensity
    if [[ -z "${EVOLUTION_INTENSITIES[$intensity]:-}" ]]; then
        log_error "Invalid evolution intensity: $intensity"
        log_info "Available intensities: ${!EVOLUTION_INTENSITIES[*]}"
        return 1
    fi
    
    # Validate growth mode
    if [[ -z "${GROWTH_MODES[$mode]:-}" ]]; then
        log_error "Invalid growth mode: $mode"
        log_info "Available modes: ${!GROWTH_MODES[*]}"
        return 1
    fi
    
    return 0
}

# Prepare evolution context
# Args:
#   $1: custom_prompt (optional)
# Returns:
#   0: success
#   1: failure
evolution_prepare_context() {
    local custom_prompt="${1:-}"
    
    log_info "Preparing evolution context..."
    
    # Clear previous context
    EVOLUTION_CONTEXT=()
    
    # Gather repository information
    EVOLUTION_CONTEXT[repo_root]="$(pwd)"
    EVOLUTION_CONTEXT[repo_name]="$(basename "$(pwd)")"
    EVOLUTION_CONTEXT[current_branch]="$(get_current_branch 2>/dev/null || echo "unknown")"
    EVOLUTION_CONTEXT[timestamp]="$(date -Iseconds)"
    EVOLUTION_CONTEXT[cycle]="$EVOLUTION_CYCLE"
    EVOLUTION_CONTEXT[generation]="$EVOLUTION_GENERATION"
    
    # Get repository statistics
    if is_git_repository; then
        EVOLUTION_CONTEXT[commit_count]="$(git rev-list --count HEAD 2>/dev/null || echo "0")"
        EVOLUTION_CONTEXT[last_commit]="$(git log -1 --format="%h %s" 2>/dev/null || echo "none")"
        EVOLUTION_CONTEXT[repo_size]="$(du -sh . 2>/dev/null | cut -f1 || echo "unknown")"
    fi
    
    # Set evolution prompt
    if [[ -n "$custom_prompt" ]]; then
        EVOLUTION_PROMPT="$custom_prompt"
    else
        EVOLUTION_PROMPT="$(evolution_generate_prompt)"
    fi
    
    EVOLUTION_CONTEXT[prompt]="$EVOLUTION_PROMPT"
    
    # Get current metrics
    if declare -F get_current_metrics >/dev/null 2>&1; then
        local metrics_data
        metrics_data="$(get_current_metrics)"
        EVOLUTION_CONTEXT[current_metrics]="$metrics_data"
    fi
    
    log_success "Evolution context prepared"
    log_debug "Repository: ${EVOLUTION_CONTEXT[repo_name]}"
    log_debug "Branch: ${EVOLUTION_CONTEXT[current_branch]}"
    log_debug "Cycle: ${EVOLUTION_CONTEXT[cycle]}"
    
    return 0
}

# Generate evolution prompt based on type and context
# Returns:
#   Prints generated prompt
evolution_generate_prompt() {
    local base_description="${EVOLUTION_TYPES[$EVOLUTION_TYPE]}"
    local intensity_description="${EVOLUTION_INTENSITIES[$EVOLUTION_INTENSITY]}"
    local mode_description="${GROWTH_MODES[$EVOLUTION_MODE]}"
    
    cat << EOF
Evolution Cycle #${EVOLUTION_CYCLE} - ${EVOLUTION_TYPE^} Evolution

Objective: $base_description
Intensity: $intensity_description
Growth Mode: $mode_description

Repository Context:
- Name: ${EVOLUTION_CONTEXT[repo_name]:-unknown}
- Branch: ${EVOLUTION_CONTEXT[current_branch]:-unknown}
- Commits: ${EVOLUTION_CONTEXT[commit_count]:-0}
- Last Change: ${EVOLUTION_CONTEXT[last_commit]:-none}

Focus Areas:
$(evolution_get_focus_areas)

Evolution Instructions:
$(evolution_get_instructions)
EOF
}

# Get focus areas based on evolution type
# Returns:
#   Prints focus areas
evolution_get_focus_areas() {
    case "$EVOLUTION_TYPE" in
        consistency)
            echo "- Code formatting and style consistency"
            echo "- Documentation formatting and structure"
            echo "- File organization and naming conventions"
            echo "- Configuration standardization"
            ;;
        error_fixing)
            echo "- Bug identification and resolution"
            echo "- Error handling improvements"
            echo "- Edge case handling"
            echo "- Validation and input sanitization"
            ;;
        documentation)
            echo "- README and documentation updates"
            echo "- Code comments and inline documentation"
            echo "- API documentation generation"
            echo "- Usage examples and tutorials"
            ;;
        code_quality)
            echo "- Code complexity reduction"
            echo "- Performance optimizations"
            echo "- Design pattern improvements"
            echo "- Code duplication elimination"
            ;;
        security_updates)
            echo "- Vulnerability assessment and fixes"
            echo "- Dependency security updates"
            echo "- Access control improvements"
            echo "- Secure coding practices"
            ;;
        feature_enhancement)
            echo "- New feature implementation"
            echo "- Existing feature improvements"
            echo "- User experience enhancements"
            echo "- Functionality extensions"
            ;;
        refactoring)
            echo "- Code structure reorganization"
            echo "- Module and component separation"
            echo "- Architecture improvements"
            echo "- Dependency management"
            ;;
        testing)
            echo "- Test coverage expansion"
            echo "- Test quality improvements"
            echo "- Integration test development"
            echo "- Testing automation"
            ;;
        optimization)
            echo "- Performance bottleneck identification"
            echo "- Resource usage optimization"
            echo "- Algorithm efficiency improvements"
            echo "- Caching and memoization"
            ;;
        custom)
            echo "- Custom requirements based on prompt"
            echo "- Specific use case optimizations"
            echo "- Targeted improvements"
            echo "- Experimental implementations"
            ;;
    esac
}

# Get evolution instructions based on intensity and mode
# Returns:
#   Prints evolution instructions
evolution_get_instructions() {
    echo "Intensity Guidelines ($EVOLUTION_INTENSITY):"
    case "$EVOLUTION_INTENSITY" in
        minimal)
            echo "- Make small, incremental changes"
            echo "- Focus on low-risk improvements"
            echo "- Maintain backward compatibility"
            echo "- Prioritize quick wins"
            ;;
        moderate)
            echo "- Implement balanced improvements"
            echo "- Consider moderate refactoring"
            echo "- Add new features carefully"
            echo "- Maintain good test coverage"
            ;;
        comprehensive)
            echo "- Implement significant changes"
            echo "- Major refactoring is acceptable"
            echo "- Add comprehensive features"
            echo "- Extensive testing required"
            ;;
        experimental)
            echo "- Explore cutting-edge approaches"
            echo "- Implement experimental features"
            echo "- Use latest technologies"
            echo "- Document experimental aspects"
            ;;
    esac
    
    echo
    echo "Growth Mode Guidelines ($EVOLUTION_MODE):"
    case "$EVOLUTION_MODE" in
        conservative)
            echo "- Use proven, stable approaches"
            echo "- Minimize breaking changes"
            echo "- Favor incremental improvements"
            echo "- Prioritize reliability"
            ;;
        adaptive)
            echo "- Balance innovation with stability"
            echo "- Adapt to current best practices"
            echo "- Consider emerging patterns"
            echo "- Evolve based on feedback"
            ;;
        experimental)
            echo "- Embrace new technologies"
            echo "- Try innovative approaches"
            echo "- Implement experimental features"
            echo "- Push technological boundaries"
            ;;
        aggressive)
            echo "- Implement advanced patterns"
            echo "- Use cutting-edge technologies"
            echo "- Make bold architectural changes"
            echo "- Optimize for future needs"
            ;;
    esac
}

# Execute evolution cycle
# Args:
#   $1: evolution_type (optional, uses current)
#   $2: intensity (optional, uses current)
#   $3: mode (optional, uses current)
#   $4: custom_prompt (optional)
# Returns:
#   0: success
#   1: failure
evolution_run_cycle() {
    local evo_type="${1:-$EVOLUTION_TYPE}"
    local intensity="${2:-$EVOLUTION_INTENSITY}"
    local mode="${3:-$EVOLUTION_MODE}"
    local custom_prompt="${4:-}"
    
    # Validate parameters
    if ! evolution_validate_params "$evo_type" "$intensity" "$mode"; then
        return 1
    fi
    
    # Update global state
    EVOLUTION_TYPE="$evo_type"
    EVOLUTION_INTENSITY="$intensity"
    EVOLUTION_MODE="$mode"
    EVOLUTION_ACTIVE=true
    ((EVOLUTION_CYCLE++))
    
    log_info "🌱 Starting Evolution Cycle #$EVOLUTION_CYCLE"
    log_info "  Type: $EVOLUTION_TYPE"
    log_info "  Intensity: $EVOLUTION_INTENSITY"
    log_info "  Mode: $EVOLUTION_MODE"
    
    # Record cycle start
    local start_time
    start_time="$(date +%s)"
    
    # Clear previous results
    EVOLUTION_RESULTS=()
    
    # Prepare evolution context
    if ! evolution_prepare_context "$custom_prompt"; then
        log_error "Failed to prepare evolution context"
        EVOLUTION_ACTIVE=false
        return 1
    fi
    
    # Create evolution branch
    local branch_name
    if ! branch_name="$(create_evolution_branch "$EVOLUTION_TYPE")"; then
        log_error "Failed to create evolution branch"
        EVOLUTION_ACTIVE=false
        return 1
    fi
    
    EVOLUTION_RESULTS[branch]="$branch_name"
    
    # Execute evolution phases
    local phases=(
        "analysis"
        "planning"
        "implementation"
        "validation"
        "documentation"
    )
    
    for phase in "${phases[@]}"; do
        log_info "📋 Executing phase: $phase"
        
        if ! "evolution_phase_$phase"; then
            log_error "Evolution phase '$phase' failed"
            EVOLUTION_ACTIVE=false
            return 1
        fi
        
        log_success "Phase '$phase' completed"
    done
    
    # Record cycle completion
    local end_time
    end_time="$(date +%s)"
    local duration
    duration=$((end_time - start_time))
    
    EVOLUTION_RESULTS[duration]="$duration"
    EVOLUTION_RESULTS[status]="completed"
    EVOLUTION_RESULTS[timestamp]="$(date -Iseconds)"
    
    # Update metrics
    if declare -F record_evolution_cycle >/dev/null 2>&1; then
        record_evolution_cycle "$EVOLUTION_TYPE" "$intensity" "$mode" "$duration" "success"
    fi
    
    log_success "🎉 Evolution Cycle #$EVOLUTION_CYCLE completed in $(format_duration "$duration")"
    
    EVOLUTION_ACTIVE=false
    return 0
}

# Evolution phase implementations
# ===========================================

# Analysis phase - understand current state
evolution_phase_analysis() {
    log_info "🔍 Analyzing repository state..."
    
    # Collect repository statistics
    local file_count
    file_count="$(find . -type f -not -path './.git/*' | wc -l | tr -d ' ')"
    
    local code_files
    code_files="$(find . -name "*.sh" -o -name "*.py" -o -name "*.js" -o -name "*.yml" -o -name "*.yaml" -o -name "*.json" | wc -l | tr -d ' ')"
    
    local total_lines
    total_lines="$(find . -name "*.sh" -o -name "*.py" -o -name "*.js" -o -name "*.md" -exec wc -l {} + 2>/dev/null | tail -n1 | awk '{print $1}' || echo "0")"
    
    EVOLUTION_RESULTS[analysis_file_count]="$file_count"
    EVOLUTION_RESULTS[analysis_code_files]="$code_files"
    EVOLUTION_RESULTS[analysis_total_lines]="$total_lines"
    
    log_info "  Files: $file_count (Code: $code_files)"
    log_info "  Lines: $total_lines"
    
    # Analyze based on evolution type
    case "$EVOLUTION_TYPE" in
        consistency)
            evolution_analyze_consistency
            ;;
        error_fixing)
            evolution_analyze_errors
            ;;
        documentation)
            evolution_analyze_documentation
            ;;
        code_quality)
            evolution_analyze_quality
            ;;
        security_updates)
            evolution_analyze_security
            ;;
        *)
            log_info "  Generic analysis completed"
            ;;
    esac
    
    return 0
}

# Planning phase - create implementation plan
evolution_phase_planning() {
    log_info "📋 Creating evolution plan..."
    
    # Generate plan based on analysis and evolution type
    local plan_file="evolution-plan.md"
    
    cat > "$plan_file" << EOF
# Evolution Plan - Cycle #${EVOLUTION_CYCLE}

## Overview
- **Type**: ${EVOLUTION_TYPE}
- **Intensity**: ${EVOLUTION_INTENSITY}
- **Mode**: ${EVOLUTION_MODE}
- **Generated**: $(date -Iseconds)

## Analysis Summary
- **Files**: ${EVOLUTION_RESULTS[analysis_file_count]:-0}
- **Code Files**: ${EVOLUTION_RESULTS[analysis_code_files]:-0}
- **Total Lines**: ${EVOLUTION_RESULTS[analysis_total_lines]:-0}

## Implementation Plan
$(evolution_create_implementation_plan)

## Success Criteria
$(evolution_create_success_criteria)

## Risk Assessment
$(evolution_assess_risks)
EOF
    
    EVOLUTION_RESULTS[plan_file]="$plan_file"
    log_success "Evolution plan created: $plan_file"
    
    return 0
}

# Implementation phase - make actual changes
evolution_phase_implementation() {
    log_info "🔧 Implementing evolution changes..."
    
    local changes_made=0
    
    # Execute implementation based on type
    case "$EVOLUTION_TYPE" in
        consistency)
            if evolution_implement_consistency; then
                ((changes_made++))
            fi
            ;;
        error_fixing)
            if evolution_implement_error_fixes; then
                ((changes_made++))
            fi
            ;;
        documentation)
            if evolution_implement_documentation; then
                ((changes_made++))
            fi
            ;;
        code_quality)
            if evolution_implement_quality_improvements; then
                ((changes_made++))
            fi
            ;;
        custom)
            if evolution_implement_custom; then
                ((changes_made++))
            fi
            ;;
        *)
            log_info "No specific implementation for type: $EVOLUTION_TYPE"
            ;;
    esac
    
    EVOLUTION_RESULTS[changes_made]="$changes_made"
    
    if [[ $changes_made -gt 0 ]]; then
        log_success "Implementation completed with $changes_made changes"
    else
        log_info "No changes were necessary"
    fi
    
    return 0
}

# Validation phase - verify changes
evolution_phase_validation() {
    log_info "✅ Validating evolution changes..."
    
    # Run basic validations
    local validation_errors=0
    
    # Check for syntax errors in shell scripts
    while IFS= read -r -d '' script_file; do
        if ! bash -n "$script_file" 2>/dev/null; then
            log_error "Syntax error in: $script_file"
            ((validation_errors++))
        fi
    done < <(find . -name "*.sh" -print0 2>/dev/null)
    
    # Validate JSON files
    while IFS= read -r -d '' json_file; do
        if ! jq empty "$json_file" 2>/dev/null; then
            log_error "Invalid JSON in: $json_file"
            ((validation_errors++))
        fi
    done < <(find . -name "*.json" -print0 2>/dev/null)
    
    # Run tests if available
    if [[ -f "test.sh" ]] || [[ -d "tests" ]]; then
        log_info "Running available tests..."
        if evolution_run_tests; then
            log_success "Tests passed"
        else
            log_warn "Some tests failed"
            ((validation_errors++))
        fi
    fi
    
    EVOLUTION_RESULTS[validation_errors]="$validation_errors"
    
    if [[ $validation_errors -eq 0 ]]; then
        log_success "Validation completed successfully"
    else
        log_warn "Validation completed with $validation_errors errors"
    fi
    
    return 0
}

# Documentation phase - update documentation
evolution_phase_documentation() {
    log_info "📚 Updating documentation..."
    
    # Update changelog
    evolution_update_changelog
    
    # Update README if needed
    evolution_update_readme
    
    # Generate evolution report
    evolution_generate_report
    
    log_success "Documentation updated"
    return 0
}

# Helper functions for specific evolution types
# ===========================================

evolution_analyze_consistency() {
    log_info "  Analyzing code consistency..."
    # Placeholder for consistency analysis
}

evolution_analyze_errors() {
    log_info "  Analyzing potential errors..."
    # Placeholder for error analysis
}

evolution_analyze_documentation() {
    log_info "  Analyzing documentation coverage..."
    # Placeholder for documentation analysis
}

evolution_analyze_quality() {
    log_info "  Analyzing code quality..."
    # Placeholder for quality analysis
}

evolution_analyze_security() {
    log_info "  Analyzing security aspects..."
    # Placeholder for security analysis
}

evolution_create_implementation_plan() {
    case "$EVOLUTION_TYPE" in
        consistency)
            echo "1. Standardize script headers and documentation"
            echo "2. Ensure consistent error handling patterns"
            echo "3. Normalize function naming conventions"
            echo "4. Standardize logging throughout codebase"
            ;;
        documentation)
            echo "1. Update README with current functionality"
            echo "2. Add missing function documentation"
            echo "3. Create usage examples"
            echo "4. Update installation instructions"
            ;;
        *)
            echo "1. Identify improvement opportunities"
            echo "2. Implement changes incrementally"
            echo "3. Test modifications thoroughly"
            echo "4. Document all changes"
            ;;
    esac
}

evolution_create_success_criteria() {
    echo "- All changes maintain backward compatibility"
    echo "- No new errors or warnings introduced"
    echo "- All tests continue to pass"
    echo "- Documentation reflects changes"
    echo "- Evolution metrics improve"
}

evolution_assess_risks() {
    case "$EVOLUTION_INTENSITY" in
        minimal)
            echo "**Low Risk**: Changes are small and incremental"
            ;;
        moderate)
            echo "**Medium Risk**: Changes require careful testing"
            ;;
        comprehensive)
            echo "**High Risk**: Extensive changes need thorough validation"
            ;;
        experimental)
            echo "**Very High Risk**: Experimental features need careful monitoring"
            ;;
    esac
}

# Implementation helpers (placeholders for actual implementations)
evolution_implement_consistency() {
    log_info "Implementing consistency improvements..."
    # Add actual consistency improvements here
    return 0
}

evolution_implement_error_fixes() {
    log_info "Implementing error fixes..."
    # Add actual error fixing logic here
    return 0
}

evolution_implement_documentation() {
    log_info "Implementing documentation improvements..."
    # Add actual documentation improvements here
    return 0
}

evolution_implement_quality_improvements() {
    log_info "Implementing quality improvements..."
    # Add actual quality improvements here
    return 0
}

evolution_implement_custom() {
    log_info "Implementing custom changes based on prompt..."
    # Add custom implementation logic here
    return 0
}

evolution_run_tests() {
    # Run available tests
    if [[ -x "test.sh" ]]; then
        ./test.sh
    elif [[ -d "tests" ]] && [[ -x "tests/run_all.sh" ]]; then
        tests/run_all.sh
    else
        log_info "No test framework detected"
        return 0
    fi
}

evolution_update_changelog() {
    local changelog_file="CHANGELOG.md"
    local date_stamp
    date_stamp="$(date '+%Y-%m-%d')"
    
    if [[ ! -f "$changelog_file" ]]; then
        cat > "$changelog_file" << 'EOF'
# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

EOF
    fi
    
    # Add new entry
    local temp_file
    temp_file="$(mktemp)"
    
    # Extract header
    head -n 6 "$changelog_file" > "$temp_file"
    
    # Add new version entry
    cat >> "$temp_file" << EOF

## [Evolution Cycle $EVOLUTION_CYCLE] - $date_stamp

### Changed
- Evolution type: $EVOLUTION_TYPE
- Evolution intensity: $EVOLUTION_INTENSITY  
- Growth mode: $EVOLUTION_MODE
- Changes implemented: ${EVOLUTION_RESULTS[changes_made]:-0}

EOF
    
    # Add rest of changelog
    tail -n +7 "$changelog_file" >> "$temp_file"
    
    mv "$temp_file" "$changelog_file"
    log_info "Updated changelog: $changelog_file"
}

evolution_update_readme() {
    # Update README with evolution information
    local readme_file="README.md"
    
    if [[ -f "$readme_file" ]]; then
        # Look for evolution marker and update
        if grep -q "AI-EVOLUTION-MARKER" "$readme_file"; then
            # Update evolution section
            log_info "Updating README evolution section"
        else
            log_info "README exists but no evolution marker found"
        fi
    else
        log_info "No README found to update"
    fi
}

evolution_generate_report() {
    local report_file="evolution-cycle-${EVOLUTION_CYCLE}-report.md"
    
    cat > "$report_file" << EOF
# Evolution Cycle #${EVOLUTION_CYCLE} Report

## Overview
- **Date**: $(date -Iseconds)
- **Type**: ${EVOLUTION_TYPE}
- **Intensity**: ${EVOLUTION_INTENSITY}
- **Mode**: ${EVOLUTION_MODE}
- **Duration**: $(format_duration "${EVOLUTION_RESULTS[duration]:-0}")

## Results
- **Status**: ${EVOLUTION_RESULTS[status]:-unknown}
- **Branch**: ${EVOLUTION_RESULTS[branch]:-none}
- **Changes Made**: ${EVOLUTION_RESULTS[changes_made]:-0}
- **Validation Errors**: ${EVOLUTION_RESULTS[validation_errors]:-0}

## Context
- **Repository**: ${EVOLUTION_CONTEXT[repo_name]:-unknown}
- **Files Analyzed**: ${EVOLUTION_RESULTS[analysis_file_count]:-0}
- **Code Files**: ${EVOLUTION_RESULTS[analysis_code_files]:-0}
- **Total Lines**: ${EVOLUTION_RESULTS[analysis_total_lines]:-0}

## Evolution Prompt
\`\`\`
${EVOLUTION_PROMPT}
\`\`\`

## Next Steps
- Review and test changes
- Merge evolution branch if successful
- Plan next evolution cycle
- Update project documentation

---
*Generated by AI Evolution Engine v${EVOLUTION_ENGINE_VERSION}*
EOF
    
    EVOLUTION_RESULTS[report_file]="$report_file"
    log_success "Evolution report generated: $report_file"
}

# Status and reporting functions
# ===========================================

# Get current evolution status
evolution_get_status() {
    cat << EOF
🌱 Evolution Engine Status

Engine Version: $EVOLUTION_ENGINE_VERSION
Active: $([ "$EVOLUTION_ACTIVE" == "true" ] && echo "Yes" || echo "No")
Current Cycle: $EVOLUTION_CYCLE
Generation: $EVOLUTION_GENERATION

Configuration:
  Type: $EVOLUTION_TYPE
  Intensity: $EVOLUTION_INTENSITY
  Mode: $EVOLUTION_MODE

Last Results:
$(for key in "${!EVOLUTION_RESULTS[@]}"; do
    echo "  $key: ${EVOLUTION_RESULTS[$key]}"
done)
EOF
}

# List available evolution types
evolution_list_types() {
    echo "📋 Available Evolution Types:"
    for type in "${!EVOLUTION_TYPES[@]}"; do
        echo "  🌱 $type: ${EVOLUTION_TYPES[$type]}"
    done
}

# List available intensities
evolution_list_intensities() {
    echo "⚡ Available Evolution Intensities:"
    for intensity in "${!EVOLUTION_INTENSITIES[@]}"; do
        echo "  ⚡ $intensity: ${EVOLUTION_INTENSITIES[$intensity]}"
    done
}

# List available growth modes
evolution_list_modes() {
    echo "🚀 Available Growth Modes:"
    for mode in "${!GROWTH_MODES[@]}"; do
        echo "  🚀 $mode: ${GROWTH_MODES[$mode]}"
    done
}

# Show evolution engine help
evolution_show_help() {
    cat << EOF
🌱 AI Evolution Engine v$EVOLUTION_ENGINE_VERSION

USAGE:
    evolution_init [config_file]         - Initialize the evolution engine
    evolution_run_cycle [type] [intensity] [mode] [prompt] - Run evolution cycle
    evolution_get_status                 - Show current status
    evolution_list_types                 - List available evolution types
    evolution_list_intensities           - List available intensities
    evolution_list_modes                 - List available growth modes

EVOLUTION TYPES:
$(for type in "${!EVOLUTION_TYPES[@]}"; do echo "    $type"; done)

INTENSITIES:
$(for intensity in "${!EVOLUTION_INTENSITIES[@]}"; do echo "    $intensity"; done)

GROWTH MODES:
$(for mode in "${!GROWTH_MODES[@]}"; do echo "    $mode"; done)

EXAMPLES:
    evolution_run_cycle "consistency" "minimal" "adaptive"
    evolution_run_cycle "documentation" "moderate" "conservative" "Update all README files"
    evolution_run_cycle "custom" "experimental" "aggressive" "Implement advanced AI features"

EOF
}
