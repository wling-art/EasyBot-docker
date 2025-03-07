import sys

import requests

# 基础 URL
BASE_URL = "https://files.inectar.cn"


# 获取最新版本的下载 URL
def get_latest_url():
    try:
        list_response = requests.get(f"{BASE_URL}/d/ftp/easybot/latest.json")
        list_response.raise_for_status()
        return list_response.json()["downloads"]["linux-x64"]["url"]

    except Exception as e:
        print(f"错误: {e}", file=sys.stderr)
        sys.exit(1)


if __name__ == "__main__":
    # 输出下载 URL
    print(get_latest_url())
