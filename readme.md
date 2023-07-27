<div align="center">
<samp>
  
  ## route53_ddns

  route53の書き換えをcronで定期実行してDDNSっぽい動きさせるスクリプト  
  config.example.shを参考にconfig.shを作成してください  
  main.shは実行権限つけてください  
  ```chmod +x main.sh```

  #### cronで1分毎に実行する例
  ```
  */1 * * * * /xxx/xxx/route53_ddns/main.sh
  ```
</samp>
</div>
