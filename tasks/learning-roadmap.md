# 学习路线

## 定位

这个文件只描述长期路线和阶段目标。日常学习入口是：

```text
tasks/session-backlog.md
sessions/
```

不要直接按本文件里的源码清单盲读。每次学习应先选一个 session。

## 学习主线

不要从 Mooncake 全仓库开始扫。主线问题固定为：

**一个 request 的 KV cache 从 prefill 生成后，如何被传输、存储、加载，并最终被 decode 使用？**

优先级：

1. 先读 vLLM 的 KV connector 抽象。
2. 再读 vLLM 里的 `MooncakeConnector` / `MooncakeStoreConnector`。
3. 然后对照 vLLM Ascend 的 `MooncakeConnectorV1` / `MooncakeLayerwiseConnector` / `AscendStoreConnector`。
4. 最后回到 Mooncake core，看 Transfer Engine 和 Mooncake Store 如何支撑这些 connector。

## Phase 1: vLLM KV Connector 心智模型

先读：

```text
repos/vllm/vllm/distributed/kv_transfer/README.md
repos/vllm/vllm/config/kv_transfer.py
repos/vllm/vllm/distributed/kv_transfer/kv_connector/v1/base.py
repos/vllm/vllm/distributed/kv_transfer/kv_connector/factory.py
repos/vllm/vllm/distributed/kv_transfer/kv_transfer_state.py
```

产出：

- 在 `notes/02-vllm-kv-transfer.md` 记录 `KVTransferConfig` 的关键字段。
- 记录 connector 如何被 factory 加载。
- 记录 scheduler 侧和 worker 侧的职责边界。
- 记录 request 什么时候进入 remote KV 等待状态。

## Phase 2: vLLM Mooncake 实现

先读：

```text
repos/vllm/vllm/distributed/kv_transfer/kv_connector/v1/mooncake/mooncake_connector.py
repos/vllm/vllm/distributed/kv_transfer/kv_connector/v1/mooncake/mooncake_utils.py
repos/vllm/vllm/distributed/kv_transfer/kv_connector/v1/mooncake/store/connector.py
repos/vllm/vllm/distributed/kv_transfer/kv_connector/v1/mooncake/store/scheduler.py
repos/vllm/vllm/distributed/kv_transfer/kv_connector/v1/mooncake/store/worker.py
```

配套测试：

```text
repos/vllm/tests/v1/kv_connector/unit/test_mooncake_connector.py
repos/vllm/tests/v1/kv_connector/unit/test_mooncake_store_connector.py
repos/vllm/tests/v1/kv_connector/unit/test_mooncake_store_worker.py
repos/vllm/tests/v1/kv_connector/unit/test_kv_load_failure_recovery.py
```

产出：

- 画出 `MooncakeConnector` 的 P2P KV transfer 流程。
- 画出 `MooncakeStoreConnector` 的共享 KV cache pool 流程。
- 记录 prefix cache、lookup、put/get 的关系。

## Phase 3: vLLM Ascend 对照阅读

先读：

```text
repos/vllm-ascend/vllm_ascend/distributed/kv_transfer/__init__.py
repos/vllm-ascend/vllm_ascend/distributed/kv_transfer/kv_p2p/mooncake_connector.py
repos/vllm-ascend/vllm_ascend/distributed/kv_transfer/kv_p2p/mooncake_layerwise_connector.py
repos/vllm-ascend/vllm_ascend/distributed/kv_transfer/kv_pool/ascend_store/ascend_store_connector.py
repos/vllm-ascend/vllm_ascend/distributed/kv_transfer/kv_pool/ascend_store/backend/mooncake_backend.py
```

配套文档：

```text
repos/vllm-ascend/docs/source/developer_guide/Design_Documents/disaggregated_prefill.md
repos/vllm-ascend/docs/source/user_guide/feature_guide/kv_pool.md
repos/vllm-ascend/docs/source/tutorials/features/pd_disaggregation_mooncake_single_node.md
repos/vllm-ascend/docs/source/tutorials/features/pd_disaggregation_mooncake_multi_node.md
```

产出：

- 在 `notes/03-vllm-ascend.md` 记录 Ascend 与 upstream vLLM 的差异。
- 在 `notes/04-integration-map.md` 更新 Mooncake / vLLM / vLLM Ascend 映射。

## Phase 4: Mooncake Core 回读

先读文档：

```text
repos/Mooncake/README.md
repos/Mooncake/docs/source/getting_started/examples/vllm-integration/index.md
repos/Mooncake/docs/source/getting_started/examples/vllm-integration/disagg-prefill-decode.md
repos/Mooncake/docs/source/getting_started/examples/vllm-integration/kv-cache-storage.md
repos/Mooncake/docs/source/python-api-reference/transfer-engine.md
repos/Mooncake/docs/source/python-api-reference/mooncake-store.md
```

再看实现入口：

```text
repos/Mooncake/mooncake-wheel/mooncake/mooncake_connector_v1.py
repos/Mooncake/mooncake-store/include/real_client.h
repos/Mooncake/mooncake-store/include/client_buffer.hpp
repos/Mooncake/mooncake-transfer-engine/src/transport/ascend_transport/
```

产出：

- 记录 vLLM connector 调用 Mooncake 的哪一层。
- 记录 Mooncake Store 的 get/put/list/remove 模型。
- 记录 Transfer Engine 如何抽象 transport。

## 如何使用这条路线

- Phase 只定义学习方向，不定义当天任务。
- 当某个 Phase 需要推进时，在 `tasks/session-backlog.md` 中选择对应 session。
- 完成 session 后，把稳定结论写入 `notes/`。
- 如果发现可贡献问题，写入 `tasks/contribution-ideas.md`。
