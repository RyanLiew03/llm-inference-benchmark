#!/bin/bash
# ==========================================
# 实验 03: Continuous Batching 串行 vs 并发
# ==========================================

echo "=== 清理旧进程 ==="
pkill -9 -f vllm
sleep 3

echo "=== 启动 vLLM (max-num-seqs = 256) ==="
python -m vllm.entrypoints.openai.api_server \
    --model /root/autodl-tmp/models/Qwen2-0.5B-Instruct \
    --max-num-seqs 256 \
    --max-model-len 1024 \
    --gpu-memory-utilization 0.5 > /root/autodl-tmp/logs/03_cb.log 2>&1 &

for i in {1..60}; do
    curl -s http://localhost:8000/v1/models > /dev/null 2>&1 && break
    sleep 2
done
echo "服务启动完成。"
echo "请使用 benchmark.py 分别测试 concurrency=1 和 concurrency=100，对比吞吐量差异。"