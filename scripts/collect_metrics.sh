#!/bin/bash

# File lưu trữ chỉ số
METRICS_FILE="metrics.csv"

# Khởi tạo file CSV nếu chưa tồn tại
if [ ! -f "$METRICS_FILE" ]; then
    echo "Timestamp,CommitTime,DeployTime,LeadTime,DeploymentStatus,FailureCount,RestoreTime,TestCoverage" > "$METRICS_FILE"
fi

# Lấy thông tin từ GitHub Actions environment variables
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
COMMIT_TIME=$(git log -1 --format=%cd --date=iso) # Thời gian commit cuối cùng
DEPLOY_TIME=$TIMESTAMP # Giả định deploy tại thời điểm hiện tại
COMMIT_HASH=$(git rev-parse HEAD)

# Tính Lead Time (giây)
COMMIT_EPOCH=$(date -d "$COMMIT_TIME" +%s)
DEPLOY_EPOCH=$(date -d "$DEPLOY_TIME" +%s)
LEAD_TIME=$((DEPLOY_EPOCH - COMMIT_EPOCH))

# Trạng thái triển khai (truyền từ pipeline: success/failure)
DEPLOYMENT_STATUS=$1

# Đếm số lần thất bại trước đó
FAILURE_COUNT=$(grep -c "failure" "$METRICS_FILE" || echo "0")

# Tính Restore Time (MTTR) nếu thất bại trước đó
RESTORE_TIME="N/A"
if [ "$DEPLOYMENT_STATUS" = "success" ] && [ "$FAILURE_COUNT" -gt 0 ]; then
    LAST_FAILURE=$(grep "failure" "$METRICS_FILE" | tail -1 | cut -d',' -f1)
    if [ -n "$LAST_FAILURE" ]; then
        LAST_FAILURE_EPOCH=$(date -d "$LAST_FAILURE" +%s)
        RESTORE_TIME=$((DEPLOY_EPOCH - LAST_FAILURE_EPOCH))
    fi
fi

# Lấy Test Coverage (giả định từ file lcov.info nếu có)
TEST_COVERAGE="N/A"
if [ -f "coverage/lcov.info" ]; then
    TEST_COVERAGE=$(grep -o "LF:[0-9]*" coverage/lcov.info | awk -F: '{sum+=$2} END {print sum}' | awk '{print $1/NR"%"}' || echo "N/A")
fi

# Ghi dữ liệu vào CSV
echo "$TIMESTAMP,$COMMIT_TIME,$DEPLOY_TIME,$LEAD_TIME,$DEPLOYMENT_STATUS,$FAILURE_COUNT,$RESTORE_TIME,$TEST_COVERAGE" >> "$METRICS_FILE"

# In kết quả để debug
cat "$METRICS_FILE"