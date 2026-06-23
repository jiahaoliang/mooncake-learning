# Mooncake / vLLM / vLLM Ascend 教程

这是一组面向计算机科学本科生的中文教程，用来理解大模型推理服务中
[KV cache](glossary.md#kv-cache) 如何被生成、传输、存储、复用和排障。

如果你刚开始接触这条技术线，建议按顺序阅读。前几篇先建立推理服务和 KV cache 的直觉，
后面的源码专题再进入 Mooncake Transfer Engine、Mooncake Store、P2P Store 和 vLLM 集成入口。

## 学习路径

| 阶段 | 章节 | 你会建立的理解 |
| --- | --- | --- |
| 入门背景 | 01-02 | 一个 prompt 如何变成回答；KV cache 为什么会从模型优化变成系统资源问题。 |
| Mooncake 机制主线 | 03-08 | Mooncake 为什么需要 Transfer Engine、Store、P2P 传输、Prefix Cache，以及它如何接入 vLLM / vLLM Ascend。 |
| Transfer Engine 源码 | 09-12 | `TransferEngine`、`Segment`、`BatchTransfer`、`Transport` 这些抽象如何配合完成数据移动。 |
| Store 与 P2P Store 源码 | 13-18 | KV cache 如何写入、读取、淘汰、分层存储，以及 P2P Store 如何共享对象。 |
| 集成与排障 | 19-20 | Python / vLLM 集成入口在哪里；出现传输、元数据、缓存问题时该从哪些日志和源码入口排查。 |

## 章节目录

| 期数 | 章节 | 读完后应该能回答 |
| --- | --- | --- |
| 01 | [从用户输入到回答：大模型推理的基本流程](01-llm-inference-from-prompt-to-answer.md) | 用户输入的 prompt 如何经过 tokenizer、prefill、decode、sampling 变成回答？ |
| 02 | [从上下文缓存到分布式传输：理解大模型推理服务的数据通路](02-kv-cache-and-mooncake-big-picture.md) | KV cache 为什么会影响显存、吞吐和延迟，Mooncake 为什么会出现在这条链路上？ |
| 03 | [Mooncake 的整体架构与数据通路](03-mooncake-architecture-and-data-path.md) | Mooncake 由哪些角色组成，KV cache 在这些角色之间如何流动？ |
| 04 | [Transfer Engine：KV cache 如何被移动](04-mooncake-transfer-engine.md) | 为什么移动 KV cache 不只是普通拷贝，还需要内存注册、元数据和 transport？ |
| 05 | [P2P KV 传输：Prefill 到 Decode](05-mooncake-p2p-kv-transfer.md) | PD 分离后，prefill 节点生成的 KV cache 如何交给 decode 节点？ |
| 06 | [Mooncake Store 与 KV Pool](06-mooncake-store-and-kv-pool.md) | Mooncake Store 如何把 KV cache 组织成可复用的缓存池？ |
| 07 | [Prefix Cache：什么时候能复用 KV](07-prefix-cache-and-reuse-policy.md) | 哪些请求可以复用已有 KV cache，命中和失效风险在哪里？ |
| 08 | [Mooncake 在 vLLM / vLLM Ascend 中如何落地](08-mooncake-in-vllm-and-ascend.md) | vLLM connector 如何把上层 KV buffer 交给 Mooncake？ |
| 09 | [Transfer Engine 源码总览](09-transfer-engine-source-overview.md) | 读 Transfer Engine 源码时应该先抓住哪几个核心抽象？ |
| 10 | [Segment 与内存注册机制](10-segment-and-memory-registration.md) | 远端为什么能定位并访问本地注册过的内存？ |
| 11 | [BatchTransfer 请求生命周期](11-batchtransfer-lifecycle.md) | 一批传输任务如何被创建、提交、执行、查询和释放？ |
| 12 | [Transport 后端选择与 RDMA/TCP 路径](12-transport-selection-rdma-tcp.md) | Mooncake 如何在 TCP、RDMA、NVLink、Ascend 等传输后端之间分层和选择？ |
| 13 | [Mooncake Store 架构源码导读](13-mooncake-store-source-overview.md) | Store 的 Client、Master Service、Segment、Replica 如何协作？ |
| 14 | [Put 路径：KV cache 如何写入 Store](14-store-put-path.md) | 一份 KV cache 如何从上层 buffer 写入 Store 并变成可查询对象？ |
| 15 | [Get 路径：KV cache 如何被读取和复用](15-store-get-path.md) | 缓存命中后，Store 如何把 KV cache 读回推理引擎可用的 buffer？ |
| 16 | [缓存空间管理：分配、淘汰、Lease、Pin](16-cache-management-lease-pin.md) | Store 如何在有限空间里避免正在使用的对象被提前回收？ |
| 17 | [多层存储与 SSD Offload](17-tiered-storage-ssd-offload.md) | Mooncake Store 如何在内存和 SSD 等低速大容量层之间移动对象？ |
| 18 | [P2P Store 源码专题](18-p2p-store-source.md) | 没有集中式 Master Service 时，P2P Store 如何记录对象位置并共享副本？ |
| 19 | [Python / vLLM 集成入口](19-python-vllm-integration.md) | Python binding 和 vLLM connector 如何调用 Mooncake API？ |
| 20 | [故障与可观测性源码地图](20-troubleshooting-and-observability-map.md) | metadata、segment、transfer、replica 出问题时，应该从哪些入口排查？ |

## 辅助页面

- [术语表](glossary.md)：统一解释本系列反复出现的术语。
- [许可证](license.md)：原创教程内容采用 CC BY 4.0 授权。
- [GitHub 仓库](https://github.com/jiahaoliang/mooncake-learning)：查看源码引用、submodule 版本和历史变更。
