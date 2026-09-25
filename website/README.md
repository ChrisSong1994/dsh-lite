# DSH Lite Website

DSH Lite 的 React 前端工作台，负责会话管理、Agent 消息流展示、工具调用可视化、审批交互和运行配置。

> 当前状态：目录已创建，前端尚未初始化。本文档中的依赖版本、目录和命令是目标约定，初始化后应同步校准。

## 技术栈

| 领域       | 选型                                        | 用途                                 |
| ---------- | ------------------------------------------- | ------------------------------------ |
| 构建工具   | Vite 8                                      | 开发服务器、生产构建和资源优化       |
| UI 框架    | React 19 + TypeScript                       | 组件、类型安全和并发渲染             |
| 路由       | React Router                                | 嵌套路由、数据路由、参数和导航       |
| 服务端状态 | TanStack Query                              | API 缓存、请求去重、重试和失效更新   |
| 客户端状态 | Zustand                                     | 会话草稿、面板状态、临时 UI 状态     |
| 表单与校验 | React Hook Form + Zod                       | 设置表单、运行时校验和类型推导       |
| 样式       | Tailwind CSS + CSS Variables                | 设计令牌、响应式布局和主题           |
| 基础组件   | Radix UI Primitives                         | 无障碍 Dialog、Popover、Tooltip 等   |
| 图标       | Lucide React                                | 统一图标                             |
| Markdown   | react-markdown + remark + rehype            | 助手消息、说明和富文本渲染           |
| 代码高亮   | Shiki                                       | 构建时/运行时高亮，避免直接注入 HTML |
| 数学公式   | remark-math + rehype-katex                  | Markdown 中的 LaTeX 公式             |
| 图表       | Mermaid（按需加载）                         | 渲染 Mermaid 代码块                  |
| 流式通信   | Fetch SSE / `@microsoft/fetch-event-source` | 消费 Agent 运行事件                  |
| 长列表     | TanStack Virtual                            | 长会话和大型工具输出虚拟化           |
| 单元测试   | Vitest + Testing Library + MSW              | 组件、Hook 和 API 行为测试           |
| 端到端测试 | Playwright                                  | 核心用户流程验证                     |
| 代码质量   | ESLint + Prettier + TypeScript              | 静态检查、格式化和类型检查           |

Node.js 建议使用当前 LTS，包管理器统一使用 pnpm。项目初始化时通过 `pnpm create vite@latest . --template react-ts` 创建 Vite 8 工程，并锁定 `pnpm-lock.yaml`。

## 核心职责

- 展示会话列表、消息时间线和运行状态
- 通过 SSE 实时接收模型文本增量与工具事件
- 渲染 Markdown、代码块、数学公式和 Mermaid 图表
- 展示工具参数、执行结果、耗时、错误和文件差异
- 对高风险工具调用进行审批、拒绝或取消
- 恢复历史会话和未完成运行
- 展示 token 用量、上下文窗口和执行统计
- 提供工作区、模型参数和界面偏好设置

## 目标目录结构

```text
website/
├── public/
├── src/
│   ├── api/
│   │   ├── client.ts             # fetch 基础封装
│   │   ├── events.ts             # SSE 连接与事件解析
│   │   ├── sessions.ts           # 会话 API
│   │   └── runs.ts               # 运行与审批 API
│   ├── components/
│   │   ├── ui/                   # Button、Dialog、Tabs 等基础组件
│   │   ├── markdown/             # Markdown、代码块、Mermaid 渲染器
│   │   └── layout/               # AppShell、Sidebar、Header
│   ├── features/
│   │   ├── chat/                 # 消息输入、时间线、流式状态
│   │   ├── sessions/             # 会话列表与历史
│   │   ├── tools/                # 工具调用卡片和审批
│   │   ├── files/                # 文件预览和差异
│   │   └── settings/             # 模型、工作区和偏好设置
│   ├── hooks/
│   ├── lib/
│   │   ├── markdown.ts           # remark/rehype 插件配置
│   │   ├── query-client.ts
│   │   └── utils.ts
│   ├── pages/
│   ├── routes/
│   ├── stores/
│   ├── styles/
│   ├── types/
│   ├── App.tsx
│   └── main.tsx
├── tests/
│   ├── e2e/
│   └── setup.ts
├── .env.example
├── eslint.config.js
├── index.html
├── package.json
├── tsconfig.json
└── vite.config.ts
```

## 路由规划

| 路径                  | 页面       | 说明                       |
| --------------------- | ---------- | -------------------------- |
| `/`                   | 首页       | 重定向到最近会话或空状态   |
| `/chat`               | 新会话     | 创建并进入一次新会话       |
| `/chat/:sessionId`    | 会话工作台 | 消息、运行状态和工具交互   |
| `/sessions`           | 历史会话   | 搜索、筛选和删除会话       |
| `/settings`           | 设置       | 模型、工作区、主题和快捷键 |
| `/settings/models`    | 模型设置   | Provider、模型和生成参数   |
| `/settings/workspace` | 工作区设置 | 根目录、权限和忽略规则     |
| `*`                   | 404        | 未找到页面                 |

路由使用 React Router 的 data router 模式，页面级数据预取由 `loader` 或 TanStack Query 统一承担，不在组件中散落请求逻辑。

## 状态管理边界

前端状态按来源拆分，避免把所有内容塞进一个全局 Store：

| 状态类型       | 方案                           | 示例                             |
| -------------- | ------------------------------ | -------------------------------- |
| 服务端状态     | TanStack Query                 | 会话列表、消息、运行记录、设置   |
| 实时流状态     | Query Cache + 专用事件 Reducer | 文本增量、工具事件、连接状态     |
| 全局客户端状态 | Zustand                        | 侧栏、主题、当前面板、未提交输入 |
| 页面局部状态   | React state                    | 弹窗开关、临时筛选、表单焦点     |
| URL 状态       | React Router                   | 会话 ID、筛选条件、标签页        |

原则：

- 服务端数据只有一个缓存来源，组件不复制完整响应。
- SSE 事件必须先归一化，再写入 Query Cache 或消息 Reducer。
- 输入草稿按 `sessionId` 隔离，避免切换会话时串数据。
- 审批弹窗由运行事件驱动，不使用不可追踪的全局布尔值。

## 后端接口约定

前端默认请求 `/api/v1`，开发环境由 Vite Proxy 转发到 `http://127.0.0.1:3099`。Vite 开发服务器约定端口为 `3090`。核心接口包括：

```text
GET    /healthz
GET    /api/v1/sessions
POST   /api/v1/sessions
GET    /api/v1/sessions/{session_id}
DELETE /api/v1/sessions/{session_id}
GET    /api/v1/sessions/{session_id}/messages
POST   /api/v1/sessions/{session_id}/runs
GET    /api/v1/runs/{run_id}/events
POST   /api/v1/runs/{run_id}/cancel
POST   /api/v1/runs/{run_id}/approvals
```

SSE 事件统一使用可判别联合类型：

```ts
type RunEvent =
  | { type: 'run_started'; runId: string }
  | { type: 'text_delta'; runId: string; delta: string }
  | { type: 'tool_call'; runId: string; callId: string; name: string; arguments: unknown }
  | { type: 'tool_result'; runId: string; callId: string; result: unknown; durationMs: number }
  | {
      type: 'approval_required'
      runId: string
      approvalId: string
      toolName: string
      arguments: unknown
    }
  | { type: 'usage'; runId: string; inputTokens: number; outputTokens: number }
  | { type: 'run_completed'; runId: string }
  | { type: 'run_failed'; runId: string; error: { code: string; message: string } }
```

事件消费要求：

- 断线后携带 `Last-Event-ID` 尝试续传。
- 同一事件重复到达时按 `eventId` 幂等处理。
- 页面隐藏或卸载时主动关闭连接。
- 运行完成后刷新会话与运行记录缓存。
- 不在前端拼接 API Key 或直接调用模型服务。

## Markdown 渲染方案

助手消息使用以下插件链：

```text
react-markdown
  -> remark-gfm
  -> remark-math
  -> rehype-sanitize
  -> rehype-katex
  -> 自定义 code 组件
  -> Shiki / Mermaid 渲染器
```

安全与体验要求：

- 默认禁用原始 HTML，确需支持时使用严格白名单。
- 外部链接使用安全属性并明确打开方式。
- Mermaid 使用 `securityLevel: "strict"`，且只在用户展开时渲染。
- 超长代码块按需高亮，避免流式输出时反复执行昂贵解析。
- 流式文本可以按帧合并，但 Markdown 结构变化后必须重新解析。
- 复制代码、下载文件和跳转行号由独立组件处理。
- 所有渲染失败都应降级为可复制的纯文本。

## 环境变量

前端只允许暴露非敏感配置，统一使用 `VITE_` 前缀：

```dotenv
VITE_PORT=3090
VITE_API_BASE_URL=/api/v1
VITE_DEV_PROXY_TARGET=http://127.0.0.1:3099
VITE_SSE_RECONNECT_MAX_RETRIES=5
VITE_MERMAID_ENABLED=true
```

模型密钥、工作区根目录和服务端数据库配置只能由后端管理，不能放入前端环境变量。

## 开发命令

初始化完成后使用以下命令：

```bash
pnpm install
pnpm dev --host 127.0.0.1 --port 3090
pnpm build
pnpm preview
pnpm lint
pnpm typecheck
pnpm test
pnpm test:e2e
```

建议在 `package.json` 中固定：

```json
{
  "scripts": {
    "dev": "vite",
    "build": "tsc -b && vite build",
    "preview": "vite preview",
    "lint": "eslint .",
    "typecheck": "tsc -b --noEmit",
    "test": "vitest",
    "test:e2e": "playwright test"
  }
}
```

## 开发原则

1. **可访问性优先**：交互组件基于 Radix，键盘和屏幕阅读器可用。
2. **流式可恢复**：断线、刷新和切换会话后状态仍然一致。
3. **服务端状态单一来源**：Query Cache 不复制、不长期分叉。
4. **渲染安全**：Markdown、Mermaid 和文件内容均视为不可信输入。
5. **渐进加载**：编辑器、Mermaid、图表和大型预览按需加载。
6. **类型闭环**：API 类型、事件类型和表单 Schema 尽量从单一来源生成。

## 相关文档

- [开发环境与端口约定](../docs/DEVELOPMENT.md)
- [前端 TODO](./TODO.md)
- [后端说明](../server/README.md)
- [项目说明](../README.md)
