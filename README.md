# Mooncake 教程 Workspace

这个 workspace 用来编写 Mooncake、vLLM、vLLM Ascend 相关的中文教程。

当前定位是：面向计算机科学本科生，输出深入浅出的教程。它不负责在 Windows 本地
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
tutorials/README.md
```

教程正文和术语表在：

```text
tutorials/
tutorials/glossary.md
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

需要查源码时，可以直接用 `rg`：

```powershell
rg MooncakeConnector repos
```

## 运行环境说明

本地 Windows 环境主要用于阅读和索引。真正构建、运行 Mooncake、vLLM、vLLM Ascend，
建议后续单独规划 Linux 或远程 Ascend 环境，并准备匹配的 Python、CANN、驱动和网络配置。
