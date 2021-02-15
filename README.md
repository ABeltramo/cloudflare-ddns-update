[![Docker hub - abeltramo/cloudflare-ddns](https://img.shields.io/badge/docker-abeltramo%2Fcloudflare--ddns-success)](https://hub.docker.com/repository/docker/abeltramo/cloudflare-ddns) [![Docker Image Size (latest by date)](https://img.shields.io/docker/image-size/abeltramo/cloudflare-ddns)](https://hub.docker.com/repository/docker/abeltramo/cloudflare-ddns/tags?page=1&ordering=last_updated)

# Cloudflare DDNS update

Access your home network remotely via a custom domain name without a static IP!

A simple bash script to automatically update Cloudflare DNS IP on a [Dynamic DNS provider](https://www.cloudflare.com/en-gb/learning/dns/glossary/dynamic-dns/).

## Docker usage

A precompiled docker image is available on [Docker HUB](https://hub.docker.com/repository/docker/abeltramo/cloudflare-ddns). This is a multi-arch image and will run on amd64, aarch64, and armhf devices, including the Raspberry Pi.

```
docker run -d \
    --name cloudflare-ddns \
    --restart always \
    -e "AUTH_EMAIL=asd@fgh.com" \
    -e "AUTH_KEY=365....." \
    -e "ZONE_IDENTIFIER=db....." \
    -e "RECORD_NAME=example.com" \
    abeltramo/cloudflare-ddns:latest
```

## Environment variables

| Variable Name         | Default value | Description                                                                 |
|-----------------------|---------------|-----------------------------------------------------------------------------|
| AUTH_EMAIL            |               | The email used to login on Cloudflare                                       |
| AUTH_KEY              |               | Global API key, found at: top right corner, "My profile" > "Global API Key" |
| ZONE_IDENTIFIER       |               | Can be found in the "Overview" tab of your domain                           |
| RECORD_NAME           |               | The full domain name to be updated                                          |
| SLEEP_SECONDS         | 900           | The interval in seconds between checks for changes in IP                    |
| PROXIED               | false         | Set to true to enable Cloudflare proxy protection                           |
| HEALTHCHECK_START_URL |               | Set a URL to be called when the script start, used with healthchecks.io     |
| HEALTHCHECK_END_URL   |               | Set a URL to be called when the script end, used with healthchecks.io       |
| CURL_PARAMS           | -sS --retry 3 | Change default CURL params, useful for debug, proxy, etc..                  |