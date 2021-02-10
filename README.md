![Docker hub - abeltramo/cloudflare-ddns](https://img.shields.io/badge/docker-abeltramo%2Fcloudflare--ddns-success) ![Docker Cloud Build Status](https://img.shields.io/docker/cloud/build/abeltramo/cloudflare-ddns) ![Docker Image Size (latest by date)](https://img.shields.io/docker/image-size/abeltramo/cloudflare-ddns)

# Cloudflare DDNS update

A simple bash script to automatically update Cloudflare DNS IP on a Dynamic DNS provider.

## Docker usage

A precompiled docker image is available on [Docker HUB](https://hub.docker.com/repository/docker/abeltramo/cloudflare-ddns).

`docker run abeltramo/cloudflare-ddns:latest`

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