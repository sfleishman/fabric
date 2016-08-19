#!/bin/bash

JAVA=/usr/bin/java
CHAINCODE_JAR=chaincode.jar

#check if chaincode jar exists
if [ ! -f $CHAINCODE_JAR ];then 
 echo "chaincode.jar does not exist. please run buildChaincode.sh first"
 exit 1
fi

$JAVA -jar $CHAINCODE_JAR "$@"

