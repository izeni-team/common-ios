#!/bin/sh

if [ "$#" -ne 2 ]; then
    echo "Requires two arguments: OLD_VERSION and NEW_VERSION"
    exit 1
fi

OLD_VERSION=$1
NEW_VERSION=$2
rm -rf Izeni/$NEW_VERSION # Just in case we're re-running it
cp -r Izeni/$OLD_VERSION Izeni/$NEW_VERSION
perl -pi -w -e "s/$OLD_VERSION/$NEW_VERSION/g;" Izeni/$NEW_VERSION/Izeni.podspec
perl -pi -w -e "s/$OLD_VERSION/$NEW_VERSION/g;" Izeni.podspec
git add .
git status
