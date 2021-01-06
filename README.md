```shell
export ZOOKEEPER_VERSION=3.6.2

wget https://archive.apache.org/dist/zookeeper/zookeeper-${ZOOKEEPER_VERSION}/apache-zookeeper-${ZOOKEEPER_VERSION}-bin.tar.gz

```

### Build Example
```shell
docker build \
    -t ${REGISTRY}/apache/zookeeper:${ZOOKEEPER_VERSION} \
    --build-arg BASE_REGISTRY=${REGISTRY} \
    --build-arg ZOOKEEPER_VERSION=${ZOOKEEPER_VERSION} \
    .
```

### Run Example
```
docker run --init -it --rm \
    --name zookeeper \
    -p 2181:2181 \
    ${REGISTRY}/apache/zookeeper:${ZOOKEEPER_VERSION}
```