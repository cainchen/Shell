#!/usr/bin/env bash
if [ "$PAM_TYPE" != "close_session" ];
then
  url="<slack_webhook_url>"
  channel="<#channel>"
  host="$(hostname)"
  date="$(date)"
  content="\"attachments\": [ { \"mrkdwn_in\": [\"text\", \"fallback\"], \"fallback\": \
           \"\`A user switched identity to root event!!\`\", \"text\": \"\`A user switched identify to root event!!\`\", \
           \"fields\": [ { \"title\": \"Event on\", \"value\": \"$date\", \"short\": true }, \
           { \"title\": \"Hostname\", \"value\": \"$host\", \"short\": true } ], \"color\": \"#F35A00\" } ]"
  curl -X POST --data-urlencode "payload={\"channel\": \"$channel\", \"mrkdwn\": true, \"username\": \
           \"Security notification\", $content, \"icon_emoji\": \":male-police-officer:\"}" "$url" &
fi
exit
