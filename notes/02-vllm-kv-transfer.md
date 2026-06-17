# vLLM KV Transfer 笔记

## 要回答的问题

- vLLM 在哪里判断一个 request 需要 remote KV？
- prefill 和 decode 阶段分别会调用哪些 connector hook？
- vLLM 如何表示 KV block 和 block ownership？
- producer 和 consumer 两种角色有什么差异？
- cache miss 或 remote KV load failure 时发生什么？

## 需要跟踪的概念

- KV connector
- producer / consumer role
- disaggregated prefill
- prefix cache
- KV block lifecycle
- request waiting states

## 搜索入口

```powershell
.\scripts\search.ps1 kv_transfer
.\scripts\search.ps1 MooncakeConnector
.\scripts\search.ps1 MooncakeStoreConnector
.\scripts\search.ps1 MultiConnector
.\scripts\search.ps1 WAITING_FOR_REMOTE_KVS
```
