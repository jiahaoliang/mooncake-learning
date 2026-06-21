# vLLM KV Transfer 笔记

## 使用方式

这个文件是长期知识库，不是临时草稿。

- session 中验证过的稳定结论写到这里。
- 临时疑问先留在 `sessions/` 或单独草稿。
- 不确定的猜测不要写成确定结论。

## 当前阅读目标

先建立 vLLM KV connector 的抽象模型，再读 Mooncake 具体实现。不要直接跳到
Mooncake C++ 细节。

## 要回答的问题

- vLLM 在哪里判断一个 request 需要 remote KV？
- prefill 和 decode 阶段分别会调用哪些 connector hook？
- vLLM 如何表示 KV block 和 block ownership？
- producer 和 consumer 两种角色有什么差异？
- cache miss 或 remote KV load failure 时发生什么？

## 必读文件

```text
repos/vllm/vllm/distributed/kv_transfer/README.md
repos/vllm/vllm/config/kv_transfer.py
repos/vllm/vllm/distributed/kv_transfer/kv_connector/v1/base.py
repos/vllm/vllm/distributed/kv_transfer/kv_connector/factory.py
repos/vllm/vllm/distributed/kv_transfer/kv_transfer_state.py
repos/vllm/vllm/distributed/kv_transfer/kv_connector/v1/mooncake/mooncake_connector.py
repos/vllm/vllm/distributed/kv_transfer/kv_connector/v1/mooncake/store/connector.py
repos/vllm/vllm/distributed/kv_transfer/kv_connector/v1/mooncake/store/scheduler.py
repos/vllm/vllm/distributed/kv_transfer/kv_connector/v1/mooncake/store/worker.py
```

## 阅读顺序

1. `kv_transfer.py`
   先理解 `KVTransferConfig`，尤其是 `kv_connector`、`kv_role`、`kv_connector_extra_config`。

2. `factory.py`
   看 connector 名称如何映射到具体实现。

3. `v1/base.py`
   把 scheduler 侧和 worker 侧 hook 列出来。

4. `kv_transfer_state.py`
   找 request 与 remote KV 状态的关系。

5. `mooncake_connector.py`
   追踪 P2P KV transfer：prefill producer 到 decode consumer。

6. `store/connector.py`、`store/scheduler.py`、`store/worker.py`
   追踪 Mooncake Store 共享 KV pool：lookup、get、put、cache hit/miss。

## 需要跟踪的概念

- KV connector
- producer / consumer role
- disaggregated prefill
- prefix cache
- KV block lifecycle
- request waiting states

## Session 001: KVTransferConfig 稳定结论

`KVTransferConfig` 是 vLLM KV transfer 的入口配置。只要设置了
`kv_connector`，就必须同时设置合法的 `kv_role`，否则会在
`KVTransferConfig.__post_init__()` 阶段抛出 `ValueError`。

关键字段：

| 字段 | 作用 | Mooncake 场景重要性 |
| --- | --- | --- |
| `kv_connector` | 选择具体 connector，例如 `MooncakeConnector` 或 `MooncakeStoreConnector`。 | 高 |
| `kv_role` | 描述当前 vLLM 实例在 KV transfer 拓扑里的业务角色。 | 高 |
| `kv_connector_extra_config` | 透传给具体 connector 的扩展配置，通用 config 不解释其语义。 | 高 |
| `kv_connector_module_path` | 从外部 Python module 动态加载 connector，优先于内置 registry。 | 中 |
| `kv_load_failure_policy` | remote KV 加载失败后的策略：`recompute` 或 `fail`。 | 高 |

`kv_both` 同时属于 producer 和 consumer：

```python
KVProducer = Literal["kv_producer", "kv_both"]
KVConsumer = Literal["kv_consumer", "kv_both"]
```

因此同一个实例可以同时满足：

```text
is_kv_producer == True
is_kv_consumer == True
```

`kv_connector_extra_config` 的语义由具体 connector 解释。通用配置层只提供
`get_from_extra_config(key, default)` 读取入口。

`KVConnectorFactory` 根据 `kv_connector` 字符串加载具体 connector class。加载优先级：

```text
kv_connector_module_path -> external module
else connector_name in registry -> built-in registered connector
else unsupported connector
```

`kv_role` 和 `KVConnectorRole` 是两个维度：

| 概念 | 描述维度 | 示例 |
| --- | --- | --- |
| `kv_role` | 当前 vLLM 实例在 KV transfer 拓扑里的业务角色。 | `kv_producer`、`kv_consumer`、`kv_both` |
| `KVConnectorRole` | 当前 connector 对象在 vLLM 内部运行在哪个职责侧。 | `SCHEDULER`、`WORKER` |

例如，一个 `kv_role="kv_consumer"` 的 decode 实例内部，也会同时存在
scheduler-side connector 和 worker-side connector。前者负责调度决策和 metadata，
后者负责实际加载/保存 KV tensor。

## 需要画出的流程

```text
MooncakeConnector:
prefill worker -> Mooncake transfer -> decode worker

MooncakeStoreConnector:
vLLM instance -> Mooncake Store put/get -> prefix cache reuse
```

## 配套测试

```text
repos/vllm/tests/v1/kv_connector/unit/test_mooncake_connector.py
repos/vllm/tests/v1/kv_connector/unit/test_mooncake_store_connector.py
repos/vllm/tests/v1/kv_connector/unit/test_mooncake_store_worker.py
repos/vllm/tests/v1/kv_connector/unit/test_kv_load_failure_recovery.py
```

## 搜索入口

```powershell
.\scripts\search.ps1 kv_transfer
.\scripts\search.ps1 MooncakeConnector
.\scripts\search.ps1 MooncakeStoreConnector
.\scripts\search.ps1 MultiConnector
.\scripts\search.ps1 WAITING_FOR_REMOTE_KVS
```
