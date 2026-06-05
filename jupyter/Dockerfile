FROM quay.io/jupyter/pyspark-notebook:spark-4.1.1

ENV SCALA_VERSION=2.13

ENV SPARK_MAJOR_VERSION=4
ENV SPARK_VERSION=4.1.1
ENV SPARK_ICEBERG_RUNTIME_VERSION=4.1
ENV SPARK_PAIMON_RUNTIME_VERSION=4.0

ENV POSTGRES_DRIVER_VERSION=42.7.10
ENV AWS_SDK_VERSION=2.29.52
ENV HADOOP_VERSION=3.4.2

ENV ICEBERG_VERSION=1.11.0
ENV PAIMON_VERSION=1.4.1

RUN mamba install --yes 'psycopg[binary]' && \
    mamba install --yes 'pyiceberg[pyarrow,sql-postgres,hive]' && \
    mamba clean --all -f -y && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"

USER root

RUN curl -fsSL -o "/usr/local/spark/jars/postgresql-${POSTGRES_DRIVER_VERSION}.jar" "https://repo1.maven.org/maven2/org/postgresql/postgresql/${POSTGRES_DRIVER_VERSION}/postgresql-${POSTGRES_DRIVER_VERSION}.jar" && \
    curl -fsSL -o "/usr/local/spark/jars/spark-avro_${SCALA_VERSION}-${SPARK_VERSION}.jar" "https://repo1.maven.org/maven2/org/apache/spark/spark-avro_${SCALA_VERSION}/${SPARK_VERSION}/spark-avro_${SCALA_VERSION}-${SPARK_VERSION}.jar" && \
    curl -fsSL -o "/usr/local/spark/jars/hadoop-aws-${HADOOP_VERSION}.jar" "https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-aws/${HADOOP_VERSION}/hadoop-aws-${HADOOP_VERSION}.jar" && \
    curl -fsSL -o "/usr/local/spark/jars/aws-core-${AWS_SDK_VERSION}.jar" "https://repo1.maven.org/maven2/software/amazon/awssdk/aws-core/${AWS_SDK_VERSION}/aws-core-${AWS_SDK_VERSION}.jar" && \
    curl -fsSL -o "/usr/local/spark/jars/bundle-${AWS_SDK_VERSION}.jar" "https://repo1.maven.org/maven2/software/amazon/awssdk/bundle/${AWS_SDK_VERSION}/bundle-${AWS_SDK_VERSION}.jar"

USER jovyan

RUN mkdir /home/jovyan/extra-jars
RUN curl -fsSL -o "/home/jovyan/extra-jars/iceberg-spark-runtime-${SPARK_MAJOR_VERSION}_${SCALA_VERSION}-${ICEBERG_VERSION}.jar" "https://repo1.maven.org/maven2/org/apache/iceberg/iceberg-spark-runtime-${SPARK_ICEBERG_RUNTIME_VERSION}_${SCALA_VERSION}/${ICEBERG_VERSION}/iceberg-spark-runtime-${SPARK_ICEBERG_RUNTIME_VERSION}_${SCALA_VERSION}-${ICEBERG_VERSION}.jar" && \
    curl -fsSL -o "/home/jovyan/extra-jars/paimon-spark-${SPARK_MAJOR_VERSION}_${SCALA_VERSION}-${PAIMON_VERSION}.jar" "https://repo1.maven.org/maven2/org/apache/paimon/paimon-spark-${SPARK_PAIMON_RUNTIME_VERSION}_${SCALA_VERSION}/${PAIMON_VERSION}/paimon-spark-${SPARK_PAIMON_RUNTIME_VERSION}_${SCALA_VERSION}-${PAIMON_VERSION}.jar"
