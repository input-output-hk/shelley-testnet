#!/bin/sh

# Disclaimer:
#
#  The following use of shell script is for demonstration and understanding
#  only, it should *NOT* be used at scale or for any sort of serious
#  deployment, and is solely used for learning how the node and blockchain
#  works, and how to interact with everything.
#
# Scenario:
#   Configure 1 stake pool having as owner the provided account address (secret key)
#

### CONFIGURATION
CLI="jcli"
COLORS=1
ADDRTYPE="--testing"

if [ $# -ne 2 ]; then
    echo "usage: $0 <REST-LISTEN-PORT> <ACCOUNT_SK>"
    echo "    <REST-PORT>   The REST Listen Port set in node-config.yaml file (EX: 3101)"
    echo "    <SOURCE-SK>   The Secret key of the Source address"
    exit 1
fi

REST_PORT="$1"
ACCOUNT_SK="$2"

REST_URL="http://127.0.0.1:${REST_PORT}/api"
BLOCK0_HASH=$($CLI rest v0 settings get -h "${REST_URL}" | grep 'block0Hash:' | sed -e 's/^[[:space:]]*//' | sed -e 's/block0Hash: //')
FEE_CONSTANT=$($CLI rest v0 settings get -h "${REST_URL}" | grep 'constant:' | sed -e 's/^[[:space:]]*//' | sed -e 's/constant: //')
FEE_COEFFICIENT=$($CLI rest v0 settings get -h "${REST_URL}" | grep 'coefficient:' | sed -e 's/^[[:space:]]*//' | sed -e 's/coefficient: //')
FEE_CERTIFICATE=$($CLI rest v0 settings get -h "${REST_URL}" | grep 'certificate:' | sed -e 's/^[[:space:]]*//' | sed -e 's/certificate: //')

ACCOUNT_PK=$(echo ${ACCOUNT_SK} | $CLI key to-public)
ACCOUNT_ADDR=$($CLI address account ${ADDRTYPE} ${ACCOUNT_PK})

echo "================Create Stake Pool================="
echo "REST_PORT: ${REST_PORT}"
echo "ACCOUNT_SK: ${ACCOUNT_SK}"
echo "BLOCK0_HASH: ${BLOCK0_HASH}"
echo "FEE_CONSTANT: ${FEE_CONSTANT}"
echo "FEE_COEFFICIENT: ${FEE_COEFFICIENT}"
echo "FEE_CERTIFICATE: ${FEE_CERTIFICATE}"
echo "=================================================="

echo " ##1. Create VRF keys"
POOL_VRF_SK=$(jcli key generate --type=Curve25519_2HashDH)
POOL_VRF_PK=$(echo ${POOL_VRF_SK} | jcli key to-public)

echo POOL_VRF_SK: ${POOL_VRF_SK}
echo POOL_VRF_PK: ${POOL_VRF_PK}

echo " ##2. Create KES keys"
POOL_KES_SK=$(jcli key generate --type=SumEd25519_12)
POOL_KES_PK=$(echo ${POOL_KES_SK} | jcli key to-public)

echo POOL_KES_SK: ${POOL_KES_SK}
echo POOL_KES_PK: ${POOL_KES_PK}

echo " ##3. Create the Stake Pool certificate using above VRF and KEY public keys"
jcli certificate new stake-pool-registration --kes-key ${POOL_KES_PK} --vrf-key ${POOL_VRF_PK} --owner ${ACCOUNT_PK} --serial 1010101010 --start-validity 0 --management-threshold 1 >stake_pool.cert

cat stake_pool.cert

echo " ##4. Sign the Stake Pool certificate with the Stake Pool Owner private key"
echo ${ACCOUNT_SK} >stake_key.sk

cat stake_pool.cert | jcli certificate sign stake_key.sk >stake_pool.signcert

cat stake_pool.signcert

echo " ##5. Send the signed Stake Pool certificate to the blockchain"
./send-certificate.sh stake_pool.signcert ${REST_PORT} ${ACCOUNT_SK}

echo " ##6. Retrieve your stake pool id (NodeId)"
cat stake_pool.cert | jcli certificate get-stake-pool-id | tee stake_pool.id