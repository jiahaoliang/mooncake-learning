# Mooncake / vLLM / vLLM Ascend 教程系列

这个目录用于沉淀面向计算机科学本科生的连续教程。

## 定位

- 每期正文约 1500 字，不含图表和代码路径表。
- 先讲 big picture，再讲必要细节。
- 用图表解释系统关系。
- 代码只作为“延伸阅读入口”，不在正文中逐行走读。
- 目标是让读者先理解问题、架构和数据流，再按需进入源码。

## 推荐阅读顺序

| 期数 | 文件 | 主题 | 外部阅读 |
| --- | --- | --- | --- |
| 01 | `01-llm-inference-from-prompt-to-answer.md` | 从 Prompt 到回答：大模型推理的基本流程 | [从零开始理解大模型](https://github.com/GitHubxsy/nanoAgent/blob/book/llm/README.md) |
| 02 | `02-kv-cache-and-mooncake-big-picture.md` | 从 KV Cache 到 Mooncake：理解大模型推理服务的数据通路 | - |
| 03 | `03-mooncake-architecture-and-data-path.md` | Mooncake 的整体架构与数据通路 | - |
| 04 | `04-mooncake-transfer-engine.md` | Transfer Engine：KV cache 如何被移动 | - |
| 05 | `05-mooncake-p2p-kv-transfer.md` | P2P KV 传输：Prefill 到 Decode | - |
| 06 | `06-mooncake-store-and-kv-pool.md` | Mooncake Store 与 KV Pool | - |
| 07 | `07-prefix-cache-and-reuse-policy.md` | Prefix Cache：什么时候能复用 KV | - |
| 08 | `08-mooncake-in-vllm-and-ascend.md` | Mooncake 在 vLLM / vLLM Ascend 中如何落地 | - |
| 09 | `09-transfer-engine-source-overview.md` | Transfer Engine 源码总览 | - |
| 10 | `10-segment-and-memory-registration.md` | Segment 与内存注册机制 | - |
| 11 | `11-batchtransfer-lifecycle.md` | BatchTransfer 请求生命周期 | - |
| 12 | `12-transport-selection-rdma-tcp.md` | Transport 后端选择与 RDMA/TCP 路径 | - |
| 13 | `13-mooncake-store-source-overview.md` | Mooncake Store 架构源码导读 | - |
| 14 | `14-store-put-path.md` | Put 路径：KV cache 如何写入 Store | - |
| 15 | `15-store-get-path.md` | Get 路径：KV cache 如何被读取和复用 | - |
| 16 | `16-cache-management-lease-pin.md` | 缓存空间管理：分配、淘汰、Lease、Pin | - |
| 17 | `17-tiered-storage-ssd-offload.md` | 多层存储与 SSD Offload | - |
| 18 | `18-p2p-store-source.md` | P2P Store 源码专题 | - |
| 19 | `19-python-vllm-integration.md` | Python / vLLM 集成入口 | - |
| 20 | `20-troubleshooting-and-observability-map.md` | 故障与可观测性源码地图 | - |

## 术语表

术语统一维护在：

```text
glossary.md
```

教程正文提到关键术语时，优先链接到 `glossary.md` 中的对应小节。

## 每期结构

```text
# 标题

## 本期目标
## 背景问题
## 核心图解
## 关键概念
## 系统流程
## 代码入口
## 小结
```

## 和其他目录的关系

- `tutorials/`：可阅读的教程成稿。
- `repos/`：上游源码，作为教程和笔记的事实来源。
