FROM alpine:3

RUN apk --no-cache add curl && \
    apk add --no-cache --upgrade grep

WORKDIR /usr/bin/

COPY cloudflare-ddns.sh /usr/bin/cloudflare-ddns

RUN chmod +x /usr/bin/cloudflare-ddns

CMD ["sh", "/usr/bin/cloudflare-ddns"]