#doitlive commentecho: true
open file:///home/agarciafdz/video_tutorial/stakepool_journey/stakepool_operator_journey.svg
clear

# 4. Create a stake pool certificate in JCLI
open https://github.com/input-output-hk/jormungandr-qa/

curl -sLOJ https://raw.githubusercontent.com/input-output-hk/jormungandr-qa/master/scripts/createStakePool.sh
curl -sLOJ https://raw.githubusercontent.com/input-output-hk/jormungandr-qa/master/scripts/send-certificate.sh

chmod +x createStakePool.sh
chmod +x send-certificate.sh

./createStakePool.sh --help

echo $PRIVATE_KEY_SK

./createStakePool.sh 3100 10000 1/10 1000000 $PRIVATE_KEY_SK | tee createStakePool_output.txt

export STAKEPOOL_ID=$(cat createStakePool_output.txt | grep -Po "(Stake Pool ID:    [0-9a-z]+?)$" | cut -f2 -d: |xargs)

./jcli rest v0 stake-pools get --host "http://127.0.0.1:3100/api"
