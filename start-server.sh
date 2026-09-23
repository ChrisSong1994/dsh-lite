#!/usr/bin/env sh

# 兼容 bash、zsh 和 sh 直接执行，例如：
#   ./start-server.sh
#   zsh ./start-server.sh
#   bash ./start-server.sh
set -eu

ROOT_DIR=$(cd "$(dirname "$0")" && pwd)
SERVER_DIR="${ROOT_DIR}/server"
ENV_FILE="${SERVER_DIR}/.env"

if [ ! -f "${SERVER_DIR}/main.py" ]; then
  echo "错误：未找到 ${SERVER_DIR}/main.py" >&2
  exit 1
fi

if [ -f "${ENV_FILE}" ]; then
  set -a
  # shellcheck disable=SC1090
  . "${ENV_FILE}"
  set +a
  echo "已加载环境变量：${ENV_FILE}"
else
  echo "提示：未找到 ${ENV_FILE}，将使用当前环境变量"
fi

HOST="${DSH_HOST:-127.0.0.1}"
PORT="${DSH_PORT:-3099}"
FASTAPI_BIN="${SERVER_DIR}/.venv/bin/fastapi"
FASTAPI_EXE="${SERVER_DIR}/.venv/Scripts/fastapi.exe"

cd "${SERVER_DIR}"

echo "启动 DSH Lite Server：http://${HOST}:${PORT}"
echo "健康检查：http://${HOST}:${PORT}/healthz"
echo "接口文档：http://${HOST}:${PORT}/docs"

if [ -x "${FASTAPI_BIN}" ]; then
  exec "${FASTAPI_BIN}" dev main.py --host "${HOST}" --port "${PORT}"
fi

if [ -x "${FASTAPI_EXE}" ]; then
  exec "${FASTAPI_EXE}" dev main.py --host "${HOST}" --port "${PORT}"
fi

if command -v uv >/dev/null 2>&1; then
  exec uv run fastapi dev main.py --host "${HOST}" --port "${PORT}"
fi

echo "错误：未找到 ${FASTAPI_BIN} 或 uv" >&2
exit 1
