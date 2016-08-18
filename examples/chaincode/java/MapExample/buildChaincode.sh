#Copyright DTCC 2016 All Rights Reserved.
#
#Licensed under the Apache License, Version 2.0 (the "License");
#you may not use this file except in compliance with the License.
#You may obtain a copy of the License at
#
#         http://www.apache.org/licenses/LICENSE-2.0
#
#Unless required by applicable law or agreed to in writing, software
#distributed under the License is distributed on an "AS IS" BASIS,
#WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#See the License for the specific language governing permissions and
#limitations under the License.
#

# define maven and gradle variables ( gradle must be in a PATH )
MAVEN_EXE=/usr/bin/mvn
POM_FILE=pom.xml
GRADLE_EXE=`which gradle`
GRADLE_BUILD_FILE=build.gradle

#expected output
CHAINCODE_JAR=./build/chaincode.jar
RUN_SHELL=runChaincode.sh

# for maven build need to cd <user path>/fabric 
FABRIC_KEYWORD="/fabric"
PWD=`pwd`
CURRENT_FOLDER="$PWD"
index=`echo $PWD | grep -bo "$FABRIC_KEYWORD/" | sed 's/:.*$//'`
FABRIC_ROOT_DIR=${PWD:0:$(($index+${#FABRIC_KEYWORD}))}

#determine which build to use. If not specified - maven is default.
THIS_BUILD="NA"
if [ "$#" -ge 1 ];then 
  	THIS_BUILD=`echo $1 | tr '[:lower:]' '[:upper:]'`
  	if [ $THIS_BUILD != "MAVEN" ] && [ $THIS_BUILD != "GRADLE" ];then
    		echo "usage: $0 [maven|gradle]"
    		exit 1
  	fi
else
# if maven pom.xml is present in a current folder - build with maven
# otherwise if build.gradle present - build with gradle
  	if [ -f $POM_FILE ];then
		THIS_BUILD="MAVEN"
  	else if [ -f $GRADLE_BUILD_FILE ];then
		THIS_BUILD="GRADLE"
       	     else 
             	echo "pom.xml is not found in a current folder $PWD"
                echo "build.gradle is not found in a current folder $PWD"
                exit 1
             fi 
       fi
fi


if [ $THIS_BUILD = "MAVEN" ]; then
  echo "Building chaincode with maven... "
  cd $FABRIC_ROOT_DIR
  $MAVEN_EXE -f $POM_FILE clean > $CURRENT_FOLDER/chaincode_build.log
  $MAVEN_EXE -f $POM_FILE install >> $CURRENT_FOLDER/chaincode_build.log
  cd $CURRENT_FOLDER
  success=`grep -c "BUILD SUCCESS" chaincode_build.log`
fi

if [ $THIS_BUILD = "GRADLE" ]; then
  echo "Building chaincode with gradle ..."
  $GRADLE_EXE -b $GRADLE_BUILD_FILE clean > chaincode_build.log
  $GRADLE_EXE -b $GRADLE_BUILD_FILE build >> chaincode_build.log
  success=`grep -c "BUILD SUCCESSFUL" chaincode_build.log`
fi

if [ $success = "2" ];then
  echo "build completed successfully"
  #copy for execution in container
  cp $CHAINCODE_JAR /root
  cp $RUN_SHELL /root
  echo "codechain.jar and runChaincode.sh are available in /root"
else
 echo "build failed. Please check chaincode_build.sh"
fi

