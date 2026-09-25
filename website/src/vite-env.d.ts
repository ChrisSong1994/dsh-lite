/// <reference types="vite/client" />

interface ImportMetaEnv {
  readonly VITE_PORT: string
  readonly VITE_API_BASE_URL: string
  readonly VITE_DEV_PROXY_TARGET: string
  readonly VITE_SSE_RECONNECT_MAX_RETRIES: string
  readonly VITE_MERMAID_ENABLED: string
}

interface ImportMeta {
  readonly env: ImportMetaEnv
}