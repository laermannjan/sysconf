#!/bin/sh
# Shared utility functions for chezmoi scripts

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m'

log_section() { printf "\n${BOLD}${BLUE}==> %s${NC}\n" "$1"; }
log_ok()      { printf "  ${GREEN}ok${NC}       %s\n" "$1"; }
log_changed() { printf "  ${YELLOW}changed${NC}  %s\n" "$1"; }
log_skipped() { printf "  ${BLUE}skipped${NC}  %s\n" "$1"; }
log_error()   { printf "  ${RED}error${NC}    %s\n" "$1" >&2; }
