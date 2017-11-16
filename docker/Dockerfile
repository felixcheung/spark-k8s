# Build on https://github.com/gettyimages/docker-spark

# See openjdk:8-jre
FROM buildpack-deps:stretch-curl

RUN set -ex; \
 apt-get update; \
 apt-get install -y locales; \
 dpkg-reconfigure -f noninteractive locales; \
 locale-gen C.UTF-8; \
 /usr/sbin/update-locale LANG=C.UTF-8; \
 echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen; \
 locale-gen; \
 apt-get -y install procps; \
 apt-get -y install libsnappy1v5; \
 apt-get clean; \
 rm -rf /var/lib/apt/lists/*

# Users with other locales should set this in their derivative image
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# Python
RUN set -ex; \
 apt-get update; \
 apt-get install -y curl unzip python3 python3-setuptools; \
 ln -s /usr/bin/python3 /usr/bin/python; \
 easy_install3 pip py4j; \
 apt-get clean; \
 rm -rf /var/lib/apt/lists/*

# http://blog.stuart.axelbrooke.com/python-3-on-spark-return-of-the-pythonhashseed
ENV PYTHONHASHSEED 0
ENV PYTHONIOENCODING UTF-8
ENV PIP_DISABLE_PIP_VERSION_CHECK 1

# R
RUN set -ex; \
 echo '' >> /etc/apt/sources.list; \
 echo 'deb http://cran.cnr.Berkeley.edu/bin/linux/debian stretch-cran34/' >> /etc/apt/sources.list; \
 apt-key adv --keyserver keys.gnupg.net --recv-key 'E19F5F87128899B192B1A2C2AD5F960A256A04AF'; \
 apt-get update; \
 apt-get -y install r-base r-base-dev; \
 apt-get clean; \
 rm -rf /var/lib/apt/lists/*

# JAVA
ARG JAVA_MAJOR_VERSION=8
ARG JAVA_UPDATE_VERSION=144
# 15
ARG JAVA_BUILD_NUMBER=01
ENV JAVA_HOME /usr/jdk1.${JAVA_MAJOR_VERSION}.0_${JAVA_UPDATE_VERSION}

ENV PATH $PATH:$JAVA_HOME/bin
RUN set -ex; \
  wget --no-cookies --no-check-certificate -q \
  --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" \
  "http://download.oracle.com/otn-pub/java/jdk/${JAVA_MAJOR_VERSION}u${JAVA_UPDATE_VERSION}-b${JAVA_BUILD_NUMBER}/090f390dda5b47b9b721c7dfaa008135/server-jre-${JAVA_MAJOR_VERSION}u${JAVA_UPDATE_VERSION}-linux-x64.tar.gz"; \
  mv server-jre-*.tar.gz /usr/; \
  cd /usr/; \
  tar xzf server-jre-*.tar.gz; \
  rm server-jre-*.tar.gz; \
  ln -s $JAVA_HOME /usr/java; \
  rm -rf $JAVA_HOME/man

ARG CORE_SITE_URL=""
ENV CORE_SITE_URL="$CORE_SITE_URL"

# HADOOP
ENV HADOOP_VERSION 2.7.4
ENV HADOOP_HOME /usr/hadoop-$HADOOP_VERSION
ENV HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop
ENV PATH $PATH:$HADOOP_HOME/bin
RUN set -ex; \
 curl -sL --retry 3 \
  "http://archive.apache.org/dist/hadoop/common/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz" \
  | gunzip \
  | tar -x -C /usr/; \
 rm -rf $HADOOP_HOME/share/doc; \
 chown -R root:root $HADOOP_HOME

# SPARK
ENV SPARK_VERSION 2.2.0
ENV SPARK_PACKAGE spark-${SPARK_VERSION}-bin-without-hadoop
ENV SPARK_HOME /usr/spark-${SPARK_VERSION}
ENV SPARK_DIST_CLASSPATH="$HADOOP_HOME/etc/hadoop/*:$HADOOP_HOME/share/hadoop/common/lib/*:$HADOOP_HOME/share/hadoop/common/*:$HADOOP_HOME/share/hadoop/hdfs/*:$HADOOP_HOME/share/hadoop/hdfs/lib/*:$HADOOP_HOME/share/hadoop/hdfs/*:$HADOOP_HOME/share/hadoop/yarn/lib/*:$HADOOP_HOME/share/hadoop/yarn/*:$HADOOP_HOME/share/hadoop/mapreduce/lib/*:$HADOOP_HOME/share/hadoop/mapreduce/*:$HADOOP_HOME/share/hadoop/tools/lib/*"
ENV PATH $PATH:${SPARK_HOME}/bin
RUN set -ex; \
 curl -sL --retry 3 \
  "http://d3kbcqa49mib13.cloudfront.net/${SPARK_PACKAGE}.tgz" \
  | gunzip \
  | tar x -C /usr/; \
 mv /usr/$SPARK_PACKAGE $SPARK_HOME; \
 chown -R root:root $SPARK_HOME

COPY docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh; 
ENTRYPOINT ["/docker-entrypoint.sh"]
EXPOSE 4040 6066 7077 8080
CMD ["help"]
