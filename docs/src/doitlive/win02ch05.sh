#doitlive commentecho: true
open file:///home/agarciafdz/video_tutorial/stakepool_journey/stakepool_operator_journey.svg
clear

# 5. Register stake pool to Cardano Foundation
open https://github.com/cardano-foundation/incentivized-testnet-stakepool-registry

export GITHUB_USERNAME='elviejo79'

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
