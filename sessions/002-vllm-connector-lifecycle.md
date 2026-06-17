# Session 002: vLLM Connector 生命周期

## 本次目标

理解 vLLM KV connector 为什么分 scheduler 侧和 worker 侧，以及两侧 hook 如何配合完成 remote KV 加载/保存。

## 先读结论

vLLM V1 connector 是双角色设计：

- scheduler 侧负责判断“哪些 request 需要外部 KV、需要多少 token、如何构造 metadata”。
- worker 侧负责在模型执行期间“按 metadata 加载或保存 KV tensor”。

两侧通过 metadata 连接：

```text
Scheduler connector -> KVConnectorMetadata -> Worker connector
Worker connector -> KVConnectorWorkerMetadata / KVConnectorOutput -> Scheduler connector
```

这能把调度决策和实际 tensor copy 分开。scheduler 不直接碰 KV tensor，worker 不直接做全局调度。

## 最小源码范围

```text
repos/vllm/vllm/distributed/kv_transfer/kv_connector/v1/base.py
repos/vllm/vllm/distributed/kv_transfer/kv_transfer_state.py
```

重点对象：

```text
KVConnectorRole
KVConnectorMetadata
KVConnectorWorkerMetadata
KVConnectorBase_V1.start_load_kv
KVConnectorBase_V1.wait_for_layer_load
KVConnectorBase_V1.save_kv_layer
KVConnectorBase_V1.wait_for_save
KVConnectorBase_V1.get_num_new_matched_tokens
KVConnectorBase_V1.update_state_after_alloc
KVConnectorBase_V1.build_connector_meta
KVConnectorBase_V1.request_finished
ensure_kv_transfer_initialized
```

## 导读

先看 `KVConnectorRole`：

```text
SCHEDULER
WORKER
```

这说明同一个 connector 类通常会被创建两次，一次放在 scheduler 进程，一次放在 worker 进程。factory 注释里明确说明：

- scheduler connector 只能在 Scheduler 内使用。
- worker connector 只能在 forward context 和 attention layer 内使用。

worker 侧关键 hook：

```text
start_load_kv -> wait_for_layer_load
save_kv_layer -> wait_for_save
get_finished
get_block_ids_with_load_errors
```

含义：

- `start_load_kv` 在 forward 前启动加载，可能异步。
- `wait_for_layer_load` 在 attention layer 内等待某一层 KV 准备好。
- `save_kv_layer` 在 attention layer 内保存当前层 KV。
- `wait_for_save` 在 forward context 退出时确保保存完成。

scheduler 侧关键 hook：

```text
get_num_new_matched_tokens
update_state_after_alloc
build_connector_meta
update_connector_output
request_finished
```

含义：

- `get_num_new_matched_tokens` 判断外部 KV 能覆盖多少新 token。
- `update_state_after_alloc` 在 block 分配后记录加载目标。
- `build_connector_meta` 构造本 step 发给 worker 的 metadata。
- `request_finished` 在 request 结束且 block 释放前触发，connector 可接管异步保存/发送。

最后看 `kv_transfer_state.py` 的 `ensure_kv_transfer_initialized`。worker 侧全局 connector agent 在这里创建，并传入 `KVConnectorRole.WORKER`。

## 你需要做的事

30-45 分钟内完成：

1. 在 `base.py` 里把 worker-side methods 和 scheduler-side methods 分界线找出来。
2. 画一个两列 hook 表：scheduler hook / worker hook。
3. 给每个 hook 写一句中文解释。
4. 打开 `kv_transfer_state.py`，确认 worker 侧 connector 是在哪里初始化的。

## 检查理解

1. 为什么 scheduler 侧不应该直接加载 KV tensor？
2. `get_num_new_matched_tokens` 为什么要求 side-effect free？
3. `build_connector_meta` 的产物给谁用？
4. `start_load_kv` 和 `wait_for_layer_load` 为什么要拆成两个 hook？
5. `request_finished` 为什么发生在 block 被释放之前？

## 本次沉淀

更新：

```text
notes/02-vllm-kv-transfer.md
notes/04-integration-map.md
```

建议沉淀内容：

- scheduler / worker hook 对照表。
- metadata 在两侧之间流动的文本图。
- request 结束时 connector 和 block 生命周期的关系。
