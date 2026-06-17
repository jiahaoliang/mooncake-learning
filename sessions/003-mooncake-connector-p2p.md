# Session 003: MooncakeConnector P2P 路径

## 本次目标

理解 vLLM upstream 的 `MooncakeConnector` 如何实现 prefill producer 到 decode consumer 的直接 KV transfer。

## 先读结论

`MooncakeConnector` 是 P2P KV transfer connector。它不是共享 KV pool，而是让 decode 侧从 prefill 侧拉取本次 request 需要的 KV。

它内部继续拆成两层：

- `MooncakeConnector`：对接 vLLM 的 `KVConnectorBase_V1` 接口。
- `MooncakeConnectorScheduler`：scheduler 侧状态管理。
- `MooncakeConnectorWorker`：worker 侧加载/发送 KV。

核心流程：

```text
Decode scheduler 判断 request 有外部 KV
  -> 分配 blocks 并构造 MooncakeConnectorMetadata
  -> Decode worker start_load_kv
  -> Mooncake worker 发起 group_kv_pull / load
  -> attention layer 等待对应层 KV
  -> request 完成后双方清理状态
```

注意：producer / consumer 是 `kv_role` 维度，scheduler / worker 是 vLLM 进程内职责维度。不要混淆。

## 最小源码范围

```text
repos/vllm/vllm/distributed/kv_transfer/kv_connector/v1/mooncake/mooncake_connector.py
repos/vllm/tests/v1/kv_connector/unit/test_mooncake_connector.py
```

重点对象：

```text
MooncakeConnector
MooncakeConnectorMetadata
MooncakeConnectorScheduler
MooncakeConnectorWorker
MooncakeConnector.get_num_new_matched_tokens
MooncakeConnector.update_state_after_alloc
MooncakeConnector.request_finished
MooncakeConnector.start_load_kv
MooncakeConnectorWorker.start_load_kv
```

## 导读

先看 `MooncakeConnector.__init__`。它根据 `KVConnectorRole` 决定当前对象初始化 scheduler 组件还是 worker 组件：

```text
role == SCHEDULER -> MooncakeConnectorScheduler
role == WORKER -> MooncakeConnectorWorker
```

然后看 scheduler 侧：

- `get_num_new_matched_tokens`：判断当前 request 是否有可从远端加载的 KV。
- `update_state_after_alloc`：block 分配后记录 request 和 block 信息。
- `request_finished`：request 完成时处理发送/保存状态。

再看 worker 侧：

- `start_load_kv`：根据 scheduler 发来的 metadata 开始加载 KV。
- `wait_for_layer_load`：MooncakeConnector upstream 中通常不做 layerwise saving；这里要确认它是否直接等待整体加载完成。
- `save_kv_layer`：P2P connector 不显式逐层保存，具体发送记录通常由 request 完成或 metadata 驱动。

最后看测试文件。测试比源码更适合初学者，因为它会暴露作者认为重要的行为边界，例如 metadata、matched tokens、request finished、worker load。

## 你需要做的事

30-45 分钟内完成：

1. 在 `mooncake_connector.py` 中找到三个类：`MooncakeConnector`、`MooncakeConnectorScheduler`、`MooncakeConnectorWorker`。
2. 标注每个类属于 vLLM connector 生命周期的哪一侧。
3. 找到 `get_num_new_matched_tokens`、`update_state_after_alloc`、`start_load_kv` 的调用意义。
4. 在测试文件里找一个和 scheduler 相关的测试、一个和 worker 相关的测试。
5. 写出 P2P 流程图，不超过 8 行。

## 检查理解

1. `MooncakeConnector` 和 `MooncakeStoreConnector` 的根本区别是什么？
2. `MooncakeConnectorScheduler` 为什么不直接做 tensor copy？
3. decode 侧为什么需要先分配本地 KV blocks，再加载 remote KV？
4. `kv_role` 和 `KVConnectorRole` 在这个文件里分别怎么体现？
5. 如果 remote KV 加载失败，后续应该去看哪个通用机制？

## 本次沉淀

更新：

```text
notes/02-vllm-kv-transfer.md
notes/04-integration-map.md
tasks/contribution-ideas.md
```

建议沉淀内容：

- `MooncakeConnector` P2P 文本流程图。
- `MooncakeConnector` / scheduler / worker 三者职责。
- 一个可能贡献点：测试、错误信息或文档中的不清楚之处。
