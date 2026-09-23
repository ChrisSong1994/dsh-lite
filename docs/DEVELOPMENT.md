# DSH Lite 开发环境与端口约定

本文档是 DSH Lite 本地开发环境的统一约定，用于避免前端、后端、代理和文档之间出现端口冲突。

> 本文件只描述开发环境约定，不修改或替代生产部署配置。

## 端口约定

| 服务 | 开发端口 | 默认监听地址 | 访问地址 | 说明 |
| --- | ---: | --- | --- | --- |
| 前端 Website | `3090` | `127.0.0.1` | `http://127.0.0.1:3090` | Vite 开发服务器 |
| 后端 Server | `3099` | `127.0.0.1` | `http://127.0.0.1:3099` | FastAPI / Uvicorn |

端口分配原则：

- `3090` 只用于 React 前端开发服务器。
- `3099` 只用于 FastAPI 后端服务。
- 前端不直接访问 DeepSeek，所有模型请求由后端发出。
- 前端默认请求同源 `/api/v1`，开发环境由 Vite Proxy 转发到 `http://127.0.0.1:3099`。
- 后端 CORS 默认只允许开发前端来源 `http://127.0.0.1:3090`。

## 本地请求链路

```text
浏览器
  -> http://127.0.0.1:3090
  -> Vite 开发服务器
  -> /api/v1/*
  -> Vite Proxy
  -> http://127.0.0.1:3099
  -> FastAPI
```

推荐使用同源代理，不要在 React 生产代码中硬编码 `http://127.0.0.1:3099`。只有在明确采用跨域开发模式时，才需要直接请求后端地址，并同步配置后端 CORS。

## 环境变量约定

### 前端

```dotenv
VITE_PORT=3090
VITE_API_BASE_URL=/api/v1
VITE_DEV_PROXY_TARGET=http://127.0.0.1:3099
```

说明：

- `VITE_PORT` 控制 Vite 开发服务器端口。
- `VITE_API_BASE_URL` 保持为 `/api/v1`，通过代理访问后端。
- `VITE_DEV_PROXY_TARGET` 仅供 Vite 开发代理使用，不应包含任何密钥。
- 模型密钥、工作区根目录和数据库配置不得放入前端环境变量。

### 后端

```dotenv
DSH_HOST=127.0.0.1
DSH_PORT=3099
DSH_CORS_ORIGINS=http://127.0.0.1:3090
```

说明：

- `DSH_PORT=3099` 是 FastAPI 本地开发端口。
- `DSH_CORS_ORIGINS` 在跨域开发时需要包含前端地址 `http://127.0.0.1:3090`。
- 使用 Vite Proxy 时，浏览器请求仍为同源请求，但保留 CORS 配置可以支持直连调试。
- 生产环境应使用明确的域名和 HTTPS，不得直接复用本地 `localhost` 配置。

## 启动命令

### 后端

```bash
cd server
uv sync --all-groups
uv run uvicorn app.main:app --reload --host 127.0.0.1 --port 3099
```

后端地址：

- 健康检查：`http://127.0.0.1:3099/healthz`
- OpenAPI：`http://127.0.0.1:3099/docs`
- ReDoc：`http://127.0.0.1:3099/redoc`

### 前端

```bash
cd website
pnpm install
pnpm dev --host 127.0.0.1 --port 3090
```

前端地址：

- 工作台：`http://127.0.0.1:3090`
- API 代理：`http://127.0.0.1:3090/api/v1`

如果 `package.json` 中的 `dev` 脚本已经读取 `VITE_PORT`，则可以直接运行：

```bash
pnpm dev
```

## 联调检查

按以下顺序检查：

1. 后端健康检查返回成功：

   ```bash
   curl http://127.0.0.1:3099/healthz
   ```

2. 前端开发服务器可以访问：

   ```bash
   curl -I http://127.0.0.1:3090
   ```

3. 前端通过代理访问后端：

   ```bash
   curl http://127.0.0.1:3090/api/v1/sessions
   ```

4. 浏览器开发者工具中，API 请求的目标应为前端同源 `/api/v1`，而不是硬编码的后端绝对地址。

## 端口冲突处理

检查端口占用：

```bash
lsof -nP -iTCP:3090 -sTCP:LISTEN
lsof -nP -iTCP:3099 -sTCP:LISTEN
```

处理原则：

- 优先停止占用端口的旧进程，而不是随意修改约定端口。
- 临时改用其他端口时，必须同时更新启动命令、Vite Proxy、后端 CORS 和本文档。
- 不得只修改前端或后端其中一侧，导致联调地址不一致。
- 如需要永久变更端口，应先由人类更新本文档和相关配置，再由人类实现生产配置修改。

## 文档同步要求

任何端口变更必须同步更新：

- [根目录 README](../README.md)
- [后端 README](../server/README.md)
- [前端 README](../website/README.md)
- 本文档 `docs/DEVELOPMENT.md`
- 后续可能出现的 `.env.example`、Vite Proxy、FastAPI CORS 和启动脚本

根据根目录 [AGENTS.md](../AGENTS.md) 的约束，Coding Agent 可以维护本文件、README 和测试用例，但不得自行修改 `server/` 或 `website/` 中的生产代码、构建配置或部署配置。需要变更端口配置时，Agent 应提交人工实现交接说明。
