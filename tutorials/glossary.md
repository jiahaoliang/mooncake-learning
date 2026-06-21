# 术语表

## Prompt

用户输入给模型的文本指令或上下文。一次请求中的 prompt 会先被切成 token，再送入模型。

## Token

模型词表中的基本输入/输出单位。文本需要先经过 tokenizer 转成 token id，模型才能处理。

## Tokenizer

把用户文本转换为 token id，或把输出 token id 还原为文本的组件。

## Detokenizer

把模型输出的 token id 还原为用户可读文本的组件。它通常和 tokenizer 使用同一套词表规则。

## Embedding

把 token id 映射成向量表示的过程或参数表。模型后续计算处理的是这些向量，而不是原始文本。

## Attention

让当前位置根据上下文中其他位置的信息更新自身表示的机制。大模型生成时会在每一层 attention 中产生 key/value tensor。

## Transformer

由 attention、前馈网络、归一化等模块堆叠而成的大模型主干结构。当前主流大语言模型大多基于 Transformer 架构。

## Logits

模型在每一步生成时对词表中所有候选 token 给出的原始分数。sampling 会基于 logits 选择下一个 token。

## Sampling

从模型给出的候选 token 分布中选择下一个 token 的过程。常见参数包括 `temperature`、`top_p` 和 `top_k`。

## Batch

一次合并执行的一组请求或 token。把多个请求合成 batch 可以提升设备利用率，但也会增加调度复杂度。

## Batching

把多个请求或多个 token 组织成 batch 一起执行的调度方法。

## Batch Size

一个 batch 中包含的请求数或 token 数。具体含义取决于上下文，但都表示一次合并执行的规模。

## KV Block

推理系统中用于管理 KV cache 的固定大小缓存块。把 KV cache 拆成 block 后，系统更容易做分配、复用和回收。

## KV Cache

Transformer attention 过程中产生的 key/value tensor 缓存。这里的 Transformer 指大模型主干结构，attention 指让当前位置关注上下文中相关位置的机制。复用或移动 KV cache
可以避免重复 prefill 计算。

## Prefill

处理 prompt tokens 并生成初始 KV cache 的阶段。

## Decode

消费已有 KV cache 并生成新 token 的阶段。

## LLM Serving Engine

大模型推理服务引擎。它不负责训练模型，而是负责在线请求的调度、batching、模型执行、KV cache 管理和 API 适配。

## vLLM

一个开源 LLM serving engine，用于让大语言模型在线推理服务更高效。

## vLLM Ascend

vLLM 在 Ascend NPU 生态中的适配和扩展，用于让 vLLM 的推理服务能力运行在 Ascend 设备上。

## Mooncake

面向大模型推理系统的数据传输和缓存组件。在本教程中，重点关注它如何帮助移动、存储和复用 KV cache。

## Ascend

华为昇腾 AI 计算硬件和软件生态。教程中提到 Ascend 时，通常指 Ascend NPU 及其相关运行时和通信栈。

## NPU

Neural Processing Unit，神经网络处理器，面向深度学习计算的专用加速设备。

## GPU

Graphics Processing Unit，图形处理器，也常用于深度学习训练和推理加速。

## CPU

Central Processing Unit，通用处理器，负责通用计算和系统控制。

## CUDA

NVIDIA GPU 生态中的并行计算平台和编程接口。

## CANN

Ascend 生态中的异构计算架构和运行时软件栈，负责算子执行、编译和设备运行支持。

## HCCN

Ascend 设备间通信相关的网络能力。教程中提到 HCCN 时，通常关注多设备或多节点通信路径。

## Transport

数据传输通道或传输机制。不同硬件生态会有不同的 transport，用来在设备、进程或机器之间移动数据。

## Tensor

多维数组，是深度学习框架中表示模型输入、参数、中间状态和输出的基本数据结构。

## Prefix

请求开头的一段共享上下文。多个请求拥有相同 prefix 时，系统可能复用已经计算好的 KV cache。

## PD Disaggregation

把 prefill 和 decode 工作拆开的推理服务架构，通常会跨不同进程、GPU、NPU 或节点。中文也翻译为PD分离。

## Connector

vLLM 中用于通过外部系统移动或加载 KV cache 的抽象，例如 Mooncake connector。

## P2P

Point-to-point，点对点传输。教程中通常指两个节点、进程或设备之间直接移动 KV cache。

## Prefix Cache

针对相同或相似 prefix 复用已有 KV cache 的缓存机制。

## KV Pool

保存和管理 KV cache 的缓存池。它可以在一个实例内部，也可以由外部存储系统提供。

## Scheduler

调度器。推理服务中负责决定请求执行顺序、batch 组合、资源分配和等待队列管理的组件。

## Worker

执行模型计算的工作进程或设备侧执行单元。它通常接收 scheduler 分配的任务。

## OpenAI-Compatible API

兼容 OpenAI API 格式的服务接口。客户端可以用类似 OpenAI SDK 或协议的方式请求本地或第三方模型服务。

## API Server

接收客户端请求并返回响应的服务入口。推理服务中的 API Server 通常负责协议解析、参数校验和流式返回。

## Forward

模型前向计算。给定输入后，模型从输入层一路计算到输出层，得到 logits 或其他输出。

## Rust

一种系统编程语言。vLLM 的部分服务端路径使用 Rust 实现。

## V1 Engine

vLLM 中一套较新的推理引擎实现路径。教程里把它作为后续查源码的入口，不要求在第一课理解细节。

## Store

存储后端。教程中提到 store 时，通常指保存或加载 KV cache 的组件。

## PyTorch

常用深度学习框架。教程中提到 PyTorch 时，通常指直接用框架代码描述和执行模型计算。

## Throughput

吞吐，单位时间内系统能处理的请求数或 token 数。

## Latency

延迟，一个请求从进入系统到得到结果或部分结果所花的时间。

## 显存

加速设备上的内存，例如 GPU memory 或 NPU memory。KV cache 通常会大量占用显存。

## kv_role

`KVTransferConfig` 中描述当前 vLLM 实例在 KV transfer 拓扑里的业务角色。
常见取值包括 `kv_producer`、`kv_consumer`、`kv_both`。

## KVConnectorRole

vLLM 内部描述 connector 对象运行位置的角色。`SCHEDULER` 表示 scheduler 侧
connector，`WORKER` 表示 worker 侧 connector。它和 `kv_role` 不是同一个维度。

## Mooncake Store

Mooncake 中作为分布式 KV cache 存储层的组件。

## Transfer Engine

Mooncake 中负责在内存、设备和机器之间高效移动数据的组件。
