# 实验 02：PagedAttention block_size 对性能的影响

## 1. 实验背景
验证 vLLM 中 PagedAttention 的 block_size 参数对显存碎片和吞吐量的影响。

## 2. 实验配置
- 模型：Qwen2-0.5B-Instruct
- 变量：--block-size 16 vs 32

## 3. 实验数据
| block_size | 显存占用 | 吞吐量 |
|------------|----------|--------|
| 16 | 6175 MiB | 3.4 tokens/s |
| 32 | 5999 MiB | 3.4 tokens/s |

## 4. 结论
- block_size 32 比 16 节省约 3% 显存，因为大块减少了管理开销。
- 吞吐量几乎无变化，因为短序列下 KV Cache 占比小。
- vLLM 默认 16 是管理开销与显存碎片的最佳平衡点。