#! /bin/bash

SCRIPT_DIR=$(dirname "$0")

source "$SCRIPT_DIR/config.sh"

LOG_FILE="$SCRIPT_DIR/log.txt"
PREV_IP_FILE="$SCRIPT_DIR/prev_ip"
CURRENT_IP=$(curl -s https://ifconfig.me)

log () {
  echo "$1"
  echo "$(date): $1" >> "$LOG_FILE"
}

if [ ! -f $PREV_IP_FILE ]; then
  log "初回実行の為、ip_prevファイルを作成します"
  log "$CURRENT_IP" > $PREV_IP_FILE
  exit 0
fi

PREV_IP=$(cat $PREV_IP_FILE)
log "前回のIP $PREV_IP"
log "現在のIP $CURRENT_IP"

if [ "$CURRENT_IP" != "$PREV_IP" ]; then
  log "ipアドレスの変更を検地しました"
  log "レコードを書き換えます"
  CHANGE_BATCH_JSON=$(cat <<EOF
{
  "Comment": "update record set",
  "Changes": [
    {
      "Action": "UPSERT",
      "ResourceRecordSet": {
        "ResourceRecords": [
          {
            "Value": "$CURRENT_IP"
          }
        ],
        "Name": "$RECOURD_NAME",
        "Type": "A",
        "TTL": 300
      }
    }
  ]
}
EOF
)
  aws route53 change-resource-record-sets --hosted-zone-id $HOSTED_ZONE_ID --change-batch "$CHANGE_BATCH_JSON" 
  log "ip_prevファイルを更新します"
  log "$CURRENT_IP" > $PREV_IP_FILE
else
  log "ipアドレスの変更は検地されませんでした"
fi
