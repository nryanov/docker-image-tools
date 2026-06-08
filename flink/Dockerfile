FROM flink:2.1.2-scala_2.12-java21

ENV JAVA_VERSION=21
ENV SCALA_VERSION=2.12

ENV FLINK_MAJOR_VERSION=2
ENV FLINK_VERSION=2.1
ENV FLINK_ICEBERG_RUNTIME_VERSION=4.1
ENV FLINK_PAIMON_RUNTIME_VERSION=4.0

ENV POSTGRES_DRIVER_VERSION=42.7.10
ENV AWS_SDK_VERSION=2.29.52
ENV HADOOP_VERSION=3.4.2

ENV ICEBERG_VERSION=1.11.0
ENV PAIMON_VERSION=1.4.1

RUN curl -fsSL -o "/opt/flink/lib/postgresql-${POSTGRES_DRIVER_VERSION}.jar" "https://repo1.maven.org/maven2/org/postgresql/postgresql/${POSTGRES_DRIVER_VERSION}/postgresql-${POSTGRES_DRIVER_VERSION}.jar" && \
    curl -fsSL -o "/opt/flink/lib/hadoop-aws-${HADOOP_VERSION}.jar" "https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-aws/${HADOOP_VERSION}/hadoop-aws-${HADOOP_VERSION}.jar" && \
    curl -fsSL -o "/opt/flink/lib/aws-core-${AWS_SDK_VERSION}.jar" "https://repo1.maven.org/maven2/software/amazon/awssdk/aws-core/${AWS_SDK_VERSION}/aws-core-${AWS_SDK_VERSION}.jar" && \
    curl -fsSL -o "/opt/flink/lib/bundle-${AWS_SDK_VERSION}.jar" "https://repo1.maven.org/maven2/software/amazon/awssdk/bundle/${AWS_SDK_VERSION}/bundle-${AWS_SDK_VERSION}.jar" && \
    curl -fsSL -o "/opt/flink/lib/iceberg-flink-runtime-${FLINK_VERSION}_${SCALA_VERSION}-${ICEBERG_VERSION}.jar" "https://repo1.maven.org/maven2/org/apache/iceberg/iceberg-flink-runtime-${FLINK_VERSION}/${ICEBERG_VERSION}/iceberg-flink-runtime-${FLINK_VERSION}-${ICEBERG_VERSION}.jar" && \
    curl -fsSL -o "/opt/flink/lib/paimon-flink-${FLINK_VERSION}_${SCALA_VERSION}-${PAIMON_VERSION}.jar" "https://repo1.maven.org/maven2/org/apache/paimon/paimon-flink-${FLINK_VERSION}/${PAIMON_VERSION}/paimon-flink-${FLINK_VERSION}-${PAIMON_VERSION}.jar"
