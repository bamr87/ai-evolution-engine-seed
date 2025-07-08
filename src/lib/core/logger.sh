#!/bin/bash
#
# @file src/lib/core/logger.sh
# @description Core logging library for AI Evolution Engine - Provides consistent logging across all scripts
# @author IT-Journey Team <team@it-journey.org>
# @created 2025-07-05
# @lastModified 2025-07-08
# @version 0.3.7-seed
#
# @relatedIssues 
#   - Workflow failure: "unbound variable" error from logger.sh line 79
#   - Bash strict mode compatibility issues
#
# @relatedEvolutions
#   - v0.3.7: Fixed unbound variable errors in strict mode (set -u)
#   - v0.3.6: Enhanced defensive initialization and error handling
#
# @dependencies
#   - bash: >=3.2
#   - date: POSIX compliant
#
# @changelog
#   - 2025-07-08: Fixed unbound variable errors for strict mode compatibility - ITJ
#   - 2025-07-08: Added defensive initialization for DEBUG, INFO, WARN, ERROR, SUCCESS variables - ITJ
#   - 2025-07-08: Fixed BASH_SOURCE array access with fallback values - ITJ
#   - 2025-07-05: Enhanced modular architecture and logging capabilities - ITJ
#
# @usage source src/lib/core/logger.sh && log_info "message"
# @notes Compatible with bash strict mode (set -euo pipefail) and all shell environments
#

# Save and temporarily disable nounset for initialization
if [[ $- =~ u ]]; then
    LOGGER_NOUNSET_WAS_SET=true
    set +u
else
    LOGGER_NOUNSET_WAS_SET=false
fi

# Color codes for output (only set if not already defined)
if [[ -z "${RED:-}" ]]; then
    RED='\033[0;31m'
    GREEN='\033[0;32m'
    YELLOW='\033[1;33m'
    BLUE='\033[0;34m'
    PURPLE='\033[0;35m'
    CYAN='\033[0;36m'
    NC='\033[0m' # No Color
fi

# Log levels (only set if not already defined)
if [[ -z "${LOG_LEVELS:-}" ]]; then
    LOG_LEVELS=("DEBUG" "INFO" "WARN" "ERROR" "SUCCESS")
    LOG_LEVEL_DEBUG=0
    LOG_LEVEL_INFO=1
    LOG_LEVEL_WARN=2
    LOG_LEVEL_ERROR=3
    LOG_LEVEL_SUCCESS=4
fi

# Defensive initialization of log level variables to prevent unbound variable errors
LOG_LEVEL_DEBUG=${LOG_LEVEL_DEBUG:-0}
LOG_LEVEL_INFO=${LOG_LEVEL_INFO:-1}
LOG_LEVEL_WARN=${LOG_LEVEL_WARN:-2}
LOG_LEVEL_ERROR=${LOG_LEVEL_ERROR:-3}
LOG_LEVEL_SUCCESS=${LOG_LEVEL_SUCCESS:-4}

# Additional defensive initialization for potential array element references
# These prevent "unbound variable" errors when LOG_LEVELS array elements are referenced
DEBUG=${DEBUG:-}
INFO=${INFO:-}
WARN=${WARN:-}
ERROR=${ERROR:-}
SUCCESS=${SUCCESS:-}

# Configuration - defensive initialization for bash 3.2
CURRENT_LOG_LEVEL=${LOG_LEVEL:-${LOG_LEVEL_INFO:-1}}
LOG_FILE=${LOG_FILE:-""}
QUIET_MODE=${QUIET_MODE:-false}
CI_ENVIRONMENT=${CI_ENVIRONMENT:-false}

# Initialize logging system
init_logger() {
    local log_dir="${1:-logs}"
    local log_name="${2:-evolution}"
    
    # Create log directory if it doesn't exist
    if [[ -n "$log_dir" ]] && [[ ! -d "$log_dir" ]]; then
        mkdir -p "$log_dir"
    fi
    
    # Set log file if directory provided
    if [[ -n "$log_dir" ]]; then
        LOG_FILE="$log_dir/${log_name}-$(date +%Y%m%d-%H%M%S).log"
        touch "$LOG_FILE"
    fi
    
    # Disable colors in CI environment
    if [[ "$CI_ENVIRONMENT" == "true" ]]; then
        readonly RED=''
        readonly GREEN=''
        readonly YELLOW=''
        readonly BLUE=''
        readonly PURPLE=''
        readonly CYAN=''
        readonly NC=''
    fi
}

# Core logging function
_log() {
    local level="${1:-INFO}"
    local message="${2:-}"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    local caller="${BASH_SOURCE[2]:-${BASH_SOURCE[1]:-unknown}}:${BASH_LINENO[1]:-0}"
    
    # Skip if log level is below threshold
    case "$level" in
        "DEBUG") [[ $CURRENT_LOG_LEVEL -le ${LOG_LEVEL_DEBUG:-0} ]] || return 0 ;;
        "INFO")  [[ $CURRENT_LOG_LEVEL -le ${LOG_LEVEL_INFO:-1} ]] || return 0 ;;
        "WARN")  [[ $CURRENT_LOG_LEVEL -le ${LOG_LEVEL_WARN:-2} ]] || return 0 ;;
        "ERROR") [[ $CURRENT_LOG_LEVEL -le ${LOG_LEVEL_ERROR:-3} ]] || return 0 ;;
        "SUCCESS") [[ $CURRENT_LOG_LEVEL -le ${LOG_LEVEL_SUCCESS:-4} ]] || return 0 ;;
    esac
    
    # Format message
    local color=""
    local prefix=""
    case "$level" in
        "DEBUG")   color="$CYAN";   prefix="🔍" ;;
        "INFO")    color="$BLUE";   prefix="ℹ️" ;;
        "WARN")    color="$YELLOW"; prefix="⚠️" ;;
        "ERROR")   color="$RED";    prefix="❌" ;;
        "SUCCESS") color="$GREEN";  prefix="✅" ;;
    esac
    
    # Log to stdout (unless in quiet mode)
    if [[ "$QUIET_MODE" != "true" ]]; then
        echo -e "${color}${prefix} [${level}]${NC} $message" >&2
    fi
    
    # Log to file if configured
    if [[ -n "$LOG_FILE" ]]; then
        echo "[$timestamp] [$level] [$caller] $message" >> "$LOG_FILE"
    fi
}

# Public logging functions
log_debug() { _log "DEBUG" "$*"; }
log_info() { _log "INFO" "$*"; }
log_warn() { _log "WARN" "$*"; }
log_error() { _log "ERROR" "$*"; }
log_success() { _log "SUCCESS" "$*"; }

# Legacy compatibility functions
log() { log_info "$*"; }
warn() { log_warn "$*"; }
error() { log_error "$*"; }
success() { log_success "$*"; }
info() { log_info "$*"; }

# Helper functions
set_log_level() {
    local level="$1"
    case "$level" in
        "DEBUG") CURRENT_LOG_LEVEL=${LOG_LEVEL_DEBUG:-0} ;;
        "INFO")  CURRENT_LOG_LEVEL=${LOG_LEVEL_INFO:-1} ;;
        "WARN")  CURRENT_LOG_LEVEL=${LOG_LEVEL_WARN:-2} ;;
        "ERROR") CURRENT_LOG_LEVEL=${LOG_LEVEL_ERROR:-3} ;;
        "SUCCESS") CURRENT_LOG_LEVEL=${LOG_LEVEL_SUCCESS:-4} ;;
        *) log_warn "Unknown log level: $level" ;;
    esac
}

enable_quiet_mode() { QUIET_MODE=true; }
disable_quiet_mode() { QUIET_MODE=false; }

get_log_file() { echo "$LOG_FILE"; }

# Restore nounset if it was originally set
if [[ "${LOGGER_NOUNSET_WAS_SET:-false}" == "true" ]]; then
    set -u
fi
