#!/bin/bash

# print commands and arguments as they are executed
set -x

echo "initializing Elementrem installation"
date
ps axjf

# Parameters
ADMINUSERN=$1
EXDATA=`echo "$2" | xxd -plain -c 250`
HOMEDIR="/home/$ADMINUSERN"
VMNAME=`hostname`
echo "User: $ADMINUSERN"
echo "User home dir: $HOMEDIR"
echo "vmname: $VMNAME"

# Initialize
cd $HOMEDIR
sudo apt-get install -y git curl wget

# Install go-lang
sudo apt-get install -y build-essential libgmp3-dev
sudo apt -y update
sudo apt-get -f -y install
sudo apt install -y golang-go

# Downloads git source 
git clone https://github.com/elementrem/go-elementrem/

# Build elementrem
cd go-elementrem
make gele
cd

# gele path to usr/bin/
cd $HOMEDIR
cd go-elementrem/build/bin
sudo cp gele /usr/bin
cd $HOMEDIR
rm -rf go-elementrem

# Install Solidity Programming Language
cd $HOMEDIR
cd 
mkdir solidity
cd solidity
wget https://github.com/elementrem/solidity/releases/download/v0.4.10/Elementrem-Solidity-0.4.10.tar.gz
wget https://github.com/elementrem/solidity/releases/download/v0.4.10/Elementrem-solidity-dependencies.0.4.10.tar.gz
tar -xvzf ./Elementrem-Solidity-0.4.10.tar.gz
tar -xvzf ./Elementrem-solidity-dependencies.0.4.10.tar.gz
sudo dpkg -i libboost-program-options1.58.0_1.58.0+dfsg-5ubuntu3_amd64.deb
sudo dpkg -i libjsoncpp1_1.7.2-1_amd64.deb
sudo dpkg -i libboost-system1.58.0_1.58.0+dfsg-5ubuntu3_amd64.deb
sudo dpkg -i libboost-filesystem1.58.0_1.58.0+dfsg-5ubuntu3_amd64.deb
sudo apt-get -y install libboost-filesystem-dev
sudo apt -y update
sudo apt-get -f -y install
sudo dpkg -i libboost-filesystem-dev_1.58.0.1ubuntu1_amd64.deb
sudo cp -r bin /usr
sudo cp -r lib /usr
sudo cp -r share /usr
cd $HOMEDIR
rm -rf solidity

# Initialize private_genesis_Block
cd $HOMEDIR
echo "{
  \"alloc\": {},
  \"nonce\": \"0x0000000000000000\",
  \"difficulty\": \"0x020000\",
  \"mixhash\": \"0x0000000000000000000000000000000000000000000000000000000000000000\",
  \"coinbase\": \"0x0000000000000000000000000000000000000000\",
  \"timestamp\": \"0x00\",
  \"parentHash\": \"0x0000000000000000000000000000000000000000000000000000000000000000\",
  \"extraData\": \"0x$EXDATA\",
  \"gasLimit\": \"0x2FEFD8\"
}" > private_prerequisites.json

# Downloads scripts
cd $HOMEDIR
wget https://raw.githubusercontent.com/elementrem/eg-elementrem/master/linux-elementrem-smartcontract/attach_private.sh
wget https://raw.githubusercontent.com/elementrem/eg-elementrem/master/linux-elementrem-smartcontract/attach_public.sh
wget https://raw.githubusercontent.com/elementrem/eg-elementrem/master/linux-elementrem-smartcontract/start_private.sh
wget https://raw.githubusercontent.com/elementrem/eg-elementrem/master/linux-elementrem-smartcontract/start_public.sh
wget https://raw.githubusercontent.com/elementrem/eg-elementrem/master/linux-elementrem-smartcontract/meteor-wallet-setup.sh
wget https://raw.githubusercontent.com/elementrem/eg-elementrem/master/linux-elementrem-smartcontract/update-gele.sh

# Initialize private network
cd $HOMEDIR
gele --datadir "$HOMEDIR/.private_elementrem" init private_prerequisites.json
echo "Elementrem CLI gele"