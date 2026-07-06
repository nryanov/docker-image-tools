# Impala

Multi-arch Docker images for [Apache Impala](https://impala.apache.org/) with **arm64** support. Official `apache/impala` images on Docker Hub are amd64-only; Impala has shipped native arm64 packages since **4.4.0**.

These images are built from official Apache release `.deb` packages and follow the same daemon layout as the upstream Impala Docker quickstart.

## Images

| Directory             | Image                              | Role                                   |
|-----------------------|------------------------------------|----------------------------------------|
| `impala/`             | `nryanov/tools-impala`             | Impala daemon (coordinator + executor) |
| `impala-statestored/` | `nryanov/tools-impala-statestored` | StateStore service                     |
| `impala-catalogd/`    | `nryanov/tools-impala-catalogd`    | Catalog service                        |
| `impala-hms/`         | `nryanov/tools-impala-hms`         | Hive Metastore (metadata)              |

All Impala daemon images default to **Impala 4.5.0**. Override at build time:

```bash
docker build --build-arg IMPALA_VERSION=4.4.1 -t my-impala ./impala
```

## Build

Single architecture (native):

```bash
docker build -t nryanov/tools-impala ./impala
docker build -t nryanov/tools-impala-statestored ./impala-statestored
docker build -t nryanov/tools-impala-catalogd ./impala-catalogd
docker build -t nryanov/tools-impala-hms ./impala-hms
```

Multi-arch (amd64 + arm64):

```bash
docker buildx build --platform linux/amd64,linux/arm64 -t nryanov/tools-impala ./impala --push
```

## Quickstart cluster

The four images mirror the [Impala Docker quickstart](https://github.com/apache/impala/tree/master/docker) services: HMS, statestored, catalogd, and impalad.

```bash
docker network create quickstart-network
export QUICKSTART_IP=$(docker network inspect quickstart-network -f '{{(index .IPAM.Config 0).Gateway}}')
export QUICKSTART_LISTEN_ADDR=${QUICKSTART_IP}

docker volume create impala-quickstart-warehouse

docker run -d --name quickstart-hms --network quickstart-network \
  -v impala-quickstart-warehouse:/var/lib/hive \
  -v impala-quickstart-warehouse:/user/hive/warehouse \
  nryanov/tools-impala-hms hms

docker run -d --name statestored --network quickstart-network \
  -p "${QUICKSTART_LISTEN_ADDR}:25010:25010" \
  nryanov/tools-impala-statestored \
  -redirect_stdout_stderr=false -logtostderr -v=1

docker run -d --name catalogd --network quickstart-network \
  -p "${QUICKSTART_LISTEN_ADDR}:25020:25020" \
  -v impala-quickstart-warehouse:/user/hive/warehouse \
  nryanov/tools-impala-catalogd \
  -redirect_stdout_stderr=false -logtostderr -v=1 \
  -hms_event_polling_interval_s=1 -invalidate_tables_timeout_s=999999

docker run -d --name impalad --network quickstart-network \
  -p "${QUICKSTART_LISTEN_ADDR}:21050:21050" \
  -p "${QUICKSTART_LISTEN_ADDR}:25000:25000" \
  -v impala-quickstart-warehouse:/user/hive/warehouse \
  -e 'JAVA_TOOL_OPTIONS=-Xmx1g' \
  nryanov/tools-impala \
  -v=1 -redirect_stdout_stderr=false -logtostderr -mem_limit=4gb
```

Connect with impala-shell (install separately):

```bash
impala-shell -i "${QUICKSTART_IP}:21050"
```

Set `QUICKSTART_LISTEN_ADDR=0.0.0.0` to accept connections from the host via `localhost`.

## Architecture notes

- **amd64** packages: `x86_64.ubuntu-20.04.deb`
- **arm64** packages: `aarch64.ubuntu-20.04.deb`
- Runtime base image: Ubuntu 20.04 (matches published package ABI, including OpenSSL 1.1)
- Impala daemons run as UID/GID 1000 (`impala` user), matching HMS volume ownership

## Ports

| Service     | Port  | Purpose           |
|-------------|-------|-------------------|
| impalad     | 21050 | HiveServer2 (SQL) |
| impalad     | 25000 | Web debug UI      |
| catalogd    | 25020 | Web debug UI      |
| statestored | 25010 | Web debug UI      |
| HMS         | 9083  | Thrift metastore  |
