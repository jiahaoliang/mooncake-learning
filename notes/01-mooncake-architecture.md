# Mooncake 架构笔记

## 当前阅读目标

先理解 Mooncake 如何支撑 vLLM connector，不急着阅读所有 transport 实现。

## 要回答的问题

- Mooncake 在 LLM serving 里解决什么问题？
- Mooncake 如何抽象 KV cache 的存储和传输？
- Transfer Engine 和 Mooncake Store 分别负责什么？
- buffer 什么时候注册、传输和释放？
- 示例中需要哪些 metadata service 或 master 进程？

## 必读文档

```text
repos/Mooncake/README.md
repos/Mooncake/docs/source/getting_started/examples/vllm-integration/index.md
repos/Mooncake/docs/source/getting_started/examples/vllm-integration/disagg-prefill-decode.md
repos/Mooncake/docs/source/getting_started/examples/vllm-integration/kv-cache-storage.md
repos/Mooncake/docs/source/python-api-reference/transfer-engine.md
repos/Mooncake/docs/source/python-api-reference/mooncake-store.md
```

## 实现入口

```text
repos/Mooncake/mooncake-wheel/mooncake/mooncake_connector_v1.py
repos/Mooncake/mooncake-store/include/real_client.h
repos/Mooncake/mooncake-store/include/client_buffer.hpp
repos/Mooncake/mooncake-transfer-engine/src/transport/ascend_transport/
```

## 需要跟踪的概念

- Transfer Engine
- Mooncake Store
- Segment
- buffer registration
- batch transfer
- RDMA / TCP / Ascend transport
- local vs remote KV cache ownership

## 源码入口

可以在 `repos/Mooncake` 里搜索：

```powershell
.\scripts\search.ps1 "Transfer Engine"
.\scripts\search.ps1 "Mooncake Store"
.\scripts\search.ps1 BatchTransfer
.\scripts\search.ps1 register
```
