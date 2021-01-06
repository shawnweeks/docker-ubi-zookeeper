ARG BASE_REGISTRY
ARG BASE_IMAGE=redhat/ubi/ubi8
ARG BASE_TAG=8.3

FROM ${BASE_REGISTRY}/${BASE_IMAGE}:${BASE_TAG} as build

ARG ZOOKEEPER_VERSION
ARG ZOOKEEPER_PACKAGE=apache-zookeeper-${ZOOKEEPER_VERSION}-bin.tar.gz

COPY ${ZOOKEEPER_PACKAGE} /tmp/

RUN mkdir -p /tmp/zookeeper_package && \
    tar -xf /tmp/${ZOOKEEPER_PACKAGE} -C "/tmp/zookeeper_package" --strip-components=1

###############################################################################
ARG BASE_REGISTRY
ARG BASE_IMAGE=redhat/ubi/ubi7
ARG BASE_TAG=7.9

FROM ${BASE_REGISTRY}/${BASE_IMAGE}:${BASE_TAG}

ENV ZK_USER zookeeper
ENV ZK_GROUP zookeeper
ENV ZK_UID 2001
ENV ZK_GID 2001

ENV ZK_HOME /opt/zookeeper

RUN yum install -y java-11-openjdk-devel python2 python2-jinja2 && \
    yum clean all && \
    mkdir -p ${ZK_HOME} && \
    groupadd -r -g ${ZK_GID} ${ZK_GROUP} && \
    useradd -r -u ${ZK_UID} -g ${ZK_GROUP} -M -d ${ZK_HOME} ${ZK_USER} && \
    chown ${ZK_USER}:${ZK_GROUP} ${ZK_HOME} && \
    mkdir -p /var/lib/zookeeper && \
    chown ${ZK_USER}:${ZK_GROUP} /var/lib/zookeeper

COPY [ "templates/*.j2", "/opt/jinja-templates/" ]
COPY --from=build --chown=${ZK_USER}:${ZK_GROUP} [ "/tmp/zookeeper_package", "${ZK_HOME}/" ]
COPY --chown=${ZK_USER}:${ZK_GROUP} [ "entrypoint.sh", "entrypoint.py", "entrypoint_helpers.py", "${ZK_HOME}/" ]

RUN chmod 755 ${ZK_HOME}/entrypoint.*

EXPOSE 2181 2888 3888

VOLUME /var/lib/zookeeper

USER ${ZK_USER}
ENV JAVA_HOME=/usr/lib/jvm/java-11
ENV PATH=${PATH}:${ZK_HOME}
WORKDIR ${ZK_HOME}
ENTRYPOINT [ "entrypoint.sh" ]