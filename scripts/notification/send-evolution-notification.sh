#!/usr/bin/env bash
#
# @file scripts/send-evolution-notification.sh
# @description Sends notifications about evolution cycle results
# @author IT-Journey Team <team@it-journey.org>
# @created 2025-07-12
# @lastModified 2025-07-12
# @version 1.0.0
#
# @relatedIssues 
#   - Missing notification script for evolution workflow
#
# @relatedEvolutions
#   - v1.0.0: Initial creation for evolution notifications
#
# @dependencies
#   - bash: >=4.0
#   - src/lib/core/bootstrap.sh: Library bootstrap
#   - curl: For webhook notifications
#
# @changelog
#   - 2025-07-12: Initial creation for evolution notifications - ITJ
#
# @usage ./send-evolution-notification.sh [--status STATUS] [--message MESSAGE]
# @notes Sends notifications via webhook or GitHub API
#

set -euo pipefail

# Get script directory and project root
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

# Bootstrap the modular system
source "$PROJECT_ROOT/src/lib/core/bootstrap.sh"
bootstrap_library

# Load required modules
require_module "core/logger"
require_module "core/validation"

# Initialize logging
init_logger "logs" "send-evolution-notification"

# Parse command line arguments
STATUS=""
MESSAGE=""
WEBHOOK_URL=""
NOTIFY_TYPE=""

while [[ $# -gt 0 ]]; do
    case $1 in
        --status)
            STATUS="$2"
            shift 2
            ;;
        --message)
            MESSAGE="$2"
            shift 2
            ;;
        --webhook-url)
            WEBHOOK_URL="$2"
            shift 2
            ;;
        --type)
            NOTIFY_TYPE="$2"
            shift 2
            ;;
        *)
            shift
            ;;
    esac
done

# Set defaults
STATUS="${STATUS:-success}"
MESSAGE="${MESSAGE:-Evolution cycle completed}"
NOTIFY_TYPE="${NOTIFY_TYPE:-github}"

log_info "Sending evolution notification..."
log_info "Status: $STATUS"
log_info "Type: $NOTIFY_TYPE"

# Prepare notification payload
TIMESTAMP=$(date -Iseconds)
EVOLUTION_VERSION="${EVOLUTION_VERSION:-unknown}"

case "$NOTIFY_TYPE" in
    "slack")
        if [[ -n "$WEBHOOK_URL" ]]; then
            PAYLOAD=$(jq -n \
                --arg text "$MESSAGE" \
                --arg status "$STATUS" \
                --arg version "$EVOLUTION_VERSION" \
                --arg timestamp "$TIMESTAMP" \
                '{
                    "text": "🌱 AI Evolution Engine Notification",
                    "attachments": [{
                        "color": (if $status == "success" then "good" elif $status == "warning" then "warning" else "danger" end),
                        "fields": [
                            {"title": "Status", "value": $status, "short": true},
                            {"title": "Version", "value": $version, "short": true},
                            {"title": "Message", "value": $text, "short": false},
                            {"title": "Timestamp", "value": $timestamp, "short": true}
                        ]
                    }]
                }')
            
            if curl -X POST -H 'Content-type: application/json' \
                --data "$PAYLOAD" \
                "$WEBHOOK_URL"; then
                log_success "Slack notification sent successfully"
            else
                log_error "Failed to send Slack notification"
                exit 1
            fi
        else
            log_warn "Slack webhook URL not provided, skipping Slack notification"
        fi
        ;;
        
    "github")
        # Create GitHub issue comment or discussion
        if [[ -n "${GITHUB_TOKEN:-}" ]] && [[ -n "${GITHUB_REPOSITORY:-}" ]]; then
            ISSUE_BODY="## 🌱 Evolution Cycle Notification

**Status:** $STATUS  
**Version:** $EVOLUTION_VERSION  
**Timestamp:** $TIMESTAMP  

**Message:** $MESSAGE

---
*Automated notification from AI Evolution Engine*"

            # Try to find an open evolution issue
            if command -v gh >/dev/null 2>&1; then
                EVOLUTION_ISSUE=$(gh issue list --label "evolution" --state open --limit 1 --json number --jq '.[0].number' 2>/dev/null || echo "")
                
                if [[ -n "$EVOLUTION_ISSUE" ]]; then
                    if gh issue comment "$EVOLUTION_ISSUE" --body "$ISSUE_BODY"; then
                        log_success "GitHub issue comment posted to issue #$EVOLUTION_ISSUE"
                    else
                        log_error "Failed to post GitHub issue comment"
                        exit 1
                    fi
                else
                    log_info "No open evolution issues found, notification logged only"
                fi
            else
                log_warn "GitHub CLI not available, skipping GitHub notification"
            fi
        else
            log_warn "GitHub token or repository not available, skipping GitHub notification"
        fi
        ;;
        
    "file")
        # Write notification to file
        NOTIFICATION_FILE="${PROJECT_ROOT}/logs/evolution-notifications.log"
        mkdir -p "$(dirname "$NOTIFICATION_FILE")"
        
        echo "[$TIMESTAMP] STATUS=$STATUS VERSION=$EVOLUTION_VERSION MESSAGE=$MESSAGE" >> "$NOTIFICATION_FILE"
        log_success "Notification written to file: $NOTIFICATION_FILE"
        ;;
        
    *)
        log_error "Unknown notification type: $NOTIFY_TYPE"
        log_info "Supported types: slack, github, file"
        exit 1
        ;;
esac

log_success "Evolution notification sent successfully"
exit 0
