#/usr/bin/env bash

export APP_SLACK_WEBHOOK=<slack_webhook_url>
export APP_SLACK_CHANNEL=<#channel>

named_check() {
  i=0
  j=0
  systemctl status named >/dev/null 2>&1
  if [ $? -ne 0 ];
    then i=1
  else
    dig @192.168.1.10 google.com +time=1 >/dev/null 2>&1
    if [ $? -ne 0 ];
      then j=1
    else
      exit 0
    fi
  fi
}

named_check
### Below is the original code.

#set -o pipefail
set -o errexit
set -o nounset
#set -o xtrace

init_params() {
  # you may declare ENV vars in /etc/profile.d/slack.sh
  if [ -z "${APP_SLACK_WEBHOOK:-}" ]; then
    echo 'error: Please configure Slack environment variable: ' > /dev/stderr
    echo '  APP_SLACK_WEBHOOK' > /dev/stderr
    exit 2
  fi

  APP_SLACK_USERNAME=${APP_SLACK_USERNAME:-$(hostname | cut --delimiter=. --fields=1)}
  APP_SLACK_ICON_EMOJI=${APP_SLACK_ICON_EMOJI:-:slack:}
  if [ -z "${1:-}" ]; then
    echo 'error: Missed required arguments.' > /dev/stderr
    echo 'note: Please follow this example:' > /dev/stderr
    echo '  $ slack.sh "#CHANNEL1,CHANNEL2" Some message here. ' > /dev/stderr
    exit 3
  fi

  slack_channels=(${APP_SLACK_CHANNEL:-})
  if [ "${1::1}" == '#' ] || [ "${1::1}" == '@' ]; then
    # explode by comma
    IFS=',' read -r -a slack_channels <<< "${1}"
    shift
  fi
  slack_message=${@}
}


send_message() {
  local channel=${1}
  echo 'Sending to '${channel}'...'
  curl --silent --data-urlencode \
    "$(printf 'payload={"text": "%s", "channel": "%s", "username": "%s", "as_user": "true", "link_names": "true", "icon_emoji": "%s" }' \
        "${slack_message}" \
        "${channel}" \
        "${APP_SLACK_USERNAME}" \
        "${APP_SLACK_ICON_EMOJI}" \
    )" \
    ${APP_SLACK_WEBHOOK} || true
  echo
}

send_message_to_channels() {
  for channel in "${slack_channels[@]:-}"; do
    send_message "${channel}"
  done
}

slack() {
  # Set magic variables for current file & dir
  __dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  __file="${__dir}/$(basename "${BASH_SOURCE[0]}")"
  readonly __dir __file

  cd ${__dir}

  if [ -f $(cd; pwd)/.slackrc ]; then
    . $(cd; pwd)/.slackrc
  fi

  declare -a slack_channels


if [ ${@} == 'server_reboot_event:' ];
then
  init_params ${@}\\ndhcp.itzxa.local have been reboot\\nlast reboot info:\\n$(last reboot | head -n 1)
fi
if [ ${@} == 'named_status_check:' ];
then
  if [ $i -ne 0 ];
  then
    init_params ${@}\\nCheck time:\\n$(date)\\nHostname: dhcp.itzxa.local\\nService: named\\nStatus: Failed \
                \\nIssue: named service does not in running!! \
                \\nInfo:\\n- systemctl status named -\\n$(systemctl status named | grep -i active)
  elif [ $j -ne 0 ];
  then
    init_params ${@}\\nCheck time:\\n$(date)\\nHostname: dhcp.itzxa.local\\nService: named\\nStatus: Failed \
                \\nIssue: named service in running but resolves got error!! \
                \\nInfo:\\n- dig @192.168.1.10 google.com -\\n$(dig @192.168.1.10 google.com +time=1)
  fi
fi
  send_message_to_channels
}

if [ "${BASH_SOURCE[0]:-}" != "${0}" ]; then
  export -f slack
else
  slack ${@}
  exit $?
fi
