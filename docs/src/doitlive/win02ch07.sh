#doitlive commentecho: true
#doitlive env: EDITOR=STAKEPOOL_ID=$(cat createStakePool_output.txt | grep -Po "(Stake Pool ID:    [0-9a-z]+?)$" | cut -f2 -d: |xargs)

open file:///home/agarciafdz/video_tutorial/stakepool_journey/stakepool_operator_journey.svg
clear

# 7. Monitor Delegated Stake

./jcli rest v0 stake-pool get $STAKEPOOL_ID --host "http://127.0.0.1:3100/api"
