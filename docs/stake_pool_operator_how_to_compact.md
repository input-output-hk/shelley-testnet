# 1. Stake pool operator How-to COMPACT edition
The goal of this edition is to just present the commands that are typed on the terminal
in the video series: [Stake pool opeator Journey](https://www.youtube.com/playlist?list=PLnPTB0CuBOBxWkg6WuocFSvu-9VIzgg7I).
If you want to view the whole context, please read the [complete how-to guide](stake_pool_operator_how_to.md).

```sh
```
# 2. Start Jormungandr node
```sh



curl -sLOJ https://github.com/input-output-hk/jormungandr/releases/download/v0.8.0-rc9+1/jormungandr-v0.8.0-rc9+1-x86_64-unknown-linux-gnu.tar.gz

tar -xzvf jormungandr-v0.8.0-rc9+1-x86_64-unknown-linux-gnu.tar.gz

./jcli -V

curl -sLOJ https://hydra.iohk.io/job/Cardano/iohk-nix/jormungandrConfigs.nightly/latest/download/1/nightly-config.yaml

tail -n +14 ./nightly-config.yaml | cat ./templates/stakepool_config_addenda.json - > ./stakepool-config.yaml

curl -sLOJ https://hydra.iohk.io/job/Cardano/iohk-nix/jormungandrConfigs.nightly/latest/download/2/genesis-hash.txt

cat genesis-hash.txt

ls -lrt

gnome-terminal --profile=client

./jormungandr --genesis-block-hash $(cat genesis-hash.txt) --config ./stakepool-config.yaml
./jormungandr --genesis-block-hash $(cat genesis-hash.txt) --config ./stakepool-config.yaml --secret ./node_secret.yaml

```
## 2.7 Check that the node is syncing
```sh

./jcli rest v0 node stats get --host "http://127.0.0.1:3100/api"

```
# 3. Fund stake pool owner account in JCLI
```sh

curl -sLOJ https://raw.githubusercontent.com/input-output-hk/jormungandr-qa/master/scripts/createAddress.sh

chmod +x createAddress.sh

./createAddress.sh account | tee stakepool_owner_account.txt

export PRIVATE_KEY_SK=$(cat stakepool_owner_account.txt | grep -Po "(ed25519e_[0-9a-z]+?)$")
export PUBLIC_KEY_PK=$(cat stakepool_owner_account.txt | grep -Po "(ed25519_[0-9a-z]+?)$")
export ACCOUNT_ADDRESS=$(cat stakepool_owner_account.txt | grep -Po "(addr[0-9a-z]+?)$")

curl -X POST https://faucet.nightly.jormungandr-testnet.iohkdev.io/send-money/$ACCOUNT_ADDRESS

./jcli rest v0 account get $ACCOUNT_ADDRESS -h http://127.0.0.1:3100/api

```
# 4. Create a stake pool certificate in JCLI
```sh

curl -sLOJ https://raw.githubusercontent.com/input-output-hk/jormungandr-qa/master/scripts/createStakePool.sh
curl -sLOJ https://raw.githubusercontent.com/input-output-hk/jormungandr-qa/master/scripts/send-certificate.sh

chmod +x createStakePool.sh
chmod +x send-certificate.sh

./createStakePool.sh --help

echo $PRIVATE_KEY_SK

./createStakePool.sh 3100 10000 1/10 1000000 $PRIVATE_KEY_SK | tee createStakePool_output.txt

export STAKEPOOL_ID=$(cat createStakePool_output.txt | grep -Po "(Stake Pool ID:    [0-9a-z]+?)$" | cut -f2 -d: |xargs)

./jcli rest v0 stake-pools get --host "http://127.0.0.1:3100/api"

```
# 5. Register stake pool to Cardano Foundation
```sh

export GITHUB_USERNAME='your_user_name'

git clone git@github.com:$GITHUB_USERNAME/incentivized-testnet-stakepool-registry.git

gedit ../utils/registry_template.json
envsubst < ../utils/registry_template.json > ./incentivized-testnet-stakepool-registry/registry/$PUBLIC_KEY_PK.json

cat ./incentivized-testnet-stakepool-registry/registry/$PUBLIC_KEY_PK.json

echo $PRIVATE_KEY_SK > owner.prv

./jcli key sign --secret-key owner.prv --output ./incentivized-testnet-stakepool-registry/registry/$PUBLIC_KEY_PK.sig ./incentivized-testnet-stakepool-registry/registry/$PUBLIC_KEY_PK.json

ls  ./incentivized-testnet-stakepool-registry/registry/* | sort

cd ./incentivized-testnet-stakepool-registry/registry/
git add $PUBLIC_KEY_PK.json
git add $PUBLIC_KEY_PK.sig
git commit -m "EXAMP"
git push
cd ../../

```
# 6. Delegate stake to your stake pool
```sh

curl -sLOJ https://raw.githubusercontent.com/input-output-hk/jormungandr-qa/master/scripts/delegate-account.sh
chmod +x delegate-account.sh

./delegate-account.sh --help

./delegate-account.sh $STAKEPOOL_ID 3100 $PRIVATE_KEY_SK

./jcli rest v0 account get $ACCOUNT_ADDRESS -h http://127.0.0.1:3100/api


```
# 7. Monitor Delegated Stake
```sh

./jcli rest v0 stake-pool get $STAKEPOOL_ID --host "http://127.0.0.1:3100/api"
