# 实验 05：FP8 KV Cache 量化与长上下文部署

## 1. 背景
Qwen2-7B-INT4 模型在 RTX 3080 (10GB) 上，默认配置下无法支持 4096 上下文（发生 OOM）。

## 2. 实验配置
- 模型：Qwen2-7B-Instruct-GPTQ-Int4
- 硬件：RTX 3080 (10GB)
- 上下文长度：4096
- vLLM 参数：`--kv-cache-dtype fp8`，`--gpu-memory-utilization 0.85`

## 3. 实验结果
- **显存占用**：8073 MiB（成功运行）
- **生成吞吐**：100.0 tokens/s（10 并发压测）
- **KV Cache 命中率**：51.4%

## 4. 结论
通过引入 FP8 KV Cache 量化，成功将长上下文推理的显存瓶颈压缩，在不增加硬件成本的前提下，实现了 7B 模型在消费级显卡上的 4096 上下文部署。