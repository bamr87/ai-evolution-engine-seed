#!/bin/bash
# scripts/apply-growth-changes.sh
# Applies evolutionary changes from AI response

set -euo pipefail

RESPONSE_FILE="${1:-/tmp/evolution_response.json}"

echo "🌾 Applying evolutionary changes..."

if [ ! -f "$RESPONSE_FILE" ]; then
    echo "❌ Error: Response file not found: $RESPONSE_FILE"
    exit 1
fi

BRANCH_NAME=$(jq -r .new_branch "$RESPONSE_FILE")

echo "🌿 Creating and switching to new branch: $BRANCH_NAME"
git checkout -b "$BRANCH_NAME"

# Apply file changes from AI response
echo "📝 Applying file changes..."
jq -c '.changes[]' "$RESPONSE_FILE" | while read -r change_json; do
  path=$(echo "$change_json" | jq -r '.path')
  action=$(echo "$change_json" | jq -r '.action')
  
  mkdir -p "$(dirname "$path")"
  echo "Processing change for $path (Action: $action)"

  if [ "$action" == "replace_content" ]; then
    content=$(echo "$change_json" | jq -r '.content')
    echo -e "$content" > "$path"
    echo "✓ Content replaced for $path"
  elif [ "$action" == "create" ]; then
    content=$(echo "$change_json" | jq -r '.content')
    echo -e "$content" > "$path"
    echo "✓ File created: $path"
  elif [ "$action" == "update_readme_block" ]; then
    # More robust way to handle multiline content for sed
    new_block_content_escaped_for_sed=$(echo "$change_json" | jq -r '.new_block_content')
    
    # Use awk for safer multiline replacement between markers
    awk -v start="<!-- AI-EVOLUTION-MARKER:START -->" \
        -v end="<!-- AI-EVOLUTION-MARKER:END -->" \
        -v new_content="$new_block_content_escaped_for_sed" '
    BEGIN { p = 1 }
    $0 == start { print; print new_content; p = 0; next }
    $0 == end { p = 1 }
    p { print }
    ' "$path" > "${path}.tmp" && mv "${path}.tmp" "$path"
    echo "✓ README.md block updated for $path"
  else
    echo "⚠️  Unknown action: $action for $path"
  fi
done

# Commit growth
echo "💾 Committing changes..."
git add -A

COMMIT_MSG=$(jq -r .commit_message "$RESPONSE_FILE")
if git commit -m "$COMMIT_MSG"; then
    echo "✅ Changes committed successfully"
    git push origin "$BRANCH_NAME"
    echo "🚀 Changes pushed to branch: $BRANCH_NAME"
else
    echo "⚠️  No changes to commit, or commit failed"
fi
