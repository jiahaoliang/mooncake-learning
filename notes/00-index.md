# 学习索引

这是 Mooncake、vLLM、vLLM Ascend 学习资料的入口。

## 推荐阅读顺序

1. Mooncake architecture、Transfer Engine、Mooncake Store。
2. vLLM KV transfer connector 的生命周期。
3. vLLM Ascend 的 disaggregated prefill 和 KV pool 集成。
4. 三个项目之间的集成映射和潜在贡献点。

## 本地笔记

- `01-mooncake-architecture.md`
- `02-vllm-kv-transfer.md`
- `03-vllm-ascend.md`
- `04-integration-map.md`
- `glossary.md`

## 源码搜索入口

```powershell
.\scripts\search.ps1 MooncakeConnector
.\scripts\search.ps1 MooncakeStoreConnector
.\scripts\search.ps1 AscendStoreConnector
.\scripts\search.ps1 kv_load_failure_policy
.\scripts\search.ps1 WAITING_FOR_REMOTE_KVS
```
