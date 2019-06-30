#!/usr/bin/env bash

## Added by Cain Chen - Augest 9 - 2018
export APP_SLACK_WEBHOOK=<slack_webhook_url>
export APP_SLACK_CHANNEL=<#channel>

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
  init_params ${@}\\n$HOSTNAME have been reboot\\nlast reboot info:\\n$(last reboot | head -n 1)
elif [ ${@} == 'wireguard_status_check:' ];
then
  init_params ${@}\\nCheck time:\\n$(date)\\nHostname: $HOSTNAME\\nService: WireGuard\\nStatus: OK \
	      \\nInfo:\\n- ping 192.168.2.254 -\\n$(ping 192.168.2.254 -c 1 | head -n 2 | tail -n 1) \
	      \\n- Port listening -\\n$(netstat -tunlp | grep -E 'udp.*51820' | grep -vw 'udp6')
fi
  send_message_to_channels
}

if [ "${BASH_SOURCE[0]:-}" != "${0}" ]; then
  export -f slack
else
  slack ${@}
  exit $?
fi
