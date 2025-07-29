#!/bin/bash

DISTRO_CONFIG="../distro.yaml"

LOG_FILE="../$(yq '.distro.log.file' "$DISTRO_CONFIG" | tr -d '\"')"
SHOULD_CLEAR_LOG="$(yq '.distro.log.clear_per_stage' "$DISTRO_CONFIG" | tr -d '\"')"
if [[ "$SHOULD_CLEAR_LOG" == "Yes" ]]; then
    rm -f "$LOG_FILE"
fi

run() {
    local command="$@"
    local cmd_tee="tee -a"
    eval "$command" | $cmd_tee "$LOG_FILE"
}

info() {
    run 'echo "Distro Name: $(yq '.distro.name' "$DISTRO_CONFIG")"'
    run 'echo "Version: $(yq '.distro.number' "$DISTRO_CONFIG") - $(yq '.distro.version' "$DISTRO_CONFIG")"'
    run 'echo "Mode: $(yq '.distro.mode' "$DISTRO_CONFIG")"'
    run 'echo ""'
}
