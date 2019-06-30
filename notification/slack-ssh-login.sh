#!/usr/bin/env bash
if [ "$PAM_TYPE" != "close_session" ];
then
  url="<slack_webhook_url>"
  channel="<#channel>"
  host="$(hostname)"
  date="$(date)"
  content="\"attachments\": [ { \"mrkdwn_in\": [\"text\", \"fallback\"], \"fallback\": \
           \"SSH login: $PAM_USER connected to \`$host\`\", \"text\": \"\`SSH login to server event!!\`\", \
           \"fields\": [ { \"title\": \"Event on\", \"value\": \"$date\", \"short\": true }, \
           { \"title\": \"Login to\", \"value\": \"$host\", \"short\": true }, \
           { \"title\": \"User\", \"value\": \"$PAM_USER\", \"short\": true }, \
           { \"title\": \"Source IP\", \"value\": \"$PAM_RHOST\", \"short\": true } ], \"color\": \"#F35A00\" } ]"
  curl -X POST --data-urlencode "payload={\"channel\": \"$channel\", \"mrkdwn\": true, \"username\": \
           \"Security notification\", $content, \"icon_emoji\": \":male-police-officer:\"}" "$url" &
fi
exit
