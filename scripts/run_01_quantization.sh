#!/bin/bash
# ==========================================
# 实验 01: FP16 vs INT4 量化对比
# ==========================================

echo "=== 清理旧进程 ==="
pkill -9 -f vllm
sleep 3

echo "=== 1. 启动 FP16 模型 ==="
python -m vllm.entrypoints.openai.api_server \
    --model /root/autodl-tmp/models/Qwen2-0.5B-Instruct \
    --max-model-len 1024 \
    --gpu-memory-utilization 0.5 > /root/autodl-tmp/logs/01_fp16.log 2>&1 &

# 等待启动
for i in {1..60}; do
    curl -s http://localhost:8000/v1/models > /dev/null 2>&1 && break
    sleep 2
done
echo "FP16 启动完成，请记录 nvidia-smi 显存占用，并运行 benchmark.py 测试吞吐。"

# ---------------------------------------------------------
# 跑完 FP16 并记录数据后，手动杀掉进程，再取消下面这段的注释跑 INT4
# ---------------------------------------------------------
# echo "=== 2. 启动 INT4 模型 ==="
# pkill -9 -f vllm
# sleep 3
# python -m vllm.entrypoints.openai.api_server \
#     --model /root/autodl-tmp/models/Qwen2-0.5B-Instruct-GPTQ-Int4 \
#     --max-model-len 1024 \
#     --gpu-memory-utilization 0.5 > /root/autodl-tmp/logs/01_int4.log 2>&1 &
# for i in {1..60}; do
#     curl -s http://localhost:8000/v1/models > /dev/null 2>&1 && break
#     sleep 2
# done
# echo "INT4 启动完成，请记录显存，并运行 benchmark.py。"