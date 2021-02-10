#!/bin/bash
set -e

# Based on benkulbertis/cloudflare-update-record.sh
auth_email=$AUTH_EMAIL                            # The email used to login 'https://dash.cloudflare.com'
auth_key=$AUTH_KEY                                # Top right corner, "My profile" > "Global API Key"
zone_identifier=$ZONE_IDENTIFIER                  # Can be found in the "Overview" tab of your domain
record_name=$RECORD_NAME                          # Domain name to be updated
sleep_seconds=${SLEEP_SECONDS:-900}               # Run every 15 minutes
proxied=${PROXIED:-false}

while true
do
  if [ -n "${HEALTHCHECK_START_URL}" ]; then
    curl -s4 --retry 3 "${HEALTHCHECK_START_URL}"
  fi

  ip=$(curl -ss https://ipinfo.io/ip)

  # SCRIPT START
  echo "[Cloudflare DDNS] Check Initiated for <$record_name>"

  # Seek for the record
  record=$(curl -s -X GET "https://api.cloudflare.com/client/v4/zones/$zone_identifier/dns_records?name=$record_name" -H "X-Auth-Email: $auth_email" -H "X-Auth-Key: $auth_key" -H "Content-Type: application/json")

  # Can't do anything without the record
  if [[ $record == *"\"count\": 0"* ]] || [[ $record == *"\"count\":0"* ]]; then
    >&2 echo -e "[Cloudflare DDNS] Record <$record_name> does not exist, perhaps create one first?"
  fi

  # Set existing IP address from the fetched record
  old_ip=$(echo "$record" | grep -Po '(?<="content":")[^"]*' | head -1 | xargs)

  # Compare if they're the same
  if [ $ip == $old_ip ]; then
    echo "[Cloudflare DDNS] IP has not changed for record <$record_name>."
  else
    # Set the record identifier from result
    record_identifier=$(echo "$record" | grep -Po '(?<="id":")[^"]*' | head -1 | xargs)

    # The execution of update
    update=$(curl -s -X PUT "https://api.cloudflare.com/client/v4/zones/$zone_identifier/dns_records/$record_identifier" -H "X-Auth-Email: $auth_email" -H "X-Auth-Key: $auth_key" -H "Content-Type: application/json" --data "{\"id\":\"$zone_identifier\",\"type\":\"A\",\"proxied\":$proxied,\"name\":\"$record_name\",\"content\":\"$ip\"}")

    # The moment of truth
    case "$update" in
    *"\"success\":false"*)
      >&2 echo -e "[Cloudflare DDNS] Update <$record_name> failed for $record_identifier. DUMPING RESULTS:\n$update"
      continue;;
    *"\"success\": false"*)
      >&2 echo -e "[Cloudflare DDNS] Update <$record_name> failed for $record_identifier. DUMPING RESULTS:\n$update"
      continue;;
    *)
      echo "[Cloudflare DDNS] IPv4 context '$ip' has been synced to Cloudflare for <$record_name>.";;
    esac
  fi

  if [ -n "${HEALTHCHECK_END_URL}" ]; then
    curl -s4 --retry 3 "${HEALTHCHECK_END_URL}"
  fi

  sleep $sleep_seconds;
done
