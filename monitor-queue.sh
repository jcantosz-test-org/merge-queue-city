#!/bin/bash
# Script to monitor the merge queue status

# Configuration
REPO="jcantosz-test-org/merge-queue-city"
BASE_BRANCH="main"  # Target branch
INTERVAL=30         # Check interval in seconds

echo "Monitoring merge queue for $REPO ($BASE_BRANCH)..."
echo "Press Ctrl+C to stop monitoring."

while true; do
  clear
  echo "==== Merge Queue Status - $(date) ===="
  
  # List PRs in the merge queue
  echo "PRs in merge queue:"
  gh pr list --repo $REPO --base $BASE_BRANCH --json number,title,headRefName,mergeable,mergeStateStatus --jq '.[] | select(.mergeStateStatus == "QUEUED") | "PR #\(.number) - \(.title) (\(.headRefName)) - \(.mergeStateStatus)"'
  
  # Get recent merge group workflow runs (this requires the GitHub API directly)
  echo -e "\nRecent merge group workflow runs:"
  gh api repos/$REPO/actions/runs \
    --jq '.workflow_runs[] | select(.name | contains("merge_group")) | "ID: \(.id) - \(.name) - \(.status) - \(.conclusion) - \(.html_url)"' \
    | head -5

  sleep $INTERVAL
done