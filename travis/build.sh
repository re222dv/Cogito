#!/bin/bash

set -e
. "$(dirname $0)/env.sh"

echo '==========='
echo '== BUILD =='
echo '==========='

if [[ $TESTS == "dart2js" ]]; then
  # skip vm tests if we are only running dart2js

  $PUB build
else
  echo '--------------------'
  echo '-- TEST: VM Tests --'
  echo '--------------------'
  $DART --checked $BASE_DIR/test/vm_tests.dart
fi

echo '-------------------------'
echo '-- TEST: Browser Tests --'
echo '-------------------------'
# Run a set of Dart Unit tests
results=$(content_shell --checked --dump-render-tree $BASE_DIR/test/browser_tests.html)
echo -e "$results"

# check to see if DumpRenderTree tests
# fails, since it always returns 0
if [[ "$results" == *"failed"* ]]
then
exit 1
fi
