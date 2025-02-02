FROM debian:12-slim

RUN apt-get update && apt-get install -y --no-install-recommends tzdata && \
    ln -fs /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata

RUN apt-get update && apt-get install -y --no-install-recommends \
    wget \
    unzip \
    libnss3 \
    libgdiplus \
    libgtk-3-0 \
    libdrm2 \
    libgbm1 \
    libasound2 \
    ca-certificates \
    && wget https://packages.microsoft.com/config/debian/12/packages-microsoft-prod.deb -O packages-microsoft-prod.deb \
    && dpkg -i packages-microsoft-prod.deb \
    && rm packages-microsoft-prod.deb \
    && apt-get update && apt-get install -y --no-install-recommends \
    dotnet-sdk-8.0 \
    aspnetcore-runtime-8.0 \
    python3 \
    python3-pip \
    python3-venv \
    && python3 -m venv /app/EasyBot/venv \
    && /app/EasyBot/venv/bin/pip install requests \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

WORKDIR /app/EasyBot

COPY get_url.py .

RUN /app/EasyBot/venv/bin/python3 get_url.py > download.url && \
    wget -q $(cat download.url) -O app.zip && \
    unzip -o app.zip -d /app/EasyBot && \
    rm -rf app.zip download.url get_url.py venv \
    && chmod +x /app/EasyBot/EasyBot


# 复制启动脚本
COPY entrypoint.sh /app/EasyBot/entrypoint.sh

WORKDIR /data

# 使用 sh 启动程序
ENTRYPOINT ["/bin/sh", "/app/EasyBot/entrypoint.sh"]