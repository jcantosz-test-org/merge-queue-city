#!/bin/bash
# Script to create multiple test PRs for merge queue testing

# Configuration
REPO="jcantosz-test-org/merge-queue-city"
BASE_BRANCH="main"  # Target branch
NUMBER_OF_PRS=10     # Number of PRs to create

# Create PRs
for i in $(seq 1 $NUMBER_OF_PRS); do
  # Create unique branch
  BRANCH_NAME="test-merge-queue-$i-$(date +%s)"
  
  # Checkout base branch
  gh repo clone $REPO /tmp/$REPO-$i || (cd /tmp/$REPO-$i && git pull)
  cd /tmp/$REPO-$i
  git checkout $BASE_BRANCH
  git pull
  
  # Create branch and make changes
  git checkout -b $BRANCH_NAME
  
  # Create a simple change - modify README or create test file
  echo "# Test change $i - $(date)" >> test-file-$i.md
  
  # Commit and push
  git add .
  git commit -m "Test change $i for merge queue testing"
  git push -u origin $BRANCH_NAME
  
  # Create PR
  gh pr create \
    --title "Test PR $i for Merge Queue" \
    --body "This PR was automatically created to test the merge queue functionality." \
    --base $BASE_BRANCH \
    --head $BRANCH_NAME
  
  echo "Created PR #$i on branch $BRANCH_NAME"
done

# List created PRs
echo "Created PRs:"
gh pr list --repo $REPO --base $BASE_BRANCH --limit $NUMBER_OF_PRS