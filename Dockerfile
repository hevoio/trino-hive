# Use the Trino base image
FROM trinodb/trino

USER trino:trino

ENV PATH="$PATH:/home/trino/.local/bin"

RUN curl https://bootstrap.pypa.io/get-pip.py -o /home/trino/get-pip.py && \
    python3 /home/trino/get-pip.py && \
    pip3 install awscli

# Copy configuration files into the container
#COPY etc/hive.properties /etc/trino/catalog/hive.properties
COPY etc/jvm.config /etc/trino/jvm.config
COPY etc/config.properties /etc/trino/config.properties
#COPY etc/node.properties /etc/trino/node.properties
COPY etc/password-authenticator.properties /etc/password-authenticator.properties
COPY etc/password.db /etc/password.db
COPY etc/access-control.properties /etc/access-control.properties
COPY etc/rules.json /etc/rules.json

# Set entrypoint to start Trino with the provided configuration files
#CMD ["/usr/lib/trino/bin/run-trino"]
COPY .deployment/start.sh start.sh

CMD ["./start.sh"]

HEALTHCHECK --interval=10s --timeout=5s --start-period=10s \
  CMD /usr/lib/trino/bin/health-check
