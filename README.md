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

当前 submodule 版本记录如下，更新时间为 2026-06-23：

| 路径 | 版本标识 | Commit |
| --- | --- | --- |
| `repos/Mooncake` | `v0.2.0-1322-ga1e97616` | `a1e97616df477ac2ab91a9458640b863a39b010b` |
| `repos/Mooncake/extern/pybind11` | `v2.11.1-250-g58c382a8` | `58c382a8e3d7081364d2f5c62e7f429f0412743b` |
| `repos/Mooncake/extern/yalantinglibs` | `0.6.0-6-g6a0e067` | `6a0e067d9a43492cf8e4e280b531924fbd724dbd` |
| `repos/vllm` | `v0.13.0rc1-5605-g7b5d60cc3` | `7b5d60cc3733025fc97ee03a91b5f46188aefe7d` |
| `repos/vllm-ascend` | `v0.19.1rc1-572-g3ac10c80` | `3ac10c803a33aaced122e0c74e16425723af5251` |
| `repos/vllm-ascend/csrc/third_party/catlass` | `v1.2.0-143-g41bf90d` | `41bf90da655bba3c66d0acd7e00abe33960ecfd6` |
| `repos/vllm-ascend/csrc/third_party/catlass/3rdparty/googletest` | `release-1.8.0-3335-gf8d7d77c` | `f8d7d77c06936315286eb55f8de22cd23c188571` |

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

## License / 许可证

本仓库原创的教程、计划和说明文档采用
[Creative Commons Attribution 4.0 International](https://creativecommons.org/licenses/by/4.0/)
（CC BY 4.0）授权。

引用、转载或改编这些原创内容时，请署名 `jiahaoliang`，链接到本仓库，并说明内容是否做过修改。

`repos/` 目录下的 Mooncake、vLLM、vLLM Ascend 是 Git submodule 引入的上游源码，
不受本仓库许可证重新授权；使用这些源码时请遵循各自上游项目的许可证。
