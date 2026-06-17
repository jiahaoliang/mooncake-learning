# Session 001: KVTransferConfig 入门

## 本次目标

理解 vLLM 通过哪些配置启用 KV connector，以及这些配置如何决定当前实例是 producer、consumer 还是 both。

## 先读结论

`KVTransferConfig` 是 vLLM KV transfer 的入口配置。只要 `kv_connector` 不为空，并且 `kv_role` 是合法角色，当前 vLLM 实例就会被视为 KV transfer instance。

关键字段：

- `kv_connector`：选择 connector 实现，例如 `MooncakeConnector`、`MooncakeStoreConnector`。
- `kv_role`：选择当前实例角色：`kv_producer`、`kv_consumer`、`kv_both`。
- `kv_connector_extra_config`：给具体 connector 的扩展参数，不由通用配置层解释。
- `kv_connector_module_path`：允许从外部 Python module 动态加载 connector，优先级高于内置 registry。
- `kv_load_failure_policy`：remote KV 加载失败后是 `recompute` 还是 `fail`。

`KVConnectorFactory` 负责把 `kv_connector` 字符串映射到具体类。`MooncakeConnector` 和 `MooncakeStoreConnector` 都是在 factory 里注册的内置 connector。

## 最小源码范围

```text
repos/vllm/vllm/config/kv_transfer.py
repos/vllm/vllm/distributed/kv_transfer/kv_connector/factory.py
```

重点对象：

```text
KVTransferConfig
KVTransferConfig.__post_init__
KVTransferConfig.is_kv_transfer_instance
KVTransferConfig.is_kv_producer
KVTransferConfig.is_kv_consumer
KVConnectorFactory.get_connector_class
KVConnectorFactory.register_connector
```

## 导读

先看 `KVTransferConfig.__post_init__`。这里做两个基本校验：

- 如果设置了 `kv_connector`，必须同时设置 `kv_role`。
- `kv_role` 只能是 `kv_producer`、`kv_consumer`、`kv_both` 之一。

然后看三个 property：

```text
is_kv_transfer_instance
is_kv_producer
is_kv_consumer
```

这三个 property 是理解后续分支的基础。`kv_both` 同时属于 producer 和 consumer，所以同一个实例可以同时保存和加载 KV。

再看 `factory.py`。内置 connector 不是一开始全部 import，而是通过 `register_connector(name, module_path, class_name)` 注册 lazy loader。真正创建时：

```text
KVConnectorFactory.create_connector
  -> get_connector_class
  -> import module
  -> getattr class
  -> connector_cls(config, role, kv_cache_config)
```

这里的 `role` 不是 `kv_role` 字符串，而是 `KVConnectorRole.SCHEDULER` 或 `KVConnectorRole.WORKER`，表示 connector 运行在 scheduler 侧还是 worker 侧。

## 你需要做的事

30-45 分钟内完成：

1. 打开 `kv_transfer.py`，把 `KVTransferConfig` 的字段扫一遍。
2. 手写一个三列表格：字段、作用、Mooncake 场景是否重要。
3. 打开 `factory.py`，找到 `MooncakeConnector` 和 `MooncakeStoreConnector` 的注册位置。
4. 用自己的话解释：`kv_role` 和 `KVConnectorRole` 为什么不是同一个东西。

## 检查理解

1. 如果用户设置了 `kv_connector="MooncakeConnector"` 但没设置 `kv_role`，vLLM 会在什么阶段报错？
2. `kv_both` 为什么同时满足 `is_kv_producer` 和 `is_kv_consumer`？
3. `kv_connector_extra_config` 为什么放在通用 config 里，但不由通用 config 解释？
4. `kv_connector_module_path` 和内置 registry 同时存在时，谁优先？
5. `KVConnectorRole.WORKER` 和 `kv_role="kv_consumer"` 分别描述什么维度？

## 本次沉淀

更新：

```text
notes/02-vllm-kv-transfer.md
notes/glossary.md
```

建议沉淀内容：

- `KVTransferConfig` 关键字段表。
- `kv_role` vs `KVConnectorRole` 的区别。
- Mooncake connector 在 factory 中的加载路径。
