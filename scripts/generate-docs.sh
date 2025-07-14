#!/bin/bash
#
# @file scripts/generate-docs.sh
# @description Automatic documentation generation from source code
# @author IT-Journey Team <team@it-journey.org>
# @created 2025-01-14
# @lastModified 2025-01-14
# @version 1.0.0
#
# @relatedIssues 
#   - Documentation generation automation for source code
#
# @relatedEvolutions
#   - v1.0.0: Initial implementation of automatic documentation generation
#
# @dependencies
#   - bash: >=4.0
#   - shdoc: Shell script documentation generator
#   - find: File discovery
#   - markdown: For processing existing docs
#
# @changelog
#   - 2025-01-14: Initial creation of documentation generation system - ITJ
#
# @usage ./scripts/generate-docs.sh [--update] [--validate] [--format]
# @notes Generates comprehensive documentation from source code and validates consistency
#

set -euo pipefail

# Configuration
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
readonly DOCS_DIR="$PROJECT_ROOT/docs"
readonly SRC_DIR="$PROJECT_ROOT/src"
readonly GENERATED_DOCS_DIR="$DOCS_DIR/generated"
readonly SHDOC_PATH="$HOME/.local/bin/shdoc"

# Ensure the directory exists
mkdir -p "$(dirname "$SHDOC_PATH")"
# Documentation generation state
readonly TIMESTAMP="$(date '+%Y-%m-%d %H:%M:%S')"
readonly VERSION="1.0.0"

# Colors for output
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[0;33m'
readonly BLUE='\033[0;34m'
readonly NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $*"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $*"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $*"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $*"
}

# Display usage information
show_usage() {
    cat << EOF
Documentation Generation Tool v${VERSION}

USAGE:
    $0 [OPTIONS]

OPTIONS:
    --update        Update existing documentation
    --validate      Validate documentation consistency
    --format        Format and organize generated docs
    --clean         Clean generated documentation
    --help          Show this help message

EXAMPLES:
    $0                      # Generate all documentation
    $0 --update --validate  # Update and validate docs
    $0 --clean              # Clean generated docs

DESCRIPTION:
    Automatically generates comprehensive documentation from source code,
    including function references, module documentation, and API guides.
    
    The tool parses shell script comments, extracts standardized headers,
    and creates organized markdown documentation in the docs/generated/ directory.

EOF
}

# Ensure shdoc is available
ensure_shdoc() {
    if [[ ! -x "$SHDOC_PATH" ]]; then
        log_info "Installing shdoc documentation generator..."
        curl -L https://raw.githubusercontent.com/reconquest/shdoc/master/shdoc -o "$SHDOC_PATH"
        chmod +x "$SHDOC_PATH"
        log_success "shdoc installed successfully"
    fi
}

# Create directory structure for generated docs
setup_docs_structure() {
    log_info "Setting up documentation directory structure..."
    
    mkdir -p "$GENERATED_DOCS_DIR"/{api,modules,scripts,utilities}
    
    # Create README for generated docs
    cat > "$GENERATED_DOCS_DIR/README.md" << EOF
# Generated Documentation

This directory contains automatically generated documentation from source code.

**Generated on**: $TIMESTAMP
**Version**: $VERSION

## Organization

- \`api/\` - API reference documentation
- \`modules/\` - Module documentation from src/lib/
- \`scripts/\` - Script documentation from scripts/
- \`utilities/\` - Utility function documentation

## Maintenance

This documentation is automatically generated from source code comments.
To update, run: \`./scripts/generate-docs.sh --update\`

**Do not edit these files manually** - changes will be overwritten.
EOF
    
    log_success "Documentation structure created"
}

# Extract metadata from file headers
extract_file_metadata() {
    local file="$1"
    local temp_file
    temp_file=$(mktemp /tmp/metadata_raw_XXXXXX)
    
    # Extract just the header section (lines starting with # until first non-comment line)
    awk '/^#!/ { next } /^#/ { print } /^[^#]/ && NF > 0 { exit }' "$file" > "$temp_file"
    
    # Parse extracted header
    local description author version usage notes
    
    description=$(grep "^# @description" "$temp_file" | sed 's/^# @description //' | head -1)
    author=$(grep "^# @author" "$temp_file" | sed 's/^# @author //' | head -1)
    version=$(grep "^# @version" "$temp_file" | sed 's/^# @version //' | head -1)
    usage=$(grep "^# @usage" "$temp_file" | sed 's/^# @usage //' | head -1)
    notes=$(grep "^# @notes" "$temp_file" | sed 's/^# @notes //' | head -1)
    
    # Use defaults if not found
    description="${description:-No description available}"
    author="${author:-Unknown}"
    version="${version:-Unknown}" 
    usage="${usage:-No usage information}"
    notes="${notes:-No additional notes}"
    
    # Clean up any shell-unsafe characters
    description=$(sanitize_metadata_value "$description")
    author=$(sanitize_metadata_value "$author")
    version=$(sanitize_metadata_value "$version")
    usage=$(sanitize_metadata_value "$usage")
    notes=$(sanitize_metadata_value "$notes")
    
    # Return variables in a safer format
    printf 'DOC_DESCRIPTION="%s"\n' "$description"
    printf 'DOC_AUTHOR="%s"\n' "$author"
    printf 'DOC_VERSION="%s"\n' "$version"
    printf 'DOC_USAGE="%s"\n' "$usage"
    printf 'DOC_NOTES="%s"\n' "$notes"
    
    rm -f "$temp_file"
}

# Generate documentation for a single shell script
generate_script_docs() {
    local script_file="$1"
    local relative_path="${script_file#$PROJECT_ROOT/}"
    local output_dir="$GENERATED_DOCS_DIR"
    
    # Determine output directory based on script location
    if [[ "$script_file" == *"/src/lib/"* ]]; then
        output_dir="$GENERATED_DOCS_DIR/modules"
    elif [[ "$script_file" == *"/scripts/"* ]]; then
        output_dir="$GENERATED_DOCS_DIR/scripts"
    else
        output_dir="$GENERATED_DOCS_DIR/utilities"
    fi
    
    local output_file="$output_dir/$(basename "$script_file" .sh).md"
    
    log_info "Generating docs for: $relative_path"
    
    # Extract metadata
    local metadata_vars
    metadata_vars=$(extract_file_metadata "$script_file")
    
    # Source the metadata variables
    eval "$metadata_vars"
    
    # Create documentation header
    cat > "$output_file" << EOF
# $(basename "$script_file")

**Path**: \`$relative_path\`

EOF
    
    # Add metadata section
    echo "## Metadata" >> "$output_file"
    echo "" >> "$output_file"
    
    cat >> "$output_file" << EOF
- **Description**: $DOC_DESCRIPTION
- **Author**: $DOC_AUTHOR
- **Version**: $DOC_VERSION
- **Usage**: \`$DOC_USAGE\`
- **Notes**: $DOC_NOTES

EOF
    
    # Generate function documentation using shdoc
    echo "## Functions" >> "$output_file"
    echo "" >> "$output_file"
    
    if [[ -x "$SHDOC_PATH" ]]; then
        # Try to generate shdoc documentation
        local shdoc_output
        if shdoc_output=$("$SHDOC_PATH" < "$script_file" 2>/dev/null) && [[ -n "$shdoc_output" ]]; then
            echo "$shdoc_output" >> "$output_file"
            echo "" >> "$output_file"
        else
            # Fallback: extract function names and basic info
            echo "### Function List" >> "$output_file"
            echo "" >> "$output_file"
            
            local func_count=0
            local func_list
            if func_list=$(grep -n "^[[:space:]]*[a-zA-Z_][a-zA-Z0-9_]*[[:space:]]*(" "$script_file" 2>/dev/null); then
                while IFS=: read -r line_num func_line; do
                    if [[ -n "$func_line" ]]; then
                        local func_name
                        func_name=$(echo "$func_line" | sed 's/^\s*\([a-zA-Z_][a-zA-Z0-9_]*\).*/\1/')
                        echo "- \`$func_name()\` (line $line_num)" >> "$output_file"
                        ((func_count++))
                    fi
                done <<< "$func_list"
            fi
            
            if [[ $func_count -eq 0 ]]; then
                echo "No functions found in this script." >> "$output_file"
            fi
            echo "" >> "$output_file"
        fi
    else
        echo "Documentation generator not available." >> "$output_file"
        echo "" >> "$output_file"
    fi
    
    # Add source code reference
    echo "" >> "$output_file"
    echo "## Source Code" >> "$output_file"
    echo "" >> "$output_file"
    echo "For complete implementation details, see: [\`$relative_path\`](../../$relative_path)" >> "$output_file"
    echo "" >> "$output_file"
    echo "---" >> "$output_file"
    echo "*Generated on: $TIMESTAMP*" >> "$output_file"
    
    log_success "Generated: $output_file"
}

# Generate API index documentation
generate_api_index() {
    local index_file="$GENERATED_DOCS_DIR/api/index.md"
    
    log_info "Generating API index..."
    
    cat > "$index_file" << EOF
# API Reference

This section contains automatically generated API documentation for all modules and functions.

**Generated on**: $TIMESTAMP

## Module Documentation

EOF
    
    # List all generated module docs
    find "$GENERATED_DOCS_DIR/modules" -name "*.md" -type f | sort | while read -r doc_file; do
        local module_name
        module_name=$(basename "$doc_file" .md)
        local relative_path="../modules/$(basename "$doc_file")"
        echo "- [$module_name]($relative_path)" >> "$index_file"
    done
    
    cat >> "$index_file" << EOF

## Script Documentation

EOF
    
    # List all generated script docs
    find "$GENERATED_DOCS_DIR/scripts" -name "*.md" -type f | sort | while read -r doc_file; do
        local script_name
        script_name=$(basename "$doc_file" .md)
        local relative_path="../scripts/$(basename "$doc_file")"
        echo "- [$script_name]($relative_path)" >> "$index_file"
    done
    
    echo "" >> "$index_file"
    echo "---" >> "$index_file"
    echo "*Generated automatically from source code*" >> "$index_file"
    
    log_success "API index generated: $index_file"
}

# Validate documentation consistency
validate_documentation() {
    log_info "Validating documentation consistency..."
    
    local issues=0
    
    # Check for orphaned documentation (docs without corresponding source)
    find "$GENERATED_DOCS_DIR" -name "*.md" -not -name "README.md" -not -name "index.md" | while read -r doc_file; do
        local basename_file
        basename_file=$(basename "$doc_file" .md)
        
        # Check if corresponding source file exists
        if ! find "$SRC_DIR" "$PROJECT_ROOT/scripts" -name "$basename_file.sh" -type f | grep -q .; then
            log_warning "Orphaned documentation found: $doc_file"
            ((issues++))
        fi
    done
    
    # Check for undocumented source files
    find "$SRC_DIR" "$PROJECT_ROOT/scripts" -name "*.sh" -type f | while read -r src_file; do
        local basename_file
        basename_file=$(basename "$src_file" .sh)
        
        if ! find "$GENERATED_DOCS_DIR" -name "$basename_file.md" -type f | grep -q .; then
            log_warning "Undocumented source file: $src_file"
            ((issues++))
        fi
    done < <(find "$SRC_DIR" "$PROJECT_ROOT/scripts" -name "*.sh" -type f)
    
    if [[ $issues -eq 0 ]]; then
        log_success "Documentation validation passed"
    else
        log_error "Documentation validation found $issues issues"
        return 1
    fi
}

# Clean generated documentation
clean_generated_docs() {
    log_info "Cleaning generated documentation..."
    
    if [[ -d "$GENERATED_DOCS_DIR" ]]; then
        rm -rf "$GENERATED_DOCS_DIR"
        log_success "Generated documentation cleaned"
    else
        log_info "No generated documentation to clean"
    fi
}

# Main documentation generation process
generate_all_documentation() {
    log_info "Starting documentation generation process..."
    
    # Ensure tools are available
    ensure_shdoc
    
    # Set up directory structure
    setup_docs_structure
    
    # Generate documentation for all shell scripts
    local script_count=0
    local temp_list="/tmp/scripts_to_process.txt"
    
    # Create list of files to process
    find "$SRC_DIR" "$PROJECT_ROOT/scripts" -name "*.sh" -type f > "$temp_list"
    
    # Process each file
    while IFS= read -r script_file; do
        if [[ -f "$script_file" && -n "$script_file" ]]; then
            log_info "Processing: $script_file"
            if output=$(generate_script_docs "$script_file" 2>&1); then
                ((script_count++)) || true
                log_success "Completed: $script_file"
            else
                local exit_code=$?
                log_error "Failed to process: $script_file (exit code: $exit_code)"
                log_error "Error details: $output"
                # Continue processing other files even if one fails
            fi
        fi
    done < "$temp_list"
    
    rm -f "$temp_list"
    
    # Generate API index
    generate_api_index
    
    log_success "Documentation generation completed successfully"
    log_info "Generated documentation for $script_count scripts"
    log_info "Documentation available at: $GENERATED_DOCS_DIR"
}

# Parse command line arguments
main() {
    local update_mode=false
    local validate_mode=false
    local format_mode=false
    local clean_mode=false
    
    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            --update)
                update_mode=true
                shift
                ;;
            --validate)
                validate_mode=true
                shift
                ;;
            --format)
                format_mode=true
                shift
                ;;
            --clean)
                clean_mode=true
                shift
                ;;
            --help)
                show_usage
                exit 0
                ;;
            *)
                log_error "Unknown option: $1"
                show_usage
                exit 1
                ;;
        esac
    done
    
    # Execute based on options
    if [[ "$clean_mode" == true ]]; then
        clean_generated_docs
        exit 0
    fi
    
    # Generate documentation
    generate_all_documentation
    
    # Run validation if requested
    if [[ "$validate_mode" == true ]]; then
        validate_documentation
    fi
    
    log_success "Documentation generation process completed"
}

# Run main function with all arguments
main "$@"