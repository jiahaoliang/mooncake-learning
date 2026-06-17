# vLLM Ascend 笔记

## 要回答的问题

- vLLM Ascend 如何适配 vLLM 的 KV transfer 行为？
- `MooncakeConnector` 和 `MooncakeLayerwiseConnector` 有什么区别？
- `AscendStoreConnector` 在哪里实现？
- 需要哪些环境变量和 transport 配置？
- `kv_load_failure_policy` 在 Ascend 场景下如何生效？

## 需要跟踪的概念

- Ascend transport
- Ascend Direct
- CANN and HCCN requirements
- layerwise KV transfer
- KV pool
- recompute on load failure

## 搜索入口

```powershell
.\scripts\search.ps1 MooncakeLayerwiseConnector
.\scripts\search.ps1 AscendStoreConnector
.\scripts\search.ps1 ascend_direct
.\scripts\search.ps1 kv_load_failure_policy
```
