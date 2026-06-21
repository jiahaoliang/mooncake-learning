# 11: BatchTransfer 请求生命周期

## 本期目标

上一期解释了 [`Segment`](glossary.md#segment) 和内存注册如何让远端定位本地 buffer。本期进入 [`BatchTransfer`](glossary.md#batchtransfer)：BatchTransfer 是一批读写传输任务，适合描述多段 [`KV cache`](glossary.md#kv-cache) 的移动。

本期只回答一个问题：一次 BatchTransfer 从提交到完成，会经历哪些状态？

## 背景问题

KV cache 通常不会是一整块简单连续数据。它可能按层、按 [`KV block`](glossary.md#kv-block)、按张量并行分片分布在多段地址上。KV block 是推理系统中管理 KV cache 的固定大小缓存块。一次请求需要移动的可能是一批地址范围。

如果每段地址都单独提交，调度和状态查询开销会很高。BatchTransfer 把多个传输请求组织成一批，用一个 [`BatchID`](glossary.md#batchid) 标识，便于提交、轮询和释放。

## 核心图解

```mermaid
flowchart LR
  A[allocateBatchID] --> B[构造 TransferRequest 列表]
  B --> C[submitTransfer]
  C --> D[MultiTransport 分发]
  D --> E[Transport 执行切片]
  E --> F[getTransferStatus]
  F --> G[freeBatchID]
```

这张图描述 BatchTransfer 的生命周期。`TransferRequest` 是单条读写请求，描述方向、源地址、目标 segment、偏移和长度。`MultiTransport` 根据请求选择后端 transport。状态查询用于判断传输仍在等待、执行中、完成还是失败。最后释放 BatchID，避免内部状态泄漏。

## TransferRequest 描述什么

一条 `TransferRequest` 至少需要说明读写方向、源地址、目标 segment、目标偏移和传输长度。读写方向决定数据是从远端读到本地，还是从本地写到远端。这里的远端不是抽象概念，而是 `openSegment` 得到的 segment handle 所指向的地址空间。

对上层来说，TransferRequest 是“我要移动哪段数据”的最小描述单元。对底层 transport 来说，它还可能被切成更小的 [`Slice`](glossary.md#slice)，也就是为了并行、对齐或重试而拆出的传输片段。

## 状态为什么要轮询

高性能传输通常是异步的。`submitTransfer` 成功只表示任务已经提交，不表示数据已经到达。上层需要通过 `getTransferStatus` 或 batch 级状态接口查看任务进度。

常见状态可以理解为等待、执行中、完成和失败。等待说明任务还没有真正完成底层传输；执行中说明 transport 后端正在处理；完成说明数据可用；失败则需要结合错误码、日志和重试策略处理。

## 释放 BatchID

`freeBatchID` 看起来只是清理动作，但很重要。BatchID 关联内部状态、任务描述和 transport 资源。如果上层忘记释放，长时间运行的推理服务会积累无用状态，最终影响稳定性。

因此，读源码时要养成一个习惯：看到 `allocateBatchID`，就继续找对应的 `freeBatchID`；看到 `submitTransfer`，就继续找状态检查和错误处理。

## 代码入口

| 问题 | 代码入口 |
| --- | --- |
| BatchID、submitTransfer、状态查询接口 | `repos/Mooncake/mooncake-transfer-engine/include/transfer_engine.h` |
| TransferRequest 和 Slice 定义 | `repos/Mooncake/mooncake-transfer-engine/include/transport/transport.h` |
| MultiTransport 分发逻辑入口 | `repos/Mooncake/mooncake-transfer-engine/include/multi_transport.h` |
| Python binding 中的同步和异步批量传输 | `repos/Mooncake/mooncake-integration/transfer_engine/transfer_engine_py.cpp` |

## 小结

本期只需要记住三点：

1. BatchTransfer 用一批 TransferRequest 描述多段 KV cache 的移动。
2. `submitTransfer` 只是提交任务，完成性要靠状态查询确认。
3. BatchID 是传输状态的生命周期标识，分配后必须释放。

下一期继续看 `MultiTransport` 如何把这些请求交给 RDMA、TCP、NVLink 或 Ascend 等后端。
