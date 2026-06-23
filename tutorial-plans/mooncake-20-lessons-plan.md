# Mooncake 教程 20 课总计划

## 总定位

本计划用于规划 Mooncake / vLLM / vLLM Ascend 教程系列的后续写作路线。整个系列以 Mooncake 为主线，重点解释 Mooncake 如何围绕大模型推理中的 KV cache 做传输、存储、复用和集成。vLLM 和 vLLM Ascend 只作为 Mooncake 的上下游背景出现：vLLM 提供推理服务和 connector 接入点，vLLM Ascend 提供 Ascend NPU 场景下的硬件适配背景。

整体分为两个阶段：

- 01-08：机制主线，帮助读者理解 Mooncake 为什么存在、解决什么问题。
- 09-20：源码专题，帮助读者沿着 Mooncake 的传输、存储、复用、集成路径读源码。

## 20 课目录

| 期数 | 主题 | 简要描述 |
| --- | --- | --- |
| 01 | 从用户输入到回答：大模型推理的基本流程 | 解释 prompt 如何经过 tokenizer、prefill、decode、sampling、detokenizer 变成回答，为 KV cache 铺垫。 |
| 02 | 从上下文缓存到分布式传输：理解大模型推理服务的数据通路 | 解释 KV cache 为什么会变成系统问题，以及 vLLM、vLLM Ascend、Mooncake 在数据通路中的位置。 |
| 03 | Mooncake 的整体架构与数据通路 | 从 Mooncake 视角建立组件地图：KV cache 从哪里来、经过哪些 Mooncake 组件、最终被谁消费。 |
| 04 | Transfer Engine：KV cache 如何被移动 | 讲 Mooncake 的核心传输能力：为什么 KV cache 传输需要注册内存、元数据和高性能 transport。 |
| 05 | P2P KV 传输：Prefill 到 Decode | 聚焦点对点 KV 传输路径，解释 PD 分离后 prefill 节点生成的 KV cache 如何交给 decode 节点。 |
| 06 | Mooncake Store 与 KV Pool | 讲 Mooncake Store 如何把 KV cache 放入共享缓存池，如何组织、索引和管理缓存空间。 |
| 07 | Prefix Cache：什么时候能复用 KV | 解释 prefix cache 的命中条件、缓存粒度、复用收益和失效风险。 |
| 08 | Mooncake 在 vLLM / vLLM Ascend 中如何落地 | 把前面机制映射回实际集成入口，解释 connector 如何把 vLLM 的 KV buffer 接到 Mooncake。 |
| 09 | Transfer Engine 源码总览 | 建立 `mooncake-transfer-engine` 源码地图：`TransferEngine`、`Transport`、`Segment`、`BatchTransfer` 各自负责什么。 |
| 10 | Segment 与内存注册机制 | 追 `registerLocalMemory`、`openSegment` 和 metadata，解释远端为什么能定位并访问本地注册过的内存。 |
| 11 | BatchTransfer 请求生命周期 | 从 `allocateBatchID`、`submitTransfer`、`getTransferStatus` 追一次传输任务如何提交、拆分、执行和完成。 |
| 12 | Transport 后端选择与 RDMA/TCP 路径 | 讲 `MultiTransport` 如何选择 TCP、RDMA、NVLink、Ascend 等后端，以及通用调度和硬件传输为什么分层。 |
| 13 | Mooncake Store 架构源码导读 | 建立 Store 源码地图：Master Service、Client、Segment、Replica 如何协同管理分布式 KV cache。 |
| 14 | Put 路径：KV cache 如何写入 Store | 追 `Put` / `BatchPut`：对象切分、空间申请、replica 创建、Transfer Engine 写入和元数据更新。 |
| 15 | Get 路径：KV cache 如何被读取和复用 | 追 `Get` / `BatchGet`：查询元数据、选择 replica、本地拷贝或远程传输，最终把 KV cache 读回上层缓冲区。 |
| 16 | 缓存空间管理：分配、淘汰、Lease、Pin | 讲 allocator、eviction policy、lease、soft pin、hard pin 如何共同管理有限缓存空间。 |
| 17 | 多层存储与 SSD Offload | 讲 Mooncake Store 如何把内存中的 KV cache 下沉到 SSD 或分布式文件系统，以及 load/offload 的数据流。 |
| 18 | P2P Store 源码专题 | 讲 `Register`、`GetReplica`、metadata、shard、replica list 如何实现无中心 master 的点对点对象共享。 |
| 19 | Python / vLLM 集成入口 | 讲 `mooncake-integration`、Python binding、vLLM connector 如何把上层 KV buffer 交给 Mooncake API。 |
| 20 | 故障与可观测性源码地图 | 整理日志、错误码、metrics 和常见失败点：metadata 不通、segment 打不开、内存未注册、transfer 超时、replica 不完整。 |

## 写作规则

- 所有新增 `docs/*.md` 课程必须遵守 `tutorial-plans/00-writing-guide.md`：术语首次出现前必须解释，不能只给 glossary 链接。
- 每课只回答一个主问题，正文约 1500 字，不逐行走读源码。
- 每课至少有一张 Mermaid 图，图后解释关键节点和箭头。
- 代码入口表必须说明路径职责，不能只罗列文件。
- 01-08 偏机制解释，09-20 偏源码调用链，但都保持本科生可读。
- 第 03 课之后 Mooncake 是绝对主角；vLLM / vLLM Ascend 只提供 Mooncake 接入和硬件适配所需背景。

## 发布检查清单

- 每新增一课，同步更新 `docs/README.md` 章节目录。
- 新增术语先补 `docs/glossary.md`，正文首次出现时就地解释。
- 检查 `text` 代码块中没有 Markdown 链接语法。
- 检查每课是否仍围绕 Mooncake 主线，避免变成 vLLM 通用教程。
- 检查每篇代码入口表是否解释了路径职责。
- 阶段完成后整体检查：01-08 能建立 Mooncake 机制图景，09-20 能覆盖 Transfer Engine、Store、P2P Store、Integration 和排障入口。

## 范围说明

- 前两课保留为必要基础铺垫。
- 本系列定位是源码学习和机制理解，不写本地部署运行教程。
- 本文件只记录规划，不代表正式阅读顺序已经更新；正式新增课程时再同步 `docs/README.md`。
