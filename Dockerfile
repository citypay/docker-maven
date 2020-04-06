FROM ubuntu:18.04
LABEL maintainer="Gary Feltham <gary.feltham@citypay.com>"

# COPY files/webupd8team_ubuntu_java.gpg /etc/apt/trusted.gpg.d/
COPY files/*.jar /tmp/

ENV LANG C.UTF-8
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64


# taken from the default maven docker implementation, see https://github.com/carlossg/docker-maven
# but stemmed from the cp oracle java implementation

ARG MAVEN_VERSION=3.5.4
ARG USER_HOME_DIR="/root"
ARG BASE_URL=https://apache.osuosl.org/maven/maven-3/${MAVEN_VERSION}/binaries



RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        tzdata locales curl && \
    echo "Etc/UTC" | tee /etc/timezone && \
    ln -fs /usr/share/zoneinfo/Etc/UTC /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata && \
    echo en_US.UTF-8 UTF-8 >> /etc/locale.gen && \
        locale-gen && \
        update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 && \
    apt-get install -y --no-install-recommends \
        ca-certificates-java \
        openjdk-8-jdk-headless awscli && \
    echo $JAVA_HOME && \
    mv /tmp/local_policy.jar ${JAVA_HOME}/jre/lib/security/ && \
    mv /tmp/US_export_policy.jar ${JAVA_HOME}/jre/lib/security/ && \
    cd ${JAVA_HOME} && rm -rf ./*src.zip \
           ./lib/missioncontrol \
           ./lib/visualvm \
           ./lib/*javafx* \
           ./jre/plugin \
           ./jre/bin/javaws \
           ./jre/bin/jjs \
           ./jre/bin/orbd \
           ./jre/bin/pack200 \
           ./jre/bin/policytool \
           ./jre/bin/rmid \
           ./jre/bin/rmiregistry \
           ./jre/bin/servertool \
           ./jre/bin/tnameserv \
           ./jre/bin/unpack200 \
           ./jre/lib/javaws.jar \
           ./jre/lib/deploy* \
           ./jre/lib/desktop \
           ./jre/lib/*javafx* \
           ./jre/lib/*jfx* \
           ./jre/lib/amd64/libdecora_sse.so \
           ./jre/lib/amd64/libprism_*.so \
           ./jre/lib/amd64/libfxplugins.so \
           ./jre/lib/amd64/libglass.so \
           ./jre/lib/amd64/libgstreamer-lite.so \
           ./jre/lib/amd64/libjavafx*.so \
           ./jre/lib/amd64/libjfx*.so \
           ./jre/lib/ext/jfxrt.jar \
           ./jre/lib/ext/nashorn.jar \
           ./jre/lib/oblique-fonts \
           ./jre/lib/plugin.jar && java -version && \
           mkdir -p /usr/share/maven /usr/share/maven/ref && \
           apt-get update -qq && \
           apt-get install -y --no-install-recommends wget libxml2-utils html2text unzip rsync && \
           wget ${BASE_URL}/apache-maven-${MAVEN_VERSION}-bin.tar.gz && \
           tar -xzf apache-maven-${MAVEN_VERSION}-bin.tar.gz -C /usr/share/maven --strip-components=1 && \
           rm -f apache-maven-${MAVEN_VERSION}-bin.tar.gz && \
           apt-get clean autoclean && apt-get autoremove --yes && rm -rf /var/lib/{apt,dpkg,cache,log} && \
           ln -s /usr/share/maven/bin/mvn /usr/bin/mvn


# Set the locale for UTF-8 support
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8


# AWS CLI needs the PYTHONIOENCODING environment varialbe to handle UTF-8 correctly:
ENV PYTHONIOENCODING=UTF-8

ENV MAVEN_HOME /usr/share/maven
ENV MAVEN_CONFIG "$USER_HOME_DIR/.m2"

COPY files/*.sh /usr/local/bin/
COPY files/microscanner /usr/local/bin/
COPY files/settings-docker.xml $MAVEN_CONFIG/settings.xml
COPY files/pom.xml $USER_HOME_DIR

RUN cd $USER_HOME_DIR && mvn verify dependency:copy-dependencies

ENTRYPOINT ["/usr/local/bin/mvn-entrypoint.sh"]
CMD ["mvn"]
