# 学习路线

## Phase 1: Mooncake 核心

- 阅读 Mooncake architecture 文档和 README。
- 找到 Transfer Engine 的主要入口。
- 找到 Mooncake Store 的对象 API 和 metadata 流程。
- 在 `notes/01-mooncake-architecture.md` 里记录 KV cache ownership 模型。

## Phase 2: vLLM KV Connector 生命周期

- 搜索 `kv_transfer`、`MooncakeConnector`、`MooncakeStoreConnector`。
- 追踪 producer 和 consumer 两条路径。
- 找出和 remote KV 相关的 request state。
- 在 `notes/02-vllm-kv-transfer.md` 里总结 connector 生命周期。

## Phase 3: vLLM Ascend 集成

- 搜索 `MooncakeLayerwiseConnector` 和 `AscendStoreConnector`。
- 对比 Ascend 行为和 upstream vLLM 行为。
- 跟踪 transport 和环境要求。
- 在 `notes/03-vllm-ascend.md` 里总结差异。

## Phase 4: 第一个贡献候选

- 从文档、测试或错误信息里挑一个小问题。
- 基于源码或文档复现/验证它。
- 在对应上游仓库或 fork 里准备一个最小 patch。
- 把想法记录到 `tasks/contribution-ideas.md`。
