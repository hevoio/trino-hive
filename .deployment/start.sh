#!/bin/bash
aws s3 cp ${S3_TRINO_HIVE_PROPERTIES_PATH} /etc/trino/catalog/hive.properties
aws s3 cp ${S3_TRINO_NODE_PROPERTIES_PATH} /etc/trino/node.properties

/usr/lib/trino/bin/run-trino