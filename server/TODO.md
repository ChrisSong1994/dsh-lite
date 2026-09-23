# DSH Lite Server TODO

本文档跟踪后端从工程初始化到可发布版本的开发任务。任务完成后勾选，并同步更新 README、配置示例和 OpenAPI 契约。

## Phase 0：工程初始化

- [ ] 使用 uv 初始化 Python 3.12+ 工程
- [ ] 在 `pyproject.toml` 中拆分主依赖和 dev 依赖
- [ ] 接入 FastAPI、Uvicorn 和 Pydantic Settings
- [ ] 接入 LangChain、`langchain-openai` 和 LangGraph
- [ ] 接入 SQLAlchemy、aiosqlite、Alembic 和 SQLite Checkpointer
- [ ] 接入 sse-starlette、HTTPX、Tenacity 和 structlog
- [ ] 配置 Ruff、mypy、pytest 和 pytest-asyncio
- [ ] 创建 `.env.example`、`.gitignore` 和本地数据目录约定
- [ ] 生成并提交 `uv.lock`
- [ ] 验证 `uv sync --all-groups`、启动、测试和静态检查命令

## Phase 1：FastAPI 基础

- [ ] 创建 `app/main.py` 和 FastAPI application factory
- [ ] 实现 `/healthz` 和版本信息接口
- [ ] 创建 `/api/v1` Router 和统一响应结构
- [ ] 实现配置加载、环境切换和启动校验
- [ ] 实现结构化日志、请求 ID 和耗时中间件
- [ ] 实现统一异常类型与错误响应
- [ ] 配置 CORS，仅允许明确的开发和生产来源
- [ ] 生成稳定 OpenAPI，并纳入接口契约测试
- [ ] 增加启动、健康检查和配置测试

## Phase 2：数据库与仓储

- [ ] 定义 Session、Message、Run、ToolCall、Approval 数据模型
- [ ] 配置 async SQLAlchemy Engine 和 Session Factory
- [ ] 实现 Repository 接口与 SQLite 实现
- [ ] 配置 Alembic，并创建初始迁移
- [ ] 实现事务边界和并发写入处理
- [ ] 实现会话与消息 CRUD 服务
- [ ] 实现运行状态与工具调用审计持久化
- [ ] 实现测试数据库 Fixture 和迁移测试
- [ ] 验证进程重启后数据完整可读

## Phase 3：LangGraph 最小闭环

- [ ] 定义 `AgentState`、消息 Reducer 和运行上下文
- [ ] 实现 `prepare_context` 节点
- [ ] 实现 DeepSeek `ChatOpenAI` 模型工厂
- [ ] 实现 `call_model` 节点和流式事件桥接
- [ ] 实现条件路由与最终回答节点
- [ ] 实现 `step_count` 和最大步数保护
- [ ] 编译 Graph 并创建应用级单例
- [ ] 使用 Fake Model 完成无网络单元测试
- [ ] 使用真实 DeepSeek Key 完成一次手工集成验证

## Phase 4：LangGraph 持久化与恢复

- [ ] 接入 SQLite Checkpointer
- [ ] 为每个会话生成稳定的 `thread_id`
- [ ] 持久化每个 Run 的图状态和节点进度
- [ ] 实现中断后恢复运行
- [ ] 实现进程重启后的运行状态审计
- [ ] 处理重复请求、幂等创建和并发 Run 冲突
- [ ] 实现取消信号传播和终态落库
- [ ] 增加 Checkpoint、恢复和并发测试

## Phase 5：工具注册与执行

- [ ] 实现工具注册表、Schema 和元数据定义
- [ ] 实现 `list_files`
- [ ] 实现 `read_file`
- [ ] 实现 `search_files`
- [ ] 实现 `write_file`
- [ ] 实现 `edit_file`
- [ ] 实现 `run_command`
- [ ] 实现 `todo_write`
- [ ] 使用 LangChain `ToolNode` 或受控执行器运行工具
- [ ] 将工具参数、结果、错误和耗时写入审计表
- [ ] 限制并发、输出长度、执行超时和文件大小
- [ ] 为每个工具增加正常、边界和恶意输入测试

## Phase 6：安全策略与审批

- [ ] 实现工作区路径规范化和逃逸检测
- [ ] 拒绝符号链接逃逸和敏感系统路径
- [ ] 实现工具风险分级和默认策略
- [ ] 使用 LangGraph `interrupt()` 实现审批暂停
- [ ] 实现 `Command(resume=...)` 恢复批准或拒绝结果
- [ ] 实现审批超时、取消和过期状态
- [ ] 使用参数数组和 `create_subprocess_exec` 执行命令
- [ ] 限制环境变量、工作目录、超时和输出
- [ ] 增加路径穿越、命令注入和审批绕过测试
- [ ] 完成一次安全威胁建模和审计

## Phase 7：运行 API 与 SSE

- [ ] 实现创建会话接口
- [ ] 实现会话列表、详情、删除和消息查询接口
- [ ] 实现创建 Run 接口
- [ ] 实现 Run 详情和事件流接口
- [ ] 实现取消 Run 接口
- [ ] 实现审批接口
- [ ] 定义稳定的 SSE 事件 Schema
- [ ] 为事件生成 `event_id`、序号和时间戳
- [ ] 支持 `Last-Event-ID` 续传和事件去重
- [ ] 处理客户端断开、心跳和慢消费者
- [ ] 增加 API 和 SSE 集成测试

## Phase 8：可观察性与可靠性

- [ ] 记录模型调用耗时、token 和重试次数
- [ ] 记录工具调用耗时、结果状态和审批结果
- [ ] 实现模型限流、超时和网络错误重试
- [ ] 实现上下文长度检查和裁剪策略
- [ ] 实现结构化错误码和用户可读错误消息
- [ ] 实现运行超时和孤儿 Run 清理
- [ ] 增加日志脱敏，禁止输出 API Key 和敏感路径
- [ ] 增加 Metrics 接口或 OpenTelemetry 接入点
- [ ] 增加故障恢复和压力测试

## Phase 9：发布与扩展

- [ ] 增加 Dockerfile 和本地开发 Compose
- [ ] 增加生产启动配置和优雅退出
- [ ] 增加数据库备份、迁移和恢复说明
- [ ] 评估 PostgreSQL Checkpointer 和业务存储适配
- [ ] 抽象模型 Provider，支持切换其他 OpenAI 兼容模型
- [ ] 评估 MCP 工具接入和远程工具隔离
- [ ] 增加 Agent 评测、回放和回归数据集
- [ ] 完成依赖漏洞扫描和安全审查

## 发布验收标准

- [ ] 创建会话后可完成至少一次多步工具调用
- [ ] 模型文本和工具事件可以通过 SSE 实时输出
- [ ] 高风险工具必须经过审批，拒绝后不会执行
- [ ] 所有文件操作均限制在配置工作区内
- [ ] Run 中断、取消和进程重启后的状态可判定
- [ ] 会话、消息、运行和审计记录持久化正确
- [ ] `uv run pytest`、Ruff 和 mypy 全部通过
- [ ] OpenAPI、README、`.env.example` 与实际行为一致
