#!/bin/bash

# 定义EasyBot配置文件路径
EASYBOT_PATH=/app/EasyBot/appsettings.json
# 初始化EasyBot配置文件
INIT() {
  cat <<EOF > $EASYBOT_PATH
{
  "Logging": {
    "LogLevel": {
      "Default": "Information",
      "Microsoft": "Warning",
      "Microsoft.Hosting.Lifetime": "Information"
    }
  },
  "AllowedHosts": "*",
  "ServerOptions": {
    "Host": "0.0.0.0",
    "Port": 26990,
    "HeartbeatInterval": "0.00:02:00"
  },
  "Kestrel": {
    "Endpoints": {
      "web_app": {
        "Url": "$WEB_HOST",
        "Protocols": "Http1"
      }
    }
  },
  "ProSettings": {
    "NavTheme": "light",
    "HeaderHeight": 48,
    "Layout": "side",
    "ContentWidth": "Fluid",
    "FixedHeader": true,
    "FixSiderbar": true,
    "Title": "EasyBot",
    "PrimaryColor": "daybreak",
    "ColorWeak": false,
    "SplitMenus": false,
    "HeaderRender": true,
    "FooterRender": true,
    "MenuRender": true,
    "MenuHeaderRender": true
  }
}
EOF
}

appsettings() {
  if [ ! -f "$EASYBOT_PATH" ]; then
    : ${WEB_HOST:='http://0.0.0.0:5000'}
    : ${SERVER_PORT:='26990'}
    INIT


  fi
}


main(){
  appsettings
}

main
/app/EasyBot/EasyBot