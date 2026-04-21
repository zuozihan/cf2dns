# cf2dns 使用说明

本项目用于获取 Cloudflare 优选 IP，并按配置更新到 DNS 解析记录（支持 DNSPod / 阿里云 / 华为云）。

## 1. 准备配置

```bash
cp .env.example .env
```

编辑 `.env`，至少填写这些字段：

- `DNS_SERVER`：DNS 服务商（`1`=DNSPod，`2`=阿里云，`3`=华为云）
- `SECRETID` / `SECRETKEY`：API 凭证
- `DOMAINS`：要更新的域名 JSON

常用可选项：

- `TYPE`：`v4` 或 `v6`
- `AFFECT_NUM`：每条线路更新条数
- `TTL`：DNS TTL
- `INTERVAL_SECONDS`：循环间隔（秒，默认 `900`，即 15 分钟）
- `LOG_FILE`：日志文件路径

`DOMAINS` 示例：

```json
{"example.com":{"@":["CM","CU","CT"]}}
```

---

## 2. 本地运行（Python）

安装依赖：

```bash
uv sync
# 或
pip install -r requirements.txt
```

执行：

```bash
uv run python cf2dns.py
# 或
python cf2dns.py
```

如需定时执行，建议用 cron 每 15 分钟运行一次。

---

## 3. Docker 运行（单容器）

```bash
docker run -d \
  --name cf2dns \
  --env-file ./.env \
  -e LOG_FILE=/app/logs/cf2dns.log \
  -v $(pwd)/docker-data/logs:/app/logs \
  dddb/cf2dns
```

查看日志：

```bash
tail -100f docker-data/logs/cf2dns.log
```

---

## 4. Docker Compose 运行（本地构建）

```bash
mkdir -p docker-data/logs
cp .env.example .env
# 修改 .env 后启动
docker compose up -d --build
```

查看日志：

```bash
tail -100f docker-data/logs/cf2dns.log
```

停止：

```bash
docker compose down
```

---

## 5. GitHub Actions 运行（可选）

1. Fork 本仓库。
2. 在仓库 `Settings -> Secrets and variables -> Actions` 中配置：
   - `DOMAINS`
   - `SECRETID`
   - `SECRETKEY`
   - （可选）`DOMAINSV6`
3. 按需修改 `.github/workflows/run.yml` 的执行频率。

