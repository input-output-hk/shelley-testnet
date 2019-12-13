#doitlive alias: open="google-chrome"
#doitlive prompt: $
#doitlive commentecho: true

## 2.7 Check that the node is syncing

./jcli rest v0 node stats get --host "http://127.0.0.1:3100/api"
