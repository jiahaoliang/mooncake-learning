# 术语表

## KV Cache

Transformer attention 过程中产生的 key/value tensor 缓存。复用或移动 KV cache
可以避免重复 prefill 计算。

## Prefill

处理 prompt tokens 并生成初始 KV cache 的阶段。

## Decode

消费已有 KV cache 并生成新 token 的阶段。

## PD Disaggregation

把 prefill 和 decode 工作拆开的推理服务架构，通常会跨不同进程、GPU、NPU 或节点。中文也翻译为PD分离。

## Connector

vLLM 中用于通过外部系统移动或加载 KV cache 的抽象，例如 Mooncake connector。

## kv_role

`KVTransferConfig` 中描述当前 vLLM 实例在 KV transfer 拓扑里的业务角色。
常见取值包括 `kv_producer`、`kv_consumer`、`kv_both`。

## KVConnectorRole

vLLM 内部描述 connector 对象运行位置的角色。`SCHEDULER` 表示 scheduler 侧
connector，`WORKER` 表示 worker 侧 connector。它和 `kv_role` 不是同一个维度。

## Mooncake Store

Mooncake 中作为分布式 KV cache 存储层的组件。

## Transfer Engine

Mooncake 中负责在内存、设备和机器之间高效移动数据的组件。
