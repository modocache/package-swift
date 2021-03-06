#!/bin/bash
# Copyright 2016 iAchieved.it LLC
# MIT License (https://opensource.org/licenses/MIT)
echo "+ Reverting local changes"
for dir in clang cmark compiler-rt llbuild lldb \
llvm swift swift-corelibs-foundation swift-corelibs-libdispatch \
swift-corelibs-xctest swift-integration-tests swiftpm ; do
  echo "+ Revert local changes in $dir"
  pushd $dir > /dev/null
  git stash save --keep-index
  git stash drop
  popd > /dev/null
done

ARCH=`arch`
if [[ $ARCH =~ arm ]]; then
  echo "+ Building for ARM, remove hpux735 LLVM"
  rm -rf llvm
fi
./swift/utils/update-checkout
if [[ $ARCH =~ arm ]]; then
  echo "+ Building for ARM, checkout hpux735 LLVM"
  rm -rf llvm
  git clone --branch arm https://github.com/hpux735/swift-llvm llvm
fi
