#!/bin/sh
set -e

BASE_URL="https://files.inectar.cn"
JSON_URL="$BASE_URL/d/ftp/easybot/latest.json"

json_data=$(curl -sSLf --retry 3 --retry-delay 2 "$JSON_URL") || {
    echo "❌ 无法获取版本信息" >&2
    exit 1
}

download_url=$(echo "$json_data" | jq -er '.downloads["linux-x64"].url') || {
    echo "❌ JSON解析失败" >&2
    exit 1
}

case "$download_url" in
    http*) ;;
    *) download_url="$BASE_URL$download_url" ;;
esac

printf "%s" "$download_url"