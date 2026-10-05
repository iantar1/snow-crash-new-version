#!/bin/bash
# babel — configuration generator service
# Processes m4 templates and regenerates the active configuration.

TEMPLATE_DIR="/var/lib/babel/templates"
OUTPUT_DIR="/var/lib/babel"
OUTPUT_CONF="${OUTPUT_DIR}/output.conf"
BACKUP_CONF="${OUTPUT_DIR}/output.conf.bak"
CHECKSUM_FILE="${OUTPUT_DIR}/output.conf.sha256"
LOCK_FILE="/tmp/babel.lock"
LOG_FILE="/var/log/babel/babel.log"
MAX_LOG_SIZE=$((1 * 1024 * 1024))   # 1 MB

log() {
    echo "$(date '+%Y-%m-%dT%H:%M:%S') [babel] $*" >> "${LOG_FILE}"
}

rotate_log() {
    if [ -f "${LOG_FILE}" ]; then
        local size
        size=$(stat -c%s "${LOG_FILE}" 2>/dev/null || echo 0)
        if [ "${size}" -gt "${MAX_LOG_SIZE}" ]; then
            mv "${LOG_FILE}" "${LOG_FILE}.1"
            log "Log rotated (previous size: ${size} bytes)"
        fi
    fi
}

acquire_lock() {
    local fd=200
    exec 200>"${LOCK_FILE}"
    if ! flock -n ${fd}; then
        log "Another instance is running, aborting"
        exit 0
    fi
}

release_lock() {
    flock -u 200 2>/dev/null || true
    rm -f "${LOCK_FILE}"
}

checksum_verify() {
    local file="$1"
    local saved_sum="$2"
    if [ ! -f "${saved_sum}" ]; then
        return 0
    fi
    local expected actual
    expected=$(cat "${saved_sum}" | awk '{print $1}')
    actual=$(sha256sum "${file}" 2>/dev/null | awk '{print $1}')
    [ "${expected}" = "${actual}" ]
}

checksum_update() {
    local file="$1"
    local out="$2"
    sha256sum "${file}" > "${out}" 2>/dev/null || true
}

# Ensure output directories exist
mkdir -p "${OUTPUT_DIR}"
mkdir -p "$(dirname "${LOG_FILE}")"

rotate_log
acquire_lock
trap release_lock EXIT

log "Starting config generation (pid=$$)"

# Rotate previous output
if [ -f "${OUTPUT_CONF}" ]; then
    if checksum_verify "${OUTPUT_CONF}" "${CHECKSUM_FILE}"; then
        log "Previous output unchanged, rotating"
    else
        log "Previous output modified externally, overwriting"
    fi
    cp "${OUTPUT_CONF}" "${BACKUP_CONF}"
fi

# Locate the template
TEMPLATE="${TEMPLATE_DIR}/template.m4"
if [ ! -f "${TEMPLATE}" ]; then
    log "ERROR: template not found at ${TEMPLATE}"
    exit 1
fi

# Check for supplementary include fragments
FRAGMENT_COUNT=0
for frag in "${TEMPLATE_DIR}"/*.m4.d; do
    [ -f "${frag}" ] || continue
    FRAGMENT_COUNT=$((FRAGMENT_COUNT + 1))
    log "Found fragment: $(basename "${frag}")"
done
[ "${FRAGMENT_COUNT}" -gt 0 ] && log "Loaded ${FRAGMENT_COUNT} fragments"

# Process the m4 template
if m4 "${TEMPLATE}" > "${OUTPUT_CONF}" 2>> "${LOG_FILE}"; then
    log "Template processed successfully"
else
    log "ERROR: m4 processing failed, restoring backup"
    if [ -f "${BACKUP_CONF}" ]; then
        cp "${BACKUP_CONF}" "${OUTPUT_CONF}"
    fi
    exit 1
fi

# Validate output: must contain at least a worker_processes directive
if ! grep -q "^worker_processes" "${OUTPUT_CONF}"; then
    log "ERROR: generated config missing worker_processes, restoring backup"
    if [ -f "${BACKUP_CONF}" ]; then
        cp "${BACKUP_CONF}" "${OUTPUT_CONF}"
    fi
    exit 1
fi

# Enforce minimum line count (guard against empty output)
LINE_COUNT=$(wc -l < "${OUTPUT_CONF}")
if [ "${LINE_COUNT}" -lt 5 ]; then
    log "ERROR: suspiciously short output (${LINE_COUNT} lines), restoring backup"
    if [ -f "${BACKUP_CONF}" ]; then
        cp "${BACKUP_CONF}" "${OUTPUT_CONF}"
    fi
    exit 1
fi

log "Generated ${LINE_COUNT} lines to ${OUTPUT_CONF}"
checksum_update "${OUTPUT_CONF}" "${CHECKSUM_FILE}"

# Optional: syntax-check the output if nginx is available
if command -v nginx >/dev/null 2>&1; then
    nginx -t -c "${OUTPUT_CONF}" >> "${LOG_FILE}" 2>&1 \
        && log "Syntax OK" \
        || log "WARN: syntax check failed (continuing)"
fi

# Signal a running daemon to reload if its PID file is present
BABEL_PID_FILE="/var/lib/babel/babel.pid"
if [ -f "${BABEL_PID_FILE}" ]; then
    BABEL_PID=$(cat "${BABEL_PID_FILE}" 2>/dev/null)
    if [ -n "${BABEL_PID}" ] && kill -0 "${BABEL_PID}" 2>/dev/null; then
        kill -HUP "${BABEL_PID}" 2>/dev/null \
            && log "Sent SIGHUP to babel daemon (pid=${BABEL_PID})" \
            || log "WARN: failed to signal daemon"
    else
        log "Daemon not running (stale PID file?)"
    fi
fi

log "Done"
