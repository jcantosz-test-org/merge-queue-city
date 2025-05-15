#!/bin/bash
# Script to add PRs to the merge queue

# Configuration
REPO="jcantosz-test-org/merge-queue-city"
BASE_BRANCH="main"  # Target branch
# You can specify PR numbers or use labels to find PRs
PR_NUMBERS=""       # Comma-separated PR numbers, e.g., "123,124,125"
PR_LABEL=""         # Optional: Label to filter PRs

# Get PR numbers if not explicitly provided
if [ -z "$PR_NUMBERS" ]; then
  if [ -n "$PR_LABEL" ]; then
    echo "Finding PRs with label: $PR_LABEL"
    PR_LIST=$(gh pr list --repo $REPO --base $BASE_BRANCH --label $PR_LABEL --json number --jq '.[].number')
  else
    echo "Finding open PRs"
    PR_LIST=$(gh pr list --repo $REPO --base $BASE_BRANCH --json number --jq '.[].number')
  fi
else
  # Convert comma-separated string to array
  PR_LIST=$(echo $PR_NUMBERS | tr ',' ' ')
fi

# Add each PR to merge queue
for PR_NUM in $PR_LIST; do
  echo "Adding PR #$PR_NUM to merge queue..."
  
  # Check if PR is mergeable
  # MERGEABLE=$(gh pr view $PR_NUM --repo $REPO --json mergeable --jq '.mergeable')
  
  # if [ "$MERGEABLE" != "true" ]; then
  #   echo "⚠️ Warning: PR #$PR_NUM is not mergeable, skipping."
  #   continue
  # fi
  
  # Add to merge queue using gh pr merge with merge-queue option
  gh pr merge $PR_NUM --repo $REPO --merge #-queue --admin
  
  echo "✅ Added PR #$PR_NUM to merge queue"
done

echo "All specified PRs have been processed."