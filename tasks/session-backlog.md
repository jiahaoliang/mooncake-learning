# 学习 Session Backlog

这个文件维护后续导师式陪读 session。每个 session 只解决一个小问题，目标时长 30-45 分钟。

## 使用规则

- 每次学习优先打开 `sessions/`，不要直接从源码清单开始。
- 完成 session 后，把稳定结论合并到 `notes/`。
- 临时疑问可以留在 session 文件或新建草稿，不直接写入长期 notes。
- 发现可贡献问题时，记录到 `tasks/contribution-ideas.md`。

## 已创建

| Session | 问题 | 产出 |
| --- | --- | --- |
| `001-vllm-kv-transfer-config.md` | `KVTransferConfig` 到底配置了什么？ | 字段表、角色说明、factory 加载路径 |
| `002-vllm-connector-lifecycle.md` | scheduler hook 和 worker hook 怎么分工？ | hook 对照表、metadata 流动图 |
| `003-mooncake-connector-p2p.md` | `MooncakeConnector` 的 producer / consumer 分支如何走？ | P2P 流程图、职责拆分 |

## 后续候选

| 优先级 | Session 题目 | 核心问题 |
| --- | --- | --- |
| P0 | MooncakeStoreConnector scheduler | 如何判断 prefix cache hit？ |
| P0 | MooncakeStoreConnector worker | 如何执行 get/put KV？ |
| P0 | KV load failure recovery | `recompute` 和 `fail` 的路径分别是什么？ |
| P1 | MultiConnector | 如何同时组合 P2P transfer 和 Store connector？ |
| P1 | vLLM Ascend connector registry | Ascend 如何注册自己的 connector？ |
| P1 | MooncakeConnectorV1 vs upstream | Ascend 的 P2P connector 改了什么？ |
| P1 | MooncakeLayerwiseConnector | 为什么需要 layerwise transfer？ |
| P1 | AscendStoreConnector | 如何调用 Mooncake backend 做 KV pool？ |
| P2 | Mooncake Store Python API | get/put/list/remove 模型是什么？ |
| P2 | Mooncake Transfer Engine | transport 抽象如何支撑 KV transfer？ |
| P2 | Ascend transport | Ascend Direct / HCCL transport 的边界是什么？ |

## Session 完成标准

一个 session 完成时，至少应该留下：

- 一段 5-10 行中文结论。
- 一个小流程图或 hook 表。
- 3-5 个检查理解问题的答案。
- 至少一个更新到 `notes/` 的稳定结论。
