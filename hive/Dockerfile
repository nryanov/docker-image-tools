FROM apache/hive:4.0.0

ENV POSTGRESQL_VERSION=42.7.5
ENV AWS_SDK_VERSION=1.12.367
ENV HADOOP_AWS_VERSION=3.3.6

USER root

RUN apt-get update && \
apt-get -y install wget && \
apt-get clean && \
wget -O /opt/hive/lib/postgresql-${POSTGRESQL_VERSION}.jar https://repo1.maven.org/maven2/org/postgresql/postgresql/${POSTGRESQL_VERSION}/postgresql-${POSTGRESQL_VERSION}.jar && \
wget -O /opt/hive/lib/hadoop-aws-${HADOOP_AWS_VERSION}.jar https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-aws/${HADOOP_AWS_VERSION}/hadoop-aws-${HADOOP_AWS_VERSION}.jar && \
wget -O /opt/hive/lib/aws-java-sdk-bundle-${AWS_SDK_VERSION}.jar https://repo1.maven.org/maven2/com/amazonaws/aws-java-sdk-bundle/${AWS_SDK_VERSION}/aws-java-sdk-bundle-${AWS_SDK_VERSION}.jar

USER hive
