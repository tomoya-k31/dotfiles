#!/usr/bin/env bash

# UI Helper Functions for better visual output
# Usage: source this file in your scripts

# Color definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
GRAY='\033[0;90m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Check if terminal supports colors
if [ -t 1 ] && [ "$(tput colors 2>/dev/null)" -ge 8 ]; then
    USE_COLORS=true
else
    USE_COLORS=false
fi

# Function to print colored text if terminal supports it
print_color() {
    local color="$1"
    local text="$2"
    if [ "$USE_COLORS" = true ]; then
        echo -e "${color}${text}${NC}"
    else
        echo "$text"
    fi
}

# Phase headers
print_phase() {
    local phase="$1"
    local title="$2"
    print_color "$BOLD$BLUE" "\n🔄 Phase $phase: $title"
    print_color "$GRAY" "$(printf '%.0s─' {1..50})"
}

# Step headers
print_step() {
    local step="$1"
    local title="$2"
    print_color "$BOLD$CYAN" "\n📋 Step $step: $title"
}

# Success messages
print_success() {
    local message="$1"
    print_color "$GREEN" "✅ $message"
}

# Warning messages
print_warning() {
    local message="$1"
    print_color "$YELLOW" "⚠️  $message"
}

# Error messages
print_error() {
    local message="$1"
    print_color "$RED" "❌ $message"
}

# Info messages
print_info() {
    local message="$1"
    print_color "$CYAN" "ℹ️  $message"
}

# Progress messages
print_progress() {
    local message="$1"
    print_color "$PURPLE" "⏳ $message"
}

# File operation messages
print_file_created() {
    local file="$1"
    print_color "$GREEN" "📁 Created: $file"
}

print_file_updated() {
    local file="$1"
    print_color "$YELLOW" "📝 Updated: $file"
}

print_file_processed() {
    local file="$1"
    print_color "$CYAN" "⚙️  Processing: $file"
}

# Git operation messages
print_git_fetch() {
    print_color "$BLUE" "🌐 Fetching from remote..."
}

print_git_pull() {
    print_color "$BLUE" "⬇️  Pulling remote updates..."
}

print_git_push() {
    print_color "$GREEN" "⬆️  Pushing local updates..."
}

print_git_commit() {
    print_color "$GREEN" "💾 Committing changes..."
}

print_git_stash() {
    print_color "$YELLOW" "📦 Stashing local changes..."
}

print_git_unstash() {
    print_color "$YELLOW" "📤 Restoring stashed changes..."
}

# Conflict messages
print_conflict() {
    local file="$1"
    print_color "$RED" "⚔️  Conflict detected: $file"
}

print_no_conflicts() {
    local file="$1"
    print_color "$GREEN" "✅ No conflicts: $file"
}

# Completion messages
print_completion() {
    local operation="$1"
    print_color "$BOLD$GREEN" "\n🎉 $operation completed successfully!"
    print_color "$GRAY" "$(printf '%.0s═' {1..50})"
}

# Section separators
print_separator() {
    print_color "$GRAY" "$(printf '%.0s─' {1..30})"
}

print_header() {
    local title="$1"
    print_color "$BOLD$WHITE" "\n╭$(printf '%.0s─' {1..48})╮"
    print_color "$BOLD$WHITE" "│ $title$(printf '%*s' $((46 - ${#title})) '') │"
    print_color "$BOLD$WHITE" "╰$(printf '%.0s─' {1..48})╯"
}