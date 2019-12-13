#doitlive alias: open="google-chrome"
#doitlive prompt: $
#doitlive commentecho: true
open file:///home/agarciafdz/video_tutorial/stakepool_journey/stakepool_operator_journey.svg
clear
# 2. Start Jormungandr node

open https://hydra.iohk.io/job/Cardano/iohk-nix/jormungandr-deployment/latest-finished/download/1/index.html

open https://github.com/input-output-hk/jormungandr/releases/v0.8.0-rc9+1/

curl -sLOJ https://github.com/input-output-hk/jormungandr/releases/download/v0.8.0-rc9+1/jormungandr-v0.8.0-rc9+1-x86_64-unknown-linux-gnu.tar.gz

tar -xzvf jormungandr-v0.8.0-rc9+1-x86_64-unknown-linux-gnu.tar.gz

./jcli -V

open https://hydra.iohk.io/job/Cardano/iohk-nix/jormungandr-deployment/latest-finished/download/1/index.html
curl -sLOJ https://hydra.iohk.io/job/Cardano/iohk-nix/jormungandrConfigs.nightly/latest/download/1/nightly-config.yaml

tail -n +14 ./nightly-config.yaml | cat ./templates/stakepool_config_addenda.json - > ./stakepool-config.yaml
open https://www.canyouseeme.org/

curl -sLOJ https://hydra.iohk.io/job/Cardano/iohk-nix/jormungandrConfigs.nightly/latest/download/2/genesis-hash.txt

cat genesis-hash.txt

ls -lrt

gnome-terminal --profile=client

./jormungandr --genesis-block-hash $(cat genesis-hash.txt) --config ./stakepool-config.yaml
