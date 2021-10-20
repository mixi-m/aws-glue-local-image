FROM openjdk:8-jdk-buster as base

ENV AWS_GLUE_ETL_ARTIFACTS_URL=https://aws-glue-etl-artifacts.s3.amazonaws.com
ARG apache_maven=apache-maven-3.6.0-bin.tar.gz

RUN apt-get update && \
    apt-get install -y \
    python3.7 \
    python3-pip \
    zip

RUN unlink /usr/bin/python && \
    ln -s /usr/bin/python3 /usr/bin/python
RUN pip3 install pytest boto3

WORKDIR /home

# Install Apache Maven
RUN mkdir -p apache-maven && \
    curl -L -O ${AWS_GLUE_ETL_ARTIFACTS_URL}/glue-common/${apache_maven} && \
    tar -xzf ${apache_maven} -C apache-maven --strip-components=1 && \
    rm ${apache_maven}

FROM base as glue-2.0

ENV GLUE_VERSION=2.0
ENV AWS_GLUE_LIB_BRANCH=glue-2.0
ARG spark_archive=spark-2.4.3-bin-hadoop2.8.tgz

RUN git clone --branch ${AWS_GLUE_LIB_BRANCH} --depth 1 https://github.com/awslabs/aws-glue-libs
COPY ./glue-setup.sh /home/aws-glue-libs/bin/glue-setup.sh

# Install Apache Spark distribution
RUN mkdir -p spark && \
    curl -L -O ${AWS_GLUE_ETL_ARTIFACTS_URL}/glue-${GLUE_VERSION}/${spark_archive} && \
    tar -xzf ${spark_archive} -C spark --strip-components=1 && \
    rm ${spark_archive}

ENV PATH=${PATH}:/home/aws-glue-libs/bin:/home/apache-maven/bin
ENV SPARK_HOME=/home/spark

COPY ./spark-defaults.conf ${SPARK_HOME}/conf/spark-defaults.conf
RUN ln -s ${SPARK_HOME}/jars /home/aws-glue-libs/jarsv1
# Install dependencies
RUN /home/aws-glue-libs/bin/gluepyspark

ENTRYPOINT [ "/home/aws-glue-libs/bin/gluepyspark" ]

FROM base as glue-3.0

ENV GLUE_VERSION=3.0
ENV AWS_GLUE_LIB_BRANCH=master
ARG spark_archive=spark-3.1.1-amzn-0-bin-3.2.1-amzn-3.tgz

RUN git clone --branch ${AWS_GLUE_LIB_BRANCH} --depth 1 https://github.com/awslabs/aws-glue-libs
COPY ./glue-setup.sh /home/aws-glue-libs/bin/glue-setup.sh

# Install Apache Spark distribution
RUN mkdir -p spark && \
    curl -L -O ${AWS_GLUE_ETL_ARTIFACTS_URL}/glue-${GLUE_VERSION}/${spark_archive} && \
    tar -xf ${spark_archive} -C spark --strip-components=1 && \
    rm ${spark_archive}

ENV PATH=${PATH}:/home/aws-glue-libs/bin:/home/apache-maven/bin
ENV SPARK_HOME=/home/spark

COPY ./spark-defaults.conf ${SPARK_HOME}/conf/spark-defaults.conf
RUN ln -s ${SPARK_HOME}/jars /home/aws-glue-libs/jarsv1
# Install dependencies
RUN /home/aws-glue-libs/bin/gluepyspark

ENTRYPOINT [ "/home/aws-glue-libs/bin/gluepyspark" ]
