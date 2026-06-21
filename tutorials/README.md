# Mooncake / vLLM / vLLM Ascend 教程系列

这个目录用于沉淀面向计算机科学本科生的连续教程。

## 定位

- 每期正文约 1500 字，不含图表和代码路径表。
- 先讲 big picture，再讲必要细节。
- 用图表解释系统关系。
- 代码只作为“延伸阅读入口”，不在正文中逐行走读。
- 目标是让读者先理解问题、架构和数据流，再按需进入源码。

## 推荐阅读顺序

| 期数 | 文件 | 主题 | 外部阅读 |
| --- | --- | --- | --- |
| 01 | `01-llm-inference-from-prompt-to-answer.md` | 从 Prompt 到回答：大模型推理的基本流程 | [从零开始理解大模型](https://github.com/GitHubxsy/nanoAgent/blob/book/llm/README.md) |
| 02 | `02-kv-cache-and-mooncake-big-picture.md` | 从 KV Cache 到 Mooncake：理解大模型推理服务的数据通路 | - |

## 术语表

术语统一维护在：

```text
glossary.md
```

教程正文提到关键术语时，优先链接到 `glossary.md` 中的对应小节。

## 每期结构

```text
# 标题

## 本期目标
## 背景问题
## 核心图解
## 关键概念
## 系统流程
## 代码入口
## 小结
```

## 和其他目录的关系

- `tutorials/`：可阅读的教程成稿。
- `repos/`：上游源码，作为教程和笔记的事实来源。
