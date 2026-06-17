# Mooncake 学习 Workspace

这个 workspace 用来学习 Mooncake 以及它和 vLLM、vLLM Ascend 周边生态的集成，
后续也可以作为贡献代码前的资料整理区。

当前定位是：源码阅读、中文笔记、跨仓库搜索、贡献准备。它不负责在 Windows 本地
安装 Python 依赖、编译 Mooncake，或运行 vLLM。

## 源码仓库

源码仓库用 Git submodule 管理：

```text
repos/Mooncake      # kvcache-ai/Mooncake
repos/vllm          # vllm-project/vllm
repos/vllm-ascend   # vllm-project/vllm-ascend
```

初始化或刷新 submodule：

```powershell
git submodule update --init --recursive
```

## 学习入口

建议从这里开始：

```text
notes/00-index.md
tasks/learning-roadmap.md
```

主线目标是理解 KV cache 在三个系统里的生命周期：

```text
Mooncake Transfer Engine / Mooncake Store
vLLM KV transfer connectors
vLLM Ascend disaggregated prefill and KV pool integration
```

也就是说，重点不是先把所有代码读完，而是持续回答：

- KV 是谁生成的？
- KV 当前在哪里？
- KV 什么时候注册、传输、存储、加载、释放？
- 失败后是重算、等待，还是报错？

## 常用命令

查看 workspace 状态：

```powershell
.\scripts\status.ps1
```

跨源码和笔记搜索：

```powershell
.\scripts\search.ps1 MooncakeConnector
```

## 运行环境说明

本地 Windows 环境主要用于阅读和索引。真正构建、运行 Mooncake、vLLM、vLLM Ascend，
建议后续单独规划 Linux 或远程 Ascend 环境，并准备匹配的 Python、CANN、驱动和网络配置。
