FROM alpine:latest
# Set environment variables for MinIO
ENV MINIO_ROOT_USER_FILE=access_key \
    MINIO_ROOT_PASSWORD_FILE=secret_key \
    MINIO_CONFIG_ENV_FILE=config.env

RUN apk add --no-cache dumb-init iproute2
RUN wget https://dl.min.io/server/minio/release/linux-amd64/minio && \
    chmod +x minio
RUN mv minio /usr/local/bin/minio

RUN ip a
RUN which tc && \
    which minio

COPY ./dockerscripts/docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh

EXPOSE 9000
VOLUME ["/data"]

ENTRYPOINT ["dumb-init", "/docker-entrypoint.sh"]
CMD ["minio"]
