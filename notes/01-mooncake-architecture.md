# Mooncake 架构笔记

## 要回答的问题

- Mooncake 在 LLM serving 里解决什么问题？
- Mooncake 如何抽象 KV cache 的存储和传输？
- Transfer Engine 和 Mooncake Store 分别负责什么？
- buffer 什么时候注册、传输和释放？
- 示例中需要哪些 metadata service 或 master 进程？

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
