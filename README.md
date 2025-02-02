# EasyBot Docker

This repository provides a Docker setup for EasyBot.

## 灵感来源

本项目的灵感来源于 [xrcuo/EasyBot-docker](https://github.com/xrcuo/EasyBot-docker)。

## Docker 镜像

Docker 镜像已经上传至 DockerHub，镜像名称为 `wlingxd/easybot`，标签为 `latest`。

[DockerHub](https://hub.docker.com/repository/docker/wlingxd/easybot/general)

## 快速开始

以下是一些常用的 Docker 命令来运行 EasyBot：

### 拉取镜像

```sh
docker pull wlingxd/easybot:latest
```

### 运行容器

command:

```sh
docker run -d \
  --name easybot \
  --restart always \
  -v $(pwd)/EasyBot:/data \
  -p 5000:5000 \
  -p 26990:26990 \
  wlingxd/easybot:latest
```

docker-compose.yml:

```yaml
services:
  easybot:
    image: wlingxd/easybot:latest
    container_name: easybot
    restart: always
    volumes:
      - ./EasyBot:/data
    ports:
      - "5000:5000"
      - "26990:26990"
```

### 查看日志

```sh
docker logs -f easybot
```

## 贡献

欢迎提交 Issue 和 Pull Request 来帮助改进此项目。

## 许可证

本项目采用 MIT 许可证。详情请参阅 LICENSE 文件。
