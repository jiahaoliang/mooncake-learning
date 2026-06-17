# 集成映射

读源码和文档时，持续更新这张表。

| Mooncake 概念 | vLLM 概念 | vLLM Ascend 概念 | 备注 |
| --- | --- | --- | --- |
| Transfer Engine | KV connector | Ascend transport | 在 producer 和 consumer 进程/节点之间移动 KV。 |
| Mooncake Store | MooncakeStoreConnector | AscendStoreConnector | 提供共享 KV 存储和 prefix 复用。 |
| PD disaggregation | MooncakeConnector | MooncakeLayerwiseConnector | 拆分 prefill 和 decode 执行。 |
| KV load failure | kv_load_failure_policy | recompute / fail behavior | 定义 remote KV 无法加载时的处理方式。 |
| Buffer registration | KV block metadata | Ascend memory registration | 读到具体代码路径后继续补充。 |

## 关键源码入口

| 方向 | 入口 |
| --- | --- |
| vLLM connector 抽象 | `repos/vllm/vllm/distributed/kv_transfer/kv_connector/v1/base.py` |
| vLLM connector 加载 | `repos/vllm/vllm/distributed/kv_transfer/kv_connector/factory.py` |
| vLLM Mooncake P2P | `repos/vllm/vllm/distributed/kv_transfer/kv_connector/v1/mooncake/mooncake_connector.py` |
| vLLM Mooncake Store | `repos/vllm/vllm/distributed/kv_transfer/kv_connector/v1/mooncake/store/` |
| vLLM Ascend P2P | `repos/vllm-ascend/vllm_ascend/distributed/kv_transfer/kv_p2p/` |
| vLLM Ascend KV pool | `repos/vllm-ascend/vllm_ascend/distributed/kv_transfer/kv_pool/ascend_store/` |
| Mooncake Python connector | `repos/Mooncake/mooncake-wheel/mooncake/mooncake_connector_v1.py` |
| Mooncake Store client | `repos/Mooncake/mooncake-store/include/real_client.h` |
| Mooncake Ascend transport | `repos/Mooncake/mooncake-transfer-engine/src/transport/ascend_transport/` |

## 待完成流程图

```text
MooncakeConnector:
prefill worker -> Mooncake transfer -> decode worker

MooncakeStoreConnector:
vLLM instance -> Mooncake Store put/get -> prefix cache reuse

AscendStoreConnector:
vLLM Ascend -> AscendStoreConnector -> Mooncake backend -> Mooncake Store
```

## 阅读规则

每追踪一条 request 路径，都尽量回答：

- 现在谁拥有 KV？
- KV 存在哪里？
- 什么时候注册？
- 什么时候传输？
- 什么时候释放？
- transfer 或 load 失败后怎么办？
