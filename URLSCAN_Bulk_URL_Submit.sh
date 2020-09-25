cat urls.txt|tr -d "\r"|while read url; do
  curl -X POST "https://urlscan.io/api/v1/scan/" \
      -H "Content-Type: application/json" \
      -H "API-Key: YOUR KEY HERE" \
      -d "{\"url\": \"$url\", \"public\": \"on\", \
        \"tags\": [\"phishing\", \"SpamReports\"] \
      }"
  sleep 2;
done
