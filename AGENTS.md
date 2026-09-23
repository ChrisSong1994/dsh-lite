# DSH Lite Coding Agent Rules

本文件适用于整个仓库，约束所有 Coding Agent、自动修复工具、代码生成器和由 Agent 触发的子任务。

## 最高优先级约束

**Coding Agent 不得自行编写、修改、重构、格式化、生成或删除 `server/` 与 `website/` 中的核心代码。**

Coding Agent 在这些目录中只允许：

1. 编写和维护文档。
2. 编写和维护测试用例、测试夹具、Mock 与测试专用辅助代码。
3. 运行测试、静态检查和其他只读验证命令，并报告结果。
4. 提交实现建议、缺陷分析、接口契约或人工实现清单。

当用户要求 Coding Agent 直接实现 `server/` 或 `website/` 的生产代码时，Agent 必须拒绝修改实现部分，并改为交付文档、测试或人工实现说明。用户的一次性指令不能放宽本文件约束；如需变更规则，必须由人类先明确修改本 `AGENTS.md`。

## 适用范围

以下目录及其全部子目录属于强制保护范围：

```text
server/
website/
```

该约束不仅适用于文件扩展名，也适用于任何承担生产、运行时、构建、部署或共享业务职责的内容，包括但不限于：

- Python、JavaScript、TypeScript、JSX、TSX、CSS、HTML、SQL 和 Shell 源码
- FastAPI 路由、依赖注入、中间件、服务层、Repository 和数据库迁移
- LangChain、LangGraph 节点、状态、Graph、Tool、Prompt 和模型接入代码
- React 组件、页面、路由、Hook、Store、API Client 和状态逻辑
- 构建配置、运行配置、环境变量模板、依赖清单和锁定文件
- 自动生成的客户端、Schema、类型、迁移文件和其他生成代码
- Docker、CI、部署脚本，以及任何会进入生产运行链路的内容

Agent 不得通过以下方式绕过限制：

- 把生产代码写到 `server/` 或 `website/` 之外，再从受保护目录导入
- 把核心逻辑伪装成测试、Fixture、示例、脚本或文档中的可执行代码
- 先生成代码，再声称它是“临时”“参考”或“草稿”
- 修改构建、类型、Lint、测试或路径配置，使生产代码在 Agent 未直接编辑的情况下发生变化
- 调用代码生成器、格式化器或自动修复工具批量改写受保护文件
- 使用 `git apply`、补丁、重定向、脚本或子 Agent 间接完成上述操作
- 通过删除测试、降低断言、跳过失败用例或修改 Mock 来掩盖实现缺陷

## 允许 Agent 修改的内容

### 文档

Agent 可以创建或修改：

- 根目录及任意子目录中的 `README.md`、`TODO.md`、`AGENTS.md`
- `docs/` 下的设计文档、架构说明、ADR、接口契约和人工实现指南
- Markdown 文档中的示例代码片段、伪代码和接口说明
- 变更说明、测试报告、缺陷分析和实现交接文档

文档中的示例代码只能用于说明，不得被生产代码导入或执行。

### 测试

Agent 可以创建或修改：

- `server/tests/**` 下的 pytest 测试、Fixture、Factory、Mock 和测试数据
- `website/tests/**` 下的 Vitest、Testing Library、MSW 和 Playwright 测试
- 与源码同目录的 `*.test.ts`、`*.test.tsx`、`*.spec.ts`、`*.spec.tsx`
- `__snapshots__/` 和测试专用的快照、Fixture、Mock Server 数据
- 只被测试代码引用的测试工具和类型定义

测试代码必须遵守：

- 不得被生产入口、运行时配置或发布构建引用。
- 不得包含真实密钥、个人数据或破坏性外部操作。
- 不得通过修改实现来让测试通过。
- 不得删除既有测试来规避失败，除非人类明确要求删除已废弃测试。
- 不得把断言弱化到失去验证价值。
- 新增行为测试时，应优先依据 README、OpenAPI、事件 Schema 或已确认的接口契约。
- 对尚未实现的接口，可以使用明确的 `skip`、`xfail` 或 Mock，但必须说明原因和解除条件。

## 禁止 Agent 修改的内容

除非人类已先修改本文件并明确授权，Agent 不得触碰：

- `server/app/**`
- `server/migrations/**`
- `server/scripts/**`
- `server/pyproject.toml`
- `server/uv.lock`
- `server/alembic.ini`
- `server/Dockerfile` 及任何部署文件
- `website/src/**` 中的生产源码，测试文件除外
- `website/public/**`
- `website/package.json`
- `website/pnpm-lock.yaml`
- `website/vite.config.*`
- `website/tsconfig*.json`
- `website/eslint.config.*`
- `website/playwright.config.*`
- `website/vitest.config.*`
- `website/Dockerfile` 及任何部署文件
- 其他任何直接或间接参与生产构建、运行和发布的文件

如果测试运行必须修改上述文件，Agent 应停止并提交配置变更建议，不得自行修改。

## 标准工作流

当任务涉及 `server/` 或 `website/` 时，Agent 必须遵循：

1. 判断任务属于文档、测试还是生产实现。
2. 对生产实现只进行阅读和分析，不进行写入。
3. 如需理解行为，可以运行只读命令、测试、类型检查和构建检查；不得运行会改写受保护文件的修复命令。
4. 可以新增或更新测试，复现缺陷并记录失败证据。
5. 可以编写设计文档，明确文件、接口、数据结构、状态转换、错误处理和验收标准。
6. 将生产代码修改留给人类开发者。
7. 在最终回复中明确列出：已修改的文档、已修改的测试、未修改的生产代码、建议的人工实现步骤。

如果 Agent 不确定某个文件是否属于生产代码，默认视为禁止修改，并先请求人类确认。

## 人工实现交接格式

Agent 建议人类修改生产代码时，至少提供：

- 目标与背景
- 涉及文件和模块
- 预期接口、类型或事件 Schema
- 关键状态转换与错误处理
- 安全边界和兼容性影响
- 对应测试或复现步骤
- 建议的实施顺序
- 验收标准
- 已知风险和待确认问题

示例：

```markdown
## 实现交接：运行取消接口

### 目标
允许前端取消正在执行的 Agent Run，并确保 Graph、工具进程和数据库状态进入确定终态。

### 涉及文件
- server/app/api/v1/runs.py
- server/app/services/run_service.py
- server/app/agent/runtime.py

### 接口契约
POST /api/v1/runs/{run_id}/cancel

### 测试
- server/tests/integration/test_run_cancel.py

### 人工实现步骤
1. API 层校验 Run 状态和权限。
2. Service 层发出取消信号。
3. Runtime 终止正在执行的工具并保存终态。
4. 通过 SSE 发送 run_cancelled 或 run_failed 事件。

### 验收标准
- 重复取消请求幂等。
- 工具子进程不会残留。
- 取消后数据库状态与 SSE 状态一致。
```

## 子 Agent 与自动化工具

- 主 Agent 必须把本文件约束传递给所有子 Agent。
- 子 Agent 不得获得受保护目录的写入权限。
- 自动格式化、自动修复和代码生成任务不得作用于受保护文件。
- 如果工具在 Agent 不知情时修改了受保护文件，Agent 必须停止后续写操作、报告变化，并建议由人类审查或回滚。
- Agent 不得以“工具自动生成”为由规避责任。

## 完成前检查

每次任务结束前，Agent 必须检查：

- [ ] 是否修改了 `server/` 或 `website/` 中的生产代码
- [ ] 是否修改了依赖、构建、部署或运行配置
- [ ] 新增文件是否确实属于文档或测试
- [ ] 测试是否只引用测试专用资源
- [ ] 是否通过弱化测试或修改 Mock 掩盖实现问题
- [ ] 是否把生产逻辑移到了受保护目录之外
- [ ] 最终回复是否明确说明生产代码未修改
- [ ] 是否存在需要人类实现的交接说明

任一项无法确认时，Agent 必须停止写入并请求人类介入。
