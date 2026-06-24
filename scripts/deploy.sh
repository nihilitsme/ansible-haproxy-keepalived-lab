#!/bin/bash

set -o pipefail

# =====================================
# Deployment Logging Wrapper
# =====================================

TIMESTAMP=$(date +%F-%H%M%S)
DEPLOY_ID="DEPLOY-${TIMESTAMP}"

LOG_DIR="logs"
DEPLOY_DIR="${LOG_DIR}/deployments"
META_DIR="${LOG_DIR}/metadata"
REPORT_DIR="${LOG_DIR}/reports"

mkdir -p "$DEPLOY_DIR"
mkdir -p "$META_DIR"
mkdir -p "$REPORT_DIR"

LOGFILE="${DEPLOY_DIR}/${DEPLOY_ID}.log"
METAFILE="${META_DIR}/${DEPLOY_ID}.txt"
REPORTFILE="${REPORT_DIR}/${DEPLOY_ID}.txt"

START_EPOCH=$(date +%s)

OPERATOR=$(whoami)
HOSTNAME=$(hostname)
PLAYBOOK="$1"

echo "=============================================="
echo "Deployment Started"
echo "=============================================="
echo "Deployment ID : $DEPLOY_ID"
echo "Timestamp     : $(date)"
echo "Operator      : $OPERATOR"
echo "Controller    : $HOSTNAME"
echo "Playbook      : $PLAYBOOK"
echo "=============================================="
echo

# =====================================
# Execute Playbook
# =====================================

ansible-playbook "$@" 2>&1 | tee "$LOGFILE"

RESULT=${PIPESTATUS[0]}

END_EPOCH=$(date +%s)
DURATION=$((END_EPOCH - START_EPOCH))

# =====================================
# Metadata
# =====================================

{
echo "Deployment ID : $DEPLOY_ID"
echo "Timestamp     : $(date)"
echo "Operator      : $OPERATOR"
echo "Controller    : $HOSTNAME"
echo "Playbook      : $PLAYBOOK"
echo "Duration      : ${DURATION}s"
echo "Result Code   : $RESULT"
} > "$METAFILE"

# =====================================
# Summary Report
# =====================================

{
echo "=============================================="
echo "DEPLOYMENT REPORT"
echo "=============================================="
echo
echo "Deployment ID : $DEPLOY_ID"
echo "Timestamp     : $(date)"
echo "Operator      : $OPERATOR"
echo "Controller    : $HOSTNAME"
echo "Playbook      : $PLAYBOOK"
echo "Duration      : ${DURATION}s"

if [ "$RESULT" -eq 0 ]
then
    STATUS="SUCCESS"
else
    STATUS="FAILED"
fi

echo "Status        : $STATUS"
echo
echo "Log File      : $LOGFILE"
echo "Metadata File : $METAFILE"

} > "$REPORTFILE"

echo
echo "=============================================="
echo "Deployment Finished"
echo "=============================================="
echo "Status        : $STATUS"
echo "Duration      : ${DURATION}s"
echo
echo "Log      : $LOGFILE"
echo "Metadata : $METAFILE"
echo "Report   : $REPORTFILE"
echo "=============================================="

exit $RESULT
