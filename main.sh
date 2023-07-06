#! /bin/bash

source config.sh

PREV_IP_FILE=prev_ip
CURRENT_IP=$(curl -s https://ifconfig.me)

if [ ! -f $PREV_IP_FILE ]; then
  echo "初回実行の為、ip_prevファイルを作成します"
  echo "$CURRENT_IP" > $PREV_IP_FILE
  exit 0
fi

PREV_IP=$(cat $PREV_IP_FILE)
echo "前回のIP $PREV_IP"
echo "現在のIP $CURRENT_IP"

if [ "$CURRENT_IP" != "$PREV_IP" ]; then
  echo "ipアドレスの変更を検地しました"
  echo "レコードを書き換えます"
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
  echo "ip_prevファイルを更新します"
  echo "$CURRENT_IP" > $PREV_IP_FILE
else
  echo "ipアドレスの変更は検地されませんでした"
fi
