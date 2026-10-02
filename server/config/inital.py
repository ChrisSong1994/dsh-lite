# 初始化读取本地环境变量到配置里面

import os
from pathlib import Path

from dotenv import dotenv_values, load_dotenv

from utils.logger import get_logger


logger = get_logger(__name__)

_SENSITIVE_KEYWORDS = (
    "PASSWORD",
    "PASSWD",
    "SECRET",
    "TOKEN",
    "API_KEY",
    "PRIVATE_KEY",
    "DATABASE_URL",
    "DSN",
)


def _format_value(key: str, value: str | None) -> str:
    if value is None:
        return "<unset>"

    normalized_key = key.upper()
    if any(keyword in normalized_key for keyword in _SENSITIVE_KEYWORDS):
        return "<redacted>"

    return value


class AppConfig:
    @classmethod
    def boost(cls) -> None:
        env_path = Path(__file__).resolve().parent.parent / ".env"
        if not env_path.is_file():
            logger.warning("未找到环境变量文件: %s", env_path)
            cls.DATABASE_HOST = os.getenv("DATABASE_HOST")
            return

        env_values = dotenv_values(env_path)
        existing_env = dict(os.environ)
        load_dotenv(env_path)

        logger.info("已加载环境变量文件: %s", env_path)
        for key, file_value in env_values.items():
            if key in existing_env:
                value = existing_env[key]
                source = "进程环境"
            else:
                value = os.environ.get(key, file_value)
                source = ".env"

            logger.info(
                "  %s=%s (来源: %s)",
                key,
                _format_value(key, value),
                source,
            )

        cls.DATABASE_HOST = os.getenv("DATABASE_HOST")
