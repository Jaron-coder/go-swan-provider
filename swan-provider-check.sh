#!/bin/bash
#Filswan provider check.

#Version
LOTUS_V=1.18.0
LOTUS_MINER_V=1.18.0
BOOSTD_V=1.15.0
SWAN_PROVIDER_V=2.1.0-rc1

LOTUS-VERSION=$(lotus -v)
LOTUS-MINER-VERSION=$(lotus-miner -v)
BOOSTD-VERSION=$(boostd -version)
SWAN-PROVIDER-VERSION=$(swan-provider version)

##Configuration file check.
[[ -n "$SWAN_PATH" ]] && [[ -f "$SWAN_PATH/provider/config.toml" ]] && [[ -f "$SWAN_PATH/provider/boost/config.toml" ]] && echo "Swan-provider and boost config exist." && cat $SWAN_PATH/provider/config.toml | grep ^[a-z] |awk '{gsub(/#.*/,"");print $0}'|awk '{gsub(/^[ \t]+$/,"");print $0}'|awk NF | sed 's/[ ]//g' > /tmp/config.temp && . /tmp/config.temp || echo -e "\033[31mSWAN_PATH variable no set or swan-provider boost config file is not exist! \033[0m" && exit 230

##Version check.
#if [[ "$LOTUS-VERSION" =~ "$LOTUS_V" ]] && [[ -n "$LOTUS-VERSION"]];then echo "normal";else echo "LOTUS Fail the inspection.";fi 
[[ "$LOTUS-VERSION" =~ "$LOTUS_V" ]] && [[ -n "$LOTUS-VERSION" ]] && echo "lotus version normal." || echo 'Lotus version test fail.' && exit 231
[[ "$LOTUS-MINER-VERSION" =~ "$LOTUS_MINER_V" ]] && [[ -n "$LOTUS-MINER-VERSION" ]] && echo "lotus-miner version normal." || echo 'Lotus-miner version test fail.' && exit 231
[[ "$BOOSTD-VERSION" =~ "$BOOSTD_V" ]] && [[ -n "$BOOSTD-VERSION" ]] && echo "boost version normal." || echo 'boost version test fail.' && exit 231
[[ "$SWAN-PROVIDER-VERSION" =~ "$SWAN_PROVIDER_V" ]] && [[ -n "$SWAN-PROVIDER-VERSION" ]] && echo "swan-provider version normal." || echo 'swan-provider version test fail.' && exit 231

##Configuration key value check.
for a in `cat /tmp/config | cut -d '=' -f1`
	do 
		if [[ ! -n $(eval echo \$${a}) ]] 
			then 
				echo -e "\033[31mSwan config $a value is null! \033[0m" 
		fi
done

##Lotus api check.
res1=`timeout -s SIGKILL 20 curl -fs $client_api_url -X POST -H "Content-Type: application/json" --data '{ "jsonrpc": "2.0", "method": "Filecoin.Version", "params": [], "id": 1 }'`
if [[ -n "$res1" ]] && [[ "$res1" =~ "$LOTUS_V" ]]
then
echo "Lotus api check success."
else
echo -e "\033[31mLotus api check fail! \033[0m"
exit 231
fi

##Miner api check.
if [[ "$market_version" == "1.2" ]]
then
	res2=`timeout -s SIGKILL 20 curl -fs http://127.0.0.1:1288/rpc/v0 -X POST -H "Content-Type: application/json" --data '{ "jsonrpc": "2.0", "method": "Filecoin.ID", "params": [], "id": 1 }'`
	if [[ -n "$res2" ]] && [[ "$res2" =~ "resu" ]]
	then
		echo "Boost api check success."
	else
		echo -e "\033[31mBoost api check fail! \033[0m"
		exit 231
	fi
else
	res3=`timeout -s SIGKILL 20 curl -fs $market_api_url -X POST -H "Content-Type: application/json" --data '{ "jsonrpc": "2.0", "method": "Filecoin.ActorAddress", "params": [],  "id": 1 }'`
	if [[ -n "$res3" ]] && [[ "$res3" =~ "$miner_fid" ]]
	then
		echo "Miner api check success."
	else
		echo -e "\033[31mMiner api check fail! \033[0m"
	exit 231
	fi
fi


echo "haha"
