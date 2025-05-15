#!/bin/bash
# Combined script to test merge queue functionality

# Configuration
REPO="jcantosz-test-org/merge-queue-city"
BASE_BRANCH="main"
NUMBER_OF_PRS=3
WAIT_TIME=30  # Seconds to wait before adding PRs to queue

# Create PRs
echo "📝 Creating $NUMBER_OF_PRS test PRs..."
./create-prs.sh

# Wait before adding to queue
echo "⏳ Waiting $WAIT_TIME seconds for checks to initialize..."
sleep $WAIT_TIME

# Add to queue
echo "🔄 Adding PRs to merge queue..."
./add-to-queue.sh

# Monitor queue
echo "👀 Monitoring merge queue status..."
./monitor-queue.sh