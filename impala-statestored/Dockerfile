# syntax=docker/dockerfile:1

ARG IMPALA_VERSION=4.5.0

FROM ubuntu:20.04 AS impala-package
ARG IMPALA_VERSION
ARG TARGETARCH

RUN apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates wget dpkg-dev \
    && rm -rf /var/lib/apt/lists/*

RUN set -eu; \
    ARCH="${TARGETARCH:-}"; \
    if [ -z "${ARCH}" ]; then \
      case "$(uname -m)" in \
        x86_64) ARCH=amd64 ;; \
        aarch64|arm64) ARCH=arm64 ;; \
        *) echo "Unsupported architecture: $(uname -m)" >&2; exit 1 ;; \
      esac; \
    fi; \
    case "${ARCH}" in \
      amd64) PKG="apache-impala-${IMPALA_VERSION}-RELEASE_hive-3.1.3-x86_64.ubuntu-20.04.deb" ;; \
      arm64) PKG="apache-impala-${IMPALA_VERSION}-RELEASE_hive-3.1.3-aarch64.ubuntu-20.04.deb" ;; \
      *) echo "Unsupported architecture: ${ARCH}" >&2; exit 1 ;; \
    esac; \
    wget -qO /tmp/impala.deb \
      "https://github.com/apache/impala/releases/download/${IMPALA_VERSION}/${PKG}"; \
    dpkg-deb -x /tmp/impala.deb /extract; \
    cp -a /extract/opt/impala /opt/impala; \
    rm -rf /tmp/impala.deb /extract

COPY scripts/setup-layout.sh /tmp/setup-layout.sh
RUN chmod +x /tmp/setup-layout.sh && /tmp/setup-layout.sh

FROM ubuntu:20.04

ARG IMPALA_VERSION=4.5.0

LABEL org.opencontainers.image.title="Apache Impala statestored" \
      org.opencontainers.image.version="${IMPALA_VERSION}"

USER root

COPY scripts/install_os_packages.sh /root/install_os_packages.sh
RUN chmod +x /root/install_os_packages.sh \
    && /root/install_os_packages.sh --install-debug-tools basic

RUN groupadd -r impala -g 1000 \
    && useradd --no-log-init -r -u 1000 -g 1000 impala \
    && chmod ugo+w /etc/passwd

COPY --from=impala-package --chown=impala:impala /opt/impala /opt/impala
COPY --chown=impala:impala scripts/daemon_entrypoint.sh scripts/graceful_shutdown_backends.sh /opt/impala/bin/
RUN chmod +x /opt/impala/bin/daemon_entrypoint.sh /opt/impala/bin/graceful_shutdown_backends.sh

USER impala
WORKDIR /opt/impala

RUN /opt/impala/bin/daemon_entrypoint.sh /opt/impala/bin/statestored --version

EXPOSE 25010

ENTRYPOINT ["/opt/impala/bin/daemon_entrypoint.sh", "/opt/impala/bin/statestored", \
            "-log_dir=/opt/impala/logs", \
            "-use_resolved_hostname=true"]
