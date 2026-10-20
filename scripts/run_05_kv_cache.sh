#!/bin/bash

# ==========================================
# vLLM 启动脚本
# 用法: bash run_server.sh
# ==========================================

MODEL_PATH="/root/autodl-tmp/models/Qwen2-7B-Instruct-GPTQ-Int4"
LOG_DIR="/root/autodl-tmp/logs"
LOG_FILE="$LOG_DIR/vllm_server.log"

# 1. 确保日志目录存在
mkdir -p $LOG_DIR

# 2. 清理旧进程（防止显存被占）
echo "=== 正在清理旧进程 ==="
pkill -9 -f vllm
sleep 3

# 3. 检查显存
echo "=== 当前显存状态 ==="
nvidia-smi | grep "MiB /"

# 4. 启动 vLLM 服务
echo "=== 启动 vLLM (INT4 权重 + FP8 KV Cache) ==="
python -m vllm.entrypoints.openai.api_server \
    --model $MODEL_PATH \
    --max-model-len 4096 \
    --gpu-memory-utilization 0.85 \
    --kv-cache-dtype fp8 > $LOG_FILE 2>&1 &

# 5. 等待服务就绪
echo "=== 等待服务启动... ==="
for i in {1..60}; do
    if curl -s http://localhost:8000/v1/models > /dev/null 2>&1; then
        echo "✅ 服务已成功启动！日志保存在: $LOG_FILE"
        break
    fi
    sleep 2
done