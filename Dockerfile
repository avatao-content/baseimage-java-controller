FROM avatao/controller:ubuntu-16.04
MAINTAINER Gergo Turcsanyi <gergo.turcsanyi@avatao.com>

ARG USER_HOME_DIR="/home/user"
ARG MAVEN_VERSION=3.5.2
ARG MAVEN_SHA=707b1f6e390a65bde4af4cdaf2a24d45fc19a6ded00fff02e91626e3e42ceaff
ARG MAVEN_BASE_URL=https://archive.apache.org/dist/maven/maven-3/${MAVEN_VERSION}/binaries

USER root

#Install Java
RUN apt-get update \
	&& apt-get install -qy openjdk-8-jdk

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
