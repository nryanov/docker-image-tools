# syntax=docker/dockerfile:1

# Hive Metastore (HMS) for Impala quickstart clusters.
# Uses Apache Hive 3.1.3 with an embedded Derby database.

ARG HIVE_VERSION=3.1.3
ARG HADOOP_VERSION=3.3.6

FROM ubuntu:20.04

ARG HIVE_VERSION
ARG HADOOP_VERSION

LABEL org.opencontainers.image.title="Apache Impala Hive Metastore" \
      org.opencontainers.image.description="Hive Metastore service for Impala quickstart deployments"

USER root

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       ca-certificates \
       curl \
       iproute2 \
       iputils-ping \
       less \
       netcat-openbsd \
       openjdk-8-jre-headless \
       tzdata \
       vim \
    && rm -rf /var/lib/apt/lists/*

RUN groupadd -r hive -g 1000 \
    && useradd --no-log-init -r -u 1000 -g 1000 hive \
    && mkdir -p /opt/hive /var/lib/hive \
    && chown hive:hive /opt/hive /var/lib/hive \
    && chmod ugo+w /etc/passwd

USER hive
WORKDIR /opt/hive

RUN curl -fsSL -o /tmp/hive.tar.gz \
      "https://archive.apache.org/dist/hive/hive-${HIVE_VERSION}/apache-hive-${HIVE_VERSION}-bin.tar.gz" \
    && tar -xzf /tmp/hive.tar.gz -C /opt/hive --strip-components=1 \
    && rm /tmp/hive.tar.gz

USER root
RUN curl -fsSL -o /tmp/hadoop.tar.gz \
      "https://archive.apache.org/dist/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz" \
    && tar -xzf /tmp/hadoop.tar.gz -C /opt \
    && ln -sf "/opt/hadoop-${HADOOP_VERSION}" /opt/hadoop \
    && chown -R hive:hive "/opt/hadoop-${HADOOP_VERSION}" /opt/hadoop \
    && rm /tmp/hadoop.tar.gz

USER hive
COPY --chown=hive:hive hms-entrypoint.sh /hms-entrypoint.sh
RUN chmod +x /hms-entrypoint.sh

ENTRYPOINT ["/hms-entrypoint.sh"]
