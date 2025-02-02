import re
import sys
import requests

# 基础 URL
BASE_URL = "https://dl.inectar.cn"


# 解析版本号
def parse_version(name):
    """
    解析文件名中的版本号和后缀数字
    返回格式: ((主版本号), 后缀数字, 文件名)
    示例：
        "EasyBot-Linux-1.3.3-fix1.zip" -> ((1, 3, 3), 1, "EasyBot-Linux-1.3.3-fix1.zip")
        "EasyBot-Linux-1.3.4.zip"      -> ((1, 3, 4), 0, "EasyBot-Linux-1.3.4.zip")
    """
    match = re.match(r"EasyBot-Linux-(\d+)\.(\d+)\.(\d+)(?:-[^0-9]*(\d+))?\.zip", name)
    if match:
        major = tuple(map(int, match.groups()[:3]))  # 主版本号
        suffix = int(match.group(4) or 0)  # 后缀数字，默认为 0
        return (major, suffix, name)
    return None


# 获取最新版本的下载 URL
def get_latest_url():
    try:
        # 获取 token
        auth_response = requests.post(
            f"{BASE_URL}/api/auth/login",
            json={"username": "guest", "password": "guest"},
        )
        auth_response.raise_for_status()
        token = auth_response.json()["data"]["token"]

        # 获取文件列表
        list_response = requests.get(
            f"{BASE_URL}/api/fs/list",
            headers={"Authorization": token},
            params={
                "path": "/主程序_Linux",
                "page": 1,
                "per_page": 0,
                "refresh": False,
            },
        )
        list_response.raise_for_status()
        files = list_response.json()["data"]["content"]

        # 找到最大版本
        max_version = ((), -1, "")  # ((主版本号), 后缀数字, 文件名)
        for file in files:
            parsed = parse_version(file["name"])
            if not parsed:
                continue

            # 先比较主版本号，再比较后缀数字
            if (parsed[0] > max_version[0]) or (
                parsed[0] == max_version[0] and parsed[1] > max_version[1]
            ):
                max_version = parsed

        if not max_version[2]:
            raise Exception("未找到有效的版本文件")

        # 返回下载 URL
        return f"{BASE_URL}/d/主程序_Linux/{max_version[2]}"

    except Exception as e:
        print(f"错误: {e}", file=sys.stderr)
        sys.exit(1)


if __name__ == "__main__":
    # 输出下载 URL
    print(get_latest_url())
