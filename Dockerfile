FROM alpine:3.23

RUN apk --no-cache add bash curl jq

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]