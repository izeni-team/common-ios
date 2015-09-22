#!/bin/sh
OLD_VERSION=$1
NEW_VERSION=$2
rm -rf Izeni/$NEW_VERSION # Just in case we're re-running it
cp -r Izeni/$OLD_VERSION Izeni/$NEW_VERSION
sed -i 's/$OLD_VERSION/$NEW_VERSION/g' Izeni/$NEW_VERSION/Izeni.podspec
sed -i 's/$OLD_VERSION/$NEW_VERSION/g' Izeni.podspec
git add .
git status
