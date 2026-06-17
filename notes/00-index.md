# 学习索引

这是 Mooncake、vLLM、vLLM Ascend 学习资料的入口。当前 workspace 使用
“导师式陪读”方式：日常学习从 session 开始，稳定结论沉淀到 notes。

## 日常入口

先打开：

```text
tasks/session-backlog.md
```

然后选择一个 session：

```text
sessions/001-vllm-kv-transfer-config.md
sessions/002-vllm-connector-lifecycle.md
sessions/003-mooncake-connector-p2p.md
```

每个 session 控制在 30-45 分钟，只解决一个问题。

## 文件职责

| 路径 | 用途 |
| --- | --- |
| `sessions/` | 每次学习的任务、导读、检查问题。 |
| `tasks/session-backlog.md` | 学习 session 队列，决定下一次学什么。 |
| `tasks/learning-roadmap.md` | 长期路线和阶段目标，不作为每天的直接入口。 |
| `notes/` | 长期知识库，只写已经验证的稳定结论。 |
| `tasks/contribution-ideas.md` | 记录潜在 issue、测试、文档 PR。 |
| `repos/` | 上游源码，主要只读。 |

## 长期阅读顺序

1. Mooncake architecture、Transfer Engine、Mooncake Store。
2. vLLM KV transfer connector 的生命周期。
3. vLLM Ascend 的 disaggregated prefill 和 KV pool 集成。
4. 三个项目之间的集成映射和潜在贡献点。

## 本地笔记

- `01-mooncake-architecture.md`
- `02-vllm-kv-transfer.md`
- `03-vllm-ascend.md`
- `04-integration-map.md`
- `glossary.md`

## 源码搜索入口

```powershell
.\scripts\search.ps1 MooncakeConnector
.\scripts\search.ps1 MooncakeStoreConnector
.\scripts\search.ps1 AscendStoreConnector
.\scripts\search.ps1 kv_load_failure_policy
.\scripts\search.ps1 WAITING_FOR_REMOTE_KVS
```
