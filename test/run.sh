#!/bin/bash

which content_shell
if [[ $? -ne 0 ]]; then
  $DART_SDK/../chromium/download_contentshell.sh
  unzip -qq content_shell-linux-x64-release.zip

  cs_path=$(ls -d drt-*)
  PATH=$cs_path:$PATH
fi

dart test/unit_tests.dart --checked
if [ $? -ne 0 ]; then
    exit 1
fi

# check to see if content_shell exists if not, fail
which content_shell
if [[ $? -ne 0 ]]; then
exit 1
fi

# Start x
sudo start xvfb

# Run a set of Dart Unit tests
results=$(content_shell --dump-render-tree test/browser_tests.html)
echo -e "$results"

# check to see if DumpRenderTree tests
# fails, since it always returns 0
if [[ "$results" == *"failed"* ]]
then
exit 1
fi
