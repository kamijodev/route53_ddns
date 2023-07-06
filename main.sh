#! /bin/bash

PREV_IP_FILE=prev_ip
CURRENT_IP=$(curl -s https://ifconfig.me)

if [ ! -f $PREV_IP_FILE ]; then
  echo "ip_prevファイルを作成します"
  echo "$CURRENT_IP" > $PREV_IP_FILE
  exit 0
fi

PREV_IP=$(cat $PREV_IP_FILE)

if [ "$CURRENT_IP" != "$PREV_IP" ]; then
  echo "ipアドレスの変更を検地しました($PREV_IP->$CURRENT_IP)"
  echo "ip_prevファイルを更新します"
  echo "$CURRENT_IP" > $PREV_IP_FILE
else
  echo "ipアドレスの変更は検地されませんでした"
fi
