FROM avatao/controller:ubuntu-16.04
MAINTAINER Gergo Turcsanyi <gergo.turcsanyi@avatao.com>

ARG USER_HOME_DIR="/home/user"
ARG MAVEN_VERSION=3.5.2
ARG MAVEN_SHA=707b1f6e390a65bde4af4cdaf2a24d45fc19a6ded00fff02e91626e3e42ceaff
ARG MAVEN_BASE_URL=https://archive.apache.org/dist/maven/maven-3/${MAVEN_VERSION}/binaries
ARG JAVA_URL=http://download.oracle.com/otn-pub/java/jdk/8u151-b12/e758a0de34e24606bca991d704f6dcbf/jdk-8u151-linux-i586.tar.gz

USER root

#Install 32 bit Java
RUN mkdir -p /opt && curl -jfksSLH "Cookie: oraclelicense=accept-securebackup-cookie" "${JAVA_URL}" \
      | tar -xzf - -C /opt \
    && ln -s /opt/jdk1.*.0_* /opt/jdk \
    && rm -rf /opt/jdk/*src.zip \
              /opt/jdk/lib/missioncontrol \
              /opt/jdk/lib/visualvm \
              /opt/jdk/lib/*javafx* \
              /opt/jdk/db \
              /opt/jdk/jre/lib/plugin.jar \
              /opt/jdk/jre/lib/ext/jfxrt.jar \
              /opt/jdk/jre/bin/javaws \
              /opt/jdk/jre/lib/javaws.jar \
              /opt/jdk/jre/lib/desktop \
              /opt/jdk/jre/plugin \
              /opt/jdk/jre/lib/deploy* \
              /opt/jdk/jre/lib/*javafx* \
              /opt/jdk/jre/lib/*jfx* \
              /opt/jdk/jre/lib/i386/libdecora_sse.so \
              /opt/jdk/jre/lib/i386/libprism_*.so \
              /opt/jdk/jre/lib/i386/libfxplugins.so \
              /opt/jdk/jre/lib/i386/libglass.so \
              /opt/jdk/jre/lib/i386/libgstreamer-lite.so \
              /opt/jdk/jre/lib/i386/libjavafx*.so \
              /opt/jdk/jre/lib/i386/libjfx*.so

ENV JAVA_HOME /opt/jdk
ENV PATH $PATH:$JAVA_HOME/bin

#Install Maven
RUN mkdir -p /usr/share/maven /usr/share/maven/ref \
  && curl -fsSL -o /tmp/apache-maven.tar.gz ${MAVEN_BASE_URL}/apache-maven-${MAVEN_VERSION}-bin.tar.gz \
  && echo "${MAVEN_SHA}  /tmp/apache-maven.tar.gz" | sha256sum -c - \
  && tar -xzf /tmp/apache-maven.tar.gz -C /usr/share/maven --strip-components=1 \
  && rm -f /tmp/apache-maven.tar.gz \
  && ln -s /usr/share/maven/bin/mvn /usr/bin/mvn

ENV MAVEN_HOME /usr/share/maven
ENV MAVEN_CONFIG "$USER_HOME_DIR/.m2"

COPY ./ /

RUN adduser --disabled-password --gecos ',,,' --uid 2001 controller
