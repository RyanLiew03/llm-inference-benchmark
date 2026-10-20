#!/bin/bash
# ==========================================
# 实验 02: PagedAttention block_size 对比
# ==========================================

echo "=== 清理旧进程 ==="
pkill -9 -f vllm
sleep 3

echo "=== 1. 启动 block_size = 16 ==="
python -m vllm.entrypoints.openai.api_server \
    --model /root/autodl-tmp/models/Qwen2-0.5B-Instruct \
    --block-size 16 \
    --max-model-len 1024 \
    --gpu-memory-utilization 0.5 > /root/autodl-tmp/logs/02_block16.log 2>&1 &

for i in {1..60}; do
    curl -s http://localhost:8000/v1/models > /dev/null 2>&1 && break
    sleep 2
done
echo "block_size 16 启动完成，请记录显存数据。"

# ---------------------------------------------------------
# 跑完 16 并记录数据后，手动杀掉进程，再取消下面这段的注释跑 32
# ---------------------------------------------------------
# echo "=== 2. 启动 block_size = 32 ==="
# pkill -9 -f vllm
# sleep 3
# python -m vllm.entrypoints.openai.api_server \
#     --model /root/autodl-tmp/models/Qwen2-0.5B-Instruct \
#     --block-size 32 \
#     --max-model-len 1024 \
#     --gpu-memory-utilization 0.5 > /root/autodl-tmp/logs/02_block32.log 2>&1 &
# for i in {1..60}; do
#     curl -s http://localhost:8000/v1/models > /dev/null 2>&1 && break
#     sleep 2
# done
# echo "block_size 32 启动完成，请记录显存数据。"