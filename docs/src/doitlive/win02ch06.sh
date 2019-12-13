#doitlive commentecho: true
open file:///home/agarciafdz/video_tutorial/stakepool_journey/stakepool_operator_journey.svg
clear

# 6. Delegate stake to your stake pool
open https://github.com/input-output-hk/jormungandr-qa/

curl -sLOJ https://raw.githubusercontent.com/input-output-hk/jormungandr-qa/master/scripts/delegate-account.sh
chmod +x delegate-account.sh

./delegate-account.sh --help

./delegate-account.sh $STAKEPOOL_ID 3100 $PRIVATE_KEY_SK

./jcli rest v0 account get $ACCOUNT_ADDRESS -h http://127.0.0.1:3100/api
