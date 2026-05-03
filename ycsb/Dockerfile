# build image
FROM ubuntu:24.04 as ycsb

WORKDIR /build
RUN apt update && \
    apt install -y curl && \
    apt clean && \
    curl -O --location https://github.com/brianfrankcooper/YCSB/releases/download/0.17.0/ycsb-0.17.0.tar.gz && \
    tar xfvz ycsb-0.17.0.tar.gz && \
    rm ycsb-0.17.0.tar.gz

# main image

FROM openjdk:17-jdk-slim

WORKDIR /ycsb/ycsb-0.17.0
COPY --from=ycsb /build/ycsb-0.17.0 /ycsb/ycsb-0.17.0

ENTRYPOINT ["bin/ycsb.sh"]
