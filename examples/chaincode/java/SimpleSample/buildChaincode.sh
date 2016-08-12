# DEFINE VARIABLES
MAVEN_EXE=/usr/bin/mvn
POM_FILE=pom.xml
POM_CONFIG=pom-config.xml
HIGHEST_BASEDIR="Highest basedir"

# DEFINE GRADLE VARIABLES
GRADLE_EXE=/home/fabricdev/opt/gradle/bin/gradle
GRADLE_BUILD_FILE=build.gradle

THIS_BUILD="NA"
if [ -f $POM_FILE ] && [ -f $POM_CONFIG ];then
	THIS_BUILD="MAVEN"
else if [ -f $GRADLE_BUILD_FILE ];then
	THIS_BUILD="GRADLE"
     fi 
fi

if [ $THIS_BUILD = "MAVEN" ]; then
  ROOT_LOCATION=`$MAVEN_EXE -f $POM_CONFIG verify | grep "$HIGHEST_BASEDIR"|awk '{print $NF}'`
  echo $ROOT_LOCATION
  PWD=`pwd`
  cd $ROOT_LOCATION
  $MAVEN_EXE -f $POM_FILE clean
  $MAVEN_EXE -f $POM_FILE install
  cd $PWD
fi

if [ $THIS_BUILD = "GRADLE" ]; then
  $GRADLE_EXE -b $GRADLE_BUILD_FILE clean
  $GRADLE_EXE -b $GRADLE_BUILD_FILE build
fi

