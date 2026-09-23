# DSH Lite Website TODO

本文档跟踪前端从初始化到可发布版本的开发任务。任务完成后勾选，并保持 README 中的技术栈和命令与实际工程一致。

## Phase 0：工程初始化

- [ ] 使用 pnpm 初始化 Vite 8 + React 19 + TypeScript 工程
- [ ] 配置 `@vitejs/plugin-react`、路径别名和严格 TypeScript 模式
- [ ] 接入 Tailwind CSS、CSS Variables 和基础设计令牌
- [ ] 配置 ESLint、Prettier 和提交前检查
- [ ] 配置 Vitest、Testing Library、jsdom 和 MSW
- [ ] 配置 Playwright 与本地测试环境
- [ ] 创建 `.env.example`、`.gitignore` 和编辑器配置
- [ ] 锁定 pnpm 版本并提交 `pnpm-lock.yaml`
- [ ] 验证 `pnpm dev`、`pnpm build`、`pnpm lint`、`pnpm typecheck`、`pnpm test`

## Phase 1：应用骨架与路由

- [ ] 创建 `AppShell`、侧栏、顶部栏和响应式布局
- [ ] 配置 React Router data router
- [ ] 实现 `/`、`/chat`、`/chat/:sessionId`、`/sessions`、`/settings`、404 路由
- [ ] 增加路由级错误页、加载态和懒加载边界
- [ ] 配置 Vite 开发代理，将 `/api` 转发到 FastAPI
- [ ] 实现主题切换、暗色模式和系统主题跟随
- [ ] 实现全局 Toast、Confirm Dialog 和错误边界
- [ ] 增加基础无障碍检查和键盘导航

## Phase 2：API 与状态基础

- [ ] 封装统一 fetch client、错误模型、超时和请求取消
- [ ] 配置 TanStack Query Client、重试策略和缓存失效规则
- [ ] 实现会话、消息、运行和设置 Query Hooks
- [ ] 创建 Zustand Store，管理侧栏、主题、面板和草稿状态
- [ ] 建立 API DTO 与前端领域模型之间的转换层
- [ ] 使用 Zod 校验关键外部响应和设置表单
- [ ] 处理 401、404、409、422、429 和 5xx 的统一反馈
- [ ] 添加 MSW Handler 和 Query Hook 单元测试

## Phase 3：会话与消息

- [ ] 实现会话列表、新建、重命名和删除
- [ ] 实现会话搜索、排序和最近访问
- [ ] 实现消息时间线、角色样式和时间分组
- [ ] 实现输入框、发送快捷键、停止生成和重新生成
- [ ] 按 `sessionId` 隔离输入草稿和滚动位置
- [ ] 实现空状态、首次使用引导和错误重试
- [ ] 为长会话接入虚拟列表
- [ ] 增加会话操作和消息渲染测试

## Phase 4：SSE 运行流

- [ ] 实现 SSE 客户端、事件解析和可判别联合类型
- [ ] 处理 `run_started`、`text_delta`、`tool_call`、`tool_result`
- [ ] 处理 `approval_required`、`usage`、`run_completed`、`run_failed`
- [ ] 实现文本增量批处理，减少 React 高频重渲染
- [ ] 实现事件去重和 `Last-Event-ID` 断线续传
- [ ] 实现重连退避、页面恢复和连接状态指示
- [ ] 运行结束后刷新会话、消息和运行记录缓存
- [ ] 页面卸载或切换会话时可靠关闭 EventSource
- [ ] 使用模拟 SSE 覆盖成功、断线、乱序和失败场景

## Phase 5：Markdown 与富内容

- [ ] 集成 `react-markdown`、`remark-gfm` 和 `remark-math`
- [ ] 集成 `rehype-sanitize` 和 `rehype-katex`
- [ ] 使用 Shiki 实现代码块高亮和语言标识
- [ ] 实现代码复制、换行切换和长内容折叠
- [ ] 实现 Mermaid 按需加载和严格安全模式
- [ ] 支持表格、任务列表、引用、脚注和外部链接
- [ ] 处理流式 Markdown 未闭合语法和渲染降级
- [ ] 增加 Markdown XSS、代码块和公式测试

## Phase 6：工具调用与审批

- [ ] 实现工具调用卡片、状态和耗时展示
- [ ] 按工具类型渲染参数摘要和结构化详情
- [ ] 实现命令输出终端视图和 ANSI 处理
- [ ] 实现文件读取预览、语法高亮和路径面包屑
- [ ] 实现文件 Diff 视图
- [ ] 实现审批弹窗，展示风险、参数和影响范围
- [ ] 支持批准一次、拒绝和取消运行
- [ ] 处理审批过期、重复提交和运行已结束状态
- [ ] 增加工具卡片和审批流程测试

## Phase 7：历史、设置与可观察性

- [ ] 实现历史会话分页、筛选和恢复
- [ ] 实现未完成运行提示和恢复入口
- [ ] 实现模型、温度、最大步数和流式开关设置
- [ ] 实现工作区选择和权限说明
- [ ] 展示 token 用量、耗时和步骤统计
- [ ] 增加运行事件调试面板，仅开发模式启用
- [ ] 实现前端错误上报接口或本地诊断导出

## Phase 8：质量、安全与性能

- [ ] 为核心页面和流程补充 Playwright E2E
- [ ] 完成键盘操作、焦点管理和屏幕阅读器检查
- [ ] 对 Markdown、Mermaid、链接和文件内容执行安全审计
- [ ] 检查 CSP、依赖漏洞和敏感信息泄漏
- [ ] 对大型会话、工具输出和代码块进行性能压测
- [ ] 使用 React Profiler 定位高频渲染
- [ ] 为 Mermaid、编辑器和大型预览配置代码分割
- [ ] 优化首屏资源、缓存策略和构建体积

## 发布验收标准

- [ ] 用户可以创建会话并收到流式回答
- [ ] 页面刷新或断线后可以恢复运行状态
- [ ] 工具调用、结果、错误和审批状态完整可见
- [ ] Markdown、代码、公式和 Mermaid 安全渲染
- [ ] 高风险工具未经审批不会执行
- [ ] 核心流程在桌面和窄屏下均可操作
- [ ] `pnpm build`、`pnpm lint`、`pnpm typecheck`、`pnpm test`、`pnpm test:e2e` 全部通过
- [ ] README、环境变量示例和实际实现一致
