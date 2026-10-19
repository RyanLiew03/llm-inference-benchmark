# 实验 03：Continuous Batching 串行与并发对比

## 1. 实验背景
验证 Continuous Batching 在并发请求下对 GPU 利用率的提升。

## 2. 实验配置
- 100 个请求，每个生成 30 tokens。
- 模式 A：串行发送（逐个发）
- 模式 B：并发发送（同时发）

## 3. 实验数据
| 模式 | 吞吐量 |
|------|--------|
| 串行 (serial) | 3.4 tokens/s |
| 并发 (concurrent) | 85.7 tokens/s |

## 4. 结论
并发模式下吞吐量提升了约 25 倍。Continuous Batching 通过动态调度请求，让 GPU 算力被彻底打满，是推理引擎提升吞吐的核心。