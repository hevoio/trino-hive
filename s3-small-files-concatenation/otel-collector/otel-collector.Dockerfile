FROM otel/opentelemetry-collector-contrib:latest as builder

FROM alpine:latest
RUN apk add --no-cache bash

WORKDIR /app

COPY --from=builder /otelcol-contrib ./
COPY --chmod=755 configs/config.yaml /etc/otel/config.yaml
COPY --chmod=755 .deployment/entrypoint.sh entrypoint.sh

ENTRYPOINT ["/app/entrypoint.sh"]

#Will be picking up configs from the ECS task definition.
CMD ["--config", "/etc/otel/config.yaml"]