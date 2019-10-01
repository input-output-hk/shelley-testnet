#!/bin/sh

# Disclaimer:
#
#  The following use of shell script is for demonstration and understanding
#  only, it should *NOT* be used at scale or for any sort of serious
#  deployment, and is solely used for learning how the node and blockchain
#  works, and how to interact with everything.

usage() {
    echo "usage: $0 <argument>"
    echo ""
    echo "    <argument> Type of address to be created: account or utxo"
}

if [[ $# -ne 1 ]]; then
    usage ${0}
    exit 1
fi

ADDR_SK=$(jcli key generate --type=ed25519extended)
ADDR_PK=$(echo ${ADDR_SK} | jcli key to-public)
if [[ $1 == "account" ]]; then
    ADDR=$(jcli address account ${ADDR_PK} --testing)
elif [[ $1 == "utxo" ]]; then
    ADDR=$(jcli address single ${ADDR_PK} --testing)
else
    echo "$1 - Unsupported argument!"
    echo "Permitted arguments: account, utxo"
    exit 1
fi

echo "PRIVATE_KEY_SK: ${ADDR_SK}"
echo "PUBLIC_KEY_PK: ${ADDR_PK}"
echo "ADDRESS: ${ADDR}"

