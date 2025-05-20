ARG TARGETPLATFORM=linux/amd64
FROM --platform=${TARGETPLATFORM} debian:12-slim AS builder

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    curl \
    jq \
    unzip \
    ca-certificates && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app/EasyBot

COPY get_url.sh .

RUN chmod +x get_url.sh && \
    download_url=$(./get_url.sh) && \
    echo "🔗 下载URL: $download_url" && \
    curl -#SLo app.zip "$download_url" && \
    unzip -o app.zip && \
    rm -f app.zip get_url.sh && \
    chmod +x EasyBot

FROM --platform=${TARGETPLATFORM} mcr.microsoft.com/dotnet/aspnet:8.0-jammy AS runtime

WORKDIR /app/EasyBot

RUN ln -fs /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata && \
    rm -rf /var/lib/apt/lists/*

COPY --from=builder /app/EasyBot /app/EasyBot
COPY entrypoint.sh /app/EasyBot/entrypoint.sh

RUN chmod +x /app/EasyBot/*

ENTRYPOINT ["/bin/sh", "/app/EasyBot/entrypoint.sh"]