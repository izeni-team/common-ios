#!/bin/sh

if [ "$#" -ne 3 ]; then
    echo "Requires two arguments: OLD_VERSION and NEW_VERSION and COMMIT_MESSAGE"
    exit 1
fi

OLD_VERSION=$1
NEW_VERSION=$2
MESSAGE=$3
rm -rf Izeni/$NEW_VERSION # Just in case we're re-running it
cp -r Izeni/$OLD_VERSION Izeni/$NEW_VERSION
perl -pi -w -e "s/$OLD_VERSION/$NEW_VERSION/g;" Izeni/$NEW_VERSION/Izeni.podspec
perl -pi -w -e "s/$OLD_VERSION/$NEW_VERSION/g;" Izeni.podspec
git add .
git status
git commit -m "$MESSAGE"
git push
git tag -d $NEW_VERSION
git push origin :refs/tags/$NEW_VERSION
git tag $NEW_VERSION master -m "$MESSAGE"
git push --tags
