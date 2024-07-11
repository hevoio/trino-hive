# Use the Trino base image
FROM trinodb/trino

USER trino:trino

# Copy configuration files into the container
COPY hive.properties /etc/trino/catalog/hive.properties
COPY jvm.config /etc/trino/jvm.config
COPY config.properties /etc/trino/config.properties
COPY node.properties /etc/trino/node.properties

# Set entrypoint to start Trino with the provided configuration files
CMD ["/usr/lib/trino/bin/run-trino"]

HEALTHCHECK --interval=10s --timeout=5s --start-period=10s \
  CMD /usr/lib/trino/bin/health-check
