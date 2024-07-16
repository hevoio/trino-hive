# Use the Trino base image
FROM trinodb/trino

USER trino:trino

# Copy configuration files into the container
COPY etc/hive.properties /etc/trino/catalog/hive.properties
COPY etc/jvm.config /etc/trino/jvm.config
COPY etc/config.properties /etc/trino/config.properties
COPY etc/node.properties /etc/trino/node.properties

# Set entrypoint to start Trino with the provided configuration files
CMD ["/usr/lib/trino/bin/run-trino"]

HEALTHCHECK --interval=10s --timeout=5s --start-period=10s \
  CMD /usr/lib/trino/bin/health-check
