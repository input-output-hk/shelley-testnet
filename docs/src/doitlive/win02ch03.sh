#doitlive commentecho: true
open file:///home/agarciafdz/video_tutorial/stakepool_journey/stakepool_operator_journey.svg
clear

# 3. Fund stake pool owner account in JCLI
open https://github.com/input-output-hk/jormungandr-qa/

curl -sLOJ https://raw.githubusercontent.com/input-output-hk/jormungandr-qa/master/scripts/createAddress.sh

chmod +x createAddress.sh

./createAddress.sh account | tee stakepool_owner_account.txt

export PRIVATE_KEY_SK=$(cat stakepool_owner_account.txt | grep -Po "(ed25519e_[0-9a-z]+?)$")
export PUBLIC_KEY_PK=$(cat stakepool_owner_account.txt | grep -Po "(ed25519_[0-9a-z]+?)$")
export ACCOUNT_ADDRESS=$(cat stakepool_owner_account.txt | grep -Po "(addr[0-9a-z]+?)$")

curl -X POST https://faucet.nightly.jormungandr-testnet.iohkdev.io/send-money/$ACCOUNT_ADDRESS

./jcli rest v0 account get $ACCOUNT_ADDRESS -h http://127.0.0.1:3100/api
