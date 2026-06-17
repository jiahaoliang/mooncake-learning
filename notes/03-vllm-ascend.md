# vLLM Ascend 笔记

## 当前阅读目标

对照 upstream vLLM 的 Mooncake connector，明确 Ascend 版本为什么需要自己的
`MooncakeConnectorV1`、`MooncakeLayerwiseConnector` 和 `AscendStoreConnector`。

## 要回答的问题

- vLLM Ascend 如何适配 vLLM 的 KV transfer 行为？
- `MooncakeConnector` 和 `MooncakeLayerwiseConnector` 有什么区别？
- `AscendStoreConnector` 在哪里实现？
- 需要哪些环境变量和 transport 配置？
- `kv_load_failure_policy` 在 Ascend 场景下如何生效？

## 必读文件

```text
repos/vllm-ascend/vllm_ascend/distributed/kv_transfer/__init__.py
repos/vllm-ascend/vllm_ascend/distributed/kv_transfer/kv_p2p/mooncake_connector.py
repos/vllm-ascend/vllm_ascend/distributed/kv_transfer/kv_p2p/mooncake_layerwise_connector.py
repos/vllm-ascend/vllm_ascend/distributed/kv_transfer/kv_pool/ascend_store/ascend_store_connector.py
repos/vllm-ascend/vllm_ascend/distributed/kv_transfer/kv_pool/ascend_store/backend/mooncake_backend.py
```

## 配套文档

```text
repos/vllm-ascend/docs/source/developer_guide/Design_Documents/disaggregated_prefill.md
repos/vllm-ascend/docs/source/user_guide/feature_guide/kv_pool.md
repos/vllm-ascend/docs/source/tutorials/features/pd_disaggregation_mooncake_single_node.md
repos/vllm-ascend/docs/source/tutorials/features/pd_disaggregation_mooncake_multi_node.md
```

## 对照维度

| 问题 | 记录位置 |
| --- | --- |
| `MooncakeConnectorV1` 和 upstream `MooncakeConnector` 差异 | 本文件 |
| `MooncakeLayerwiseConnector` 为什么需要 layerwise transfer | 本文件 |
| `AscendStoreConnector` 如何通过 Mooncake backend 做 KV pool | 本文件 |
| Ascend transport / memory registration 特殊点 | `notes/04-integration-map.md` |

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
