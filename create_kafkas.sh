#!/bin/bash

NUM=$1
STORAGE_CLASS=gp2
KAFKA_CPU=1000m
KAFKA_MEM=1Gi
ZOOKEEPER_CPU=500m
ZOOKEEPER_MEM=1Gi
BATCH=$(openssl rand -base64 12 |  tr -dc A-Za-z0-9 | tr '[:upper:]' '[:lower:]')

for ((i=1;i<=${NUM};i++))
do
    NAME=foo-$(openssl rand -base64 12 |  tr -dc A-Za-z0-9 | tr '[:upper:]' '[:lower:]')

echo Creating ${NAME} ${BATCH}

oc apply -f - << EOF
apiVersion: v1
kind: Namespace
metadata:
  labels:
    kafka: "true"
    batch: ${BATCH}
  name: ${NAME}
spec:
---
apiVersion: kafka.strimzi.io/v1beta2
kind: Kafka
metadata:
  name: ${NAME}
  namespace: ${NAME}
  labels:
    kafka: "true"
    batch: ${BATCH}
spec:
  kafka:
    config:
      auto.create.topics.enable: "false"
      default.replication.factor: 3
      inter.broker.protocol.version: 2.7.0
      leader.imbalance.per.broker.percentage: 0
      log.message.format.version: 2.7.0
      max.connections: "33"
      max.connections.creation.rate: "16"
      min.insync.replicas: 2
      offsets.topic.replication.factor: 3
      quota.window.num: "30"
      quota.window.size.seconds: "2"
      ssl.enabled.protocols: TLSv1.3
      ssl.protocol: TLSv1.3
      transaction.state.log.min.isr: 2
      transaction.state.log.replication.factor: 3
    jvmOptions:
      -XX:
        ExitOnOutOfMemoryError: "true"
      -Xms: 512m
      -Xmx: 512m
    listeners:
      - name: plain
        port: 9092
        type: internal
        tls: false
      - name: tls
        port: 9093
        type: internal
        tls: true
    rack:
      topologyKey: topology.kubernetes.io/zone
    replicas: 3
    resources:
      limits:
        cpu: ${KAFKA_CPU}
        memory: ${KAFKA_MEM}
      requests:
        cpu: ${KAFKA_CPU}
        memory: ${KAFKA_MEM}
    storage:
      type: jbod
      volumes:
      - class: $STORAGE_CLASS
        deleteClaim: true
        id: 0
        size: "32212254720"
        type: persistent-claim
    template:
      pod:
        affinity:
          podAntiAffinity:
            requiredDuringSchedulingIgnoredDuringExecution:
            - topologyKey: kubernetes.io/hostname
    version: 2.7.0
  kafkaExporter:
    resources:
      limits:
        cpu: 1000m
        memory: 256Mi
      requests:
        cpu: 500m
        memory: 128Mi
  zookeeper:
    jvmOptions:
      -XX:
        ExitOnOutOfMemoryError: "true"
      -Xms: 512m
      -Xmx: 512m
    replicas: 3
    resources:
      limits:
        cpu: ${ZOOKEEPER_CPU}
        memory: ${ZOOKEEPER_MEM}
      requests:
        cpu: ${ZOOKEEPER_CPU}
        memory: ${ZOOKEEPER_MEM}
    storage:
      class: $STORAGE_CLASS
      deleteClaim: true
      size: 10Gi
      type: persistent-claim
    template:
      pod:
        affinity:
          podAntiAffinity:
            requiredDuringSchedulingIgnoredDuringExecution:
            - topologyKey: kubernetes.io/hostname
            - topologyKey: topology.kubernetes.io/zone
EOF

done
