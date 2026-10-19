# LLM 推理性能优化实验 (基于 vLLM)

本项目在单张消费级显卡 (RTX 3080, 10GB) 上，针对 Qwen2 系列大模型，深入实践并量化对比了多项核心推理优化技术，旨在解决大模型部署中的显存瓶颈与吞吐瓶颈。

## 核心实验与结论

| 实验模块 | 核心技术 | 关键数据/结论 |
|----------|----------|---------------|
| **[01 量化对比](./experiments/01_quantization.md)** | FP16 vs GPTQ-INT4 | INT4 使权重减小 26%，证明量化是显存受限场景的首选。 |
| **[02 PagedAttention](./experiments/02_paged_attention.md)** | block_size 调整 | 验证 block_size=32 可节省约 3% 显存，理解显存碎片管理。 |
| **[03 Continuous Batching](./experiments/03_continuous_batching.md)** | 动态批处理 | 并发模式下吞吐量提升约 25 倍（3.4 -> 85.7 tokens/s）。 |
| **[04 投机解码](./experiments/04_speculative_decoding.md)** | Speculative Decoding | 实测接受率 24.3%，分析了 Draft 模型大小对加速比的影响。 |
| **[05 KV Cache 量化](./experiments/05_kv_cache_quantization.md)** | FP8 KV Cache | **结合 INT4 权重与 FP8 缓存，成功在 10GB 显卡上跑通 7B 模型的 4096 长上下文，实测峰值显存 8073 MiB，吞吐达 100 tokens/s。** |

## 硬件与软件环境
- **GPU**: NVIDIA RTX 3080 (10GB)
- **推理框架**: vLLM 0.30.0
- **CUDA**: 12.8
- **操作系统**: Ubuntu 22.04 (AutoDL)

## 如何复现
（由于所有实验均基于 vLLM 官方 CLI 参数调优，复现极其简单，详情请见 `experiments/` 目录下的各 Markdown 文档）。