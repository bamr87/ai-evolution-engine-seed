#!/bin/bash
#
# @file src/lib/integration/ci.sh
# @description CI/CD integration and workflow management
# @author IT-Journey Team <team@it-journey.org>
# @created 2025-07-05
# @lastModified 2025-07-05
# @version 2.0.0
#
# @relatedIssues 
#   - Refactor scripts to be modular with well-structured library
#
# @relatedEvolutions
#   - v2.0.0: Complete modular CI/CD integration
#
# @dependencies
#   - bash: >=4.0
#   - core/logger.sh: Logging functions
#   - core/utils.sh: Utility functions
#
# @changelog
#   - 2025-07-05: Initial creation of CI/CD integration module - ITJ
#
# @usage require_module "integration/ci"; ci_run_tests
# @notes Handles all CI/CD operations and workflow management
#

# Source dependencies if not already loaded
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if ! declare -F log_info >/dev/null 2>&1; then
    source "$SCRIPT_DIR/../core/logger.sh"
fi

readonly CI_MODULE_VERSION="2.0.0"

# CI/CD integration state
declare -g CI_ENVIRONMENT=""
declare -g CI_BUILD_ID=""
declare -g CI_COMMIT_SHA=""
declare -g CI_BRANCH=""
declare -g CI_PR_NUMBER=""
declare -g CI_DETECTED=false

# Detect CI environment
# Returns:
#   0: success
#   1: failure
ci_detect_environment() {
    log_debug "Detecting CI environment"
    
    # GitHub Actions
    if [[ -n "${GITHUB_ACTIONS:-}" ]]; then
        CI_ENVIRONMENT="github-actions"
        CI_BUILD_ID="${GITHUB_RUN_ID:-}"
        CI_COMMIT_SHA="${GITHUB_SHA:-}"
        CI_BRANCH="${GITHUB_REF_NAME:-}"
        CI_PR_NUMBER="${GITHUB_PR_NUMBER:-}"
        CI_DETECTED=true
        log_info "Detected GitHub Actions environment"
        return 0
    fi
    
    # GitLab CI
    if [[ -n "${GITLAB_CI:-}" ]]; then
        CI_ENVIRONMENT="gitlab-ci"
        CI_BUILD_ID="${CI_PIPELINE_ID:-}"
        CI_COMMIT_SHA="${CI_COMMIT_SHA:-}"
        CI_BRANCH="${CI_COMMIT_REF_NAME:-}"
        CI_PR_NUMBER="${CI_MERGE_REQUEST_IID:-}"
        CI_DETECTED=true
        log_info "Detected GitLab CI environment"
        return 0
    fi
    
    # Jenkins
    if [[ -n "${JENKINS_URL:-}" ]]; then
        CI_ENVIRONMENT="jenkins"
        CI_BUILD_ID="${BUILD_ID:-}"
        CI_COMMIT_SHA="${GIT_COMMIT:-}"
        CI_BRANCH="${GIT_BRANCH:-}"
        CI_DETECTED=true
        log_info "Detected Jenkins environment"
        return 0
    fi
    
    # Azure DevOps
    if [[ -n "${AZURE_HTTP_USER_AGENT:-}" ]]; then
        CI_ENVIRONMENT="azure-devops"
        CI_BUILD_ID="${BUILD_BUILDID:-}"
        CI_COMMIT_SHA="${BUILD_SOURCEVERSION:-}"
        CI_BRANCH="${BUILD_SOURCEBRANCHNAME:-}"
        CI_DETECTED=true
        log_info "Detected Azure DevOps environment"
        return 0
    fi
    
    # CircleCI
    if [[ -n "${CIRCLECI:-}" ]]; then
        CI_ENVIRONMENT="circleci"
        CI_BUILD_ID="${CIRCLE_BUILD_NUM:-}"
        CI_COMMIT_SHA="${CIRCLE_SHA1:-}"
        CI_BRANCH="${CIRCLE_BRANCH:-}"
        CI_PR_NUMBER="${CIRCLE_PR_NUMBER:-}"
        CI_DETECTED=true
        log_info "Detected CircleCI environment"
        return 0
    fi
    
    # Travis CI
    if [[ -n "${TRAVIS:-}" ]]; then
        CI_ENVIRONMENT="travis-ci"
        CI_BUILD_ID="${TRAVIS_BUILD_ID:-}"
        CI_COMMIT_SHA="${TRAVIS_COMMIT:-}"
        CI_BRANCH="${TRAVIS_BRANCH:-}"
        CI_PR_NUMBER="${TRAVIS_PULL_REQUEST:-}"
        CI_DETECTED=true
        log_info "Detected Travis CI environment"
        return 0
    fi
    
    log_info "No CI environment detected"
    return 1
}

# Initialize CI integration
# Returns:
#   0: success
#   1: failure
ci_init() {
    log_info "Initializing CI integration v$CI_MODULE_VERSION"
    
    ci_detect_environment
    
    if [[ "$CI_DETECTED" == "true" ]]; then
        log_info "CI Environment: $CI_ENVIRONMENT"
        log_debug "Build ID: $CI_BUILD_ID"
        log_debug "Commit SHA: $CI_COMMIT_SHA"
        log_debug "Branch: $CI_BRANCH"
        [[ -n "$CI_PR_NUMBER" ]] && log_debug "PR Number: $CI_PR_NUMBER"
    fi
    
    return 0
}

# Check if running in CI environment
# Returns:
#   0: running in CI
#   1: not running in CI
ci_is_running() {
    [[ "$CI_DETECTED" == "true" ]]
}

# Get CI environment info
# Returns:
#   0: success (prints JSON)
ci_get_info() {
    local info
    info=$(cat << EOF
{
    "environment": "$CI_ENVIRONMENT",
    "build_id": "$CI_BUILD_ID",
    "commit_sha": "$CI_COMMIT_SHA",
    "branch": "$CI_BRANCH",
    "pr_number": "$CI_PR_NUMBER",
    "detected": $CI_DETECTED
}
EOF
)
    echo "$info"
}

# Run tests in CI environment
# Args:
#   $1: test_command (optional, default: "make test")
#   $2: test_type (optional: unit, integration, e2e)
# Returns:
#   0: tests passed
#   1: tests failed
ci_run_tests() {
    local test_command="${1:-make test}"
    local test_type="${2:-unit}"
    
    log_info "Running $test_type tests in CI"
    log_debug "Test command: $test_command"
    
    local start_time
    start_time=$(date +%s)
    
    # Create test output directory
    local test_output_dir="test-results"
    mkdir -p "$test_output_dir"
    
    # Run tests with output capture
    local test_exit_code=0
    if ! eval "$test_command" > "$test_output_dir/${test_type}-test-output.log" 2>&1; then
        test_exit_code=1
        log_error "$test_type tests failed"
    else
        log_info "$test_type tests passed"
    fi
    
    local end_time
    end_time=$(date +%s)
    local duration=$((end_time - start_time))
    
    log_info "Test duration: ${duration}s"
    
    # Generate test report
    ci_generate_test_report "$test_type" "$test_exit_code" "$duration"
    
    return "$test_exit_code"
}

# Generate test report
# Args:
#   $1: test_type
#   $2: exit_code
#   $3: duration
# Returns:
#   0: success
ci_generate_test_report() {
    local test_type="$1"
    local exit_code="$2"
    local duration="$3"
    
    local report_file="test-results/${test_type}-report.json"
    
    local status
    if [[ "$exit_code" -eq 0 ]]; then
        status="passed"
    else
        status="failed"
    fi
    
    local report
    report=$(cat << EOF
{
    "test_type": "$test_type",
    "status": "$status",
    "exit_code": $exit_code,
    "duration": $duration,
    "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
    "ci_info": $(ci_get_info)
}
EOF
)
    
    echo "$report" > "$report_file"
    log_debug "Test report generated: $report_file"
}

# Build application in CI environment
# Args:
#   $1: build_command (optional, default: "make build")
#   $2: build_type (optional: debug, release)
# Returns:
#   0: build successful
#   1: build failed
ci_build() {
    local build_command="${1:-make build}"
    local build_type="${2:-release}"
    
    log_info "Building application in CI ($build_type)"
    log_debug "Build command: $build_command"
    
    local start_time
    start_time=$(date +%s)
    
    # Create build output directory
    local build_output_dir="build-results"
    mkdir -p "$build_output_dir"
    
    # Run build with output capture
    local build_exit_code=0
    if ! eval "$build_command" > "$build_output_dir/build-output.log" 2>&1; then
        build_exit_code=1
        log_error "Build failed"
    else
        log_info "Build successful"
    fi
    
    local end_time
    end_time=$(date +%s)
    local duration=$((end_time - start_time))
    
    log_info "Build duration: ${duration}s"
    
    # Generate build report
    ci_generate_build_report "$build_type" "$build_exit_code" "$duration"
    
    return "$build_exit_code"
}

# Generate build report
# Args:
#   $1: build_type
#   $2: exit_code
#   $3: duration
# Returns:
#   0: success
ci_generate_build_report() {
    local build_type="$1"
    local exit_code="$2"
    local duration="$3"
    
    local report_file="build-results/build-report.json"
    
    local status
    if [[ "$exit_code" -eq 0 ]]; then
        status="success"
    else
        status="failed"
    fi
    
    local report
    report=$(cat << EOF
{
    "build_type": "$build_type",
    "status": "$status",
    "exit_code": $exit_code,
    "duration": $duration,
    "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
    "ci_info": $(ci_get_info)
}
EOF
)
    
    echo "$report" > "$report_file"
    log_debug "Build report generated: $report_file"
}

# Deploy application in CI environment
# Args:
#   $1: deploy_command (optional, default: "make deploy")
#   $2: environment (optional: staging, production)
# Returns:
#   0: deployment successful
#   1: deployment failed
ci_deploy() {
    local deploy_command="${1:-make deploy}"
    local environment="${2:-staging}"
    
    log_info "Deploying application to $environment"
    log_debug "Deploy command: $deploy_command"
    
    local start_time
    start_time=$(date +%s)
    
    # Create deployment output directory
    local deploy_output_dir="deploy-results"
    mkdir -p "$deploy_output_dir"
    
    # Run deployment with output capture
    local deploy_exit_code=0
    if ! eval "$deploy_command" > "$deploy_output_dir/deploy-output.log" 2>&1; then
        deploy_exit_code=1
        log_error "Deployment failed"
    else
        log_info "Deployment successful"
    fi
    
    local end_time
    end_time=$(date +%s)
    local duration=$((end_time - start_time))
    
    log_info "Deployment duration: ${duration}s"
    
    # Generate deployment report
    ci_generate_deploy_report "$environment" "$deploy_exit_code" "$duration"
    
    return "$deploy_exit_code"
}

# Generate deployment report
# Args:
#   $1: environment
#   $2: exit_code
#   $3: duration
# Returns:
#   0: success
ci_generate_deploy_report() {
    local environment="$1"
    local exit_code="$2"
    local duration="$3"
    
    local report_file="deploy-results/deploy-report.json"
    
    local status
    if [[ "$exit_code" -eq 0 ]]; then
        status="success"
    else
        status="failed"
    fi
    
    local report
    report=$(cat << EOF
{
    "environment": "$environment",
    "status": "$status",
    "exit_code": $exit_code,
    "duration": $duration,
    "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
    "ci_info": $(ci_get_info)
}
EOF
)
    
    echo "$report" > "$deploy_output_dir/deploy-report.json"
    log_debug "Deployment report generated: $report_file"
}

# Set CI output variable
# Args:
#   $1: name
#   $2: value
# Returns:
#   0: success
ci_set_output() {
    local name="$1"
    local value="$2"
    
    if [[ -z "$name" ]]; then
        log_error "Output name is required"
        return 1
    fi
    
    case "$CI_ENVIRONMENT" in
        "github-actions")
            echo "$name=$value" >> "$GITHUB_OUTPUT"
            ;;
        "gitlab-ci")
            echo "$name=$value" >> "$CI_OUTPUT"
            ;;
        *)
            log_debug "Setting output: $name=$value"
            ;;
    esac
    
    log_debug "CI output set: $name=$value"
}

# Add CI summary
# Args:
#   $1: summary_text
# Returns:
#   0: success
ci_add_summary() {
    local summary_text="$1"
    
    if [[ -z "$summary_text" ]]; then
        log_error "Summary text is required"
        return 1
    fi
    
    case "$CI_ENVIRONMENT" in
        "github-actions")
            echo "$summary_text" >> "$GITHUB_STEP_SUMMARY"
            ;;
        *)
            log_info "CI Summary: $summary_text"
            ;;
    esac
}

# Archive CI artifacts
# Args:
#   $1: artifact_path
#   $2: artifact_name (optional)
# Returns:
#   0: success
#   1: failure
ci_archive_artifacts() {
    local artifact_path="$1"
    local artifact_name="${2:-artifacts}"
    
    if [[ -z "$artifact_path" ]]; then
        log_error "Artifact path is required"
        return 1
    fi
    
    if [[ ! -e "$artifact_path" ]]; then
        log_error "Artifact path does not exist: $artifact_path"
        return 1
    fi
    
    log_info "Archiving artifacts: $artifact_path"
    
    # Create archive directory
    local archive_dir="ci-artifacts"
    mkdir -p "$archive_dir"
    
    # Copy artifacts
    if [[ -d "$artifact_path" ]]; then
        cp -r "$artifact_path" "$archive_dir/$artifact_name"
    else
        cp "$artifact_path" "$archive_dir/$artifact_name"
    fi
    
    log_info "Artifacts archived to: $archive_dir/$artifact_name"
    
    return 0
}

log_debug "CI integration module loaded (v$CI_MODULE_VERSION)"
