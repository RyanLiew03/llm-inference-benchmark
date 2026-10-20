#!/bin/bash
# ==========================================
# 实验 04: 投机解码 (Speculative Decoding)
# ==========================================

echo "=== 清理旧进程 ==="
pkill -9 -f vllm
sleep 3

echo "=== 启动投机解码服务 ==="
# 注意：vLLM 0.30 参数名为 --spec-model 和 --spec-tokens
python -m vllm.entrypoints.openai.api_server \
    --model /root/autodl-tmp/models/Qwen2-0.5B-Instruct \
    --spec-model /root/autodl-tmp/models/Qwen2-0.5B-Instruct \
    --spec-tokens 5 \
    --max-model-len 1024 \
    --gpu-memory-utilization 0.6 > /root/autodl-tmp/logs/04_spec.log 2>&1 &

for i in {1..60}; do
    curl -s http://localhost:8000/v1/models > /dev/null 2>&1 && break
    sleep 2
done
echo "投机解码服务启动完成。请压测并查看日志中的 acceptance rate 指标。"