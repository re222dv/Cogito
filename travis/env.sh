#!/bin/false
set -e

if [[ -z $ENV_SET ]]; then
export ENV_SET=1

  if [ -n "$DART_SDK" ]; then
DARTSDK=$DART_SDK
  else
echo "sdk=== $DARTSDK"
      DART=`which dart|cat` # pipe to cat to ignore the exit code
      DARTSDK=`which dart | sed -e 's/\/dart\-sdk\/.*$/\/dart-sdk/'`

      if [ "$DARTSDK" = "/Applications/dart/dart-sdk" ]; then
          # Assume we are a mac machine with standard dart setup
          export DARTIUM="/Applications/dart/chromium/Chromium.app/Contents/MacOS/Chromium"
      else
DARTSDK="`pwd`/dart-sdk"
          case $( uname -s ) in
            Darwin)
              export DARTIUM=${DARTIUM:-./dartium/Chromium.app/Contents/MacOS/Chromium}
              ;;
            Linux)
              export DARTIUM=${DARTIUM:-./dartium/chrome}
              ;;
          esac
fi
fi

case $( uname -s ) in
    Darwin)
      path=$(readlink ${BASH_SOURCE[0]}||echo './travis/env.sh')
      export SCRIPT_DIR=$(dirname $path)
      ;;
    Linux)
      export SCRIPT_DIR=$(dirname $(readlink -f ${BASH_SOURCE[0]}))
      ;;
  esac
export BASE_DIR=$(dirname $SCRIPT_DIR)


  export CS_PATH=$BASE_DIR/drt-lucid64-full-stable-35121.0
  export CS_BIN=$CS_PATH/content_shell
  export DART_SDK="$DARTSDK"
  export DARTSDK
  export DART=${DART:-"$DARTSDK/bin/dart"}
  export PUB=${PUB:-"$DARTSDK/bin/pub"}
  export DARTANALYZER=${DARTANALYZER:-"$DARTSDK/bin/dartanalyzer"}
  export DARTDOC=${DARTDOC:-"$DARTSDK/bin/dartdoc"}
  export DART_DOCGEN=${DART_DOCGEN:-"$DARTSDK/bin/docgen"}
  export DART_VM_OPTIONS="--old_gen_heap_size=2048"
  export DARTIUM_BIN=${DARTIUM_BIN:-"$DARTIUM"}
  export CHROME_BIN=${CHROME_BIN:-"google-chrome"}
  export PATH=$CS_PATH:$PATH:$DARTSDK/bin

  echo '*********'
  echo '** ENV **'
  echo '*********'
  echo CS_PATH=$CS_PATH
  echo CS_BIN=$CS_BIN
  echo DART_SDK=$DART_SDK
  echo DART=$DART
  echo PUB=$PUB
  echo DARTANALYZER=$DARTANALYZER
  echo DARTDOC=$DARTDOC
  echo DART_DOCGEN=$DART_DOCGEN
  echo DARTIUM_BIN=$DARTIUM_BIN
  echo CHROME_BIN=$CHROME_BIN
  echo PATH=$PATH
  echo NGDART_BASE_DIR=$BASE_DIR
  echo NGDART_SCRIPT_DIR=$SCRIPT_DIR
  $DART --version 2>&1

fi
