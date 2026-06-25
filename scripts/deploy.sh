#!/bin/bash

set -o pipefail

PLAYBOOK="$1"

if [ -z "$PLAYBOOK" ]; then
    echo "Usage:"
    echo "./scripts/deploy.sh playbooks/site.yml"
    exit 1
fi

TIMESTAMP=$(date +%F-%H%M%S)
DEPLOY_ID="DEPLOY-${TIMESTAMP}"

BASE_DIR="logs"

DEPLOY_DIR="${BASE_DIR}/deployments"
META_DIR="${BASE_DIR}/metadata"
REPORT_DIR="${BASE_DIR}/reports"

mkdir -p "$DEPLOY_DIR"
mkdir -p "$META_DIR"
mkdir -p "$REPORT_DIR"

LOGFILE="${DEPLOY_DIR}/${DEPLOY_ID}.log"
METAFILE="${META_DIR}/${DEPLOY_ID}.meta"
SUMMARYFILE="${REPORT_DIR}/${DEPLOY_ID}.summary"

START_EPOCH=$(date +%s)

OPERATOR=$(whoami)
HOSTNAME=$(hostname)

GIT_BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
GIT_COMMIT=$(git rev-parse HEAD 2>/dev/null)
GIT_MESSAGE=$(git log -1 --pretty=%s 2>/dev/null)

echo
echo "===================================="
echo "Deployment Started"
echo "===================================="
echo "Deployment ID : ${DEPLOY_ID}"
echo "Playbook      : ${PLAYBOOK}"
echo "Operator      : ${OPERATOR}"
echo

ansible-playbook "$PLAYBOOK" -K 2>&1 | tee "$LOGFILE"

RESULT=${PIPESTATUS[0]}

END_EPOCH=$(date +%s)
DURATION=$((END_EPOCH - START_EPOCH))

LOG_SHA256=$(sha256sum "$LOGFILE" | awk '{print $1}')

if [ "$RESULT" -eq 0 ]; then
    STATUS="SUCCESS"
else
    STATUS="FAILED"
fi

cat > "$METAFILE" <<EOF
Deployment ID : ${DEPLOY_ID}
Timestamp     : $(date)
Operator      : ${OPERATOR}
Controller    : ${HOSTNAME}

Playbook      : ${PLAYBOOK}

Git Branch    : ${GIT_BRANCH}
Git Commit    : ${GIT_COMMIT}
Git Message   : ${GIT_MESSAGE}

Duration      : ${DURATION}s
Result Code   : ${RESULT}
Status        : ${STATUS}

Log SHA256    : ${LOG_SHA256}
EOF

cat > "$SUMMARYFILE" <<EOF
====================================
DEPLOYMENT SUMMARY
====================================

Deployment ID : ${DEPLOY_ID}

Timestamp     : $(date)

Operator      : ${OPERATOR}

Controller    : ${HOSTNAME}

Playbook      : ${PLAYBOOK}

Git Branch    : ${GIT_BRANCH}

Git Commit    : ${GIT_COMMIT}

Duration      : ${DURATION}s

Status        : ${STATUS}

SHA256        : ${LOG_SHA256}

====================================

PLAY RECAP

EOF

grep -A 50 "PLAY RECAP" "$LOGFILE" >> "$SUMMARYFILE"

echo
echo "===================================="
echo "Deployment Finished"
echo "===================================="
echo "Status   : ${STATUS}"
echo "Duration : ${DURATION}s"
echo
echo "Log      : ${LOGFILE}"
echo "Metadata : ${METAFILE}"
echo "Summary  : ${SUMMARYFILE}"
echo "===================================="

exit $RESULT
